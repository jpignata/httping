#!/usr/bin/ruby

require 'net/http'

module Enumerable
  def sum
    inject { |result, element| result + element }
  end

  def mean
    sum / size
  end
end

class HTTPing
  include Net
  include URI
    
  def uri=(uri)
    @uri = URI.parse(uri)

    unless @uri.class == URI::HTTP
      puts "Invalid URI #{@uri}: Use format of http://host:port/uri-path"
      exit
    end

    @uri.path = "/" unless @uri.path.match /^\//
  end

  def run
    @ping_results = []
    
    trap("INT") { on_exit }
    while(true) do 
      ping
    end
  end

  def ping
    request = Net::HTTP.new(@uri.host, @uri.port)
    start_time = Time.now
    response, data = request.get("#{@uri.path}?#{@uri.query}")
    difference = Time.now - start_time
    @ping_results << difference

    puts "#{friendly_size(data.length)} from #{@uri}: code=#{response.code} msg=#{response.message} time=#{friendly_response_time(difference)}"
  end
  
  def on_exit
    puts "\n\n--- #{@uri} httping statistics ---"
    puts "#{@ping_results.size} GETs transmitted"
    puts "round-trip min/avg/max = #{friendly_response_time(@ping_results.min)}/#{friendly_response_time(@ping_results.mean)}/#{friendly_response_time(@ping_results.max)}"
    exit
  end

  def friendly_response_time(seconds)
    case seconds
      when 0..1 then "#{(seconds * 1000).floor} msecs"
      when 1..2 then "1 sec"
      else "#{seconds.floor} secs"
    end
  end

  def friendly_size(size)
    case size
      when 0..1024 then "#{size} bytes"
      when 1024..1048576 then "#{size / 1024} kb"
      when 1048576..1073741824 then "#{size / 1048576} mb"
    end
  end
end

if ARGV[0]
  httping = HTTPing.new
  httping.uri = ARGV[0]
  httping.run
else
  puts "Usage: httping.rb <url>"
  exit  
end