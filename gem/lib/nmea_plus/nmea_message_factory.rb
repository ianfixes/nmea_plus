
require_relative "message_factory"

require_relative "message/nmea/aam"
require_relative "message/nmea/alm"
require_relative "message/nmea/apa"
require_relative "message/nmea/apb"
require_relative "message/nmea/bod"
require_relative "message/nmea/bwc"
require_relative "message/nmea/bwr"
require_relative "message/nmea/bww"
require_relative "message/nmea/dbk"
require_relative "message/nmea/dbs"
require_relative "message/nmea/dbt"
require_relative "message/nmea/dcn"
require_relative "message/nmea/dpt"
require_relative "message/nmea/dtm"
require_relative "message/nmea/fsi"
require_relative "message/nmea/gbs"
require_relative "message/nmea/gga"
require_relative "message/nmea/glc"
require_relative "message/nmea/gll"
require_relative "message/nmea/gns"
require_relative "message/nmea/grs"
require_relative "message/nmea/gsa"
require_relative "message/nmea/gst"
require_relative "message/nmea/gsv"
require_relative "message/nmea/gtd"
require_relative "message/nmea/gxa"
require_relative "message/nmea/hdg"
require_relative "message/nmea/hdm"
require_relative "message/nmea/hdt"
require_relative "message/nmea/hfb"
require_relative "message/nmea/hsc"
require_relative "message/nmea/its"
require_relative "message/nmea/lcd"
require_relative "message/nmea/msk"
require_relative "message/nmea/mss"
require_relative "message/nmea/mtw"
require_relative "message/nmea/mwv"
require_relative "message/nmea/oln"
require_relative "message/nmea/osd"
require_relative "message/nmea/r00"
require_relative "message/nmea/rma"
require_relative "message/nmea/rmb"
require_relative "message/nmea/rmc"
require_relative "message/nmea/rot"
require_relative "message/nmea/rpm"
require_relative "message/nmea/rsa"
require_relative "message/nmea/rsd"
require_relative "message/nmea/rte"
require_relative "message/nmea/sfi"
require_relative "message/nmea/stn"
require_relative "message/nmea/tds"
require_relative "message/nmea/tfi"
require_relative "message/nmea/tpc"
require_relative "message/nmea/tpr"
require_relative "message/nmea/tpt"

=begin boilerplate for message definitions
require_relative "base_nmea"

module NMEAPlus
  module Message
    module NMEA
      class < NMEAPlus::Message::NMEA::NMEAMessage

      end
    end
  end
end
=end

module NMEAPlus

  class NMEAMessageFactory < MessageFactory

    def self.parent_module
      "NMEA"
    end

    def self.alternate_data_type(data_type)
      # match last 3 digits (get rid of talker)
      data_type[2..4]
    end
  end

end
