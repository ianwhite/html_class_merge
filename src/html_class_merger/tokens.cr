class HtmlClassMerger
  # Represents an ordered list of tokens, which are grouped by arbitrary strings, and can also be marked as important.
  # Only one token per group is stored.
  class Tokens
    @tokens = {} of String => String
    @important = Set(String).new

    # Add the token to the group, optionally marking it as important,
    # If there is no group known for the token, use the token itself as the group
    def add!(token : String, group : Symbol | String, important : Bool = false) : self
      group = group.to_s

      if !existing_important?(group) || important
        # when replacing a token in a group, remove the old token so that the token is placed at the end of the list
        @tokens.delete(group)
        @tokens[group] = token
      end

      if important
        @important << group
      end

      self
    end

    # remove the token for the specified group, unless the token is marked as important
    # if override_important is true, the token for the group will be removed even if it is marked as important
    def remove!(group : Symbol | String, override_important : Bool = false) : self
      group = group.to_s

      if !existing_important?(group) || override_important
        @tokens.delete(group)
      end

      if override_important
        @important.delete(group)
      end

      self
    end

    def to_s : String
      @tokens.values.join(" ")
    end

    private def existing_important?(group : String) : Bool
      @important.includes?(group)
    end
  end
end