require './bin/enumerable.rb'

RSpec.describe Enumerable do
  describe '#my_each' do
    it 'returns every single element of an array ' do
      expect([1, 2, 3, 4, 'hi'].my_each { |x| print x }).to eql([1, 2, 3, 4, 'hi'])
    end
  end
  describe '#my_each_with_index' do
    it 'returns every single element of an array ' do
      expect([1, 2, 3, 4, 'hi'].my_each_with_index { |x| print x }).to eql([1, 2, 3, 4, 'hi'])
    end
  end
  describe '#my_select' do
    it 'returns array of elements that matches the block' do
      expect([1, 2, 3, 4, 5, 6].my_select(&:even?)).to eql([2, 4, 6])
    end
  end

  describe '#my_all' do
    it 'returns true if all elements matches' do
      expect(%w[ant bear cat].my_all? { |word| word.length >= 3 }).to eql(true)
    end
    it 'returns true if all the elements match the parameter' do
      expect([3, 4, 7, 11].my_all?(3)).to eql(false)
    end
  end

  describe '#my_any' do
    it 'returns true if all the elements matches' do
      expect(%w[ant bear cat].my_any? { |word| word.length >= 3 }).to eql(true)
    end
    it 'returns false if the array is empty' do
      expect([].my_any?).to eql(false)
    end
  end

  describe '#my_none' do
    it 'returns true if all the elements matches' do
      expect(%w[ant bear cat].my_none? { |word| word.length >= 3 }).to eql(false)
    end
    it 'returns true if regexp matches all the elements' do
      expect(%w[ant bear cat].my_none?(/d/)).to eql(true)
    end
  end
  describe '#my_count' do
    it 'returns the length of the array' do
      expect([1, 2, 4, 2].my_count).to eql(4)
    end
    it 'returns the number of elements that matches the pattern' do
      expect([1, 2, 4, 2].my_count(2)).to eql(2)
    end
    it 'returns the number of elements that matches the block' do
      expect([1, 2, 4, 2].my_count(&:even?)).to eql(3)
    end
  end
  describe '#multiply_els' do
    it 'multiplies the elements between each other' do
    end
  end
  describe '#my_map' do
    it 'returns a new array with the classes of each element of the array' do
      expect(%w[a b c].my_map(&:class)).to eql([String, String, String])
    end
  end
  describe '#my_inject' do
    it 'returns a new array with the classes of each element of the array' do
      expect((5..10).my_inject { |sum, n| sum + n }).to eql(45)
    end
  end
end
