require "./spec_helper"

TestMerger = HtmlClassMerger.new
TestMerger.register! :bg, [/\Abg-/]
TestMerger.register! :text, [/\Atext-/]
TestMerger.register! :border, [/\Aborder-\d/], replace: [:border_x, :border_y, :border_l, :border_r, :border_t, :border_b]
TestMerger.register! :border_x, [/\Aborder-x-\d/], replace: [:border_l, :border_r]
TestMerger.register! :border_y, [/\Aborder-y-\d/], replace: [:border_t, :border_b]
TestMerger.register! :border_l, [/\Aborder-l-\d/]
TestMerger.register! :border_r, [/\Aborder-r-\d/]
TestMerger.register! :border_t, [/\Aborder-t-\d/]
TestMerger.register! :border_b, [/\Aborder-b-\d/]

describe HtmlClassMerger do
  describe "#merge" do
    it "demonstrates simple group override" do
      TestMerger.merge("bg-red bg-white text-green text-black").should eq "bg-white text-black"
    end

    it "demonstrates replacing groups" do
      TestMerger.merge("border-l-1 border-x-2 border-3").should eq "border-3"
      TestMerger.merge("border-l-1 border-x-2").should eq "border-x-2"
      TestMerger.merge("border-l-1 border-y-2").should eq "border-l-1 border-y-2"
      TestMerger.merge("border-3 border-x-2 border-l-1").should eq "border-3 border-x-2 border-l-1"
      TestMerger.merge("border-l-1 border-y-2 border-l-3 border-b-2").should eq "border-y-2 border-l-3 border-b-2"
    end
  end

  describe "#register! - all the ways" do
    it "(group : Symbol, String)" do
      merger = HtmlClassMerger.new
      merger.register! :foobar, "foo bar"
      merger.merge("foo bar baz").should eq "bar baz"
    end

    it "(group : Symbol, Enumerable(String | Regex))" do
      merger = HtmlClassMerger.new
      merger.register! :foobar, [/foo/, "bar"]
      merger.merge("foo bar baz").should eq "bar baz"
    end

    it "(group : Symbol, tokens : String)" do
      merger = HtmlClassMerger.new
      merger.register! :foobar, "foo bar"
      merger.merge("foo bar baz").should eq "bar baz"
    end

    it "(group : Symbol, *splat of things)" do
      merger = HtmlClassMerger.new
      merger.register! :foobar, "foo", ["foo2 bar2", /\Abar\z/]
      merger.merge("foo foo2 bar bar2 baz").should eq "bar2 baz"
    end

    it "(group : Symbol, matcher, replace: Symbol)" do
      merger = HtmlClassMerger.new
      merger.register! :foobar, "foo", replace: :foo
      merger.groups_replaced_by?(:foobar).should eq Set{:foo}
    end

    it "(group : Symbol, matcher, replace: Enumerable(Symbol))" do
      merger = HtmlClassMerger.new
      merger.register! :foobar, "foo", replace: %i(foo bar)
      merger.groups_replaced_by?(:foobar).should eq Set{:foo, :bar}
    end

    it "(merger : HtmlClassMerger) merges the argument's registry with ours" do
      merger = HtmlClassMerger.new
      merger.register! :foobar, "foo"
      merger2 = HtmlClassMerger.new
      merger2.register! :foobar, "bar"
      merger2.register! merger
      merger2.merge("foo bar baz").should eq "bar baz"
    end
  end

  describe "#register" do
    it "does not mutate the original" do
      merger = HtmlClassMerger.new
      merger.register! :foobar, "foo"
      merger2 = merger.register(:foobar, "bar")
      merger3 = merger.register(merger2).register!(:foobar, "baz")

      merger.should_not eq merger2
      merger.should_not eq merger3

      merger.merge("foo bar baz").should eq "foo bar baz"
      merger2.merge("foo bar baz").should eq "bar baz"
      merger3.merge("foo bar baz").should eq "baz"
    end
  end
end
