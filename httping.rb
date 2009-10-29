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
  def to_human_time
    case self
      when 0..1 then "#{(self * 1000).floor} msecs"
      when 1..2 then "1 sec"
      else "#{floor} secs"
    end
  end
end

class Fixnum
  def to_human_size
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

  attr_writer :flood, :format

  def initialize
    @ping_results = []
  end
    
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
    trap("INT") { results }
    loop do 
      ping
      results if count_reached?
      sleep 1 unless @flood
    end    
  end

  def ping
    request = Net::HTTP.new(@uri.host, @uri.port)
    start_time = Time.now
    response, data = request.get("#{@uri.path}?#{@uri.query}")
    @ping_results << duration = Time.now - start_time
    ping_summary(response, data, duration) if @format == :interactive
  end

  def ping_summary(response, data, duration)
    puts "#{data.length.to_human_size} from #{@uri}: code=#{response.code} msg=#{response.message} time=#{duration.to_human_time}"
  end

  def results
    if @format.nil?
      interactive_results
    else
      send("#{@format}_results")
    end
    
    exit
  end

  def interactive_results
    puts
    puts "--- #{@uri} httping.rb statistics ---"
    puts "#{@ping_results.size} GETs transmitted"
    puts "round-trip min/avg/max = #{@ping_results.min.to_human_time}/#{@ping_results.mean.to_human_time}/#{@ping_results.max.to_human_time}"
  end
  
  def json_results
    results = "{\"max\": #{@ping_results.max}, \"avg\": #{@ping_results.mean}, \"min\": #{@ping_results.min}}"
    sent = @ping_results.size
    uri = @uri.to_s
    puts "{\"results\": #{results}, \"sent\": #{sent}, \"uri\": \"#{uri}\"}"
  end

  def quick_results
    duration = @ping_results.first.to_human_time
    puts "OK [#{duration}]"
  end

  def count_reached?
    @ping_results.size == @count
  end
end

class Runner
  BANNER = "Usage: httping.rb [options] uri"
  
  def run
    options = parse_arguments
    
    if options[:format] == :json && !options.include?(:count)
      options[:count] = 5 # Default to 5 if no count provided
    elsif options[:format] == :quick
      options[:count] = 1 # Quick format always sends only 1 ping
    end
    
    if options[:uri]
      httping = HTTPing.new
      httping.uri = options[:uri]
      httping.format = options[:format]
      httping.count = options[:count]
      httping.flood = options[:flood]
      httping.run
    else
      puts BANNER
    end
  end

  def parse_arguments
    options = {
      :format => :interactive,
      :flood => false
    }

    begin
      params = OptionParser.new do |opts|
        opts.banner = BANNER
        opts.on('-c', '--count NUM', 'Number of times to ping host') do |count|
          options[:count] = count
        end
        opts.on('-f', '--flood', 'Flood ping (no delay)') do 
          options[:flood] = true
        end
        opts.on('-j', '--json', 'Return JSON results') do 
          options[:format] = :json
        end
        opts.on('-q', '--quick', 'Ping once and return OK if up') do 
          options[:format] = :quick
        end
        opts.on('-h', '--help', 'Display this screen') do
          puts opts
          exit
        end
        opts.parse!
        options[:uri] = ARGV.first
      end
    rescue OptionParser::InvalidOption => exception
      puts exception
    end
  
    options
  end
end

Runner.new.run unless @test