require 'spec'

@test = true
require 'httping'

require 'fakeweb'
FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:any, "http://www.google.com", :body => "hey there.")

class Output 
  class << self
    def puts (output_string)
      @output = [] if @output.nil?
      @output << output_string
    end
  
    def output
      @output.join("\n")
    end
    
    def clear
      @output.clear
    end
  end
end

def puts(output_string)
  Output.puts(output_string)
end