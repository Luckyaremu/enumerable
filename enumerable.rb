# rubocop: disable Metrics/ModuleLength
module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    array = []
    while i < size
      yield to_a[i]
      array << to_a[i]
      i += 1
    end
    array
  end

  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    array = []
    while i < size
      yield to_a[i], i
      array << to_a[i]
      i += 1
    end
    array
  end

  def my_select
    return to_enum unless block_given?

    array = []
    my_each do |x|
      array.push(x) if yield(x) == true
    end
    array
  end

  def my_all?(reg = nil)
    if !reg.nil?
      my_each { |x| return false unless reg == x }
    elsif block_given?
      my_each { |x| return false unless yield x }
    else
      my_each { |x| return false unless x }
    end
    true
  end

  def my_any?(reg = nil)
    res = false
    if !reg.nil?
      my_each { |x| res = true if reg == x }
    elsif block_given?
      my_each { |x| res = true if yield(x) }
    else
      my_each { |x| res = true if x }
    end
    res
  end

  def my_none?(_proc = nil)
    res = false
    if !reg.nil?
      my_each { |x| res = true if reg == x }
    elsif block_given?
      my_each { |x| res = true if yield(x) }
    else
      my_each { |x| res = true if x }
    end
    res
  end

  def my_count(proc = nil)
    ar = self
    i = 0
    if proc
      my_each do |x|
        next unless x == proc

        i += 1
      end
      return i
    end
    if block_given?
      ar.my_each do |x|
        next unless (yield x) == true

        i += 1
      end
      return i
    end
    ar.my_each do
      i += 1
    end
    i
  end

  def my_map(proc = nil)
    ar = self
    new_arr = []
    unless proc.nil?
      each do |x|
        return false unless proc.yield x
      end
      return true
    end
    return to_enum unless block_given? && proc.nil?

    ar.my_each do |j|
      a = yield j
      new_arr.append(a)
    end
    new_arr
  end

  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop: disable Metrics/CyclomaticComplexity

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

  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop: enable Metrics/CyclomaticComplexity

  def multiply_els(arr)
    arr.my_inject { |x, num| x * num }
  end
end
# rubocop: enable Metrics/ModuleLength
# arr = [1, 2, 3, 4, 5, 6]
# t = [nil, true, '']
# p arr.each.class == arr.my_each.class
# p t.my_none? == t.none?
# p t.any? == t.my_any?
# p t.each_with_index.class == t.my_each_with_index.class
# p t.count == t.my_count
# p t.map.class == t.my_map.class
# p arr.inject(:+) == arr.my_inject(:+)
