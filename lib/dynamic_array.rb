require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    self.length = 0
    self.capacity = 8
    self.store = StaticArray.new(capacity)
  end

  # O(1)
  def [](index)
    if index >= length
      raise 'index out of bounds'
    end
    self.store[index]
  end

  # O(1)
  def []=(index, value)
    if index >= length
      raise 'index out of bounds'
    end
    self.store[index] = value
  end

  # O(1)
  def pop
    raise 'index out of bounds' unless length > 0
    self.length -= 1
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    if length < capacity
      self.store[length] = val
    else
      resize!
    end
    self.length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    raise 'index out of bounds' unless length > 0

    del = self.store.first
    copy = StaticArray.new(capacity)
    (1..length - 1).each do |i|
      copy[i] = self.store[i - 1]
    end

    self.store = copy
    self.length -= 1

    del
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if length == capacity
    copy = StaticArray.new(capacity)
    copy[0] = val
    (1..length - 1).each do |i|
      copy[i] = self.store[i]
    end

    self.store = copy
    self.length += 1

    val
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    newArr = StaticArray.new(capacity * 2)

    (0...length).each do |i|
      newArr[i] = self.store[i]
    end

    self.store = newArr
    self.capacity *= 2
  end
end
