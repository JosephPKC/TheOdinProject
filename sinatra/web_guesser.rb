require 'sinatra'
require 'sinatra/reloader'

def caesar_cipher(de, sh)
  en = []
  for i in 0...de.length
    ch = de[i]
    if ('A'..'Z').cover? ch
      ch = ((((ch.ord - 65) + sh) % 26) + 65).chr
    elsif ('a'..'z').cover? ch
      ch = ((((ch.ord - 97) + sh) % 26) + 97).chr
    end
    en << ch.chr
  end
  en.join('')
end


get '/' do
  de = params['input']
  sh = params['shift'].to_i
  sh ||= 0
  en = de.nil? ? '' : caesar_cipher(de, sh)
  erb :index, :locals => {:encrypt => en}
end

