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

  it "should be instanciated by passing an URI" do
    uri = URI.parse('http://localhost:8080/some/fine/test')
    li = RuoteKit::Client::LaunchItem.new(uri)
    li.should be_a_kind_of(RuoteKit::Client::LaunchItem)
    li.uri.should == 'http://localhost:8080/some/fine/test'
    li.should be_valid
  end

  it "should be instanciated by passing a definition uri as string" do
    uri = 'http://localhost:8080/some/fine/test'
    li = RuoteKit::Client::LaunchItem.new(uri)
    li.should be_a_kind_of(RuoteKit::Client::LaunchItem)
    li.uri.should == 'http://localhost:8080/some/fine/test'
    li.should be_valid
  end

  it "should treat other strings passed to the initialize method as first argument as definitions" do
    li = RuoteKit::Client::LaunchItem.new('foo')
    li.should be_a_kind_of(RuoteKit::Client::LaunchItem)
    li.definition.should == 'foo'
    li.should be_valid
  end

  it "should set the fields according to the given fields as second argument of the initialize method" do
    li = RuoteKit::Client::LaunchItem.new('foo', {'moo' => 'mah', 'boo' => 'baa'})
    li.should be_a_kind_of(RuoteKit::Client::LaunchItem)
    li.fields.should == {'moo' => 'mah', 'boo' => 'baa'}
  end
end
