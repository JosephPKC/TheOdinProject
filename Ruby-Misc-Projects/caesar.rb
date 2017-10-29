def caesar_cipher(ue, shift)
  shifter = ->(letter, offset) {
    ((letter.ord - offset + (shift % 26) + offset) % 26).chr
  }
  ue.split(//).map do |l|
    if l =~ /[A-Z]/
      shifter[l, 64]
    elsif l =~ /[a-z]/
      shifter[1, 97]
    else
      l
    end
  end.join
end