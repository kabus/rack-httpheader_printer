# -*- coding: utf-8 -*-
module Rack
  class HttpheaderPrinter
    class LoggerPrinter < AbstractPrinter
      def initialize(*args)
        super
        @logger = @options[:logger] || ::Logger.new(STDOUT)
      end
      def print_request_headers(headers)
        puts "REQUEST HEADERS ################################"
        print_headers(headers)
        puts "################################################"
      end
      def print_response_headers(headers)
        puts "RESPONSE HEADERS ###############################"
        print_headers(headers)
        puts "################################################"
      end

      private
      def print_headers(headers)
        headers.sort_by{|k,vs| k}.each do |k,vs|
          vs.to_s.split("\n").each do |v|
            puts "#{k}: #{v}"
          end
        end
      end
      def puts(msg)
        @logger.debug msg
      end
    end
  end
end
