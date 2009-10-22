#!/usr/bin/ruby

require 'net/http'
require 'optparse'

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
    
  def uri=(uri)
    @uri = URI.parse(uri)

    unless @uri.class == URI::HTTP
      puts "ERROR: Invalid URI #{@uri}"
      exit
    end

    @uri.path = "/" unless @uri.path.match /^\//
  end

  def count=(count)
    @count = count.to_i
  end

  def run
    @ping_results = []
    
    trap("INT") { results }
    loop do 
      ping
      results if count_reached?
    end    
  end

  def ping
    request = Net::HTTP.new(@uri.host, @uri.port)
    start_time = Time.now
    response, data = request.get("#{@uri.path}?#{@uri.query}")
    @ping_results << difference = Time.now - start_time
    puts "#{data.length.to_friendly_size} from #{@uri}: code=#{response.code} msg=#{response.message} time=#{difference.to_friendly_time}"
  end
  
  def results
    puts
    puts "--- #{@uri} httping.rb statistics ---"
    puts "#{@ping_results.size} GETs transmitted"
    puts "round-trip min/avg/max = #{@ping_results.min.to_friendly_time}/#{@ping_results.mean.to_friendly_time}/#{@ping_results.max.to_friendly_time}"
    exit
  end
  
  def count_reached?
    @ping_results.size == @count
  end
end

options = {}

params = OptionParser.new do |opts|
  options[:uri] = ARGV.first
  opts.banner = "Usage: httping.rb [options] uri"
  opts.on('-c', '--count NUM', 'Number of times to ping host') do |count|
    options[:count] = count
  end
  opts.on('-h', '--help', 'Display this screen') do
    puts opts
    exit
  end
  opts.parse!
end

if options[:uri]
  httping = HTTPing.new
  httping.uri = options[:uri]
  httping.count = options[:count]
  httping.run
else
  puts params.banner
end