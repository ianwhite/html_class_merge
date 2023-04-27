require "../spec_helper"

module HtmlClassMerge
  describe RegexIndex do
    it "#regex_index documentation example" do
      regex = /\Afoo-(bar|baz)\z/
      RegexIndex.regex_index(regex).should eq "fo"
      RegexIndex.regex_index(regex, 3).should eq "foo"
      RegexIndex.regex_index(regex, 4).should eq "foo-"
      RegexIndex.regex_index(regex, 5).should be_nil
      RegexIndex.regex_index(regex, 3, "f").should be_nil
      RegexIndex.regex_index(regex, 3, /[fo]/).should eq "foo"
      RegexIndex.regex_index(regex, 4, /[fo]/).should be_nil
    end

    it "#regex_index documentation example with caret anchor" do
      regex = /^foo-(bar|baz)\z/
      RegexIndex.regex_index(regex).should eq "fo"
      RegexIndex.regex_index(regex, 3).should eq "foo"
      RegexIndex.regex_index(regex, 4).should eq "foo-"
      RegexIndex.regex_index(regex, 5).should be_nil
      RegexIndex.regex_index(regex, 3, "f").should be_nil
      RegexIndex.regex_index(regex, 3, /[fo]/).should eq "foo"
      RegexIndex.regex_index(regex, 4, /[fo]/).should be_nil
    end

    it "#regex_index returns nil for non start anchored regex" do
      RegexIndex.regex_index(/foo/).should be_nil
      RegexIndex.regex_index(/foo\z/).should be_nil
    end

    it "#regex_index returns nil for union regex" do
      RegexIndex.regex_index(/\Afoo|bar/).should be_nil
    end

    it "#regex_index returns nil for regex with non chars" do
      RegexIndex.regex_index(/\A\d-foo/).should be_nil
    end
  end
end
