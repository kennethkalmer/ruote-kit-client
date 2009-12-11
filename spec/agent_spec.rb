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
        {"links"=>[{"href"=>"/", "rel"=>"http://ruote.rubyforge.org/rels.html#root"}, {"href"=>"/processes", "rel"=>"http://ruote.rubyforge.org/rels.html#processes"}, {"href"=>"/workitems", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}, {"href"=>"/history", "rel"=>"http://ruote.rubyforge.org/rels.html#history"}, {"href"=>"/processes", "rel"=>"self"}], "launched" => "20091209-suhegashi" }
      )
      mock_request(
        @agent,
        :get,
        '/processes/20091209-suhegashi',
        nil,
        { :accept => 'application/json' },
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
        {"links"=>[{"href"=>"/", "rel"=>"http://ruote.rubyforge.org/rels.html#root"}, {"href"=>"/processes", "rel"=>"http://ruote.rubyforge.org/rels.html#processes"}, {"href"=>"/workitems", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}, {"href"=>"/history", "rel"=>"http://ruote.rubyforge.org/rels.html#history"}, {"href"=>"/processes", "rel"=>"self"}], "launched" => "20091209-suhegashi" }
      )
      mock_request(
        @agent,
        :get,
        '/processes/20091209-suhegashi',
        nil,
        { :accept => 'application/json' },
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
        {"links"=>[{"href"=>"/", "rel"=>"http://ruote.rubyforge.org/rels.html#root"}, {"href"=>"/processes", "rel"=>"http://ruote.rubyforge.org/rels.html#processes"}, {"href"=>"/workitems", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}, {"href"=>"/history", "rel"=>"http://ruote.rubyforge.org/rels.html#history"}, {"href"=>"/processes", "rel"=>"self"}], "launched" => "20091209-suhegashi" }
      )
      mock_request(
        @agent,
        :get,
        '/processes/20091209-suhegashi',
        nil,
        { :accept => 'application/json' },
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
    it "should update workitems" do
      workitem = RuoteKit::Client::Workitem.new({"fei"=> {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}, "participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}}, "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}]})

      mock_request(
        @agent,
        :put,
        "/workitems/20091204-bojupuraju/0_0_0",
        {'fields' => {'moo' => 'mah', 'boo' => 'bah'}.merge(workitem['fields'])},
        { :accept => 'application/json', :content_type => 'application/json' },
        {"workitem"=>{"fei"=> {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}, "participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}, 'moo' => 'mah', 'boo' => 'bah'}, "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}]}}
      )

      workitem['fields']['moo'] = 'mah'
      workitem['fields']['boo'] = 'bah'

      lambda {
        response = @agent.update_workitem!(workitem)
        response.should be_true
      }.should_not raise_error
    end
    it "should reply to workitems" do
      workitem = RuoteKit::Client::Workitem.new({"fei"=> {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}, "participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}}, "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}]})

      mock_request(
        @agent,
        :put,
        "/workitems/20091204-bojupuraju/0_0_0",
        {'fields' => {'moo' => 'mah', 'boo' => 'bah'}.merge(workitem['fields']), '_proceed' => '1'},
        { :accept => 'application/json', :content_type => 'application/json' },
        {"workitem"=>{"fei"=> {"class"=>"Ruote::FlowExpressionId", "engine_id"=>"engine", "wfid"=>"20091204-bojupuraju", "expid"=>"0_0_0"}, "participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}, 'moo' => 'mah', 'boo' => 'bah'}, "links"=>[{"href"=>"/processes/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091204-bojupuraju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}]}}
      )

      workitem['fields']['moo'] = 'mah'
      workitem['fields']['boo'] = 'bah'

      lambda {
        response = @agent.proceed_workitem!(workitem)
        response.should be_true
      }.should_not raise_error
    end
  end

  describe "loading expressions" do
    it "should return an array of expressions for a Process instance" do
      mock_request(
        @agent,
        :get,
        "/expressions/20091209-zujasuju",
        nil,
        { :accept => 'application/json' },
        {"links"=>[{"href"=>"/", "rel"=>"http://ruote.rubyforge.org/rels.html#root"}, {"href"=>"/processes", "rel"=>"http://ruote.rubyforge.org/rels.html#processes"}, {"href"=>"/workitems", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}, {"href"=>"/history", "rel"=>"http://ruote.rubyforge.org/rels.html#history"}, {"href"=>"/expressions/20091209-zujasuju", "rel"=>"self"}], "expressions"=>[{"class"=>"Ruote::Exp::ParticipantExpression", "variables"=>nil, "participant_name"=>"nada", "original_tree"=>["participant", {"activity"=>"REST :)", "ref"=>"nada"}, []], "on_timeout"=>nil, "modified_time"=>"Wed Dec 09 16:24:15 +0100 2009", "updated_tree"=>nil, "timeout_job_id"=>nil, "has_error"=>false, "on_cancel"=>nil, "created_time"=>"Wed Dec 09 16:24:15 +0100 2009", "applied_workitem"=>{"participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}}, "fei"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0_0"}}, "parent_id"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0"}, "links"=>[{"href"=>"/processes/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}, {"href"=>"/expressions/20091209-zujasuju/0_0", "rel"=>"parent"}], "tagname"=>nil, "children"=>[], "timeout_at"=>nil, "state"=>nil, "on_error"=>nil, "fei"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0_0"}}, {"class"=>"Ruote::Exp::SequenceExpression", "variables"=>{"test"=>["0", ["define", {"name"=>"test"}, [["sequence", {}, [["nada", {"activity"=>"REST :)"}, []]]]]]]}, "original_tree"=>["define", {"name"=>"test"}, [["sequence", {}, [["nada", {"activity"=>"REST :)"}, []]]]]], "on_timeout"=>nil, "modified_time"=>"Wed Dec 09 16:24:15 +0100 2009", "updated_tree"=>nil, "timeout_job_id"=>nil, "has_error"=>false, "on_cancel"=>nil, "created_time"=>"Wed Dec 09 16:24:15 +0100 2009", "applied_workitem"=>{"participant_name"=>nil, "fields"=>{}, "fei"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0"}}, "parent_id"=>nil, "links"=>[{"href"=>"/processes/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}], "tagname"=>nil, "children"=>["engine|20091209-zujasuju|0_0"], "timeout_at"=>nil, "state"=>nil, "on_error"=>nil, "fei"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0"}}, {"class"=>"Ruote::Exp::SequenceExpression", "variables"=>nil, "original_tree"=>["sequence", {}, [["nada", {"activity"=>"REST :)"}, []]]], "on_timeout"=>nil, "modified_time"=>"Wed Dec 09 16:24:15 +0100 2009", "updated_tree"=>nil, "timeout_job_id"=>nil, "has_error"=>false, "on_cancel"=>nil, "created_time"=>"Wed Dec 09 16:24:15 +0100 2009", "applied_workitem"=>{"participant_name"=>nil, "fields"=>{}, "fei"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0"}}, "parent_id"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0"}, "links"=>[{"href"=>"/processes/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}, {"href"=>"/expressions/20091209-zujasuju/0", "rel"=>"parent"}], "tagname"=>nil, "children"=>["engine|20091209-zujasuju|0_0_0"], "timeout_at"=>nil, "state"=>nil, "on_error"=>nil, "fei"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0"}}]}
      )

      process = RuoteKit::Client::Process.new({"definition_revision"=>nil, "root_expression"=>nil, "wfid"=>"20091209-zujasuju", "definition_name"=>"test", "original_tree"=>["define", {"name"=>"test"}, [["sequence", {}, [["nada", {"activity"=>"REST :)"}, []]]]]], "variables"=>{"test"=>["0", ["define", {"name"=>"test"}, [["sequence", {}, [["nada", {"activity"=>"REST :)"}, []]]]]]]}, "errors"=>[], "tags"=>[], "links"=>[{"href"=>"/processes/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}, {"href"=>"/workitems/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}], "current_tree"=>["define", {"name"=>"test"}, [["sequence", {}, [["participant", {"activity"=>"REST :)", "ref"=>"nada"}, []]]]]], "launched_time"=>"Wed Dec 09 16:24:15 +0100 2009", "expressions"=>[{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0_0"}, {"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0"}, {"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0"}]})
      expressions = @agent.expressions(process)
      expressions.should_not be_empty
      expressions.first.should be_a_kind_of(RuoteKit::Client::Expression)
      expressions.first.agent.should_not be_nil
    end
    it "should return an Expression instance if wfid and expid are given" do
      mock_request(
        @agent,
        :get,
        "/expressions/20091209-zujasuju/0_0_0",
        nil,
        { :accept => 'application/json' },
        {"expression"=>{"class"=>"Ruote::Exp::ParticipantExpression", "variables"=>nil, "participant_name"=>"nada", "original_tree"=>["participant", {"activity"=>"REST :)", "ref"=>"nada"}, []], "on_timeout"=>nil, "modified_time"=>"Wed Dec 09 16:24:15 +0100 2009", "updated_tree"=>nil, "timeout_job_id"=>nil, "has_error"=>false, "on_cancel"=>nil, "created_time"=>"Wed Dec 09 16:24:15 +0100 2009", "applied_workitem"=>{"participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}}, "fei"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0_0"}}, "parent_id"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0"}, "links"=>[{"href"=>"/processes/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}, {"href"=>"/expressions/20091209-zujasuju/0_0", "rel"=>"parent"}], "tagname"=>nil, "children"=>[], "timeout_at"=>nil, "state"=>nil, "on_error"=>nil, "fei"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0_0"}}, "links"=>[{"href"=>"/", "rel"=>"http://ruote.rubyforge.org/rels.html#root"}, {"href"=>"/processes", "rel"=>"http://ruote.rubyforge.org/rels.html#processes"}, {"href"=>"/workitems", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}, {"href"=>"/history", "rel"=>"http://ruote.rubyforge.org/rels.html#history"}, {"href"=>"/expressions/20091209-zujasuju/0_0_0", "rel"=>"self"}]}
      )

      expression = @agent.find_expression('20091209-zujasuju', '0_0_0')
      expression.should be_a_kind_of(RuoteKit::Client::Expression)
      expression.agent.should_not be_nil
    end
  end

  describe "manage expressions" do
    it "can cancel expressions" do
      mock_request(
        @agent,
        :delete,
        "/expressions/20091209-zujasuju/0_0_0",
        nil,
        { :accept => 'application/json', :params => {} },
        {"links"=>[{"href"=>"/", "rel"=>"http://ruote.rubyforge.org/rels.html#root"}, {"href"=>"/processes", "rel"=>"http://ruote.rubyforge.org/rels.html#processes"}, {"href"=>"/workitems", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}, {"href"=>"/history", "rel"=>"http://ruote.rubyforge.org/rels.html#history"}, {"href"=>"/expressions/20091209-zujasuju/0_0_0", "rel"=>"self"}], "status"=>"ok"}
      )

      lambda {
        expression = RuoteKit::Client::Expression.new({"class"=>"Ruote::Exp::ParticipantExpression", "variables"=>nil, "participant_name"=>"nada", "original_tree"=>["participant", {"activity"=>"REST :)", "ref"=>"nada"}, []], "on_timeout"=>nil, "modified_time"=>"Wed Dec 09 16:24:15 +0100 2009", "updated_tree"=>nil, "timeout_job_id"=>nil, "has_error"=>false, "on_cancel"=>nil, "created_time"=>"Wed Dec 09 16:24:15 +0100 2009", "applied_workitem"=>{"participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}}, "fei"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0_0"}}, "parent_id"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0"}, "links"=>[{"href"=>"/processes/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}, {"href"=>"/expressions/20091209-zujasuju/0_0", "rel"=>"parent"}], "tagname"=>nil, "children"=>[], "timeout_at"=>nil, "state"=>nil, "on_error"=>nil, "fei"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0_0"}})
        response = @agent.cancel_expression(expression)
        response.should be_true
      }.should_not raise_error
    end
    it "can kill expressions" do
      mock_request(
        @agent,
        :delete,
        "/expressions/20091209-zujasuju/0_0_0",
        nil,
        { :accept => 'application/json', :params => {'_kill' => '1'} },
        {"links"=>[{"href"=>"/", "rel"=>"http://ruote.rubyforge.org/rels.html#root"}, {"href"=>"/processes", "rel"=>"http://ruote.rubyforge.org/rels.html#processes"}, {"href"=>"/workitems", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}, {"href"=>"/history", "rel"=>"http://ruote.rubyforge.org/rels.html#history"}, {"href"=>"/expressions/20091209-zujasuju/0_0_0", "rel"=>"self"}], "status"=>"ok"}
      )

      lambda {
        expression = RuoteKit::Client::Expression.new({"class"=>"Ruote::Exp::ParticipantExpression", "variables"=>nil, "participant_name"=>"nada", "original_tree"=>["participant", {"activity"=>"REST :)", "ref"=>"nada"}, []], "on_timeout"=>nil, "modified_time"=>"Wed Dec 09 16:24:15 +0100 2009", "updated_tree"=>nil, "timeout_job_id"=>nil, "has_error"=>false, "on_cancel"=>nil, "created_time"=>"Wed Dec 09 16:24:15 +0100 2009", "applied_workitem"=>{"participant_name"=>"nada", "fields"=>{"params"=>{"activity"=>"REST :)", "ref"=>"nada"}}, "fei"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0_0"}}, "parent_id"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0"}, "links"=>[{"href"=>"/processes/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#process"}, {"href"=>"/expressions/20091209-zujasuju", "rel"=>"http://ruote.rubyforge.org/rels.html#expressions"}, {"href"=>"/expressions/20091209-zujasuju/0_0", "rel"=>"parent"}], "tagname"=>nil, "children"=>[], "timeout_at"=>nil, "state"=>nil, "on_error"=>nil, "fei"=>{"class"=>"Ruote::FlowExpressionId", "wfid"=>"20091209-zujasuju", "engine_id"=>"engine", "expid"=>"0_0_0"}})
        response = @agent.kill_expression(expression)
        response.should be_true
      }.should_not raise_error
    end
  end
end
