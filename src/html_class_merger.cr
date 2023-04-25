require "./html_class_merger/merge"
require "./html_class_merger/group_registry"

class HtmlClassMerger
  VERSION = "0.2.3"

  include Merge

  def_clone

  @group_registry = GroupRegistry.new

  protected getter group_registry : GroupRegistry

  def register!(*args, **kwargs)
    @group_registry.register!(*args, **kwargs)
    self
  end

  def register(*args, **kwargs)
    clone.register!(*args, **kwargs)
  end

  def register!(merger : HtmlClassMerger)
    @group_registry.merge!(merger.group_registry)
    self
  end

  # use the group regsitry to find the group for the given token
  def group_for?(token : String) : Symbol?
    @group_registry.group_for?(token)
  end

  # use the groups registry to find the groups replaced by the given group
  def groups_replaced_by?(group : Symbol) : Set(Symbol)?
    @group_registry.groups_replaced_by?(group)
  end

  # subclass to add knwoledge of what tokens are important
  def important_token(token : String) : { Bool, String }
    { false, token }
  end

  # subclass to add knowledge of what scoped tokens look like
  def scoped_token(token : String) : { String, String }
    { "", token }
  end
end
