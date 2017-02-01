require_relative "vpe"

module NMEAPlus
  module Message
    module NMEA
      # YWP - Water Propagation Speed
      class YWP < NMEAPlus::Message::NMEA::VPE; end
    end
  end
end
