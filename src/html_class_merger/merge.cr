require "./tokens"
require "./tokenize"

class HtmlClassMerger
  # The Merge module contains the algorithm to merge html classes, using knowledge about html classes of
  # which classes are important, scoped, and grouped, which the implementor of this module must provide.
  module Merge
    include Tokenize

    # Given a group, return the set of groups that it replaces, or nil
    abstract def groups_replaced_by?(group : String | Symbol) : Set(String)?

    # Given a html class token, return the group that it belongs to, if any.
    abstract def group_for?(token : String) : String?

    # Given a html class token, return whether it is important, along with the underlying token name
    abstract def important_token(token : String) : { Bool, String }

    # Given a html class token, return its scope, along with the underlying token name.
    # The return value is a tuple of the scope and the underlying token name, if the token
    # is not scoped, the scope should be the empty string "".
    abstract def scoped_token(token : String) : { String, String }

    # uses the Knowledge protocol and Tokens object to merge html classes
    def merge(html_classes : String) : String
      tokenize(html_classes).reduce(Tokens.new) do |tokens, token|
        original_token = token

        is_important, token = important_token(token)
        scope, token        = scoped_token(token)
        group               = group_for?(token)

        if group && (replacements = groups_replaced_by?(group))
          replacements.each { |g| tokens.remove! "#{scope}#{g}", is_important }
        end

        tokens.add! original_token, "#{scope}#{group || token}", is_important
      end.to_s
    end
  end
end
