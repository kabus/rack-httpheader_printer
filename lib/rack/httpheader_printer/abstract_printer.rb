# -*- coding: utf-8 -*-
module Rack
  class HttpheaderPrinter
    class AbstractPrinter
      attr_reader :request_headers, :response_headers, :env, :response, :options
      def initialize(request_headers, response_headers, env, response, options)
        @request_headers = request_headers
        @response_headers = response_headers
        @env = env
        @response = response
        @options = options
      end
      def run
        raise "Implement this!"
      end
    end
  end
end
