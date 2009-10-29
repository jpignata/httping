class Ping
  include Net

  attr_writer :flood, :format, :audible, :user_agent, :referrer, :delay, :count, :uri

  def initialize
    @ping_results = []
  end
  
  def run
    trap("INT") { results }
    loop do 
      ping
      results if count_reached?
      sleep @delay unless @flood
    end    
  end

  def ping
    start_time = Time.now
    response, data = request.get(uri, http_header)
    @ping_results << duration = Time.now - start_time
    ping_summary(response, data, duration) if @format == :interactive
  end
  
  def request
    request = Net::HTTP.new(@uri.host, @uri.port)

    if @uri.scheme == "https"
      request.use_ssl = true
      request.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    
    request
  end
  
  def uri
    if @uri.query
      "#{@uri.path}?#{@uri.query}"
    else
      "#{@uri.path}"
    end
  end
  
  def http_header
    header = {}
    header['User-Agent'] = @user_agent if @user_agent
    header['Referrer'] = @referrer if @referrer 
    header   
  end

  def ping_summary(response, data, duration)
    print beep if @audible
    puts "#{data.length.to_human_size} from #{@uri}: code=#{response.code} msg=#{response.message} time=#{duration.to_human_time}"
  end

  def beep
    7.chr
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