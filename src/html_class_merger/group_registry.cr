require "./tokenize"

class HtmlClassMerger
  class GroupRegistry
    include Tokenize

    alias Matcher = String | Regex | Enumerable(String | Regex)

    @replaces        = {} of Symbol => Set(Symbol)
    @string_matchers = {} of String => Symbol
    @regex_matchers  = {} of Regex => Symbol

    @match_cache = {} of String => Symbol?

    def_clone

    # returns the group the given token belongs to, or nil
    def group_for?(token : String) : Symbol?
      @string_matchers[token]? || regex_match?(token)
    end

    # returns the set of groups that the given group replaces
    def groups_replaced_by?(group : Symbol) : Set(Symbol)?
      @replaces[group]?
    end

    # register group matchers, and group replacements
    def register!(group : Symbol, *matchers : Matcher, replace : Symbol | Enumerable(Symbol)) : self
      register!(group, *matchers)
      register!(group, replace)
    end

    def register!(group : Symbol, matcher : String) : self
      @match_cache.clear
      tokenize(matcher).each { |string| @string_matchers[string] = group }
      self
    end

    def register!(group : Symbol, matcher : Regex) : self
      @match_cache.clear
      @regex_matchers[matcher] = group
      self
    end

    def register!(group : Symbol, matcher : Enumerable(String | Regex)) : self
      matcher.each { |m| register!(group, m) }
      self
    end

    # register what group the given string or regex matches
    def register!(group : Symbol, *matchers : Matcher) : self
      matchers.each { |matcher| register!(group, matcher) }
      self
    end

    # register what groups are replaced by the given group
    def register!(group : Symbol, replace : Symbol) : self
      @replaces[group] = Set(Symbol).new unless @replaces.has_key?(group)
      @replaces[group] << replace
      self
    end

    def register!(group : Symbol, replace : Enumerable(Symbol)) : self
      replace.each { |r| register!(group, r) }
      self
    end

    # merge another group registry into this one
    def merge!(other : GroupRegistry) : self
      @replaces.merge!(other.replaces) { |_, a, b| a + b }
      @string_matchers.merge!(other.string_matchers)
      @regex_matchers.merge!(other.regex_matchers)
      @match_cache.clear
      self
    end

    protected getter replaces : Hash(Symbol, Set(Symbol))
    protected getter string_matchers : Hash(String, Symbol)
    protected getter regex_matchers : Hash(Regex, Symbol)

    private def regex_match?(token : String) : Symbol?
      @match_cache.fetch(token) do
        @match_cache[token] = @regex_matchers.each { |r, group| return group if r =~ token }
      end
    end
  end
end
