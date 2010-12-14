# -*- coding: utf-8 -*-
module Rack #:nodoc:
  class HttpheaderPrinter
    autoload :AbstractPrinter, "rack/httpheader_printer/abstract_printer.rb"
    autoload :LoggerPrinter,   "rack/httpheader_printer/logger_printer"

    @@default_config = {
      :request_filters => [/^rack/, /^action_/, /^warden/],
      :printer => LoggerPrinter
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

      printer = @printer_factory.new(env, config)
      printer.print_request_headers(filter_headers(env, @request_filters))
      printer.print_response_headers(filter_headers(headers, @response_filters))

      [status, headers, response]
    end

    private
    def filter_headers(headers, filters)
      headers.reject{|k,v|
        filters.any?{|f| f === k }
      }
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
