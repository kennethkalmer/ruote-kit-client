require File.dirname(__FILE__) + '/spec_helper'

describe RuoteKit::Client::Workitem do
  before(:each) do
    @workitem = RuoteKit::Client::Workitem.new({"fei"=> {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}, "participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}}, "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}]})

    @agent = RuoteKit::Client::Agent.new('http://localhost:8080/')
    @workitem.agent = @agent
  end

  it "should have a process" do
    mock_request(
      @agent,
      :get,
      '/processes/20091204-bojupuraju',
      nil,
      { :accept => 'application/json' },
      { "process" => {"wfid"=>"20091204-bojupuraju", "definition_name"=>"test", "definition_revision"=>nil, "original_tree"=>["define", {"name"=>"test"}, [["sequence", {}, [["nada", {"activity"=>"REST :)"}, []]]]]], "current_tree"=>["define", {"name"=>"test"}, [["sequence", {}, [["participant", {"activity"=>"REST :)", "ref"=>"nada"}, []]]]]], "variables"=>{"test"=>["0", ["define", {"name"=>"test"}, [["sequence", {}, [["nada", {"activity"=>"REST :)"}, []]]]]]]}, "tags"=>{}, "launched_time"=>"2009-12-04 12:04:55 +0200", "root_expression"=>nil, "expressions"=>[{"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0"}, {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0"}, {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}], "errors"=>[], "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}, {"href"=>"/workitems/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}]}}
    )

    process = @workitem.process
    process.should_not be_nil
    process.should be_a_kind_of( RuoteKit::Client::Process )
    process.agent.should_not be_nil
    process.wfid.should == @workitem['fei']['wfid']
  end
  it "should have an expression"
  it "can be updated" do
    @agent.expects( :update_workitem ).with( @workitem ).returns( true )
    @workitem.save
  end
  it "can be proceeded" do
    @agent.expects( :proceed_workitem ).with( @workitem ).returns( true )
    @workitem.proceed
  end
end
