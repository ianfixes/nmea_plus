require 'nmea_plus'

RSpec.describe NMEAPlus::SourceDecoder, "#parse" do
  describe "testing the source decoder" do
    # before do
    #   @source_decoder = NMEAPlus::SourceDecoder.new
    # end


    context "when reading from a file source" do
      it "reads individual messages" do
        samples = File.join(File.dirname(__FILE__), "samples", "aivdm_message_samples.txt")

        sd = NMEAPlus::SourceDecoder.new(File.open(samples))
        called_once = false

        sd.each_message do |message|
          called_once = true
          expect(message.is_a? NMEAPlus::Message::AIS::AISMessage).to eq(true)
          expect(message.is_a? NMEAPlus::Message::Base).to eq(true)
          expect(message.checksum_ok?).to eq(true)
          expect(message.ais.message_type.is_a? Integer).to eq(true)
        end

        expect(called_once).to eq(true)
      end
    end

    context "when reading from a file source" do
      it "reads multipart AIS messages" do
        samples = File.join(File.dirname(__FILE__), "samples", "aivdm_message_samples.txt")

        sd = NMEAPlus::SourceDecoder.new(File.open(samples))
        called_once = false
        multipart_found = false

        sd.each_complete_message do |message|
          called_once = true
          multipart_found = true if 1 < message.total_messages
          expect(message.is_a? NMEAPlus::Message::AIS::AISMessage).to eq(true)
          expect(message.is_a? NMEAPlus::Message::Base).to eq(true)
          expect(message.all_messages_received?).to eq(true)
          expect(message.all_checksums_ok?).to eq(true)
          expect(message.ais.message_type.is_a? Integer).to eq(true)
        end

        expect(called_once).to eq(true)
        expect(multipart_found).to eq(true)
      end
    end


    context "when reading from a StringIO source" do
      it "reads multipart AIS messages" do

        input1 = "!AIVDM,2,1,0,A,58wt8Ui`g??r21`7S=:22058<v05Htp000000015>8OA;0sk,0*7B"
        input2 = "!AIVDM,2,2,0,A,eQ8823mDm3kP00000000000,2*5D"
        io_source = StringIO.new("#{input1}\n#{input2}")

        sd = NMEAPlus::SourceDecoder.new(io_source)
        now = Time.now

        called_once = false
        multipart_found = false

        sd.each_complete_message do |parsed|
          called_once = true
          multipart_found = true if 1 < parsed.total_messages

          expect(parsed.ais.message_type).to eq(5)
          expect(parsed.ais.repeat_indicator).to eq(0)
          expect(parsed.ais.source_mmsi).to eq(603916439)
          expect(parsed.ais.ais_version).to eq(0)
          expect(parsed.ais.imo_number).to eq(439303422)
          expect(parsed.ais.callsign.strip).to eq("ZA83R")
          expect(parsed.ais.name.strip).to eq("ARCO AVON")
          expect(parsed.ais.ship_cargo_type).to eq(69)
          expect(parsed.ais.ship_dimension_to_bow).to eq(113)
          expect(parsed.ais.ship_dimension_to_stern).to eq(31)
          expect(parsed.ais.ship_dimension_to_port).to eq(17)
          expect(parsed.ais.ship_dimension_to_starboard).to eq(11)
          expect(parsed.ais.epfd_type).to eq(0)
          expect(parsed.ais.eta).to eq(Time.new(now.year, 3, 23, 19, 45, 0))
          expect(parsed.ais.static_draught).to eq(13.2)
          expect(parsed.ais.destination.strip).to eq("HOUSTON")
          expect(parsed.ais.dte?).to eq(false)
        end

        expect(called_once).to eq(true)
        expect(multipart_found).to eq(true)
      end
    end



     context "when reading from a StringIO source" do
       it "can swallow parse errors" do

        input1 = "!AIVDM,2,1,0,A,58wt8Ui`g??r21`7S=:22058<v05Htp000000015>8OA;0sk,0*7B"
        input2 = "junk line"
        input3 = "!AIVDM,2,2,0,A,eQ8823mDm3kP00000000000,2*5D"
        io_source = StringIO.new("#{input1}\n#{input2}\n#{input3}")

        sd = NMEAPlus::SourceDecoder.new(io_source)

        called_once = false
        multipart_found = false

        sd.each_complete_message do |parsed|
          called_once = true
          multipart_found = true if 1 < parsed.total_messages
        end

        expect(called_once).to eq(true)
        expect(multipart_found).to eq(true)
      end
    end

     context "when reading from a StringIO source" do
       it "can expose parse errors" do

        input1 = "!AIVDM,2,1,0,A,58wt8Ui`g??r21`7S=:22058<v05Htp000000015>8OA;0sk,0*7B"
        input2 = "junk line"
        input3 = "!AIVDM,2,2,0,A,eQ8823mDm3kP00000000000,2*5D"
        io_source = StringIO.new("#{input1}\n#{input2}\n#{input3}")

        sd = NMEAPlus::SourceDecoder.new(io_source)
        sd.throw_on_parse_fail = true

        called_once = false
        multipart_found = false

        expect{sd.each_complete_message {}}.to raise_error(Racc::ParseError)

      end
    end


    context "when reading from a file source" do
      it "reads NMEA messages" do
        samples = File.join(File.dirname(__FILE__), "samples", "gps_message_samples.txt")

        sd = NMEAPlus::SourceDecoder.new(File.open(samples))
        called_once = false
        multipart_found = false

        sd.each_complete_message do |message|
          called_once = true
          multipart_found = true if 1 < message.total_messages
          expect(message.is_a? NMEAPlus::Message::NMEA::NMEAMessage).to eq(true)
          expect(message.is_a? NMEAPlus::Message::Base).to eq(true)
          expect(message.all_messages_received?).to eq(true)
          expect(message.all_checksums_ok?).to eq(true)
          if message.interpreted_data_type == "VDM"
            expect(message.ais.message_type.is_a? Integer).to eq(true)
          end
        end

        expect(called_once).to eq(true)
        # expect(multipart_found).to eq(true)
      end
    end



  end
end
