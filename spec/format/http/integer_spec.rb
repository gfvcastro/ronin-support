require 'spec_helper'
require 'ronin/support/format/core_ext/http/integer'

describe Integer do
  subject { 0x20 }

  it "must provide String#uri_encode" do
    expect(subject).to respond_to(:uri_encode)
  end

  it "must provide String#uri_escape" do
    expect(subject).to respond_to(:uri_escape)
  end

  it "must provide String#format_http" do
    expect(subject).to respond_to(:format_http)
  end

  describe "#uri_encode" do
    let(:uri_encoded) { '%20' }

    it "must URI encode itself" do
      expect(subject.uri_encode).to eq(uri_encoded)
    end

    context "when given unsafe characters" do
      let(:not_encoded) { ' ' }

      it "must encode itself if listed as unsafe" do
        expect(subject.uri_encode(' ', "\n", "\r")).to eq(uri_encoded)
      end

      it "must not encode itself if not listed as unsafe" do
        expect(subject.uri_encode('A', 'B', 'C')).to eq(not_encoded)
      end
    end
  end

  describe "#uri_escape" do
    let(:uri_escaped) { '+' }

    it "must URI escape itself" do
      expect(subject.uri_escape).to eq(uri_escaped)
    end
  end

  describe "#format_http" do
    let(:http_formatted) { '%20' }

    it "must format the byte" do
      expect(subject.format_http).to eq(http_formatted)
    end
  end

  describe "#http_escape" do
    let(:http_escaped) { '+' }

    it "must format the byte" do
      expect(subject.http_escape).to eq(http_escaped)
    end
  end
end
