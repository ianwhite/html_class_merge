class HtmlClassMerger
  # Given a Regex, return an index of the first n characters, if the regex would match those first n characters, or nil.
  # This means the Regex must be anchored at the start, contain only word chars for the first n characters,
  # and not be a union at the top level.
  #
  # This can be used to pre-filter a long list of regexs to only those that might match a given string
  #
  # ```
  # regex = /\Afoo-(bar|baz)\z/
  # RegexIndex.regex_index(regex)             # => "fo"
  # RegexIndex.regex_index(regex, 3)          # => "foo"
  # RegexIndex.regex_index(regex, 4)          # => "foo-"
  # RegexIndex.regex_index(regex, 5)          # => nil
  # RegexIndex.regex_index(regex, 3, "f")     # => nil
  # RegexIndex.regex_index(regex, 3, "[fo]")  # => "foo"
  # RegexIndex.regex_index(regex, 4, "[fo]")  # => nil
  # ```
  module RegexIndex
    extend self

    # return the index of the first n characters, if the regex would match only those n characters, or nil
    def regex_index(regex : Regex, n = 2, char = "[\\w\\-]") : String?
      return nil                if regex.source.matches? /\A(?:\\A|\^)#{char}+\|/ # return nil if union at top level
      return regex.source[2, n] if regex.source.matches? /\A\\A#{char}{#{n}}/     # return first n chars for \A
      return regex.source[1, n] if regex.source.matches? /\A\^#{char}{#{n}}/      # return first n chars for ^
      nil                                                                         # return nil otherwise
    end
  end
end
