require 'nmea_plus/message/nmea/base_nmea'

module NMEAPlus
  module Message
    module NMEA
      # TRS - TRANSIT Satellite Operating Status
      # TRANSIT system is not operational, no recommended replacement.
      class TRS < NMEAPlus::Message::NMEA::NMEAMessage

        # TRANSIT system operating status
        # @!parse attr_reader :status
        # @return [Symbol]
        def status
          case @fields[1]
          when 'A' then :acquiring
          when 'c' then :calculating
          when 'e' then :error
          when 'm' then :message
          when 'T' then :test
          when 'U' then :dead_reckoning
          end
        end

        # Description of status
        # @!parse attr_reader :status_description
        # @return [String]
        def status_description
          case status
          when :acquiring then 'Acquiring'
          when :calculating then 'Calculating'
          when :error then 'Error'
          when :message then 'Message'
          when :test then 'Test'
          when :dead_reckoning then 'Dead reckoning'
          end
        end

      end
    end
  end
end
