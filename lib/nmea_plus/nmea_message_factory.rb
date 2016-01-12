
require_relative 'message_factory'

# standard NMEA
require_relative 'message/nmea/aam'
require_relative 'message/nmea/alm'
require_relative 'message/nmea/apa'
require_relative 'message/nmea/apb'
require_relative 'message/nmea/bod'
require_relative 'message/nmea/bwc'
require_relative 'message/nmea/bwr'
require_relative 'message/nmea/bww'
require_relative 'message/nmea/dbk'
require_relative 'message/nmea/dbs'
require_relative 'message/nmea/dbt'
require_relative 'message/nmea/dcn'
require_relative 'message/nmea/dpt'
require_relative 'message/nmea/dtm'
require_relative 'message/nmea/fsi'
require_relative 'message/nmea/gbs'
require_relative 'message/nmea/gga'
require_relative 'message/nmea/glc'
require_relative 'message/nmea/gll'
require_relative 'message/nmea/gns'
require_relative 'message/nmea/grs'
require_relative 'message/nmea/gsa'
require_relative 'message/nmea/gst'
require_relative 'message/nmea/gsv'
require_relative 'message/nmea/gtd'
require_relative 'message/nmea/gxa'
require_relative 'message/nmea/hdg'
require_relative 'message/nmea/hdm'
require_relative 'message/nmea/hdt'
require_relative 'message/nmea/hfb'
require_relative 'message/nmea/hsc'
require_relative 'message/nmea/its'
require_relative 'message/nmea/lcd'
require_relative 'message/nmea/msk'
require_relative 'message/nmea/mss'
require_relative 'message/nmea/mtw'
require_relative 'message/nmea/mwv'
require_relative 'message/nmea/oln'
require_relative 'message/nmea/osd'
require_relative 'message/nmea/r00'
require_relative 'message/nmea/rma'
require_relative 'message/nmea/rmb'
require_relative 'message/nmea/rmc'
require_relative 'message/nmea/rot'
require_relative 'message/nmea/rpm'
require_relative 'message/nmea/rsa'
require_relative 'message/nmea/rsd'
require_relative 'message/nmea/rte'
require_relative 'message/nmea/sfi'
require_relative 'message/nmea/stn'
require_relative 'message/nmea/tds'
require_relative 'message/nmea/tfi'
require_relative 'message/nmea/tpc'
require_relative 'message/nmea/tpr'
require_relative 'message/nmea/tpt'
require_relative 'message/nmea/trf'
require_relative 'message/nmea/ttm'
require_relative 'message/nmea/vbw'
require_relative 'message/nmea/vdr'
require_relative 'message/nmea/vhw'
require_relative 'message/nmea/vlw'
require_relative 'message/nmea/vpw'
require_relative 'message/nmea/vtg'
require_relative 'message/nmea/vwr'
require_relative 'message/nmea/wcv'
require_relative 'message/nmea/wnc'
require_relative 'message/nmea/wpl'
require_relative 'message/nmea/xdr'
require_relative 'message/nmea/xte'
require_relative 'message/nmea/xtr'
require_relative 'message/nmea/zda'
require_relative 'message/nmea/zfo'
require_relative 'message/nmea/ztg'

# proprietary
require_relative 'message/nmea/pashr'

module NMEAPlus

=begin boilerplate for message definitions
require_relative 'base_nmea'

module NMEAPlus
  module Message
    module NMEA
      class < NMEAPlus::Message::NMEA::NMEAMessage

      end
    end
  end
end
=end

  # Defines a factory for NMEA messages, which will all use {NMEAPlus::Message::NMEA::NMEAMessage} as their base.
  # The factory extracts the NMEA data type (prefixed by a 2-character "talker ID"), and looks for a class with
  # that name within the NMEA message namespace.
  class NMEAMessageFactory < MessageFactory

    # @return [String] The name of the parent module: NMEA
    def self.parent_module
      'NMEA'
    end

    # Match all NMEA messages as their generic counterparts.  GPGLL becomes GLL, etc.
    # @param data_type [String] The data_type of the NMEA message (e.g. the GPGLL of "$GPGLL,12,3,,4,5*00")
    # @return [String] The data_type that we will attempt to use in decoding the message (e.g. GLL)
    def self.alternate_data_type(data_type)
      # match last 3 digits (get rid of talker)
      data_type[2..4]
    end
  end

end
