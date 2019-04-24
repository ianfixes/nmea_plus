class NMEAPlus::Parser

token CSUM CASH BANG DATA

# super simple for now, but leaves room for expansion to other message types

rule
  start
    : CASH DATA CSUM  { result = NMEAPlus::NMEAMessageFactory.create(val[0], val[1], val[2]) }
    | BANG DATA CSUM  { result = NMEAPlus::AISMessageFactory.create(val[0], val[1], val[2]) }
    ;

---- header

require 'nmea_plus/nmea_message_factory'
require 'nmea_plus/ais_message_factory'

---- inner

# override racc's on_error so we can have context in our error messages
def on_error(t, val, vstack)
  errcontext = (@ss.pre_match[-10..-1] || @ss.pre_match) +
                @ss.matched + @ss.post_match[0..9]
  line_number = @ss.pre_match.lines.count
  raise ParseError, sprintf("parse error on value %s (%s) " +
                            "on line %s around \"%s\"",
                            val.inspect, token_to_str(t) || '?',
                            line_number, errcontext)
end
