require File.dirname(__FILE__) + '/spec_helper'

describe RuoteKit::Client::Agent do
  before(:each) do
    @agent = RuoteKit::Client::Agent.new( 'http://localhost:8080/' )
  end

  it "should know it's url" do
    @agent.url.should be_a_kind_of( URI )
    @agent.url.to_s.should == 'http://localhost:8080/'
  end

  describe "launching processes" do
    it "should do so for valid launch items" do
      li = RuoteKit::Client::LaunchItem.new
      li.definition = %q{
        Ruote.process_definition :name => 'test' do
          sequence do
            nada :activity => 'REST :)'
          end
        end
      }

      mock_request(
        @agent,
        :post,
        '/processes',
        li.to_json,
        { :content_type => 'application/json', :accept => 'application/json' },
        {"links"=>[{"href"=>"/", "rel"=>"http://ruote.rubyforge.org/rels.html#root"}, {"href"=>"/processes", "rel"=>"http://ruote.rubyforge.org/rels.html#processes"}, {"href"=>"/workitems", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}, {"href"=>"/history", "rel"=>"http://ruote.rubyforge.org/rels.html#history"}, {"href"=>"/processes", "rel"=>"self"}], "process"=>{"definition_revision"=>"0.1","root_expression"=>nil,"wfid"=>"20091209-suhegashi","definition_name"=>"Test"} }
      )

      lambda {

        process = @agent.launch_process( li )
        process.should_not be_nil
        process.should be_a_kind_of( RuoteKit::Client::Process )

      }.should_not raise_error
    end

    it "should do so and create a launch item on the fly if a process def is given as string" do
      li = RuoteKit::Client::LaunchItem.new
      li.definition = %q{
        Ruote.process_definition :name => 'test' do
          sequence do
            nada :activity => 'REST :)'
          end
        end
      }
      mock_request(
        @agent,
        :post,
        '/processes',
        li.to_json,
        { :content_type => 'application/json', :accept => 'application/json' },
        {"links"=>[{"href"=>"/", "rel"=>"http://ruote.rubyforge.org/rels.html#root"}, {"href"=>"/processes", "rel"=>"http://ruote.rubyforge.org/rels.html#processes"}, {"href"=>"/workitems", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}, {"href"=>"/history", "rel"=>"http://ruote.rubyforge.org/rels.html#history"}, {"href"=>"/processes", "rel"=>"self"}], "process"=>{"definition_revision"=>"0.1","root_expression"=>nil,"wfid"=>"20091209-suhegashi","definition_name"=>"Test"} }
      )

      lambda {
        

        process = @agent.launch_process( li.definition )
        process.should_not be_nil
        process.should be_a_kind_of( RuoteKit::Client::Process )

      }.should_not raise_error
    end

    it "should do so and create a launch item on the fly if a process def is given by an URI" do
      uri = URI.parse('http://localhost:8080/workflow_definitions/fine_example')
      li = RuoteKit::Client::LaunchItem.new( uri, {'moo' => 'mah'} )
      
      mock_request(
        @agent,
        :post,
        '/processes',
        li.to_json,
        { :content_type => 'application/json', :accept => 'application/json' },
        {"links"=>[{"href"=>"/", "rel"=>"http://ruote.rubyforge.org/rels.html#root"}, {"href"=>"/processes", "rel"=>"http://ruote.rubyforge.org/rels.html#processes"}, {"href"=>"/workitems", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}, {"href"=>"/history", "rel"=>"http://ruote.rubyforge.org/rels.html#history"}, {"href"=>"/processes", "rel"=>"self"}], "process"=>{"definition_revision"=>"0.1","root_expression"=>nil,"wfid"=>"20091209-suhegashi","definition_name"=>"Test"} }
      )

      lambda {
        process = @agent.launch_process( uri, {'moo' => 'mah'} )
        process.should_not be_nil
        process.should be_a_kind_of( RuoteKit::Client::Process )

      }.should_not raise_error
    end

    it "should not launch invalid launch items" do
      li = RuoteKit::Client::LaunchItem.new

      lambda {
        @agent.launch_process( li )
      }.should raise_error( RuoteKit::Client::Exception )
    end
  end

  describe "loading processes" do
    it "should handle an empty list of processes" do
      mock_request(
        @agent,
        :get,
        '/processes',
        nil,
        { :accept => 'application/json' },
        {"processes" => []}
      )

      @agent.processes.should be_empty
    end

    it "should return an array of processes" do
      mock_request(
        @agent,
        :get,
        '/processes',
        nil,
        { :accept => 'application/json' },
        { "processes" => {"wfid"=>"20091204-bojupuraju", "definition_name"=>"test", "definition_revision"=>nil, "original_tree"=>["define", {"name"=>"test"}, [["sequence", {}, [["nada", {"activity"=>"REST :)"}, []]]]]], "current_tree"=>["define", {"name"=>"test"}, [["sequence", {}, [["participant", {"activity"=>"REST :)", "ref"=>"nada"}, []]]]]], "variables"=>{"test"=>["0", ["define", {"name"=>"test"}, [["sequence", {}, [["nada", {"activity"=>"REST :)"}, []]]]]]]}, "tags"=>{}, "launched_time"=>"2009-12-04 12:04:55 +0200", "root_expression"=>nil, "expressions"=>[{"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0"}, {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0"}, {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}], "errors"=>[], "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}, {"href"=>"/workitems/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}]}}
      )

      processes = @agent.processes
      processes.should_not be_empty
      processes.first.should be_a_kind_of( RuoteKit::Client::Process )
      processes.first.agent.should_not be_nil
    end

    it "should find one process by its wfid" do
      mock_request(
        @agent,
        :get,
        '/processes/20091204-bojupuraju',
        nil,
        { :accept => 'application/json' },
        { "process" => {"wfid"=>"20091204-bojupuraju", "definition_name"=>"test", "definition_revision"=>nil, "original_tree"=>["define", {"name"=>"test"}, [["sequence", {}, [["nada", {"activity"=>"REST :)"}, []]]]]], "current_tree"=>["define", {"name"=>"test"}, [["sequence", {}, [["participant", {"activity"=>"REST :)", "ref"=>"nada"}, []]]]]], "variables"=>{"test"=>["0", ["define", {"name"=>"test"}, [["sequence", {}, [["nada", {"activity"=>"REST :)"}, []]]]]]]}, "tags"=>{}, "launched_time"=>"2009-12-04 12:04:55 +0200", "root_expression"=>nil, "expressions"=>[{"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0"}, {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0"}, {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}], "errors"=>[], "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}, {"href"=>"/workitems/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}]}}
      )

      process = @agent.find_process('20091204-bojupuraju')
      process.should_not be_nil
      process.should be_a_kind_of( RuoteKit::Client::Process )
    end
  end

  describe "managing processes" do
    it "should be able to cancel processes" do
      mock_request(
        @agent,
        :delete,
        "/processes/foo",
        nil,
        { :accept => 'application/json' },
        { "status" => "ok" }
      )

      @agent.cancel_process('foo')
    end

    it "should be able to kill processes" do
      mock_request(
        @agent,
        :delete,
        "/processes/foo?_kill=1",
        nil,
        { :accept => 'application/json' },
        { "status" => "ok" }
      )

      @agent.kill_process('foo')
    end
  end

  describe "loading workitems" do
    it "should load all" do
      mock_request(
        @agent,
        :get,
        "/workitems",
        nil,
        { :accept => 'application/json', :params => {} },
        {"workitems"=>[{"fei"=> {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}, "participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}}, "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}]}]}
      )

      workitems = @agent.workitems
      workitems.should_not be_empty
      workitems.first.should be_a_kind_of( RuoteKit::Client::Workitem )
      workitems.first.agent.should_not be_nil
    end

    it "should filter workitems by wfid" do
      mock_request(
        @agent,
        :get,
        "/workitems/20091204-bojupuraju",
        nil,
        { :accept => 'application/json', :params => {} },
        {"workitems"=>[{"fei"=> {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}, "participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}}, "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}]}]}
      )

      workitems = @agent.workitems(:wfid => "20091204-bojupuraju")
      workitems.should_not be_empty
      workitems.first.should be_a_kind_of( RuoteKit::Client::Workitem )
      workitems.first.agent.should_not be_nil
    end
    it "should filter workitems by process" do
      mock_request(
        @agent,
        :get,
        "/workitems/20091204-bojupuraju",
        nil,
        { :accept => 'application/json', :params => {} },
        {"workitems"=>[{"fei"=> {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}, "participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}}, "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}]}]}
      )

      process = RuoteKit::Client::Process.new('wfid' => '20091204-bojupuraju')

      workitems = @agent.workitems(:process => process)
      workitems.should_not be_empty
      workitems.first.should be_a_kind_of( RuoteKit::Client::Workitem )
      workitems.first.agent.should_not be_nil

    end
    it "should filter workitems by wfid/expid" do
      mock_request(
        @agent,
        :get,
        "/workitems/20091204-bojupuraju/0_0_0",
        nil,
        { :accept => 'application/json' },
        {"workitem"=>{"fei"=> {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}, "participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}}, "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}]}}
      )

      workitem = @agent.find_workitem('20091204-bojupuraju', '0_0_0')
      workitem.should_not be_nil
      workitem.should be_a_kind_of( RuoteKit::Client::Workitem )
    end

    it "should filter workitems by participant" do
      mock_request(
        @agent,
        :get,
        "/workitems",
        nil,
        { :accept => 'application/json', :params => {'participant' => 'nada'} },
        {"workitems"=>[{"fei"=>{"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}, "participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}}, "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}]}]}
      )

      workitems = @agent.workitems(:participant => 'nada')
      workitems.should_not be_empty
      workitems.first.should be_a_kind_of( RuoteKit::Client::Workitem )
      workitems.first.agent.should_not be_nil
    end
  end

  describe "managing workitems" do
    it "should update workitems"
    it "should reply to workitems"
  end
end
