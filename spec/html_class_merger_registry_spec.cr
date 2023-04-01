require "./spec_helper"

describe HtmlClassMerger do
  describe "as group registry" do
    it "can register matches" do
      groups = HtmlClassMerger.new
      groups.register! :bg, [/\Abg-\w+-\d\d\d\z/, "bg-black", "bg-white"]

      groups.group_of_token?("bg-red-800").should eq :bg
      groups.group_of_token?("bg-white").should eq :bg
      groups.group_of_token?("text-black").should eq nil
    end

    it "can register replacements" do
      groups = HtmlClassMerger.new
      groups.register! :border_x, [:border_l, :border_r]

      groups.groups_replaced_by(:border_x).should eq Set{:border_l, :border_r}
      groups.groups_replaced_by(:border_l).should eq Set(Symbol).new
    end

    it "can register matches and replacements in one line" do
      groups = HtmlClassMerger.new
      groups.register! :border_x, match: [/\Aborder-x-\w\z/], replace: [:border_l, :border_r]

      groups.group_of_token?("border-x-2").should eq :border_x
      groups.groups_replaced_by(:border_x).should eq Set{:border_l, :border_r}
    end
  end
end
