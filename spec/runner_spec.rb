require File.join(File.dirname(__FILE__), 'spec_helper')

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
      Output.to_s.should == "Usage: httping [options] uri"
    end

    it "returns the params banner if invalid arguments are specified" do
      ARGV << "-z"
      @runner.run
      Output.to_s.should == "invalid option: -z\nUsage: httping [options] uri"
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