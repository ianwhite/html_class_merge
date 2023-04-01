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

  # describe TailwindMergeStrategy do
  #   it "handles simple group override" do
  #     combiner = TailwindMergeStrategy.new(TestGroups.new)

  #     combiner.merge("bg-red bg-white text-green text-black").should eq "bg-white text-black"
  #   end

  #   it "handles simple replacements" do
  #     combiner = TailwindMergeStrategy.new(TestGroups.new)

  #     combiner.merge("border-l-1 border-x-2 border-3").should eq "border-3"
  #     combiner.merge("border-l-1 border-x-2").should eq "border-x-2"
  #     combiner.merge("border-l-1 border-y-2").should eq "border-l-1 border-y-2"
  #     combiner.merge("border-3 border-x-2 border-l-1").should eq "border-3 border-x-2 border-l-1"
  #     combiner.merge("border-l-1 border-y-2 border-l-3 border-b-2").should eq "border-y-2 border-l-3 border-b-2"
  #   end

  #   it "handles important" do
  #     combiner = TailwindMergeStrategy.new(TestGroups.new)

  #     combiner.merge("!bg-red bg-white text-green text-black").should eq "!bg-red text-black"
  #     combiner.merge("!bg-red bg-white !bg-green bg-black").should eq "!bg-green"
  #   end

  #   it "handles important when replacing groups" do
  #     combiner = TailwindMergeStrategy.new(TestGroups.new)
  #     combiner.merge("border-l-1 border-x-2 border-3").should eq "border-3"
  #     combiner.merge("!border-l-1 border-x-2 border-3").should eq "!border-l-1 border-3"
  #     combiner.merge("border-3 !border-l-2 border-l-1").should eq "border-3 !border-l-2"
  #     combiner.merge("border-3 !border-l-2 border-y-3 !border-x-2").should eq "border-3 border-y-3 !border-x-2"
  #     combiner.merge("border-3 !border-l-2 border-y-3 !border-x-2 !border-2").should eq "!border-2"
  #   end

  #   it "handles scopes (even if they are not specified in that same order)" do
  #     combiner = TailwindMergeStrategy.new(TestGroups.new)

  #     combiner.merge("hover:bg-red bg-white hover:bg-green").should eq "bg-white hover:bg-green"
  #     combiner.merge("lg:hover:bg-red hover:md:bg-green hover:lg:bg-blue md:hover:bg-white").should eq "hover:lg:bg-blue md:hover:bg-white"
  #   end

  #   it "handles important with scopes" do
  #     combiner = TailwindMergeStrategy.new(TestGroups.new)

  #     combiner.merge("!hover:bg-red bg-white hover:bg-green").should eq "!hover:bg-red bg-white"
  #     combiner.merge("lg:hover:bg-red !hover:md:bg-green hover:lg:bg-blue md:hover:bg-white").should eq "!hover:md:bg-green hover:lg:bg-blue"
  #   end

  #   it "handles scopes with replacements" do
  #     combiner = TailwindMergeStrategy.new(TestGroups.new)

  #     combiner.merge("md:border-l-1 md:border-x-2 border-3").should eq "md:border-x-2 border-3"
  #   end
  # end
end
