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
      else "#{floor} secs"
    end
  end
end

class Fixnum
  def to_friendly_size
    case self
      when 1024..1048576 then "#{self / 1024} kb"
      when 1048576..1073741824 then "#{self / 1048576} mb"
      else "#{self} bytes"
    end
  end
end

class HTTPing
  include Net
  include URI

  def count=(count)
    @count = count.to_i
  end
    
  def uri=(uri)
    @uri = URI.parse(uri)

    unless @uri.class == URI::HTTP
      puts "Invalid URI #{@uri}: Use format of http://host:port/uri-path"
      exit
    end

    @uri.path = "/" unless @uri.path.match /^\//
  end

  def run
    @pings_sent = 0 if @count
    @ping_results = []
    
    trap("INT") { results }
    loop do 
      ping
      check_and_increment_counter if @count
    end    
  end

  def ping
    request = Net::HTTP.new(@uri.host, @uri.port)
    start_time = Time.now
    response, data = request.get("#{@uri.path}?#{@uri.query}")
    @ping_results << difference = Time.now - start_time
    puts "#{data.length.to_friendly_size} from #{@uri}: code=#{response.code} msg=#{response.message} time=#{difference.to_friendly_time}"
  end
  
  def check_and_increment_counter
    @pings_sent += 1
    results if @count == @pings_sent
  end
  
  def results
    puts
    puts "--- #{@uri} httping.rb statistics ---"
    puts "#{@ping_results.size} GETs transmitted"
    puts "round-trip min/avg/max = #{@ping_results.min.to_friendly_time}/#{@ping_results.mean.to_friendly_time}/#{@ping_results.max.to_friendly_time}"
    exit
  end
end

if ARGV[0]
  httping = HTTPing.new
  httping.uri = ARGV[0]
  httping.count = ARGV[1] if ARGV[1]
  httping.run
else
  puts "Usage: httping.rb <url> [count]"
end