require 'nmea_plus/version'

require 'nmea_plus/generated_parser/parser'
require 'nmea_plus/generated_parser/tokenizer'

# @author Ian Katz
module NMEAPlus

  # The NMEA source decoder wraps an IO object, converting each_line functionality
  # to {#each_message} or {#each_complete_message}
  class SourceDecoder
    # False by default.
    # @return [bool] whether to throw an exception on lines that don't properly parse
    attr_accessor :throw_on_parse_fail

    # False by default. Typically for development.
    # @return [bool] whether to throw an exception on message types that aren't supported
    attr_accessor :throw_on_unrecognized_type

    # @param line_reader [IO] The source stream for messages
    def initialize(line_reader)
      unless line_reader.respond_to? :each_line
        fail ArgumentError, "line_reader must inherit from type IO (or implement each_line)"
      end
      @throw_on_parse_fail = false
      @source = line_reader
      @decoder = NMEAPlus::Decoder.new
    end

    # Executes the block for every valid NMEA message in the source stream
    # @yield [NMEAPlus::Message] A parsed message
    # @return [void]
    def each_message
      @source.each_line do |line|
        if @throw_on_parse_fail
          yield @decoder.parse(line)
        else
          got_error = false
          begin
            y = @decoder.parse(line)
          rescue
            got_error = true
          end
          yield y unless got_error
        end
      end
    end

    # Executes the block for every valid NMEA message in the source stream, attempting to
    # group multipart messages into message chains.
    # @yield [NMEAPlus::Message] A parsed message that may contain subsequent parts
    # @return [void]
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
