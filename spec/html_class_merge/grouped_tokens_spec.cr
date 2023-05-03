require "../spec_helper"

module HTMLClassMerge
  describe GroupedTokens do
    it "can add! and remove! tokens by group" do
      list = GroupedTokens.new
      list.add! "bg-red", :bg
      list.add! "text-lg", :text

      list.tokens.should eq %w(bg-red text-lg)

      list.add! "bg-green", :bg
      list.add! "floom", nil

      list.tokens.should eq %w(text-lg bg-green floom)

      list.remove! :bg

      list.tokens.should eq %w(text-lg floom)

      list.remove! :text

      list.tokens.should eq %w(floom)
    end
  end
end
