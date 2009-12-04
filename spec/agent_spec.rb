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
        {"links"=>[{"href"=>"/", "rel"=>"http://ruote.rubyforge.org/rels.html#root"}, {"href"=>"/processes", "rel"=>"http://ruote.rubyforge.org/rels.html#processes"}, {"href"=>"/workitems", "rel"=>"http://ruote.rubyforge.org/rels.html#workitems"}, {"href"=>"/history", "rel"=>"http://ruote.rubyforge.org/rels.html#history"}, {"href"=>"/processes", "rel"=>"self"}], "launched"=>"20091204-bomabohire"}
      )

      lambda {

        wfid = @agent.launch_process( li )
        wfid.should_not be_nil
        wfid.should match(/^[0-9a-z\-]+$/)

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
  end
end
