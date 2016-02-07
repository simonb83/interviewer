require 'spec_helper'

describe Reference do

  it "validates presence of name" do
    reference = Reference.new(name: "")
    reference.should_not be_valid
  end

  it "validates presence of email" do
    reference = Reference.new(name: "Simon", email: "")
    reference.should_not be_valid
  end

  it "validates presence of relationship" do
    reference = Reference.new(name: "Simon", email: "Email", relationship: "")
    reference.should_not be_valid
  end

end
