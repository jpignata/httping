require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Ping" do
  before do
    @httping = Ping.new
    @httping.uri = URI.parse("http://www.example.com/")
    @httping.format = :interactive
    @httping.count = 10
  end

  after(:each) do
    Output.clear
  end

  describe "#ping" do
    context "a HTTP URI" do
      it "pings the configured url and outputs statistics" do
        @httping.ping 
        Output.to_s.should match(/10 bytes from http:\/\/www.example.com\/: code=200 msg=OK time=[0-9] msecs/)
      end
    end
    
    context "a HTTPS URI" do
      it "pings the configured url and outputs statistics" do
        @httping.uri = URI.parse("https://www.example.com/")
        @httping.ping
        Output.to_s.should match(/10 bytes from https:\/\/www.example.com\/: code=200 msg=OK time=[0-9] msecs/)
      end
    end

    context "a URI with a query string" do
      it "pings the configured url and outputs statistics" do
        @httping.uri = URI.parse("http://www.example.com/search?q=test")
        @httping.ping
        Output.to_s.should match(/10 bytes from http:\/\/www.example.com\/search\?q=test: code=200 msg=OK time=[0-9] msecs/)
      end
    end
    
    context "audible ping" do
      it "outputs a console beep if audible is sold" do
        @httping.audible = true
        @httping.ping
        Output.to_s.should match(/\007/)
      end
    end
  end

  context "#count_reached?" do
    it "returns false if a host has not yet been pinged the number of times requested" do
      2.times { @httping.ping }
      @httping.should_not be_count_reached
    end

    it "returns true if a host has been pinged the number of times requested" do
      10.times { @httping.ping }
      @httping.should be_count_reached
    end
  end
  
  context "#results" do
    before do
      5.times { @httping.ping }
    end
    
    it "outputs a summary of the pings" do
      @httping.results
      Output.to_s.should match(/-- http:\/\/www.example.com\/ httping.rb statistics ---\n5 GETs transmitted\n/)
    end
  end
  
  context "#json_results" do
    before do
      @httping.format = :json
      2.times { @httping.ping }
    end
    
    it "outputs a summary of the pings in JSON format" do
      @httping.results
      Output.to_s.should match(/\{\"results\": \{\"max\": [0-9\.]*, \"avg\": [0-9\.]*, \"min\": [0-9\.]*\}, \"sent\": 2, \"uri\": \"http:\/\/www.example.com\/\"\}/)
    end
  end

  context "#quick_results" do
    before do
      @httping.format = :quick
      @httping.ping
    end
    
    it "outputs OK if host responds to HTTP GET" do
      @httping.results
      Output.to_s.should match(/OK/)
    end
  end
  
  context "#run" do
    before do
      @httping = Ping.new
      @httping.uri = URI.parse("http://www.example.com/")
      @httping.format = :interactive
      @httping.count = 5
    end
    
    it "pings until a count is reached" do
      @httping.flood = true
      @httping.run
      Output.to_s.should match(/5 GETs transmitted/)
    end

    it "adds a delay between each ping if a delay is provided" do
      @httping.flood = false
      @httping.delay = 0.25
      start_time = Time.now
      @httping.run 
      (Time.now - start_time).should > 0.5
    end
  end
end