
module NMEAPlus

  # meant to be extended.  Creates message classes with a common prefix and variable suffix
  class MessageFactory

    # factory class must be extended
    def self.parent_module
      "FIXME_parent_module"
    end

    def self.dynamically_get_message_class(class_identifier)
      begin
        Object::const_get(class_identifier).new
      rescue ::NameError => e
        raise ::NameError, "Couldn't instantiate a #{class_identifier} object: #{e}"
      end
    end

    # Choose what class to create, and create it based on the first of the (unsplitted) fields
    #
    def self.create(message_prefix, fields, checksum)
      message_type = fields.split(',', 2)[0].upcase  # assumed to be 'GPGGA', etc
      class_name = "NMEAPlus::Message::#{self.parent_module}::#{message_type}"

      # create message and make sure it's the right type
      message = self.dynamically_get_message_class(class_name)
      raise ArgumentError, "Undefined message type #{prefix} (classname #{class_name})" unless message.is_a? NMEAPlus::Message::Base

      # assign its data and return it
      message.checksum = checksum
      message.payload = fields
      message.prefix = message_prefix
      message
    end

  end

end
