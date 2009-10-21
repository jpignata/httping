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

class Float
  def to_friendly_time
    case self
      when 0..1 then "#{(self * 1000).floor} msecs"
      when 1..2 then "1 sec"
      else "#{self.floor} secs"
    end
  end
end

class Fixnum
  def to_friendly_size
    case self
      when 0..1024 then "#{self} bytes"
      when 1024..1048576 then "#{self / 1024} kb"
      when 1048576..1073741824 then "#{self / 1048576} mb"
    end
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
    @ping_results << difference = Time.now - start_time
    puts "#{data.length.to_friendly_size} from #{@uri}: code=#{response.code} msg=#{response.message} time=#{difference.to_friendly_time}"
  end
  
  def on_exit
    puts "\n\n--- #{@uri} httping statistics ---"
    puts "#{@ping_results.size} GETs transmitted"
    puts "round-trip min/avg/max = #{@ping_results.min.to_friendly_time}/#{@ping_results.mean.to_friendly_time}/#{@ping_results.max.to_friendly_time}"
    exit
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