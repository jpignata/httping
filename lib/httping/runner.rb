class Runner
  BANNER = "Usage: httping [options] uri"
  
  def run
    options = parse_arguments
    
    if options[:uri]
      httping = Ping.new
      options.each { |property, value| httping.send("#{property}=", value) }
      httping.run
    else
      puts BANNER
    end
  end

  def parse_arguments
    options = {
      :delay => 1,
      :format => :interactive,
      :flood => false,
      :audible => false
    }

    begin
      params = OptionParser.new do |opts|
        opts.banner = BANNER
        opts.on('-c', '--count NUM', 'Number of times to ping host') do |count|
          options[:count] = count.to_i
        end
        opts.on('-d', '--delay SECS', 'Delay in seconds between pings (default: 1)') do |delay|
          options[:delay] = delay.to_i
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
        opts.on('-a', '--audible', 'Beep on each ping') do 
          options[:audible] = true
        end
        opts.on('-u', '--user-agent STR', 'User agent string to send in headers') do |user_agent|
          options[:user_agent] = user_agent
        end
        opts.on('-r', '--referrer STR', 'Referrer string to send in headers') do |referrer|
          options[:referrer] = referrer
        end
        opts.on('-h', '--help', 'Display this screen') do
          puts opts
          exit
        end
        opts.parse!
        options[:uri] = parse_uri if ARGV.first
      end
    rescue OptionParser::InvalidOption => exception
      puts exception
    end
    
    if options[:format] == :json && !options.include?(:count)
      options[:count] = 5 # Default to 5 if no count provided for JSON format
    elsif options[:format] == :quick
      options[:count] = 1 # Quick format always sends only 1 ping
    end
  
    options
  end
  
  def parse_uri
    uri = URI.parse(ARGV.first)

    if uri.class == URI::Generic
      uri = URI.parse("http://#{ARGV.first}")
    end
    
    uri.path = "/" unless uri.path.match /^\//

    unless ["http", "https"].include?(uri.scheme) 
      puts "ERROR: Invalid URI #{uri}"
      exit
    end

    uri
  end  
end