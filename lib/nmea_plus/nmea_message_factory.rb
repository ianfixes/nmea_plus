
require_relative 'message_factory'

# standard NMEA
require_relative 'message/nmea/aam'
require_relative 'message/nmea/alm'
require_relative 'message/nmea/apa'
require_relative 'message/nmea/apb'
require_relative 'message/nmea/bec'
require_relative 'message/nmea/ber'
require_relative 'message/nmea/bod'
require_relative 'message/nmea/bpi'
require_relative 'message/nmea/bwc'
require_relative 'message/nmea/bwr'
require_relative 'message/nmea/bww'
require_relative 'message/nmea/dbk'
require_relative 'message/nmea/dbs'
require_relative 'message/nmea/dbt'
require_relative 'message/nmea/dcn'
require_relative 'message/nmea/dpt'
require_relative 'message/nmea/dru'
require_relative 'message/nmea/dtm'
require_relative 'message/nmea/fsi'
require_relative 'message/nmea/gbs'
require_relative 'message/nmea/gda'
require_relative 'message/nmea/gdf'
require_relative 'message/nmea/gdp'
require_relative 'message/nmea/gga'
require_relative 'message/nmea/gla'
require_relative 'message/nmea/glc'
require_relative 'message/nmea/glf'
require_relative 'message/nmea/gll'
require_relative 'message/nmea/glp'
require_relative 'message/nmea/gns'
require_relative 'message/nmea/goa'
require_relative 'message/nmea/gof'
require_relative 'message/nmea/gop'
require_relative 'message/nmea/grs'
require_relative 'message/nmea/gsa'
require_relative 'message/nmea/gst'
require_relative 'message/nmea/gsv'
require_relative 'message/nmea/gtd'
require_relative 'message/nmea/gxa'
require_relative 'message/nmea/gxf'
require_relative 'message/nmea/gxp'
require_relative 'message/nmea/hcc'
require_relative 'message/nmea/hcd'
require_relative 'message/nmea/hdg'
require_relative 'message/nmea/hdm'
require_relative 'message/nmea/hdt'
require_relative 'message/nmea/hfb'
require_relative 'message/nmea/hsc'
require_relative 'message/nmea/htc'
require_relative 'message/nmea/hvd'
require_relative 'message/nmea/hvm'
require_relative 'message/nmea/its'
require_relative 'message/nmea/ima'
require_relative 'message/nmea/lcd'
require_relative 'message/nmea/mda'
require_relative 'message/nmea/mhu'
require_relative 'message/nmea/mmb'
require_relative 'message/nmea/msk'
require_relative 'message/nmea/mss'
require_relative 'message/nmea/mta'
require_relative 'message/nmea/mtw'
require_relative 'message/nmea/mwh'
require_relative 'message/nmea/mws'
require_relative 'message/nmea/mwv'
require_relative 'message/nmea/oln'
require_relative 'message/nmea/olw'
require_relative 'message/nmea/omp'
require_relative 'message/nmea/onz'
require_relative 'message/nmea/osd'
require_relative 'message/nmea/r00'
require_relative 'message/nmea/rma'
require_relative 'message/nmea/rmb'
require_relative 'message/nmea/rmc'
require_relative 'message/nmea/rnn'
require_relative 'message/nmea/rot'
require_relative 'message/nmea/rpm'
require_relative 'message/nmea/rsa'
require_relative 'message/nmea/rsd'
require_relative 'message/nmea/rte'
require_relative 'message/nmea/sbk'
require_relative 'message/nmea/scd'
require_relative 'message/nmea/scy'
require_relative 'message/nmea/sdb'
require_relative 'message/nmea/sfi'
require_relative 'message/nmea/sgd'
require_relative 'message/nmea/sgr'
require_relative 'message/nmea/slc'
require_relative 'message/nmea/snc'
require_relative 'message/nmea/snu'
require_relative 'message/nmea/sps'
require_relative 'message/nmea/ssf'
require_relative 'message/nmea/stc'
require_relative 'message/nmea/str'
require_relative 'message/nmea/stn'
require_relative 'message/nmea/siu'
require_relative 'message/nmea/sys'
require_relative 'message/nmea/tds'
require_relative 'message/nmea/tec'
require_relative 'message/nmea/tep'
require_relative 'message/nmea/tfi'
require_relative 'message/nmea/tga'
require_relative 'message/nmea/tif'
require_relative 'message/nmea/tpc'
require_relative 'message/nmea/tpr'
require_relative 'message/nmea/tpt'
require_relative 'message/nmea/trf'
require_relative 'message/nmea/trp'
require_relative 'message/nmea/trs'
require_relative 'message/nmea/ttm'
require_relative 'message/nmea/vbw'
require_relative 'message/nmea/vcd'
require_relative 'message/nmea/vdr'
require_relative 'message/nmea/vhw'
require_relative 'message/nmea/vlw'
require_relative 'message/nmea/vpw'
require_relative 'message/nmea/vpe'
require_relative 'message/nmea/vta'
require_relative 'message/nmea/vtg'
require_relative 'message/nmea/vti'
require_relative 'message/nmea/vwe'
require_relative 'message/nmea/vwr'
require_relative 'message/nmea/vwt'
require_relative 'message/nmea/wcv'
require_relative 'message/nmea/wdc'
require_relative 'message/nmea/wdr'
require_relative 'message/nmea/wfm'
require_relative 'message/nmea/wnc'
require_relative 'message/nmea/wnr'
require_relative 'message/nmea/wpl'
require_relative 'message/nmea/xdr'
require_relative 'message/nmea/xte'
require_relative 'message/nmea/xtr'
require_relative 'message/nmea/ywp'
require_relative 'message/nmea/yws'
require_relative 'message/nmea/zaa'
require_relative 'message/nmea/zda'
require_relative 'message/nmea/zfi'
require_relative 'message/nmea/zfo'
require_relative 'message/nmea/zpi'
require_relative 'message/nmea/ztg'

# proprietary
require_relative 'message/nmea/proprietary/pashr'

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
    # @return [Array] Array of data_type strings that we will attempt to use in decoding the message
    def self.alternate_data_type(data_type)
      # match last 3 digits (get rid of talker)
      [data_type[2..4]]
    end
  end

end
