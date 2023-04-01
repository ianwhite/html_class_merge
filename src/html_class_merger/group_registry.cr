class HtmlClassMerger
  class GroupRegistry
    @replacements = {} of Symbol => Set(Symbol)
    @string_matchers = {} of String => Symbol
    @regex_matchers = {} of Regex => Symbol

    @match_cache = {} of String => Symbol?

    def_clone

    # returns the group the given token belongs to, or nil
    def []?(token : String) : Symbol?
      @string_matchers[token]? || regex_match?(token)
    end

    # returns the set of groups that the given group replaces
    def replacements(group : Symbol) : Set(Symbol)
      @replacements[group]? || Set(Symbol).new
    end

    # register what group the given string or regex matches
    def register!(group : Symbol, match : Enumerable(String | Regex)) : self
      @match_cache.clear

      match.each do |m|
        case m
        when String then @string_matchers[m] = group
        when Regex  then @regex_matchers[m] = group
        end
      end

      self
    end

    # register what groups are replaced by the given group
    def register!(group : Symbol, replace : Enumerable(Symbol)) : self
      @replacements[group] = Set(Symbol).new unless @replacements.has_key?(group)
      @replacements[group].concat replace.to_a

      self
    end

    def register!(group : Symbol, match : Enumerable(String | Regex), replace : Enumerable(Symbol)) : self
      register!(group, match)
      register!(group, replace)
    end

    def register(*args) : self
      clone.register!(*args)
    end

    private def regex_match?(token : String) : Symbol?
      @match_cache.fetch(token) do
        @match_cache[token] = @regex_matchers.each { |r, group| return group if r =~ token }
      end
    end
  end
end