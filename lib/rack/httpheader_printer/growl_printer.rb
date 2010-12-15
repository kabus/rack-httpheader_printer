# -*- coding: utf-8 -*-
require 'rbconfig'
module Rack
  class HttpheaderPrinter
    class GrowlPrinter < AbstractPrinter
      def run
        GrowlPrinter.growl 'REQUEST HEADER', @request_headers.to_s
        GrowlPrinter.growl 'RESPONSE HEADER', @response_headers.to_s
      end

      class << self
        def growl(title, message)
          if message.split("\n").length > 7
            message.lines.each_slice(7).with_index do |ls,i|
              growl_send "#{title} #{i+1}", ls.join("\n")
            end
          else
            growl_send title, message
          end
        end
        def growl_send(title, message)
          case ::Config::CONFIG['host_os']
          when /linux|bsd/i
            system "notify-send \"#{title}\" \"#{message}\""
          else
            raise
          end
        end
      end
    end
  end
end
