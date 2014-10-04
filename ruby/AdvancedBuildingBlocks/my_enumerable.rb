module Enumerable

  def my_each
    return enum_for(:my_each) unless block_given?

    # can't use 'for in' loop because it calls #each for you
    index = 0
    while index < self.length
      yield self[index]
      index += 1
    end
    self
  end

  def my_each_with_index 
      return enum_for(:my_each_with_index) unless block_given?
      index = 0
      while index < self.length
        yield self[index],index
        index += 1
      end
      self
  end

  def my_select
    return enum_for(:my_select) unless block_given?
    result = []
    my_each { |item| result << item if yield item}
    result
  end

  def my_all?(&block)
    result = true
    block ||= Proc.new { |obj| obj }

    # can't use &&= because all items might not be called
    my_each {|item| result = !!block.call(item) && result }
    result 
  end

  def my_any?(&block)
    result = false
    block ||= Proc.new { |obj| obj }

    # !! is used to garuntee a true or false return
    my_each {|item| result = !!block.call(item) || result }
    result 
  end

  def my_none?(&block)
    result = true
    block ||= Proc.new { |obj| obj }

    my_each {|item| result = !block.call(item) && result }
    result 
  end

  def my_count(*args,&block)
    
    # *args is used so we can count false or nil
    case args.length
    when 0
      block ||= Proc.new {|needle| needle}
    when 1
      puts "warning: given block not used" if block
      block = Proc.new {|needle| needle == args[0]  }
    else
      raise ArgumentError, "wrong number of arguments (#{args.length} for 1)"
    end

    result = 0
    my_each { |item| result += 1 if !!block.call(item) }
    result
  end

  def my_map(passed_proc=nil)
    result = []
    if passed_proc
      if block_given?
        my_each { |item| result <<  yield(passed_proc.call(item)) }
      else 
        my_each { |item| result <<  passed_proc.call(item)}
      end
    end
    result
  end

  def my_inject(*args, &block)
    return nil if self.length == 0
    
    shifted = []
    case args.length
    when 0
      result = self.shift
      shifted << result
    when 1
      if block
        result = args[0]
      else
        result = self.shift
        shifted << result
        sym = args[0]
      end
    when 2
      result, sym = *args
    else
        raise ArgumentError, "wrong number of arguments (#{args.length} for 0..2)"
    end
    block = Proc.new {|result,item| result.send(sym,item)} if sym
    my_each {|item| result = block.call(result, item)}
    self.unshift(shifted[0]) if shifted.length > 0
    result
  end
end

def multiply_els(target)
  target.my_inject(:*)
end