require File.dirname(__FILE__) + '/spec_helper'

describe RuoteKit::Client::Process do
  before(:each) do
    @process = RuoteKit::Client::Process.new(
      {"wfid"=>"20091204-bojupuraju", "definition_name"=>"test", "definition_revision"=>nil, "original_tree"=>["define", {"name"=>"test"}, [["sequence", {}, [["nada", {"activity"=>"REST :)"}, []]]]]], "current_tree"=>["define", {"name"=>"test"}, [["sequence", {}, [["participant", {"activity"=>"REST :)", "ref"=>"nada"}, []]]]]], "variables"=>{"test"=>["0", ["define", {"name"=>"test"}, [["sequence", {}, [["nada", {"activity"=>"REST :)"}, []]]]]]]}, "tags"=>{}, "launched_time"=>"2009-12-04 12:04:55 +0200", "root_expression"=>nil, "expressions"=>[{"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0"}, {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0"}, {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}], "errors"=>[], "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}, {"href"=>"/workitems/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}]}
    )

    @agent = RuoteKit::Client::Agent.new('http://localhost:8080/')
    @process.agent = @agent
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

  it "should have a list of expressions" do
    @agent.expects( :expressions ).with( @process )
    @process.expressions
  end
  it "should have a list of workitems" do
    mock_request(
      @agent,
      :get,
      "/workitems/20091204-bojupuraju",
      nil,
      { :accept => 'application/json', :params => {} },
      {"workitems"=>[{"fei"=> {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}, "participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}}, "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}]}]}
    )

    workitems = @process.workitems
    workitems.should_not be_empty
    workitems.first.should be_a_kind_of( RuoteKit::Client::Workitem )
    workitems.first.agent.should_not be_nil
  end

  it "can be cancelled" do
    mock_request(
      @agent,
      :delete,
      "/processes/#{@process.wfid}",
      nil,
      { :accept => 'application/json' },
      { "status" => "ok" }
    )

    @process.cancel!
  end

  it "can be killed" do
    mock_request(
      @agent,
      :delete,
      "/processes/#{@process.wfid}?_kill=1",
      nil,
      { :accept => 'application/json' },
      { "status" => "ok" }
    )

    @process.kill!
  end
end
