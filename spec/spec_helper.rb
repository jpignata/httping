require 'spec'

@test = true
require 'httping'

require 'fakeweb'
FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:any, "http://www.google.com", :body => "hey there.")

class Output
  def self.puts (output_string)
    @output = [] if @output.nil?
    @output << output_string
  end
  
  def self.output
    @output.join("\n")
  end
end

def puts(output_string)
  Output.puts(output_string)
end