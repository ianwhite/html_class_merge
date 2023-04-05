require "./tokenize"

class HtmlClassMerger
  class GroupRegistry
    include Tokenize

    alias Group = String | Symbol
    alias Matcher = String | Regex | Enumerable(String | Regex)

    @replaces        = {} of String => Set(String)
    @string_matchers = {} of String => String
    @regex_matchers  = {} of Regex => String

    @match_cache = {} of String => String?

    def_clone

    # returns the group the given token belongs to, or nil
    def group_for?(token : String) : String?
      @string_matchers[token]? || regex_match?(token)
    end

    # returns the set of groups that the given group replaces
    def groups_replaced_by?(group : Group) : Set(String)?
      @replaces[group.to_s]?
    end

    def register!(group : Group, *matchers : Matcher, replace : Group | Enumerable(Group)) : self
      register!(group, *matchers)
      register_replace!(group, replace)
    end

    def register!(group : Group, matcher : String) : self
      @match_cache.clear
      tokenize(matcher).each { |string| @string_matchers[string] = group.to_s }
      self
    end

    def register!(group : Group, matcher : Regex) : self
      @match_cache.clear
      @regex_matchers[matcher] = group.to_s
      self
    end

    def register!(group : Group, matcher : Enumerable(String | Regex)) : self
      matcher.each { |m| register!(group, m) }
      self
    end

    # register what group the given string or regex matches
    def register!(group : Group, *matchers : Matcher) : self
      matchers.each { |matcher| register!(group, matcher) }
      self
    end

    # register what groups are replaced by the given group
    def register_replace!(group : Group, replace : Group) : self
      group = group.to_s
      @replaces[group] = Set(String).new unless @replaces.has_key?(group)
      @replaces[group].concat tokenize(replace.to_s)
      self
    end

    def register_replace!(group : Group, replace : Enumerable(Group)) : self
      replace.each { |r| register_replace!(group, r) }
      self
    end

    def merge!(other : GroupRegistry) : self
      @replaces.merge!(other.replaces) { |_, a, b| a + b }
      @string_matchers.merge!(other.string_matchers)
      @regex_matchers.merge!(other.regex_matchers)
      @match_cache.clear
      self
    end

    protected getter replaces : Hash(String, Set(String))
    protected getter string_matchers : Hash(String, String)
    protected getter regex_matchers : Hash(Regex, String)

    private def regex_match?(token : String) : String?
      @match_cache.fetch(token) do
        @match_cache[token] = @regex_matchers.each { |r, group| return group if r =~ token }
      end
    end
  end
end
