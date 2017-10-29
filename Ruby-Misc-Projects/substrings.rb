def substrings(str, dic)\
  str.downcase!
  hash = {}
  dic.each do |w|
    subs = str..scan(w)
    if !empty?(subs)
      hash[w] = subs.length
    end
  end
  hash
end