#write your code here
def translate(msg)
  msg.split.map {
    |m|
    i = 0
    while not ['a', 'e', 'i', 'o', 'u', 'y'].include? m[i, 1]
      i += m[i, 2] == 'qu' ? 2 : 1
    end
  m[i..-1] + m[0, i] + 'ay'
  }.join(" ")
end