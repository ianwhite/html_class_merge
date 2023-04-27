require "../spec_helper"

module HtmlClass
  describe Tokenize do
    it "#tokenize tokenizes a String" do
      Tokenize.tokenize("foo bar baz").should eq %w(foo bar baz)
      Tokenize.tokenize("  foo bar   baz ").should eq %w(foo bar baz)
    end

    it "#tokenize tokenizes a splat of String" do
      Tokenize.tokenize("foo", "bar", "baz").should eq %w(foo bar baz)
      Tokenize.tokenize("foo bar", "baz").should eq %w(foo bar baz)
    end

    it "#tokenize tokenizes an array of String" do
      Tokenize.tokenize(["foo", "bar", "baz"]).should eq %w(foo bar baz)
      Tokenize.tokenize(["foo bar", "baz"]).should eq %w(foo bar baz)
    end

    it "#tokenize tokenizes a splat of String or Array(String) - HtmlClass::Tokenizable" do
      Tokenize.tokenize("foo bar", ["baz"]).should eq %w(foo bar baz)
      Tokenize.tokenize(["foo bar", "baz"], "bing", %w(badda bing)).should eq %w(foo bar baz bing badda bing)
    end
  end
end
