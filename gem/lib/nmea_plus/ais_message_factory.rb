
require_relative 'message_factory'

require_relative 'message/ais/vdm'


module NMEAPlus
  class AISMessageFactory < MessageFactory
    def self.parent_module
      "AIS"
    end

    def self.alternate_data_type(data_type)
      # match last 3 digits (get rid of talker)
      data_type[2..4]
    end
  end
end
