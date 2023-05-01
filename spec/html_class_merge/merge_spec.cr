require "spec"
require "../../src/html_class_merge/tokenize"
require "../../src/html_class_merge/merge"

class TestMerge
  include HtmlClassMerge::Merge
  include HtmlClassMerge::Tokenize

  def merge(*tokens : HtmlClassMerge::Tokenizable) : String
    tokenize(*tokens).join(" ")
  end
end

module HtmlClassMerge
  describe "example of implementing Merge protocol" do
    it "works" do
      TestMerge.new.merge("foo", "bar").should eq "foo bar"
    end
  end
end
