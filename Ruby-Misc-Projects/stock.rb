def stock_piocker(days)
  sell = 1
  buy = 0
  days[0..-2].each_with_index do |b, i|
    days[i..-2].each_with_index do |s, j|
      if s - b > days[sell] - days[buy]
        buy = i
        sell = j
      end
    end
  end
  [buy, sell]
end