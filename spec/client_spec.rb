require File.dirname(__FILE__) + '/spec_helper'

describe RuoteKit::Client do
  it "should be a factory to an agent" do
    RuoteKit::Client( 'http://localhost:8080' ).should be_a( RuoteKit::Client::Agent )
  end
end
