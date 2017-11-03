class Enumerable

  def my_each
    return self unless block_given?
    0...size.times do |i|
      yield self[i]
    end
    self
  end

  def my_each_with_index
    return self unless block_given?
    0...size.times do |i|
      yield self[i], i
    end
    self
  end

  def my_all?
    return true unless block_given?
    0...size.times do |i|
      return false unless yield self[i]
    end
    true
  end

  def my_any?
    return true unless block_given?
    0...size.times do |i|
      return true if yield self[i]
    end
    false
  end

  def my_none?
    return false unless block_given?
    0...size.times do |i|
      return false if yield self[i]
    end
    true
  end

  def my_count
    size
  end

  def my_map
    return self unless block_given?
    alt = []
    0...size.times do |i|
      alt << yield(self[i])
    end
    alt
  end

  def my_inject(a=nil)
    return self unless block_given?
    cc = self.dup
    a ||= cc.shift
    cc.my_each do |x|
      a = yield(a, x)
    end
    a
  end
end
