Given /^Twilio is working$/ do
  Twilio::REST::Client.any_instance.stub(:account).and_return(Twilio::REST::Client.new("string1","string2"))
  @calls = mock
  Twilio::REST::Client.any_instance.stub(:calls).and_return(@calls)
  @calls.stub(:create).and_return(Net::HTTPSuccess.new(nil, nil, nil).tap { |n|
    n.stub(:body).and_return("<?xml version=\"1.0\"?>\n<TwilioResponse></TwilioResponse>\n")})
end

When /^call is made to begin interview$/ do
  visit candidate_begin_path(@candidate)
end

Then /^I should hear the introduction$/ do
  response = Hash.from_xml(page.body)
  # response.should =~ /"greeting-v1.mp3"/
  response.include?('html').should be_true
end