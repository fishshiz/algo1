require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    self.length = 0
    self.capacity = 8
    self.start_idx = 0
    self.store = StaticArray.new(8)
  end

  # O(1)
  def [](index)
    unless (index >= 0) && (index < length)
      raise 'index out of bounds'
    else
      self.store[(start_idx + index) % capacity]
    end
  end

  # O(1)
  def []=(index, val)
    unless index.between?(0, length)
      raise 'index out of bounds'
    else
      self.store[(start_idx + index) % capacity] = val
    end
  end

  # O(1)
  def pop
    raise "index out of bounds" if length < 1

    last = self[length - 1]
    self[length - 1] = nil
    self.length -= 1

    last
  end

  # O(1) ammortized
  def push(val)
    resize! if length == capacity
    self.length += 1
    self[length - 1] = val
  end

  # O(1)
  def shift
    raise "index out of bounds" if length < 1

    first = self[0]
    self[0] = nil
    self.start_idx = ((start_idx + 1) % capacity)
    self.length -= 1

    first
  end

  # O(1) ammortized
  def unshift(val)
    resize! unless length != capacity

    self.start_idx = ((start_idx - 1) % capacity)
    self.length += 1
    self[0] = val
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
  end

  def resize!
    new_cap = capacity * 2
    tmp_store = StaticArray.new(new_cap)

    length.times do |i|
      tmp_store[i] = self[i]
    end

    self.store = tmp_store
    self.capacity = new_cap
    self.start_idx = 0
  end
end
