class HtmlClassMerger
  module Tokenize
    # split a string of html classes into an array of token strings
    def tokenize(html_classes : String) : Array(String)
      html_classes.split(/\s+/).reject(&.empty?)
    end
  end
end
