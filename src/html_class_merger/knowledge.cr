class HtmlClassMerger
  # Protocol for how to get knowledge about html classes, is used by Merge to build a list of html classes
  module Knowledge
    # Given a group symbol, return the set of symbols that it replaces.
    abstract def groups_replaced_by(group : Symbol) : Set(Symbol)

    # Given a html class token, return the group symbol that it belongs to, if any.
    abstract def group_of_token?(token : String) : Symbol?

    # Given a html class token, return whether it is important, along with the underlying token name
    abstract def important_token(token : String) : { Bool, String }

    # Given a html class token, return its scope, along with the underlying token name.
    # The return value is a tuple of the scope and the underlying token name, if the token
    # is not scoped, the scope should be the empty string "".
    abstract def scoped_token(token : String) : { String, String }
  end
end