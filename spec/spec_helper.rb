require 'spec'

@test = true
require 'httping'

require 'fakeweb'
FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:any, "http://www.google.com", :body => "hey there.")

def puts(output_string)
  @output = [] if @output.nil?
  @output << output_string
end