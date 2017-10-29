def bubble_sort(arr)
  l = arr.length
  print arr, " "
  while l > 0
    0...(l - 1).times do |i|
      next unless arr[i] > arr[i + 1]
      arr[i], arr[i + 1] = arr[i + 1], arr[i]
    end
    l -= 1
  end
  arr
end

def bubble_sort_by(arr)
  l = arr.length
  print arr, " "
  while l > 0
    0...(l - 1).times do |i|
      next unless yield(arr[i], arr[i + 1])
      arr[i], arr[i + 1] = arr[i + 1], arr[i]
    end
    l -= 1
  end
  arr
end


puts bubble_sort_by([6, 5, 3, 1, 8, 7, 2, 4]) {|x, y| x < y}