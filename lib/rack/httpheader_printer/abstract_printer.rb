# -*- coding: utf-8 -*-
module Rack
  class HttpheaderPrinter
    class AbstractPrinter
      attr_reader :request_headers, :response_headers, :env,
                  :status, :headers, :response, :options
      def initialize(request_headers, response_headers, env,
                     status, headers, response, options)
        @request_headers = request_headers
        @response_headers = response_headers
        @env = env
        @status = status
        @headers = headers
        @response = response
        @options = options
      end
      def run
        print_request_headers
        print_response_headers
      end
      def print_request_headers
        raise
      end
      def print_response_headers
        raise
      end
    end
  end
end
