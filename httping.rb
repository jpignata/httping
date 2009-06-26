#!/usr/bin/ruby

require 'net/http'

include Net
include URI

module Enumerable
  def sum
    self.inject { |result, element| result + element }
  end

  def mean
    self.sum / self.size
  end
end

if !ARGV[0]
  puts "Usage: httping.rb <url>"
  exit
end

ping_results = Array.new
uri = URI.parse(ARGV[0])

unless uri.class == URI::HTTP
  puts "Invalid URI #{uri}: Use format of http://host:port/uri-path"
  exit
end

uri.path = "/" unless uri.path.match /^\//

def friendly_response_time(seconds)
  friendly_response_time = case seconds
    when 0..1 then "#{(seconds * 1000).floor} msecs"
    when 1..2 then "1 sec"
    else "#{seconds.floor} secs"
  end
end

trap ("INT") do
  puts "\n\n--- #{uri} httping statistics ---"
  puts "#{ping_results.size} GETs transmitted"
  puts "round-trip min/avg/max = #{friendly_response_time(ping_results.min)}/#{friendly_response_time(ping_results.mean)}/#{friendly_response_time(ping_results.max)}"
  exit
end

while (1) do
  h = Net::HTTP.new(uri.host, uri.port)
  start_time = Time.now
  resp, data = h.get("#{uri.path}?#{uri.query}")
  difference = Time.now - start_time

  friendly_size = case data.length
    when 0..1024 then "#{data.length} bytes"
    when 1024..1048576 then "#{data.length / 1024} kb"
    when 1048576..1073741824 then "#{data.length / 1048576} mb"
  end

   puts "#{friendly_size} from #{uri}: code=#{resp.code} msg=#{resp.message} time=#{friendly_response_time(difference)}"
  ping_results << difference
end