require 'nmea_plus'

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
        expect(NMEAPlus::NMEAMessageFactory.alternate_data_type("__AAM")).to eq("GPAAM")
      end
    end

  end
end
