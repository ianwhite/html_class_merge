module HtmlClassMerge
  # Represents an ordered list of tokens, which are grouped by a symbol.
  # Only one token per group is stored.
  # The order of the tokens is determined by the order in which they are added.
  class GroupedTokens
    @tokens = {} of (Symbol | String) => String

    # Add a *token*, optionally to *group*
    # If a token for the *group* already exists, it will be removed and the new *token* will be added at the end of the list
    def add!(token : String, group : Symbol?) : self
      remove!(group) if group
      @tokens[group || token] = token
      self
    end

    # remove any existing token for the specified *group*
    def remove!(group : Symbol) : self
      @tokens.delete(group)
      self
    end

    def tokens : Array(String)
      @tokens.values
    end
  end
end
