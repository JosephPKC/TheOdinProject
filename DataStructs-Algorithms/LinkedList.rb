class Node
  attr_accessor :value, :next_node

  def initialize(val)
    @value = val
    @next_node = nil
  end
end

class LinkedList
  attr_reader :head, :tail, :length

  def initialize
    @head = nil
    @tail = nil
    @length = 0
  end

  def append(val)
    insert_into_empty(val)
    node = Node.new(val)
    @tail.next_node = node
    @tail = node
    @length += 1
  end

  def prepend(val)
    insert_into_empty(val)
    node = Node.new(val)
    node.next_node = @head
    @head = node
    @length += 1
  end

  def at(index)
    return nil if index >= @length || @head.nil?
    walker = @head
    i = 0
    until i == index
      i += 1
      walker = walker.next_node
    end
    walker.value
  end

  def pop
    node = @tail
    @tail = previous(@length - 1)
    @tail.next_node = nil
    @length -= 1
    node.value
  end

  def contains?(val)
    return false if @head.nil?
    walker = @head
    until walker.nil? || walker.value == val
      walker = walker.next_node
    end
    walker.nil? ? false : true
  end

  def find(val)
    return nil if @head.nil?
    walker = @head
    i = 0
    until walker.nil? || walker.value == val
      walker = walker.next_node
      i += 1
    end
    walker.nil? ? nil : i
  end

  def to_s
    s = ""
    walker = @head
    until walker.nil?
      s += "(#{walker.value})"
      s += ' -> ' unless walker == @tail
    end
    s
  end

  def insert_at(val, index)
    return false if index > @length || @head.nil?
    if index.zero?
      prepend(val)
      return true
    end
    if index == @length
      append(val)
      return true
    end
    node = Node.new(val)
    node.next_node = at(index)
    previous(index).next_node = node
    @length += 1
    true
  end

  def remove_at(index)
    return false if index >= @length || @head.nil?
    if index.zero?
      node = @head
      @head = @head.next_node
      node.next_node = nil
      length -= 1
    end
    if index == @length - 1
      pop
      return true
    end
    node = at(index)
    previous(index).next_node = node.next_node
    node.next_node = nil
    length -= 1
  end

  private

  def insert_into_empty(val)
    if @head.nil?
      @head = Node.new(val)
      @tail = @head
    end
  end

  def previous(index)
    return nil if index >= @length || index.zero? || @head.nil?
    walker = @head
    i = 0
    until i == index - 1
      i += 1
      walker = walker.next_node
    end
    walker
  end
end