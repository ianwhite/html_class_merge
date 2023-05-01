require "./tokenizable"

module HtmlClassMerge
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
