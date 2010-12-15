# -*- coding: utf-8 -*-
module Rack
  class HttpheaderPrinter
    class LoggerPrinter < AbstractPrinter
      def initialize(*args)
        super
        @logger = @options[:logger] || ::Logger.new(STDOUT)
      end

      def run
        print_request_headers
        print_response_headers
      end

      private

      def print_request_headers
        puts "REQUEST HEADERS ################################"
        puts @request_headers.to_s
        puts "################################################"
      end
      def print_response_headers
        puts "RESPONSE HEADERS ###############################"
        puts @response_headers.to_s
        puts "################################################"
      end

      def puts(msg)
        @logger.debug msg
      end
    end
  end
end
