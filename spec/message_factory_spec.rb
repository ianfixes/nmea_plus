require "nmea_plus"

RSpec.describe NMEAPlus::MessageFactory, "#create" do
  describe "testing the message factory" do
    context "by itself" do
      it "has basic functions" do
        expect(NMEAPlus::MessageFactory.parent_module).to eq("FIXME_parent_module")
        expect(NMEAPlus::MessageFactory.message_class_exists?("foobar")).to eq(false)
        expect(NMEAPlus::MessageFactory.message_class_exists?("NMEAPlus::MessageFactory")).to eq(true)
      end
    end
  end
end

RSpec.describe NMEAPlus::NMEAMessageFactory, "#create" do
  describe "testing the message factory" do
    context "by itself" do
      it "has basic functions" do
        expect(NMEAPlus::NMEAMessageFactory.alternate_data_type("GPAAM")).to eq(["AAM"])
      end
    end
  end
end

RSpec.describe NMEAPlus::AISMessageFactory, "#create" do
  describe "testing the message factory" do
    context "by itself" do
      it "has basic functions" do
        expect(NMEAPlus::AISMessageFactory.alternate_data_type("AIVDO")).to eq(["VDO"])
      end

      # via http://catb.org/gpsd/AIVDM.html#_aivdm_aivdo_payload_armoring
      %w[AB AD AI AN AR AS AT AX BS SA].each do |talker|
        it "recognizes talker ID of #{talker} as VDO" do
          expect(NMEAPlus::AISMessageFactory.alternate_data_type("#{talker}VDO")).to eq(["VDO"])
        end
      end
    end
  end
end
