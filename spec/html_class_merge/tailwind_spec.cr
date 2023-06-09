require "../spec_helper"
require "../../src/html_class_merge/tailwind"

module HTMLClassMerge
  describe Tailwind do
    it "display" do
      Tailwind.merge("inline-block flex block table-row").should eq "table-row"
      Tailwind.merge("inline-block !flex block table-row").should eq "!flex"
    end

    it "overflow" do
      Tailwind.merge("overflow-x-scroll overflow-hidden").should eq "overflow-hidden"
      Tailwind.merge("overflow-hidden overflow-y-clip").should eq "overflow-hidden overflow-y-clip"
    end

    it "top-right-bottom-left" do
      Tailwind.merge("left-[12px] top-4 -left-3 inset-y-3").should eq "-left-3 inset-y-3"
      Tailwind.merge("bottom-2 inset-2 inset-x-1").should eq "inset-2 inset-x-1"
      Tailwind.merge("top-12 left-10 inset-[40px]").should eq "inset-[40px]"
      Tailwind.merge("top-3 left-4 -inset-x-10").should eq "top-3 -inset-x-10"
      Tailwind.merge("-top-4 start-0 end-4 inset-y-px").should eq "start-0 end-4 inset-y-px"
    end

    it "flex" do
      Tailwind.merge("flex-1 flex-auto").should eq "flex-auto"
      Tailwind.merge("basis-24 basis-full basis-3/4").should eq "basis-3/4"
      Tailwind.merge("row-span-4 row-auto col-auto col-span-12").should eq "row-auto col-span-12"
    end

    it "spacing" do
      Tailwind.merge("pl-2.5 pb-px pr-[12px] p-4 m-2 ml-5 ms-8 -mx-2 me-4").should eq "p-4 m-2 -mx-2 me-4"
      Tailwind.merge("-ml-2 me-4 mx-[13px]").should eq "mx-[13px]"
      Tailwind.merge("mx-[-13px] m-[7px]").should eq "m-[7px]"
    end

    it "background" do
      Tailwind.merge("bg-red-700 bg-[#787878]/20 bg-none bg-[url('foo.png')]").should eq "bg-[#787878]/20 bg-[url('foo.png')]"
    end

    it "bg color and opacity" do
      Tailwind.merge("bg-black/40 bg-green-500/50").should eq "bg-green-500/50"
      Tailwind.merge("bg-black bg-green-500/50").should eq "bg-green-500/50"
    end

    it "border color and opacity" do
      Tailwind.merge("border-white border-black/50").should eq "border-black/50"
      Tailwind.merge("border-l-green-300 border-r-white border-white").should eq "border-white"
      Tailwind.merge("border-black border-l-blue-500 border-l-white").should eq "border-black border-l-white"
    end

    it "border width and style" do
      Tailwind.merge("border-4 border-2 border-s-2 border-x-1 border-r-0").should eq "border-2 border-x-1 border-r-0"
      Tailwind.merge("border-4 border-l border-r-0 border-2").should eq "border-2"
      Tailwind.merge("border-dashed border-none").should eq "border-none"
    end

    it "README example" do
      button = "rounded-sm border border-gray-600 bg-gray-50 text-gray-900 hover:bg-gray-700 hover:text-white px-3 py-2"
      danger = "border-red-600 bg-red-50 hover:bg-red-700"
      large = "rounded text-lg p-5 border-2"

      Tailwind.merge("#{button} #{danger}").should eq "rounded-sm border text-gray-900 hover:text-white px-3 py-2 border-red-600 bg-red-50 hover:bg-red-700"
      Tailwind.merge([button, large]).should eq "border-gray-600 bg-gray-50 text-gray-900 hover:bg-gray-700 hover:text-white rounded text-lg p-5 border-2"
      Tailwind.merge(button, danger, large).should eq "text-gray-900 hover:text-white border-red-600 bg-red-50 hover:bg-red-700 rounded text-lg p-5 border-2"
    end
  end
end
