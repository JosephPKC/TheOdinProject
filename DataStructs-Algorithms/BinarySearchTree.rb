class Node
  attr_accessor :value, :parent, :left, :right

  def initialize(val)
    @value = val
    @parent = nil
    @left = nil
    @right = nil
  end
end

class BinarySearchTree
  attr_reader :root

  def initialize(arr = nil)
    @root = build_tree(arr)
  end

  def breadth_first_search(val)
    frontier = Queue.new
    frontier << @root
    until frontier.empty?
      node = frontier.shift
      return node if node.value == val
      frontier << node.left unless node.left.nil?
      frontier << node.right unless node.right.nil?
    end
    nil
  end

  def depth_first_search(val)
    frontier = Stack.new
    frontier << @root
    until frontier.empty?
      node = frontier.pop
      return node if node.value == val
      frontier << node.right unless node.right.nil?
      frontier << node.left unless node.left.nil?
    end
    nil
  end

  def dfs_rec(val, root = @root)
    return nil if root.nil?
    return root if root.value == val
    dfs_rec(val, root.left)
    dfs_rec(val, root.right)
  end

  private

  def build_tree(arr)
    return nil if arr.nil?
    root = Node.new(arr[0])
    arr[1..-1].each do |a|
      node = Node.new(a)
      insert(node, root)
    end
    root
  end

  def insert(node, root)
    if root.nil? || root.value == node.value
      root = node
    elsif root.value < node.value
      create_links(node, root.right, true) if root.right.nil?
      insert(node, root.right) unless root.right.nil?
    else
      create_links(node, root.left, false) if root.left.nil?
      insert(node, root.left) unless root.left.nil?
    end
  end

  def create_links(node, parent, is_right)
    node.parent = parent
    parent.right = node if is_right
    parent.left = node unless is_right
  end
end