require "../html_class_merger"

class HtmlClassMerger::TailwindClassMerger < HtmlClassMerger
  # in tailwind, important classes are prefixed with "!"
  def important_token(token : String) : { Bool, String }
    token.starts_with?("!") ? { true, token[1..] } : { false, token }
  end

  # in tailwind, the scope is a prefix of one or more tokens separated by ":", followed by ":"
  def scoped_token(token : String) : { String, String }
    if token.includes?(":")
      *scope, token = token.split(":")
      { scope.sort.join(":") + ":", token }
    else
      { "", token }
    end
  end
end
