# -*- coding: utf-8 -*-
module Rack
  class HttpheaderPrinter
    class AbstractPrinter
      attr_reader :request_headers, :response_headers, :env, :status, :headers, :response, :options
      def initialize(request_headers, response_headers, env, status, headers, response, options)
        @request_headers = request_headers
        @response_headers = response_headers
        @env = env
        @status = status
        @headers = headers
        @response = response
        @options = options
      end
      def run
        raise "Implement this!"
      end

      private
      def insert_last(text)
        insert_text :before, /<\/body>/i, text
      end
      def insert_text(position, pattern, new_text)
        index = case pattern
                when Regexp
                  if match = @response.body.match(pattern)
                    match.offset(0)[position == :before ? 0 : 1]
                  else
                    @response.body.size
                  end
                else
                  pattern
                end
        newbody = @response.body
        newbody.insert index, new_text
        @response.body = newbody
      end
    end
  end
end
