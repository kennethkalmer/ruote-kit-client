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

  it "should be able to pull a list of processes"
end
