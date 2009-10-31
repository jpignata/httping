require 'spec'
require File.join(File.dirname(__FILE__), '../lib/httping')


require 'fakeweb'
FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:any, "http://www.example.com", :body => "hey there.")
FakeWeb.register_uri(:any, "https://www.example.com", :body => "hey there.")
FakeWeb.register_uri(:any, "http://www.example.com/search?q=test", :body => "hey there.")

class Object
  def exit(status_code = nil)
    @status = status_code
  end

  def puts(output_string = "\n")
    Output.puts(output_string)
  end
end

class Output 
  class << self
    def puts(output_string)
      @output = [] if @output.nil?
      @output << output_string
    end
  
    def to_s
      @output.join("\n") if @output
    end
    
    def clear
      @output.clear if @output
    end
  end
end
