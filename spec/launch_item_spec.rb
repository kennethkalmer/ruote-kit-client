require File.dirname(__FILE__) + '/spec_helper'

describe RuoteKit::Client::LaunchItem do
  before(:each) do
    @li = RuoteKit::Client::LaunchItem.new
  end

  it "should have a process definition" do
    @li.should respond_to(:definition)
    @li.should respond_to(:definition=)
  end

  it "should have a process uri" do
    @li.should respond_to(:uri)
    @li.should respond_to(:uri=)
  end

  it "should have fields" do
    @li.fields.should be_a_kind_of( Hash )
    @li.fields.should be_empty
  end

  it "should validate" do
    @li.should_not be_valid

    @li.definition = 'foo'
    @li.should be_valid

    @li.definition = nil

    @li.uri = 'http://www.example.com/foo.rb'
    @li.should be_valid
  end

  it "should have a JSON representation" do
    @li.definition = "foo"

    JSON.parse( @li.to_json ).should == { "fields" => {}, "definition" => "foo" }
  end
end
