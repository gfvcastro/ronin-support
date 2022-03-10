require 'spec_helper'
require 'ronin/support/network/mixins/pop3'

describe Ronin::Support::Network::Mixins::POP3 do
  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  let(:host) { 'pop.gmail.com' }
  let(:port) { 995 }

  describe "#pop3_connect" do
    context "integration", :network do
      it "must return a Net::POP3 object" do
        pending "need valid POP3 credentials"

        pop3 = subject.pop3_connect(host, port: port, ssl: true)

        pop3.should be_kind_of(Net::POP3)
        pop3.finish
      end

      it "must connect to an POP3 service" do
        pending "need valid POP3 credentials"
        pop3 = subject.pop3_connect(host, port: port, ssl: true)

        pop3.should be_started
        pop3.finish
      end

      context "when given a block" do
        it "must yield the new Net::POP3 object" do
          pending "need valid POP3 credentials"
          pop3 = subject.pop3_connect(host, port: port, ssl: true) do |pop3|
            pop3.should be_kind_of(Net::POP3)
          end

          pop3.finish
        end
      end
    end
  end

  describe "#pop3_session" do
    context "integration", :network do
      it "must yield a new Net::POP3 object" do
        pending "need valid POP3 credentials"

        yielded_pop3 = nil

        subject.pop3_session(host, port: port, ssl: true) do |pop3|
          yielded_pop3 = pop3
        end

        yielded_pop3.should be_kind_of(Net::POP3)
      end

      it "must finish the POP3 session after yielding it" do
        pending "need valid POP3 credentials"

        pop3        = nil
        was_started = nil

        subject.pop3_session(host, port: port, ssl: true) do |yielded_pop3|
          pop3        = yielded_pop3
          was_started = pop3.started?
        end

        was_started.should == true
        pop3.should_not be_started
      end
    end
  end
end
