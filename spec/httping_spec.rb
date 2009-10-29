require 'spec_helper'

describe "Enumerable" do
  before do
    @array = [1, 58, 49, 330, 2, 15, 3, 80]
  end
  
  context ".sum" do
    it "returns the sum of all members of a set" do
      @array.sum.should be(538)
    end
  end
  
  context ".mean" do
    it "returns the mean of a set" do
      @array.mean.should be(67)
    end
  end
end

describe "Float" do
  before do
    @milliseconds = 0.2997921
    @second = 1.1291
    @seconds = 48.31292
  end
  
  context ".to_human_time" do
    it "returns a human friendly string of the elapsed time represented by a float" do
      @milliseconds.to_human_time.should == "299 msecs"
      @second.to_human_time.should == "1 sec"
      @seconds.to_human_time.should == "48 secs"
    end
  end
end

describe "Fixnum" do
  before do
    @bytes = 12
    @kilobytes = 8_939
    @megabytes = 4_911_219
    @gigabytes = 8_289_119_584
  end
  
  context ".to_human_size" do
    it "returns a human friendly string of the amount of bytes represented by a number" do
      @bytes.to_human_size.should == "12 bytes"
      @kilobytes.to_human_size.should == "8 kb"
      @megabytes = "5 mb"
      @gigabytes = "8289119489 bytes"
    end
  end
end

describe "HTTPing" do
  before do
    @httping = HTTPing.new
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

describe "Runner" do  
  before(:each) do
    ARGV.clear
    @runner = Runner.new
  end

  after(:each) do
    Output.clear
  end

  context ".parse_arguments" do
    it "parses command-line arguments into an options hash" do
      ARGV << "http://www.example.com"
      ARGV << "--count"
      ARGV << "3"

      options = @runner.parse_arguments
      options[:count].should == 3
      options[:uri].to_s.should == "http://www.example.com/"
    end
  end

  context ".run" do
    it "returns the params banner if no arguments are passed" do
      @runner.run
      Output.to_s.should == "Usage: httping.rb [options] uri"
    end

    it "returns the params banner if invalid arguments are specified" do
      ARGV << "-z"
      @runner.run
      Output.to_s.should == "invalid option: -z\nUsage: httping.rb [options] uri"
    end
  end
  
  context "parse_uri" do
    it "outputs an error and exists if not given an HTTP(S) URI" do
      ARGV.clear
      ARGV << "ftp://www.example.com"
      @runner.parse_uri
      Output.to_s.should == "ERROR: Invalid URI ftp://www.example.com"
    end
    
    it "accepts HTTP URIs" do
      ARGV.clear
      ARGV << "http://www.example.com"
      @runner.parse_uri
      Output.to_s.should_not match(/ERROR/)
    end

    it "accepts HTTPS URIs" do
      ARGV.clear
      ARGV << "https://www.example.com"
      @runner.parse_uri
      Output.to_s.should_not match(/ERROR/)
    end
  end
end