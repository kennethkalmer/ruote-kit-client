require File.dirname(__FILE__) + '/spec_helper'

describe RuoteKit::Client::Process do
  before(:each) do
    @process = RuoteKit::Client::Process.new(
      {"wfid"=>"20091204-bojupuraju", "definition_name"=>"test", "definition_revision"=>nil, "original_tree"=>["define", {"name"=>"test"}, [["sequence", {}, [["nada", {"activity"=>"REST :)"}, []]]]]], "current_tree"=>["define", {"name"=>"test"}, [["sequence", {}, [["participant", {"activity"=>"REST :)", "ref"=>"nada"}, []]]]]], "variables"=>{"test"=>["0", ["define", {"name"=>"test"}, [["sequence", {}, [["nada", {"activity"=>"REST :)"}, []]]]]]]}, "tags"=>{}, "launched_time"=>"2009-12-04 12:04:55 +0200", "root_expression"=>nil, "expressions"=>[{"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0"}, {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0"}, {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}], "errors"=>[], "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}, {"href"=>"/workitems/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}]}
    )
  end

  it "should have a wfid" do
    @process.wfid.should == '20091204-bojupuraju'
  end

  it "should have a name" do
    @process.name.should == 'test'
  end

  it "should have a revision" do
    @process.revision.should be_nil
  end

  it "should have a list of expressions"
  it "should have a list of workitems"
end
