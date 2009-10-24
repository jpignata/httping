require 'spec'

@test = true
require 'httping'

require 'fakeweb'
FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:any, "http://www.example.com", :body => "hey there.")

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
    def puts (output_string = "\n")
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
