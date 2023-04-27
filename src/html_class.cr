module HtmlClass
  alias Tokenizable = String | Enumerable(String)

  # Protocol for merging tokens into a string
  module Merge
    # Merge the given tokens into a string
    abstract def merge(*tokens : Tokenizable) : String
  end

  # Provides #tokenize, which given a splat of Tokenizable, returns an array of String tokens
  module Tokenize
    extend self

    def tokenize(*tokens : Tokenizable) : Array(String)
      tokens.flat_map { |t| tokenize t }
    end

    def tokenize(tokens : Enumerable(String)) : Array(String)
      tokenize tokens.join(" ")
    end

    def tokenize(tokens : String) : Array(String)
      tokens.split(/\s+/).reject(&.empty?)
    end
  end
end
