require 'nmea_plus'

RSpec.describe NMEAPlus::Message::AIS::VDMPayload::VDMMsg, "#stuff" do
  describe "testing the parser" do
    before do
      @msg = NMEAPlus::Message::AIS::VDMPayload::VDMMsg.new
    end

    context "when using the base VDM payload container type" do
      it "provides correct low-level string functions" do
        expect(@msg._6b_ascii(0)).to eq('@')
        expect(@msg._6b_ascii(15)).to eq('O')
        expect(@msg._6b_ascii(31)).to eq('_')
        expect(@msg._6b_ascii(47)).to eq('/')
        expect(@msg._6b_ascii(63)).to eq('?')

        @msg.payload_bitstring = "HELLO@@@TEST@".chars.map { |c| (c.ord - 64).to_s(2).rjust(6, "0") }.join
        expect(@msg._6b_string(0, @msg.payload_bitstring.length)).to eq("HELLO@@@TEST@")
        expect(@msg._6b_string_nullterminated(0, @msg.payload_bitstring.length)).to eq("HELLO")
      end
    end

    context "when using the base VDM payload container type" do
      it "provides correct low-level integer functions" do
        @msg.payload_bitstring = "101000001101101111110111110"
        expect(@msg._6b_unsigned_integer(0, 6)).to eq(40)
        expect(@msg._6b_integer(0, 27)).to eq(-49881154)
        expect(@msg.payload_bitstring).to eq("101000001101101111110111110") # ensure no side effects
        expect(@msg._6b_boolean(2, 30)).to eq(true)
        expect(@msg._6b_boolean(3, 30)).to eq(false)
      end
    end
  end
end
