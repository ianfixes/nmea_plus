require 'nmea_plus'

RSpec.describe NMEAPlus::Decoder, "#parse" do
  describe "testing the parser" do
    before do
      @parser = NMEAPlus::Decoder.new
    end

    context "when initialized" do
      it "can parse" do
        #puts "got these tokens: #{@parser.tokenize("$1,2*33")}"
        #@parser.parse("$1,2*33")
        #puts "got these tokens: #{@parser.tokenize("$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*47")}"
        @parser.parse("$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*47")
      end
    end

    context "when reading a message" do
      it "conforms to basic data storage requirements" do
        input = "$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*47"
        parsed = @parser.parse(input)
        expect(parsed.original).to eq(input)
        expect(parsed.data_type).to eq("GPGGA")
        expect(parsed.interpreted_data_type).to eq("GGA")
        expect(parsed.checksum).to eq("47")
        expect(parsed.checksum).to eq(parsed.calculated_checksum)
        expect(parsed.checksum_ok?).to eq(true)
        expect(parsed.total_messages).to eq(1)
        expect(parsed.message_number).to eq(1)
        expect(parsed.all_messages_received?).to eq(true)
      end
    end

    context "when reading a message" do
      it "recognizes bad checksums" do
        input = "$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*48"
        parsed = @parser.parse(input)
        expect(parsed.calculated_checksum).to eq("47")
        expect(parsed.checksum_ok?).to eq(false)
      end
    end

    context "when reading a message" do
      it "recognizes multipart" do
        input = "$GPALM,3,1*00"
        parsed1 = @parser.parse(input)
        expect(parsed1.total_messages).to eq(3)
        expect(parsed1.message_number).to eq(1)
        expect(parsed1.all_messages_received?).to eq(false)

        input = "$GPALM,3,2*00"
        parsed2 = @parser.parse(input)
        expect(parsed2.total_messages).to eq(3)
        expect(parsed2.message_number).to eq(2)
        expect(parsed2.all_messages_received?).to eq(false)

        input = "$GPALM,3,3*00"
        parsed3 = @parser.parse(input)
        expect(parsed3.total_messages).to eq(3)
        expect(parsed3.message_number).to eq(3)
        expect(parsed3.all_messages_received?).to eq(false)

        parsed1.add_message_part(parsed2)
        expect(parsed1.all_messages_received?).to eq(false)
        parsed1.add_message_part(parsed3)
        expect(parsed1.all_messages_received?).to eq(true)
      end
    end

  end
end
