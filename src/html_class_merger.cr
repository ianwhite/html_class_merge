require "./html_class_merger/knowledge"
require "./html_class_merger/merge"
require "./html_class_merger/group_registry"

class HtmlClassMerger
  VERSION = "0.1.0"

  include Merge

  @group_registry = GroupRegistry.new

  delegate register!, register, to: @group_registry

  def knowledge : Knowledge
    self
  end

  include Knowledge

  def group_of_token?(token : String) : Symbol?
    @group_registry[token]?
  end

  def groups_replaced_by(group : Symbol) : Set(Symbol)
    @group_registry.replacements(group)
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
