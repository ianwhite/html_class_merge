require "./html_class_merger/merge"
require "./html_class_merger/group_registry"

class HtmlClassMerger
  VERSION = "0.1.0"

  include Merge

  @group_registry = GroupRegistry.new

  delegate register!, register, to: @group_registry

  # use the group regsitry to find the group for the given token
  def group_for?(token : String) : String?
    @group_registry.group_for?(token)
  end

  # use the groups registry to find the groups replaced by the given group
  def groups_replaced_by?(group : String) : Set(String)?
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
