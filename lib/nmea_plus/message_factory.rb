
module NMEAPlus

  # The base class for MessageFactory objects, which are instantiated in the Parser.  MessageFactory objects
  # create message classes with a common prefix and variable suffix.  In an NMEA example,
  # the prefix might be GP and the suffixes might be AAM or GLL (making GPAAM and GPGLL).
  #
  # If you are creating more subclasses of MessageFactory, you are probably a developer adding more NMEA-style
  # message factories to the parser, and you are working with the repo (not the gem).
  # @abstract MessageFactory is meant to be extended by actual implementations of message parsing classes
  class MessageFactory

    # For dynamic loading purposes.  Don't mess this up!
    # @abstract
    # @return [String] The name of the parent module
    def self.parent_module
      "FIXME_parent_module"
    end

    # Sometimes we want to override the data_type specified in the message (e.g. __AAM) with an
    # alternate type (like GPAAM) or a generic type (like AAM).  This is where we put that logic.
    # @abstract
    # @param data_type [String] The data_type of the NMEA message (e.g. the GPGLL of "$GPGLL,12,3,,4,5*00")
    # @return [String] The data_type that we will attempt to use in decoding the message
    def self.alternate_data_type(data_type)
      data_type # in basic implementation, there is no alternative.
    end

    # Check whether a given object exists.  this will work for all consts but shhhhhhhhh
    # @param class_identifier [String] The name of a ruby class
    # @return [bool]
    def self.message_class_exists?(class_identifier)
      Object::const_get(class_identifier)
      return true
    rescue ::NameError
      return false
    end

    # Shortcut for the full name to a message class built from this factory.
    # @param data_type [String]
    # @return [String] The fully qualified message class name
    def self.message_class_name(data_type)
      "NMEAPlus::Message::#{self.parent_module}::#{data_type}"
    end

    # Try to load a class for the data_type specified in the message.  If it doesn't exist,
    # then try an alternate.  If that doesn't work, fail.
    # @param data_type [String] The data type for a given message
    # @return [String] The fully qualified message class name
    def self.best_match_for_data_type(data_type)
      return data_type if self.message_class_exists?(self.message_class_name(data_type))
      self.alternate_data_type(data_type)
    end

    # Get a message class through reflection
    # @param class_identifier [String] the fully-qualified name of the class to instantiate
    # @return [Object] The object for that class string
    def self.dynamically_get_message_object(class_identifier)
      Object::const_get(class_identifier).new
    rescue ::NameError => e
      raise ::NameError, "Couldn't instantiate a #{class_identifier} object: #{e}"
    end

    # Choose what message class to create, and create it based on the first of the (unsplitted) fields -- which
    # is the data_type
    # @param message_prefix [String] The single-character prefix for this message type (e.g. "$", "!")
    # @param fields [String] The entire payload of the message
    # @param checksum [String] The two-character checksum of the message
    # @return [NMEAPlus::Message] A message object
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
