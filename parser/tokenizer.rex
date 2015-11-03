
module NMEAPlus
class Decoder < Parser  # not indented due to constraints of .rex format

macro
  csum      \*[0-9A-F]{2}
  cash      \$
  bang      !
  data      [^\*]+
  nlns      [\w\n\r]*

rule

# [:state]  pattern  [actions]

  {csum}{nlns}     { [:CSUM, text[1..2]] }
  {cash}           { [:CASH, text] }
  {bang}           { [:BANG, text] }
  {data}           { [:DATA, text] }

inner

  def parse(input)
    @yydebug = true if ENV['DEBUG_RACC']
    scan_str(input)
  end

  def tokenize(input)
    scan_setup(input)
    ret = []
    last_token = nil
    loop do
      last_token = next_token
      break if last_token.nil?
      ret << last_token
    end
    ret
  end

  end # class
end # module
