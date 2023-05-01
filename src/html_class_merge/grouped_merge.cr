require "./group_registry"
require "./grouped_tokens"
require "./merge"
require "./tokenize"

module HtmlClassMerge
  class GroupedMerge
    include Merge
    include Tokenize

    def_clone

    # used to register and lookup info about groups
    getter group_registry : GroupRegistry = GroupRegistry.new

    # Register a group with the group registry
    def register!(*args, **kwargs)
      @group_registry.register!(*args, **kwargs)
      self
    end

    # merge the given HrefClassMerger's group registry into this one's
    def register!(merger : GroupedMerge)
      @group_registry.merge!(merger.group_registry)
      self
    end

    # non mutating version of register!
    def register(*args, **kwargs)
      clone.register!(*args, **kwargs)
    end

    delegate group_for?, groups_replaced_by?, to: @group_registry

    # Merge the given html classes into a single string
    def merge(*html_classes : Tokenizable) : String
      tokenize(*html_classes).reduce(GroupedTokens.new) do |tokens, tok|
        group = group_for?(tok)
        groups_replaced_by?(group).each { |g| tokens.remove!(g) } if group
        tokens.add!(tok, group)
      end.tokens.join(" ")
    end
  end
end
