# -*- coding: utf-8 -*-
module Rack
  class HttpheaderPrinter
    class HtmlPrinter < AbstractPrinter
      @@fieldset_class_name = 'html_printer_fieldset'

      def run
        buttons = '<div style="float:left;">' + toggle_button_tag('request') + toggle_button_tag('response') + '</div>'
        insert_last buttons
        insert_last '<div style="clear:both;"></div>'
        insert_last display_tag('request', @request_headers)
        insert_last display_tag('response', @response_headers)
        insert_last script_tag
      end

      private
      def display_tag(name, headers)
        lines = headers.sort_by{|k,vs| k}.map do |k,vs|
          vs.to_s.split("\n").map do |v|
            "#{k}: #{v}"
          end
        end.flatten
        <<HTML
<fieldset class="#{@@fieldset_class_name}" id="html_printer_#{name}" style="display:none; border: 1px dashed #AAAAAA; margin: 0.5em; padding: 0.5em; font-family: monospace;">
  <legend>rack #{name} headers</legend>
  <ul>
    #{lines.map{|l| "<li>#{CGI.escape_html l}</li>"}.join}
  </ul>
</fieldset>
HTML
      end
      def toggle_button_tag(name)
        <<HTML
<input type="button" onclick="HtmlPrinter.hideAllAndToggle('html_printer_#{name}');return false;" value="#{name}" />
HTML
      end

      def script_tag
        <<HTML
<script type="text/javascript">
var HtmlPrinter = function() {
  function hideAllAndToggle(id) {
    hideAll();
    toggle(id);
  }
  function hideAll() {
    var ary = document.getElementsByTagName("fieldset");
    for(i=0; i<ary.length; ++i) {
      if(ary[i].className == '#{@@fieldset_class_name}') {
        hide(ary[i]);
      }
    }
  }
  function toggle(id) {
    var el = document.getElementById(id);
    if(el.style.display == 'none') {
      show(el);
    } else {
      hide(el);
    }
  }
  function show(el) {
    el.style.display = 'block';
  }
  function hide(el) {
    el.style.display = 'none';
  }
  return { hideAllAndToggle:hideAllAndToggle };
}();
</script>
HTML
      end

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
