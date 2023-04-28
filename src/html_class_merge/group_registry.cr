require "./regex_index"
require "./tokenize"

module HtmlClassMerge
  class GroupRegistry
    include Tokenize
    include RegexIndex

    alias Matcher = String | Regex | Enumerable(String | Regex)

    getter replaces = {} of Symbol => Set(Symbol)
    getter string_matchers = {} of String => Symbol

    # regex matchers are indexed by the first 2 characters of what they would match, to speed up lookup
    getter regex_matchers = {} of String? => Hash(Regex, Symbol)

    # cache of regex matches, to speed up lookup
    @match_cache = {} of String => Symbol?

    def_clone

    # Returns the group of *token*, or nil
    def group_for?(token : String) : Symbol?
      @string_matchers[token]? || regex_match?(token)
    end

    # Returns the set of groups that *group* replaces, or nil if there are none
    def groups_replaced_by?(group : Symbol) : Set(Symbol)
      @replaces[group]? || Set(Symbol).new
    end

    # Register *matchers*, and *replace*ments for *group*
    def register!(group : Symbol, *matchers : Matcher, replace : Symbol | Enumerable(Symbol)) : self
      register!(group, *matchers)
      register!(group, replace)
    end

    # Register a String matcher for *group*
    def register!(group : Symbol, matcher : String) : self
      @match_cache.clear
      tokenize(matcher).each { |string| @string_matchers[string] = group }
      self
    end

    # Register a Regex matcher for *group*
    #
    # Regexes are indexed by the first 2 characters of what they would match, to speed up lookup
    def register!(group : Symbol, matcher : Regex) : self
      @match_cache.clear
      idx = regex_index(matcher)
      @regex_matchers[idx] ||= {} of Regex => Symbol
      @regex_matchers[idx][matcher] = group
      self
    end

    # Register a collection of String or Regex *matchers* for *group*
    def register!(group : Symbol, matcher : Enumerable(String | Regex)) : self
      matcher.each { |m| register!(group, m) }
      self
    end

    # Register a splat of String or Regex *matchers* for *group*
    def register!(group : Symbol, *matchers : Matcher) : self
      matchers.each { |matcher| register!(group, matcher) }
      self
    end

    # Register a *group*'s *replace*ments
    def register!(group : Symbol, replace : Symbol) : self
      @replaces[group] = Set(Symbol).new unless @replaces.has_key?(group)
      @replaces[group] << replace
      self
    end

    # Register a collection of *replace*ments for *group*
    def register!(group : Symbol, replace : Enumerable(Symbol)) : self
      replace.each { |r| register!(group, r) }
      self
    end

    # merge *other* into this registry
    def merge!(other : GroupRegistry) : self
      @replaces.merge!(other.replaces) { |_, a, b| a + b }
      @string_matchers.merge!(other.string_matchers)
      @regex_matchers.merge!(other.regex_matchers) { |_, a, b| a.merge(b) }
      @match_cache.clear
      self
    end

    # Return the group that matches *token* by regex, or nil.  This is cached.
    private def regex_match?(token : String) : Symbol?
      @match_cache.fetch(token) do
        @match_cache[token] = lookup_regex(token)
      end
    end

    # Return the group that matches *token* by regex, or nil
    #
    # Uses the first 2 characters of *token* to speed up lookup
    private def lookup_regex(token) : Symbol?
      regex_index = token[0, 2]
      indexed_rexeg_match?(regex_index, token) || indexed_rexeg_match?(nil, token)
    end

    # Return the group that matches *token* by regex, or nil, in the given index
    private def indexed_rexeg_match?(regex_index, token) : Symbol?
      return unless matchers = @regex_matchers[regex_index]?
      matchers.each { |r, group| return group if r =~ token }
    end
  end
end
