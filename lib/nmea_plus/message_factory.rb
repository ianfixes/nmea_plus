
module NMEAPlus

  # meant to be extended.  Creates message classes with a common prefix and variable suffix
  class MessageFactory

    # factory class must be extended
    def self.parent_module
      "FIXME_parent_module"
    end

    # a way to override the data_type (e.g. __AAM) with GPAAM to get a match
    # whatever factory extends this class should override this method
    def self.alternate_data_type(data_type)
      data_type # in basic implementation, there is no alternative.
    end

    # check whether a given object exists.  this will work for all consts but shhhhhhhhh
    def self.message_class_exists?(class_identifier)
      Object::const_get(class_identifier)
      return true
    rescue ::NameError
      return false
    end

    # shortcut for the full name to a message class
    def self.message_class_name(data_type)
      "NMEAPlus::Message::#{self.parent_module}::#{data_type}"
    end

    # use the actual type if we have it, else try an alternate (and let it fail there)
    def self.best_match_for_data_type(data_type)
      return data_type if self.message_class_exists?(self.message_class_name(data_type))
      self.alternate_data_type(data_type)
    end

    # get a message class through reflection
    def self.dynamically_get_message_object(class_identifier)
      Object::const_get(class_identifier).new
    rescue ::NameError => e
      raise ::NameError, "Couldn't instantiate a #{class_identifier} object: #{e}"
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
      unless message.is_a? NMEAPlus::Message::Base
        fail ArgumentError, "Undefined message type #{data_type} (classname #{class_name})"
      end

      # assign its data and return it
      message.checksum = checksum
      message.payload = fields
      message.prefix = message_prefix
      message.interpreted_data_type = interpreted_type
      message
    end

  end

end
