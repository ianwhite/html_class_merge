require "./tokenizable"

module HTMLClassMerge
  # Protocol for merging tokens into a string
  module Merge
    # Merge the given tokens into a string
    abstract def merge(*tokens : Tokenizable) : String
  end
end
