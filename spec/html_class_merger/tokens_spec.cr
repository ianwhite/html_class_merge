require "../spec_helper"

class HtmlClassMerger
  describe Tokens do
    it "can add! and remove! tokens by group" do
      list = Tokens.new
      list.add! "bg-red", "bg"
      list.add! "text-lg", "text"
      list.add! "bg-green", "bg"

      list.to_s.should eq "text-lg bg-green"

      list.remove! "bg"

      list.to_s.should eq "text-lg"
    end

    it "when add!(..., important: true) then latter add! and remove! to group has no effect" do
      list = Tokens.new
      list.add! "bg-red", "bg", true
      list.add! "text-lg", "text", false
      list.add! "bg-green", "bg", false

      list.to_s.should eq "bg-red text-lg"

      list.remove! "bg"

      list.to_s.should eq "bg-red text-lg"
    end

    it "add!(... important: true) overrides existing important group" do
      list = Tokens.new
      list.add! "bg-red", "bg", true
      list.add! "bg-green", "bg", true

      list.to_s.should eq "bg-green"

      list.add! "bg-blue", "bg", false

      list.to_s.should eq "bg-green"
    end

    it "remove!(... important: true) overrides existing important group" do
      list = Tokens.new
      list.add! "bg-red", "bg", true
      list.remove! "bg", true

      list.to_s.should eq ""

      list.add! "bg-blue", "bg", false

      list.to_s.should eq "bg-blue"
    end

    it "example" do
      class_names = Tokens.new
      class_names.add!("text-lg", "text-size", important: true)
      class_names.add!("text-red-500", "text-color", important: false)
      class_names.add!("text-sm", "text-size", important: false) # does not replace "text-lg" because it is important
      class_names.to_s.should eq "text-lg text-red-500"
      class_names.remove!("text-size", override_important: false) # does not remove "text-lg" because is important
      class_names.to_s.should eq "text-lg text-red-500"
      class_names.remove!("text-size", override_important: true) # DOES remove "text-lg" because important override is true
      class_names.to_s.should eq "text-red-500"
    end
  end
end
