class FacesFormatter
  class << self
    def format_as_xhtml(text)
      Lesstile.format_as_xhtml(
        text,
        :text_formatter => lambda {|text| RedCloth.new(CGI::unescapeHTML(text)).to_html},
        :code_formatter => lambda {|code, lang| Albino.colorize( code, lang, :O => 'linenos=table')}
      )
    end
  end
end
