# -*- coding: utf-8 -*-
module Rack #:nodoc:
  class HttpheaderPrinter

    @@default_options = {
      :request_filters => [/^rack/, /^action_/, /^warden/],
      :printer => lambda {|msg| print msg},
    }

    attr_reader :env

    def initialize(app, options={})
      @app = app
      @options = @@default_options.merge(options)

      @printer = @options[:printer]
      @default_filters = to_a(@options[:filters] || @options[:default_filters])
      @request_filters = @default_filters + to_a(@options[:request_filters])
      @response_filters = @default_filters + to_a(@options[:response_filters])
    end

    def call(env)
      @env = env.dup
      status, headers, response = @app.call(env)

      print_headers(@env, @request_filters)
      print_headers(headers, @response_filters)

      [status, headers, response]
    end

    def print_headers(h, filters)
      h.keys.sort_by(&:to_s).each {|k|
        if filters.none?{|f| f === k}
          h[k].to_s.split("\n").each { |v|
            _print_ "#{k}: #{v}\r\n"
          }
        end
      }
    end

    private
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

    def _print_(msg)
      instance_exec(msg, &@printer)
    end
  end
end
