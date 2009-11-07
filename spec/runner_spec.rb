require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Runner" do  
  before(:each) do
    ARGV.clear
    @runner = Runner.new
  end

  after(:each) do
    Output.clear
  end

  context "#parse_arguments" do
    it "parses command-line arguments into an options hash" do
      ARGV << "http://www.example.com"
      ARGV << "--count" << "3"
      ARGV << "--delay" << "2"
      ARGV << "--audible"
      ARGV << "--user-agent" << "Mozilla"
      ARGV << "--referrer" << "http://www.example.com/about-us"
      ARGV << "--flood"

      options = @runner.parse_arguments
      options[:count].should == 3
      options[:delay].should == 2
      options[:audible].should be
      options[:flood].should be
      options[:user_agent].to_s.should == "Mozilla"
      options[:referrer].to_s.should == "http://www.example.com/about-us"
      options[:uri].to_s.should == "http://www.example.com/"
    end

    it "defaults count to 5 if JSON format is flag passed" do
      ARGV << "http://www.example.com"
      ARGV << "--json"
      
      options = @runner.parse_arguments
      options[:count].should == 5
    end

    it "sets count to 1 if quick format is flag passed" do
      ARGV << "http://www.example.com"
      ARGV << "--quick"
      
      options = @runner.parse_arguments
      options[:count].should == 1
    end

    it "outputs a help screen if help flag passed" do
      ARGV << "--help"
      @runner.parse_arguments
      Output.to_s.should match(/-j, --json *Return JSON results/)
    end
  end

  context "#run" do
    it "returns the params banner if no arguments are passed" do
      @runner.run
      Output.to_s.should == "Usage: httping [options] uri"
    end

    it "returns the params banner if invalid arguments are specified" do
      ARGV << "-z"
      @runner.run
      Output.to_s.should == "invalid option: -z\nUsage: httping [options] uri"
    end

    it "creates a ping object based upon passed in parameters" do
      ARGV << "http://www.example.com"
      ARGV << "--count" << "5"
      ARGV << "--flood"
      @runner.run
      Output.to_s.should match(/5 GETs transmitted/)
    end
  end
  
  context "#parse_uri" do
    it "outputs an error and exists if not given an HTTP(S) URI" do
      ARGV << "ftp://www.example.com"
      @runner.parse_uri
      Output.to_s.should == "ERROR: Invalid URI ftp://www.example.com"
    end
    
    it "accepts HTTP URIs" do
      ARGV << "http://www.example.com"
      @runner.parse_uri
      Output.to_s.should_not match(/ERROR/)
    end

    it "accepts HTTPS URIs" do
      ARGV << "https://www.example.com"
      @runner.parse_uri
      Output.to_s.should_not match(/ERROR/)
    end
  end
end