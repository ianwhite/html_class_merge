class HtmlClassMerger
  # Given a Regex, return an index of the first n characters, if the regex would match those first n characters, or nil.
  # This means the Regex must be anchored at the start, and not be a disjunction at the top level.
  #
  # This can be used to pre-filter a long list of regexs to only those that might match a given string
  #
  # eg.
  #   regex = /\Afoo-(bar|baz)\z/
  #   RegexIndex.regex_index(regex)    # => "fo"
  #   RegexIndex.regex_index(regex, 3) # => "foo"
  #   RegexIndex.regex_index(regex, 4) # => "foo-"
  #   RegexIndex.regex_index(regex, 5) # => nil
  module RegexIndex
    extend self

    # return the index of the first n characters, if the regex would match only those n characters, or nil
    def regex_index(regex : Regex, length = regex_index_length, char = regex_index_char) : String?
      return nil                     if regex_index_union?(regex, char)
      return regex.source[2, length] if regex.source =~ /\A\\A#{char}{#{length}}/
      return regex.source[1, length] if regex.source =~ /\A\^#{char}{#{length}}/
      nil
    end

    # return true if the regex is anchored at the start and has a union at the top level, given the character class
    def regex_index_union?(regex : Regex, char = regex_index_char) : Bool
      /\A(?:\\A|\^)#{char}+\|/.matches?(regex.source)
    end

    def regex_index_length : Int32
      2
    end

    def regex_index_char : String
      "[\\w\\-]"
    end
  end
end
