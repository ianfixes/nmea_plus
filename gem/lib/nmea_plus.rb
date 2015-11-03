require 'nmea_plus/version'

require 'nmea_plus/generated_parser/parser'
require 'nmea_plus/generated_parser/tokenizer'

module NMEAPlus
  class SourceDecoder
    attr_accessor :throw_on_parse_fail
    attr_accessor :throw_on_unrecognized_type  # typically for development

    def initialize(line_reader)
      unless line_reader.respond_to? :each_line
        fail ArgumentError, "line_reader must inherit from type IO (or implement each_line)"
      end
      @throw_on_parse_fail = false
      @source = line_reader
      @decoder = NMEAPlus::Decoder.new
    end

    # return each parsed message
    def each_message
      @source.each_line do |line|
        if @throw_on_parse_fail
          yield @decoder.parse(line)
        else
          begin
            y = @decoder.parse(line)
            yield y
          rescue
          end
        end
      end
    end

    # return messages grouped into multipart chains as required
    def each_complete_message
      partials = {}
      each_message do |msg|
        slot = msg.data_type

        if partials[slot].nil?
          partials[slot] = msg
        else
          # the message was already in there
          if 1 != (msg.message_number - partials[slot].message_number)
            # error! just overwrite what was there
            partials[slot] = msg
          else
            partials[slot].add_message_part(msg)
          end
        end

        # take action if we've completed the chain
        maybe_full = partials[slot]
        if maybe_full.all_messages_received?
          partials[slot] = nil
          yield maybe_full
        end
      end
    end

  end
end
