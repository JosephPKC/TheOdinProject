#write your code here
def echo(say)
  say
end

def shout(say)
  say.upcase
end

def repeat(say, n = 2)
  [say] * n * ' '
end

def start_of_word(say, n)
  say[0..n - 1]
end

def first_word(say)
  say.split[0]
end

def titleize(say)
  sp = say.split.each {|s| s != "and" && s != "over" && s != "the" ? s.capitalize! : s}
  sp[0].capitalize!
  sp.join(" ")
end