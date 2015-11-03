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
      it "reads multipart messages" do
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


  end
end
