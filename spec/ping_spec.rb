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

  context ".ping" do
    it "pings the configured url and outputs statistics" do
      @httping.ping 
      Output.to_s.should match(/10 bytes from http:\/\/www.example.com\/: code=200 msg=OK time=[0-9] msecs/)
    end
  end

  context ".count_reached?" do
    it "returns false if a host has not yet been pinged the number of times requested" do
      2.times { @httping.ping }
      @httping.should_not be_count_reached
    end

    it "returns true if a host has been pinged the number of times requested" do
      10.times { @httping.ping }
      @httping.should be_count_reached
    end
  end
  
  context ".results" do
    before do
      5.times { @httping.ping }
    end
    
    it "outputs a summary of the pings" do
      @httping.results
      Output.to_s.should match(/-- http:\/\/www.example.com\/ httping.rb statistics ---\n5 GETs transmitted\n/)
    end
  end  
end