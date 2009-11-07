require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Enumerable" do
  before do
    @array = [1, 58, 49, 330, 2, 15, 3, 80]
  end
  
  context "#sum" do
    it "returns the sum of all members of a set" do
      @array.sum.should be(538)
    end
  end
  
  context "#mean" do
    it "returns the mean of a set" do
      @array.mean.should be(67)
    end
  end
end

describe "Float" do
  before do
    @milliseconds = 0.2997921
    @second = 1.1291
    @seconds = 48.31292
  end
  
  context "#to_human_time" do
    it "returns a human friendly string of the elapsed time represented by a float" do
      @milliseconds.to_human_time.should == "299 msecs"
      @second.to_human_time.should == "1 sec"
      @seconds.to_human_time.should == "48 secs"
    end
  end
end

describe "Fixnum" do
  before do
    @bytes = 12
    @kilobytes = 8_939
    @megabytes = 4_911_219
    @gigabytes = 8_289_119_584
  end
  
  context "#to_human_size" do
    it "returns a human friendly string of the amount of bytes represented by a number" do
      @bytes.to_human_size.should == "12 bytes"
      @kilobytes.to_human_size.should == "8 kb"
      @megabytes = "5 mb"
      @gigabytes = "8289119489 bytes"
    end
  end
end