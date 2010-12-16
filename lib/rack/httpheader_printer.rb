# -*- coding: utf-8 -*-
module Rack #:nodoc:
  class HttpheaderPrinter
    autoload :AbstractPrinter,  "rack/httpheader_printer/abstract_printer"
    autoload :LoggerPrinter,    "rack/httpheader_printer/logger_printer"
    autoload :HtmlPrinter,      "rack/httpheader_printer/html_printer"
    autoload :GrowlPrinter,     "rack/httpheader_printer/growl_printer"
    autoload :JsConsolePrinter, "rack/httpheader_printer/js_console_printer"

    @@default_config = {
      :request_filters => [/^rack/, /^action_/, /^warden/],
      :printer => HtmlPrinter
    }

    attr_reader :config

    def initialize(app, config={})
      @app = app
      @config = @@default_config.merge(config)

      @printer_factory = @config[:printer]
      @default_filters = to_a(@config[:filters] || @config[:default_filters])
      @request_filters = @default_filters + to_a(@config[:request_filters])
      @response_filters = @default_filters + to_a(@config[:response_filters])
    end

    def call(env)
      status, headers, response = @app.call(env)

      request_headers = filter_headers(env, @request_filters)
      response_headers = filter_headers(headers, @response_filters)

      printer = @printer_factory.new(request_headers, response_headers, env, status, headers, response, config)
      printer.run

      [status, headers, response]
    end

    private
    def filter_headers(headers, filters)
      hs = headers.reject{|k,v|
        filters.any?{|f| f === k }
      }.sort_by{|k,v| k}
      def hs.to_s
        self.map do |k,vs|
          vs.to_s.split("\n").map{|v| "#{k}: #{v}"}
        end.flatten.join("\n")
      end
      hs
    end

    def to_a(val)
      case val
      when Array
        val
      when nil
        []
      else
        [val]
      end
    end
  end
end
