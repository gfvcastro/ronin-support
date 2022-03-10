require 'spec_helper'
require 'ronin/support/format/core_ext/binary/array'

describe Array do
  subject { [0x1234, "hello"] }

  it "must provide Array#pack" do
    expect(subject).to respond_to(:pack)
  end

  describe "#pack" do
    let(:packed) { "\x34\x12hello\0" }

    context "when only given a String" do
      it "must pack elements using Array#pack codes" do
        expect(subject.pack('vZ*')).to eq(packed)
      end
    end

    context "otherwise" do
      it "must pack fields using Binary::Template" do
        expect(subject.pack(:uint16_le, :string)).to eq(packed)
      end
    end
  end
end
