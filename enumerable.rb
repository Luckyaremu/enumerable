module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    each do |x|
      yield x
    end
    self
  end

  def my_each_with_index
    return to_enum __method__ unless block_given?

    idx = 0
    each do |x|
      yield(x, idx)
      idx += 1
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    array = []
    my_each do |x|
      array.push(x) if yield(x) == true
    end
    array
  end

  def my_all?(reg = nill)
    if !reg.nill?
      my_each { |x| return false unless reg == x }
    elsif block_given?
      my_each { |x| return false unless yield x }
    else
      my_each { |x| return false unless x }
    end
    true
  end

  def my_any?(reg = nill)
    res = false
    if !reg.nill?
      my_each { |x| res = true if reg == x }
    elsif block_given?
      my_each { |x| res = true if yield x }
    else
      my_each { |x| res = true if x }
    end
    res
  end

  def my_none?(reg = nil, &block)
    !my_any?(reg, &block)
  end

  def my_count(num = nill?)
    counter = 0

    if num
      my_each { |x| counter += 1 if num == x }
      counter
    elsif block_given?
      my_each { |x| counter += 1 if yield(x) }
      counter
    else
      num
    end
  end

  def my_map(proc = nil)
    return to_enum(:my_map) if !block_given? && proc.nil?

    array = []
    if !proc.nil?
      my_each do |x|
        array.push(proc.call(x))
      end
    else
      my_each do |x|
        array.push(yield(x))
      end
    end
    arr
  end

  # rubocop:disable Metrics/CyclomaticComplexity:
  # rubocop:disable Metrics/PerceivedComplexity

  def my_inject(cum = nil, reg = nil)
    arr = self.class == Range ? to_a : self
    if cum.nil?
      cum = arr[0]
      index = 1
    else
      index = 0
    end

    (index...size).each do |x|
      cum = yield(cum, arr[x]) if block_given?
    end
    return arr.reduce(cum) if reg.nil? && cum.is_a?(Symbol)
    return cum *= arr.reduce(reg) if reg.is_a?(Symbol) && reg == :*
    return cum += arr.reduce(reg) if reg.is_a?(Symbol) && cum.is_a?(Integer)

    cum
  end

  # rubocop:enable Metrics/CyclomaticComplexity:
  # rubocop:enable Metrics/PerceivedComplexity

  def multiply_els(arr)
    arr.my_inject { |x, num| x * num }
  end
end
