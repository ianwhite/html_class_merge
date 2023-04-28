module HtmlClassMerge
  VERSION = "0.4.1"

  alias Tokenizable = String | Enumerable(String)
end

require "./html_class_merge/grouped_merge"
