
require_relative "../base"

module NMEAPlus
  module Message
    module AIS

      class AISMessage < NMEAPlus::Message::Base
        def talker
          data_type[0..1]
        end

        def message_type
          data_type[2..-1]
        end

      end
    end
  end
end
