class Book
# write your code here
  attr_reader :title
  def title=(nt)
    sp = nt.split(" ")
    sp = [sp[0].capitalize] + sp[1..-1].map do |s|
      if ["a", "an", "and", "the", "in", "of"].include? s
        s
      else
        s.capitalize
      end
    end
    @title = sp.join(" ")
  end
end