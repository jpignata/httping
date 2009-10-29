class Fixnum
  def to_human_size
    case self
      when 1024..1048576 then "#{self / 1024} kb"
      when 1048576..1073741824 then "#{self / 1048576} mb"
      else "#{self} bytes"
    end
  end
end