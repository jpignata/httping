class Float
  def to_human_time
    case self
      when 0..1 then "#{(self * 1000).floor} msecs"
      when 1..2 then "1 sec"
      else "#{floor} secs"
    end
  end
end