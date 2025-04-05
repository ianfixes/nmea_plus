require "nmea_plus/message/nmea/base_nmea"

module NMEAPlus
  module Message
    module NMEA
      # TRS - TRANSIT Satellite Operating Status
      # TRANSIT system is not operational, no recommended replacement.
      class TRS < NMEAPlus::Message::NMEA::NMEAMessage
        STATUS_FLAGS = {
          "A" => :acquiring,
          "c" => :calculating,
          "e" => :error,
          "m" => :message,
          "T" => :test,
          "U" => :dead_reckoning
        }.freeze

        STATUS_DESCRIPTIONS = {
          acquiring: "Acquiring",
          calculating: "Calculating",
          error: "Error",
          message: "Message",
          test: "Test",
          dead_reckoning: "Dead reckoning"
        }.freeze

        # TRANSIT system operating status
        # @!parse attr_reader :status
        # @return [Symbol]
        def status
          STATUS_FLAGS[@fields[1]]
        end

        # Description of status
        # @!parse attr_reader :status_description
        # @return [String]
        def status_description
          STATUS_DESCRIPTIONS[status]
        end

      end
    end
  end
end
