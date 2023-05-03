require "../spec_helper"

require "../../src/html_class_merge/important_grouped_tokens"

module HTMLClassMerge
  describe ImportantGroupedTokens do
    it "can add! and remove! tokens by group" do
      list = ImportantGroupedTokens.new
      list.add! "bg-red", "bg"
      list.add! "text-lg", "text"
      list.add! "bg-green", "bg"

      list.tokens.should eq %w(text-lg bg-green)

      list.remove! "bg"

      list.tokens.should eq %w(text-lg)
    end

    it "when add!(..., important: true) then latter add! and remove! to group has no effect" do
      list = ImportantGroupedTokens.new
      list.add! "bg-red", "bg", true
      list.add! "text-lg", "text", false
      list.add! "bg-green", "bg", false

      list.tokens.should eq %w(bg-red text-lg)

      list.remove! "bg"

      list.tokens.should eq %w(bg-red text-lg)
    end

    it "add!(... important: true) overrides existing important group" do
      list = ImportantGroupedTokens.new
      list.add! "bg-red", "bg", true
      list.add! "bg-green", "bg", true

      list.tokens.should eq %w(bg-green)

      list.add! "bg-blue", "bg", false

      list.tokens.should eq %w(bg-green)
    end

    it "remove!(... important: true) overrides existing important group" do
      list = ImportantGroupedTokens.new
      list.add! "bg-red", "bg", true
      list.remove! "bg", true

      list.tokens.should eq [] of String

      list.add! "bg-blue", "bg", false

      list.tokens.should eq %w(bg-blue)
    end

    it "example" do
      class_names = ImportantGroupedTokens.new
      class_names.add!("text-lg", "text-size", important: true)
      class_names.add!("text-red-500", "text-color", important: false)
      class_names.add!("text-sm", "text-size", important: false) # does not replace "text-lg" because it is important

      class_names.tokens.should eq %w(text-lg text-red-500)

      class_names.remove!("text-size", override_important: false) # does not remove "text-lg" because is important

      class_names.tokens.should eq %w(text-lg text-red-500)

      class_names.remove!("text-size", override_important: true) # DOES remove "text-lg" because important override is true

      class_names.tokens.should eq %w(text-red-500)
    end
  end
end
