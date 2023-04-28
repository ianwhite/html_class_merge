require "./spec_helper"
require "yaml"

describe HtmlClassMerge do
  it "version should match shard.yml" do
    yaml = File.open("shard.yml") do |file|
      YAML.parse(file)
    end

    HtmlClassMerge::VERSION.should eq yaml["version"]
  end
end
