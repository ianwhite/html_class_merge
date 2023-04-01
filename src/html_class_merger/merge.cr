require "./tokens"

class HtmlClassMerger
  # The Merge module contains the algorithm to merge html classes, using the Knowledge protocol to find out
  # which classes are important, scoped, and grouped
  module Merge
    abstract def knowledge : Knowledge

    # uses the Knowledge protocol and Tokens object to merge html classes
    def merge(html_classes : String) : String
      html_class_tokens(html_classes).reduce(Tokens.new) do |tokens, token|
        original_token = token

        is_important, token = knowledge.important_token(token)
        scope, token        = knowledge.scoped_token(token)
        group               = knowledge.group_of_token?(token)

        if group
          knowledge.groups_replaced_by(group).each { |g| tokens.remove! "#{scope}#{g}", is_important }
        end

        tokens.add! original_token, "#{scope}#{group || token}", is_important
      end.to_s
    end

    private def html_class_tokens(html_classes : String) : Array(String)
      html_classes.split(/\s+/).reject(&.empty?)
    end
  end
end
