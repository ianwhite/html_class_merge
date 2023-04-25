require "./html_class_merger/merge"
require "./html_class_merger/group_registry"

class HtmlClassMerger
  VERSION = "0.2.3"

  include Merge

  def_clone

  # used to register and lookup info about groups
  getter group_registry : GroupRegistry = GroupRegistry.new

  # Register a group with the group registry
  def register!(*args, **kwargs)
    @group_registry.register!(*args, **kwargs)
    self
  end

  # merge the given HrefClassMerger's group registry into this one's
  def register!(merger : HtmlClassMerger)
    @group_registry.merge!(merger.group_registry)
    self
  end

  # non mutating version of register!
  def register(*args, **kwargs)
    clone.register!(*args, **kwargs)
  end

  # Returns the group of the given *token*, or nil if the token is not a group
  def group_for?(token : String) : Symbol?
    @group_registry.group_for?(token)
  end

  # Returns the set of groups that *group* replaces, or nil if there are none
  def groups_replaced_by?(group : Symbol) : Set(Symbol)?
    @group_registry.groups_replaced_by?(group)
  end

  # Returns whether *token* is an important token
  #
  # This implementation always returns { false, token },
  # subclass to add knowledge of what tokens are important.
  def important_token(token : String) : { Bool, String }
    { false, token }
  end

  # Returns the scope and underlying token for *token*
  #
  # This implementation always returns { "", token } (no scope),
  # subclass to add knowledge of what scoped tokens look like.
  def scoped_token(token : String) : { String, String }
    { "", token }
  end
end
