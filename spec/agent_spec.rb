require File.dirname(__FILE__) + '/spec_helper'

describe RuoteKit::Client::Agent do
  before(:each) do
    @agent = RuoteKit::Client::Agent.new( 'http://localhost:8080/' )
  end

  it "should know it's url" do
    @agent.url.should == 'http://localhost:8080/'
  end
end
