# -*- coding: utf-8 -*-
module Rack
  class HttpheaderPrinter
    class AbstractPrinter
      attr_reader :env, :options
      def initialize(env, options)
        @env = env
        @options = options
      end
      def print_request_headers(headers)
        raise
      end
      def print_response_headers(headers)
        raise
      end
    end
  end
end
