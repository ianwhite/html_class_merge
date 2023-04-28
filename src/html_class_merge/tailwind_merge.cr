require "../html_class_merge"
require "./important_grouped_tokens"

module HtmlClassMerge
  class TailwindMerge < GroupedMerge
    def merge(*html_classes : Tokenizable) : String
      tokenize(*html_classes).reduce(ImportantGroupedTokens.new) do |tokens, tok|
        orig_tok = tok
        is_important, tok = important_token(tok)
        scope, tok = scoped_token(tok)
        group = group_for?(tok)

        if group
          groups_replaced_by?(group).each { |g| tokens.remove!("#{scope}#{g}", is_important) }
        end

        tokens.add!(orig_tok, "#{scope}#{group || tok}", is_important)
      end.tokens.join(" ")
    end

    # in tailwind, important classes are prefixed with "!"
    def important_token(token : String) : {Bool, String}
      token.starts_with?("!") ? {true, token[1..]} : {false, token}
    end

    # in tailwind, the scope is a prefix of one or more tokens separated by ":", followed by ":"
    def scoped_token(token : String) : {String, String}
      if token.includes?(":")
        *scope, token = token.split(":")
        {scope.sort.join(":") + ":", token}
      else
        {"", token}
      end
    end
  end
end
