require 'nmea_plus/message_factory'

# standard NMEA
require 'nmea_plus/message/nmea/aam'
require 'nmea_plus/message/nmea/alm'
require 'nmea_plus/message/nmea/apa'
require 'nmea_plus/message/nmea/apb'
require 'nmea_plus/message/nmea/bec'
require 'nmea_plus/message/nmea/ber'
require 'nmea_plus/message/nmea/bod'
require 'nmea_plus/message/nmea/bpi'
require 'nmea_plus/message/nmea/bwc'
require 'nmea_plus/message/nmea/bwr'
require 'nmea_plus/message/nmea/bww'
require 'nmea_plus/message/nmea/dbk'
require 'nmea_plus/message/nmea/dbs'
require 'nmea_plus/message/nmea/dbt'
require 'nmea_plus/message/nmea/dcn'
require 'nmea_plus/message/nmea/dpt'
require 'nmea_plus/message/nmea/dru'
require 'nmea_plus/message/nmea/dtm'
require 'nmea_plus/message/nmea/fsi'
require 'nmea_plus/message/nmea/gbs'
require 'nmea_plus/message/nmea/gda'
require 'nmea_plus/message/nmea/gdf'
require 'nmea_plus/message/nmea/gdp'
require 'nmea_plus/message/nmea/gga'
require 'nmea_plus/message/nmea/gla'
require 'nmea_plus/message/nmea/glc'
require 'nmea_plus/message/nmea/glf'
require 'nmea_plus/message/nmea/gll'
require 'nmea_plus/message/nmea/glp'
require 'nmea_plus/message/nmea/gns'
require 'nmea_plus/message/nmea/goa'
require 'nmea_plus/message/nmea/gof'
require 'nmea_plus/message/nmea/gop'
require 'nmea_plus/message/nmea/grs'
require 'nmea_plus/message/nmea/gsa'
require 'nmea_plus/message/nmea/gst'
require 'nmea_plus/message/nmea/gsv'
require 'nmea_plus/message/nmea/gtd'
require 'nmea_plus/message/nmea/gxa'
require 'nmea_plus/message/nmea/gxf'
require 'nmea_plus/message/nmea/gxp'
require 'nmea_plus/message/nmea/hcc'
require 'nmea_plus/message/nmea/hcd'
require 'nmea_plus/message/nmea/hdg'
require 'nmea_plus/message/nmea/hdm'
require 'nmea_plus/message/nmea/hdt'
require 'nmea_plus/message/nmea/hfb'
require 'nmea_plus/message/nmea/hsc'
require 'nmea_plus/message/nmea/htc'
require 'nmea_plus/message/nmea/hvd'
require 'nmea_plus/message/nmea/hvm'
require 'nmea_plus/message/nmea/its'
require 'nmea_plus/message/nmea/ima'
require 'nmea_plus/message/nmea/lcd'
require 'nmea_plus/message/nmea/mda'
require 'nmea_plus/message/nmea/mhu'
require 'nmea_plus/message/nmea/mmb'
require 'nmea_plus/message/nmea/msk'
require 'nmea_plus/message/nmea/mss'
require 'nmea_plus/message/nmea/mta'
require 'nmea_plus/message/nmea/mtw'
require 'nmea_plus/message/nmea/mwh'
require 'nmea_plus/message/nmea/mws'
require 'nmea_plus/message/nmea/mwv'
require 'nmea_plus/message/nmea/oln'
require 'nmea_plus/message/nmea/olw'
require 'nmea_plus/message/nmea/omp'
require 'nmea_plus/message/nmea/onz'
require 'nmea_plus/message/nmea/osd'
require 'nmea_plus/message/nmea/r00'
require 'nmea_plus/message/nmea/rma'
require 'nmea_plus/message/nmea/rmb'
require 'nmea_plus/message/nmea/rmc'
require 'nmea_plus/message/nmea/rnn'
require 'nmea_plus/message/nmea/rot'
require 'nmea_plus/message/nmea/rpm'
require 'nmea_plus/message/nmea/rsa'
require 'nmea_plus/message/nmea/rsd'
require 'nmea_plus/message/nmea/rte'
require 'nmea_plus/message/nmea/sbk'
require 'nmea_plus/message/nmea/scd'
require 'nmea_plus/message/nmea/scy'
require 'nmea_plus/message/nmea/sdb'
require 'nmea_plus/message/nmea/sfi'
require 'nmea_plus/message/nmea/sgd'
require 'nmea_plus/message/nmea/sgr'
require 'nmea_plus/message/nmea/slc'
require 'nmea_plus/message/nmea/snc'
require 'nmea_plus/message/nmea/snu'
require 'nmea_plus/message/nmea/sps'
require 'nmea_plus/message/nmea/ssf'
require 'nmea_plus/message/nmea/stc'
require 'nmea_plus/message/nmea/str'
require 'nmea_plus/message/nmea/stn'
require 'nmea_plus/message/nmea/siu'
require 'nmea_plus/message/nmea/sys'
require 'nmea_plus/message/nmea/tds'
require 'nmea_plus/message/nmea/tec'
require 'nmea_plus/message/nmea/tep'
require 'nmea_plus/message/nmea/tfi'
require 'nmea_plus/message/nmea/tga'
require 'nmea_plus/message/nmea/tif'
require 'nmea_plus/message/nmea/tpc'
require 'nmea_plus/message/nmea/tpr'
require 'nmea_plus/message/nmea/tpt'
require 'nmea_plus/message/nmea/trf'
require 'nmea_plus/message/nmea/trp'
require 'nmea_plus/message/nmea/trs'
require 'nmea_plus/message/nmea/ttm'
require 'nmea_plus/message/nmea/vbw'
require 'nmea_plus/message/nmea/vcd'
require 'nmea_plus/message/nmea/vdr'
require 'nmea_plus/message/nmea/vhw'
require 'nmea_plus/message/nmea/vlw'
require 'nmea_plus/message/nmea/vpw'
require 'nmea_plus/message/nmea/vpe'
require 'nmea_plus/message/nmea/vta'
require 'nmea_plus/message/nmea/vtg'
require 'nmea_plus/message/nmea/vti'
require 'nmea_plus/message/nmea/vwe'
require 'nmea_plus/message/nmea/vwr'
require 'nmea_plus/message/nmea/vwt'
require 'nmea_plus/message/nmea/wcv'
require 'nmea_plus/message/nmea/wdc'
require 'nmea_plus/message/nmea/wdr'
require 'nmea_plus/message/nmea/wfm'
require 'nmea_plus/message/nmea/wnc'
require 'nmea_plus/message/nmea/wnr'
require 'nmea_plus/message/nmea/wpl'
require 'nmea_plus/message/nmea/xdr'
require 'nmea_plus/message/nmea/xte'
require 'nmea_plus/message/nmea/xtr'
require 'nmea_plus/message/nmea/ywp'
require 'nmea_plus/message/nmea/yws'
require 'nmea_plus/message/nmea/zaa'
require 'nmea_plus/message/nmea/zcd'
require 'nmea_plus/message/nmea/zda'
require 'nmea_plus/message/nmea/zev'
require 'nmea_plus/message/nmea/zfi'
require 'nmea_plus/message/nmea/zfo'
require 'nmea_plus/message/nmea/zlz'
require 'nmea_plus/message/nmea/zpi'
require 'nmea_plus/message/nmea/zta'
require 'nmea_plus/message/nmea/zte'
require 'nmea_plus/message/nmea/ztg'
require 'nmea_plus/message/nmea/zti'
require 'nmea_plus/message/nmea/zwp'
require 'nmea_plus/message/nmea/zzu'

# proprietary
require 'nmea_plus/message/nmea/proprietary/pashr'

module NMEAPlus

=begin boilerplate for message definitions
require 'nmea_plus/message/nmea/base_nmea'

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
      sentence_type = data_type[2..4]
      alternates = [sentence_type]

      # Match special Route messages: R00 is the same as R01, R02...
      alternates.push('R00') unless /R\d\d/.match(sentence_type).nil?
      alternates
    end
  end

end
