require 'nmea_plus/version'

require 'nmea_plus/generated_parser/parser'
require 'nmea_plus/generated_parser/tokenizer'

# NMEAPlus contains classes for parsing and decoding NMEA and AIS messages, of which the {NMEAPlus::SourceDecoder}
# is most relevant.  Parsed messages extend from the {Message::NMEA::NMEAMessage} object, and any binary
# AIS playloads are decoded into objects that extend from {Message::AIS::AISMessage}.
# @author Ian Katz
module NMEAPlus

  # The SourceDecoder is meant as the primary entry point into the {NMEAPlus} module.
  # It wraps a {Decoder} object and an IO object, converting IO's #each_line functionality
  # to {#each_message} and/or {#each_complete_message},
  # which yield {NMEAPlus::Message} objects representing the parsed data.
  class SourceDecoder
    # False by default.
    # @return [bool] whether to throw an exception on lines that don't properly parse
    attr_accessor :throw_on_parse_fail

    # @param line_reader [IO] The source stream for messages
    def initialize(line_reader)
      unless line_reader.respond_to? :each_line
        raise ArgumentError, "line_reader must inherit from type IO (or implement each_line)"
      end
      @throw_on_parse_fail = false
      @source = line_reader
      @decoder = NMEAPlus::Decoder.new
    end

    # Executes the block for every valid NMEA message in the source stream.
    # In practice, you should use {#each_complete_message} unless you have a very compelling reason not to.
    # @yield [NMEAPlus::Message] A parsed message
    # @return [void]
    # @example
    #   input = "$GPGGA,123519,4807.038,N,01131.000,W,1,08,0.9,545.4,M,46.9,M,2.2,123*4b"
    #   io_source = StringIO.new(input)  # source decoder works on any IO object
    #   source_decoder = NMEAPlus::SourceDecoder.new(io_source)
    #   source_decoder.each_message do |message|
    #     if "GGA" == message.interpreted_data_type
    #       puts "Latitude: #{message.latitude} / Longitude: #{message.longtitude}"
    #       # prints "Latitude: 48.1173 / Longitude: -11.516666666666666666"
    #     end
    #   end
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

    # Attempts to group multipart NMEA messages into chains, and executes the block once for every complete chain.
    #
    # @yield [NMEAPlus::Message] A parsed message that may contain subsequent parts
    # @return [void]
    # @example
    #   input1 = "!AIVDM,2,1,0,A,58wt8Ui`g??r21`7S=:22058<v05Htp000000015>8OA;0sk,0*7B"
    #   input2 = "!AIVDM,2,2,0,A,eQ8823mDm3kP00000000000,2*5D"
    #   io_source = StringIO.new("#{input1}\n#{input2}")  # source decoder works on any IO object
    #   source_decoder = NMEAPlus::SourceDecoder.new(io_source)
    #   source_decoder.each_complete_message do |message|
    #     if message.ais && message.ais.message_type == 5
    #       ais = message.ais  # ais payload shortcut
    #       puts "Ship with MMSI #{ais.source_mmsi} (#{ais.name.strip}) is going to #{ais.destination.strip}"
    #       # prints "Ship with MMSI 603916439 (ARCO AVON) is going to HOUSTON"
    #     end
    #   end
    def each_complete_message
      partials = {}  # hash of message type to message-chain-in-progress
      each_message do |msg|
        # don't clutter things up if the message arrives already complete
        if msg.all_messages_received?
          yield msg
          next
        end

        # put message into partials slot (merge if necessary) based on its data type
        slot = msg.data_type
        if partials[slot].nil?                                           # no message in there
          partials[slot] = msg
        elsif 1 != (msg.message_number - partials[slot].message_number)  # broken sequence
          # error! just overwrite what was there
          partials[slot] = msg
        else                                                             # chain on to what's there
          partials[slot].add_message_part(msg)
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
