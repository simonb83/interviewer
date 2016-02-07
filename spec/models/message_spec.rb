require 'spec_helper'

describe Message do

  describe "sent to recruiter" do

    it "returns true if a message was sent to the passed recruiter" do
      recruiter_1 = create(:recruiter)
      recruiter_2 = create(:recruiter)
      message = Message.create(recruiter_id: recruiter_1.id)
      MessageRecipient.create(message_id: message.id, recruiter_id: recruiter_2.id)
      message.sent_to_recruiter(recruiter_2).should be_true
    end

    it "returns false if a message was not sent to the passed recruiter" do
      recruiter_1 = create(:recruiter)
      recruiter_2 = create(:recruiter)
      message = Message.create(recruiter_id: recruiter_1.id)
      MessageRecipient.create(message_id: message.id, recruiter_id: recruiter_1.id)
      message.sent_to_recruiter(recruiter_2).should_not be_true
    end

  end

end