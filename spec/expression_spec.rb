require File.dirname(__FILE__) + '/spec_helper'

describe RuoteKit::Client::Expression do
  before(:each) do
    @expression = RuoteKit::Client::Expression.new({"class"=>"Ruote::Exp::ParticipantExpression", "variables"=>nil, "participant_name"=>"nada", "original_tree"=>["participant", {"activity"=>"REST :)", "ref"=>"nada"}, []], "on_timeout"=>nil, "modified_time"=>"Wed Dec 09 16:24:15 +0100 2009", "updated_tree"=>nil, "timeout_job_id"=>nil, "has_error"=>false, "on_cancel"=>nil, "created_time"=>"Wed Dec 09 16:24:15 +0100 2009", "applied_workitem"=>{"participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}}, "fei"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0_0"}}, "parent_id"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0"}, "links"=>[{"href"=>"/processes/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}, {"href"=>"/expressions/20091209-zujasuju/0_0", "rel"=>"parent"}], "tagname"=>nil, "children"=>[], "timeout_at"=>nil, "state"=>nil, "on_error"=>nil, "fei"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0_0"}})

    @agent = RuoteKit::Client::Agent.new('http://localhost:8080/')
    @expression.agent = @agent
  end

  it "should have a wfid" do
    @expression.wfid.should == "20091209-zujasuju"
  end
  it "should have an expid" do
    @expression.expid.should == "0_0_0"
  end
  it "should have a workitem" do
    @agent.expects( :find_workitem ).with( "20091209-zujasuju", "0_0_0" )
    @expression.workitem
  end
  it "can be cancelled" do
    @agent.expects( :cancel_expression ).with( @expression )
    @expression.cancel!
  end
  it "can be killed" do
    @agent.expects( :kill_expression ).with( @expression )
    @expression.kill!
  end
end
