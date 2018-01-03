# Implement a queue with #enqueue and #dequeue, as well as a #max API,
# a method which returns the maximum element still in the queue. This
# is trivial to do by spending O(n) time upon dequeuing.
# Can you do it in O(1) amortized? Maybe use an auxiliary storage structure?

# Use your RingBuffer to achieve optimal shifts! Write any additional
# methods you need.

require_relative 'ring_buffer'

class QueueWithMax
  attr_accessor :store

  def initialize
    @store = RingBuffer.new
    @length = 0
    @max = nil
  end

  def enqueue(val)
    @store.unshift(val)
    @length += 1
    @max = val if !max || val > @max
  end

  def dequeue
    removed = @store.pop
    @length -= 1

    if removed == @max
      @max = @store[0]
      i = 0
      while i < @length
        @max = @store[i] if @max == nil || @store[i] < @max
        i += 1
      end
    end
    removed
  end

  def max
    @max
  end

  def length
    @length
  end

end
