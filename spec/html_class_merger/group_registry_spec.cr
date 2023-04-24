require "../spec_helper"

class HtmlClassMerger
  describe GroupRegistry do
    it "can register groups with #register!" do
      registry = GroupRegistry.new
      registry.register! :bg, /\Abg-\w+-\d\d\d\z/, "bg-black bg-white"
      registry.register! :text, %w(text-black text-white)
      registry.register! :text, /\Atext-\w+-\d\d\d\z/

      registry.group_for?("bg-red-800").should eq :bg
      registry.group_for?("bg-white").should eq :bg
      registry.group_for?("text-black").should eq :text
      registry.group_for?("text-red-800").should eq :text
      registry.group_for?("rounded").should eq nil
    end

    it "can register replacements" do
      registry = GroupRegistry.new
      registry.register! :border_x, [:border_l, :border_r]
      registry.register! :border, :border_x

      registry.groups_replaced_by?(:border_x).should eq Set{:border_l, :border_r}
      registry.groups_replaced_by?(:border).should eq Set{:border_x}
      registry.groups_replaced_by?(:text).should eq nil
    end

    it "can register matches and replacements in one line" do
      registry = GroupRegistry.new
      registry.register! :border_x, /\Aborder-x-\w\z/, "border-x-none", replace: [:border_l, :border_r]

      registry.group_for?("border-x-2").should eq :border_x
      registry.group_for?("border-x-none").should eq :border_x
      registry.groups_replaced_by?(:border_x).should eq Set{:border_l, :border_r}
    end

    it "can merge! another group_registry" do
      registry1 = GroupRegistry.new
      registry1.register! :border_x, /\Aborder-x-\w\z/, "border-x-none", replace: [:border_l, :border_r]

      registry2 = GroupRegistry.new
      registry2.register! :border_y, /\Aborder-y-\w\z/, "border-y-none", replace: [:border_t, :border_b]

      registry2.merge!(registry1)
      registry2.group_for?("border-x-2").should eq :border_x
      registry2.group_for?("border-y-2").should eq :border_y
      registry2.groups_replaced_by?(:border_x).should eq Set{:border_l, :border_r}
    end
  end
end
