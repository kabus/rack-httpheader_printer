# -*- coding: utf-8 -*-
module Rack
  class HttpheaderPrinter
    class JsConsolePrinter < AbstractPrinter
      def run
        return unless headers["Content-Type"] =~ /text\/html|application\/xhtml\+xml/

        insert_last <<HTML
<script type="text/javascript">
  console.log("#{header_text}");
  console.log("#{response_text}");
</script>
HTML
      end

      def header_text
        JsConsolePrinter.escape_javascript "[[REQUEST HEADER]]\n" + @request_headers.to_s + "\n"
      end
      def response_text
        JsConsolePrinter.escape_javascript "[[RESPONSE HEADER]]\n" + @response_headers.to_s + "\n"
      end

      class << self
        JS_ESCAPE_MAP = { '\\' => '\\\\', '</' => '<\/', "\r\n" => '\n', "\n" => '\n', "\r" => '\n', '"' => '\\"', "'" => "\\'" }
        def escape_javascript(javascript)
          if javascript
            javascript.gsub(/(\\|<\/|\r\n|[\n\r"'])/) { JS_ESCAPE_MAP[$1] }
          else
            ''
          end
        end
      end
    end
  end
end
