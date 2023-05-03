require "spec"
require "../../src/html_class_merge/tokenize"
require "../../src/html_class_merge/merge"

class TestMerge
  include HTMLClassMerge::Merge
  include HTMLClassMerge::Tokenize

  def merge(*tokens : HTMLClassMerge::Tokenizable) : String
    tokenize(*tokens).join(" ")
  end
end

module HTMLClassMerge
  describe "example of implementing Merge protocol" do
    it "works" do
      TestMerge.new.merge("foo", "bar").should eq "foo bar"
    end
  end
end
