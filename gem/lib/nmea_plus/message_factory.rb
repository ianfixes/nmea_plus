
module NMEAPlus

  # meant to be extended.  Creates message classes with a common prefix and variable suffix
  class MessageFactory

    # factory class must be extended
    def self.parent_module
      "FIXME_parent_module"
    end

    def self.message_class_exists?(class_identifier)
      begin
        Object::const_get(class_identifier)
        return true
      rescue ::NameError => e
        return false
      end
    end

    def self.message_class_name(data_type)
      "NMEAPlus::Message::#{self.parent_module}::#{data_type}"
    end

    def self.best_match_for_data_type(data_type)
      return data_type if self.message_class_exists?(self.message_class_name(data_type))
      return self.alternate_data_type(data_type)
    end

    def self.alternate_data_type(data_type)
      data_type # in basic implementation, there is no alternative.
    end

    def self.dynamically_get_message_object(class_identifier)
      begin
        Object::const_get(class_identifier).new
      rescue ::NameError => e
        raise ::NameError, "Couldn't instantiate a #{class_identifier} object: #{e}"
      end
    end

    # Choose what class to create, and create it based on the first of the (unsplitted) fields
    #
    def self.create(message_prefix, fields, checksum)
      # get the data type and adjust it if necessary (e.g. support for NMEA standard sentences like __AAM)
      data_type = fields.split(',', 2)[0].upcase  # assumed to be 'GPGGA', etc
      interpreted_type = self.best_match_for_data_type(data_type)
      class_name = self.message_class_name(interpreted_type)

      # create message and make sure it's the right type
      message = self.dynamically_get_message_object(class_name)
      raise ArgumentError, "Undefined message type #{data_type} (classname #{class_name})" unless message.is_a? NMEAPlus::Message::Base

      # assign its data and return it
      message.checksum = checksum
      message.payload = fields
      message.prefix = message_prefix
      message.interpreted_data_type = interpreted_type
      message
    end

  end

end
