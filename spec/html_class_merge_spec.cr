require "./spec_helper"
require "yaml"

describe HTMLClassMerge do
  it "version should match shard.yml" do
    yaml = File.open("shard.yml") do |file|
      YAML.parse(file)
    end

    HTMLClassMerge::VERSION.should eq yaml["version"]
  end
end
