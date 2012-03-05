require File.join(File.dirname(__FILE__),'..','spec_helper')

describe "Ticket" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for Ticket,'testuser'
    end

    it "should process Ticket query" do
      pending
    end

    it "should process Ticket create" do
      pending
    end

    it "should process Ticket update" do
      pending
    end

    it "should process Ticket delete" do
      pending
    end
  end  
end