# rubocop: disable Metrics/ModuleLength
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

  def my_all?(proc = nil)
    ar = self
    return ar.self proc if proc

    if block_given?
      ar.my_each do |i|
        next unless (yield i) == false

        return false
      end
      return true
    end
    return false if ar.include?(false) || ar.include?(nil)

    true
  end

  def my_any?(proc = nil)
    ar = self
    return ar.any?(proc) if proc

    if block_given?
      ar.my_each do |i|
        next unless (yield i) == true

        return true
      end
      return false
    end
    return true if !ar.member?(nil) || ar.include?(true)

    false
  end

  def my_none?(proc = nil)
    ar = self
    return ar.none?(proc) if proc

    if block_given?
      ar.my_each do |i|
        next unless (yield i) == true

        return false
      end
      return true
    end
    !ar[ar.length - 1]
  end

  def my_count(proc = nil)
    ar = self
    i = 0
    if proc
      ar.my_each do |x|
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
      ar.each do |x|
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
