# encoding: utf-8
require 'spec_helper'

describe CallsController do

def stub_twilio_account
    Twilio::REST::Client.any_instance.stub(:account).and_return(Twilio::REST::Client.new("string1","string2"))
    @calls = mock
    Twilio::REST::Client.any_instance.stub(:calls).and_return(@calls)
end

describe "GET set_up" do

  it "does not generate call if candidate has completed verbal interview" do
    candidate = create(:candidate, completed_verbal_interview: true)
    get :set_up, candidate_id: candidate.id
    response.should redirect_to(candidate_complete_voice_interview_path(candidate))
  end

  it "hangs up existing in-progress calls" do
    candidate = create(:candidate)
    stub_twilio_account
    @call = candidate.calls.create(status: "in-progress")
    @calls.stub(:get).and_return(@call)
    @call.should_receive(:hangup).once
    @calls.stub(:create)
    get :set_up, candidate_id: candidate.id
  end

  it "generates call with correct parameters" do
    candidate = create(:candidate)
    stub_twilio_account
    @calls.should_receive(:create).with(from: '+525556598547', to: '1234', url: candidate_begin_url(candidate, protocol: 'https'), method: 'get', statusCallback: candidate_call_callback_url(candidate, protocol: 'https'), timeout: 10)
    get :set_up, candidate_id: candidate.id, number: '1234'
  end

  it "redirects to interview in progress if call is created" do
    candidate = create(:candidate)
    stub_twilio_account
    @calls.stub(:create).and_return(Net::HTTPSuccess.new(nil, nil, nil).tap { |n|
    n.stub(:body).and_return("<?xml version=\"1.0\"?>\n<TwilioResponse></TwilioResponse>\n")})
    get :set_up, candidate_id: candidate.id, number: '1234'
    response.should render_template('candidates/interview_in_progress')
  end

  it "redirects to start voice interview if error is raised" do
    candidate = create(:candidate)
    stub_twilio_account
    @calls.stub(:create).and_raise(Twilio::REST::RequestError.new(mock('err')))
    get :set_up, candidate_id: candidate.id, number: '1234'
    response.should render_template('candidates/start_voice_interview')
  end
end

describe "GET begin" do

  it "creates call instance if call is successfully connected" do
    candidate = create(:candidate)
    Call.should_receive(:create).with(sid: "string", status: "string", candidate_id: candidate.id)
    get :begin, {"candidate_id"=>candidate.id, "CallSid" => "string", "CallStatus" => "string"}
  end

  it "renders xml is call is successfully connected" do
    candidate = create(:candidate)
    Call.stub(:create)
    get :begin, candidate_id: candidate.id
    response.should be_success
    response.content_type.should be Mime::XML
  end

  it "renders xml including Play Greeting, Gather Input, Play Menu" do
    candidate = create(:candidate)
    Call.stub(:create)
    get :begin, candidate_id: candidate.id
    response.body.should =~ /(<Play>https:\/\/).*(\/instructions.mp3<\/Play>)/
    response.body.should =~ /(<Gather action="https:\/\/)(.*)(\/close_greeting" numDigits="1">)/
    response.body.should =~ /(<Play>https:\/\/)(.*)(\/assets\/menu1.mp3<\/Play>)/
  end
end

describe "POST close_greeting" do

  it "redirects to beginning of call if 2 is entered" do
    candidate = create(:candidate)
    post :close_greeting, candidate_id: candidate.id, "Digits" => "2"
    response.should redirect_to(controller: "calls", action: "begin")
  end

  it "redirects to begin questions if 1 is entered" do
    candidate = create(:candidate)
    Candidate.any_instance.stub(:verbal_question_ids).and_return(["1","2","3"])
    post :close_greeting, candidate_id: candidate.id, "Digits" => "1"
    response.should redirect_to(candidate_begin_questions_url(assigns(:candidate), list: ["1","2","3"], protocol: 'https'))
  end

  it "renders xml if any other key is pressed" do
    candidate = create(:candidate)
    post :close_greeting, candidate_id: candidate.id, "Digits" => "3"
    response.should be_success
    response.content_type.should be Mime::XML
  end

  it "renders xml including Gather Input and Play Menu" do
    candidate = create(:candidate)
    Call.stub(:create)
    get :begin, candidate_id: candidate.id
    response.body.should =~ /(<Gather action="https:\/\/)(.*)(\/close_greeting" numDigits="1">)/
    response.body.should =~ /(<Play>https:\/\/)(.*)(\/assets\/menu1.mp3<\/Play>)/
  end
end

describe "GET begin_questions" do

  it "redirects to next question if answer exists and there are other questions" do
    candidate = create(:candidate)
    Answer.stub(:where).and_return(["1"])
    get :begin_questions, candidate_id: candidate.id, list: ["1","2","3"]
    response.should redirect_to(candidate_begin_questions_url(assigns(:candidate), list: ["2","3"], number: 2, protocol: 'https'))
  end

  it "redirects to end of interview if answer exists and there are no other questions" do
    candidate = create(:candidate)
    Answer.stub(:where).and_return(["1"])
    get :begin_questions, candidate_id: candidate.id, list: ["1"]
    response.should redirect_to(candidate_finalize_call_path(assigns(:candidate)))
  end

  it "renders xml if answer does not exist" do
    candidate = create(:candidate)
    get :begin_questions, candidate_id: candidate.id, list: ["1"]
    response.should be_success
    response.content_type.should be Mime::XML
  end

  it "renders xml starting with saying Question 1 for the first question" do
    candidate = create(:candidate)
    get :begin_questions, candidate_id: candidate.id, list: ["1"]
    response.body.should =~ /(<Say language=\"es\">Pregunta 1<\/Say>)/
  end

  it "sets number as 1 if number has no value" do
    candidate = create(:candidate)
    get :begin_questions, candidate_id: candidate.id, list: ["1"]
    assigns(:number).should == 1
  end

  it "sets number as params[:number] if it is assigned" do
    candidate = create(:candidate)
    get :begin_questions, candidate_id: candidate.id, list: ["1"], number: 2
    assigns(:number).should == 2
  end

  it "increments number by 1 when moving on to next question" do
    candidate = create(:candidate)
    Answer.stub(:where).and_return(["1"])
    get :begin_questions, candidate_id: candidate.id, list: ["1","2","3"]
    response.should redirect_to(candidate_begin_questions_url(assigns(:candidate), list: ["2","3"], number: 2, protocol: 'https'))
  end

  it "renders xml including Play Question, Play Menu 2, Pause and Record" do
    candidate = create(:candidate)
    get :begin_questions, candidate_id: candidate.id, list: ["1"]
    response.body.should =~ /(<Play>https:\/\/)(.*)(\/assets\/q_1.mp3<\/Play>)/
    response.body.should =~ /(<Play>https:\/\/)(.*)(\/assets\/menu2.mp3<\/Play>)/
    response.body.should =~ /(<Pause length="15"\/>)/
    response.body.should =~ /(<Record action="https:\/\/)(.*)(finishOnKey="1" maxLength="540"\/>)/
  end
end

describe "GET move_on" do

  it "creates answer when candidate has finished" do
    candidate = create(:candidate)
    answer = mock('Answer')
    questionanswer = mock('QuestionAnswer')
    Candidate.any_instance.stub(:answers).and_return(answer)
    answer.should_receive(:create!).with(content: "url", question_id: 1).and_return(answer)
    answer.stub(:question_answers).and_return(questionanswer)
    questionanswer.should_receive(:create).with(question_id: 1)
    get :move_on, candidate_id: candidate.id, "RecordingUrl"=>"url", "q_id"=>"1", list: ["1"]
  end

  it "is directed to next question if it exists" do
    candidate = create(:candidate)
    answer = mock('Answer')
    questionanswer = mock('QuestionAnswer')
    Candidate.any_instance.stub(:answers).and_return(answer)
    answer.stub(:create!).and_return(answer)
    answer.stub(:question_answers).and_return(questionanswer)
    questionanswer.stub(:create)
    get :move_on, candidate_id: candidate.id, list: ["1","2"]
    response.should redirect_to(candidate_begin_questions_path(assigns(:candidate), list: ["2"], number: 1))
  end

  it "is directed to finish interview if no more questions" do
    candidate = create(:candidate)
    answer = mock('Answer')
    questionanswer = mock('QuestionAnswer')
    Candidate.any_instance.stub(:answers).and_return(answer)
    answer.stub(:create!).and_return(answer)
    answer.stub(:question_answers).and_return(questionanswer)
    questionanswer.stub(:create)
    get :move_on, candidate_id: candidate.id, list: ["1"]
    response.should redirect_to(candidate_finalize_call_path(assigns(:candidate)))
  end

  it "raises ActiveRecord exception if answer exists" do
    candidate = create(:candidate)
    candidate.answers.create(content: "url", question_id: 1)
    get :move_on, candidate_id: candidate.id, list: ["1"], q_id: "1"
    expect { candidate.answers.create!(content: "string", question_id: 1) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "does not create question_answer if exception is raised" do
    candidate = create(:candidate)
    candidate.answers.create(content: "url", question_id: 1)
    Answer.any_instance.should_not_receive(:questions_answers)
    get :move_on, candidate_id: candidate.id, list: ["1"]
  end

  it "redirects to nex question if exception is raised" do
    candidate = create(:candidate)
    candidate.answers.create(content: "url", question_id: 1)
    get :move_on, candidate_id: candidate.id, list: ["1","2"]
    response.should redirect_to(candidate_begin_questions_path(assigns(:candidate), list: ["2"], number: 1))
  end
end

describe "GET finalize_call" do

  it "marks interview as closed and adds number and sid" do
    candidate = create(:candidate)
    Candidate.any_instance.should_receive(:update_attributes).with(call_sid: "string", called_number: "1234", completed_verbal_interview: true)
    get :finalize_call, candidate_id: candidate.id, "CallSid"=>"string", "To"=>"1234"
  end

  it "renders xml" do
    candidate = create(:candidate)
    Candidate.any_instance.stub(:update_attributes)
    get :finalize_call, candidate_id: candidate.id
    response.should be_success
    response.content_type.should be Mime::XML
  end

  it "xml includes Hangup" do
    candidate = create(:candidate)
    Candidate.any_instance.stub(:update_attributes)
    get :finalize_call, candidate_id: candidate.id
    response.body.should =~ /(<Hangup\/>)/
  end
end

describe "POST call_callback" do
  it "changes status of terminated call" do
    candidate = create(:candidate)
    candidate.calls.create(sid: "call123")
    call = mock('Call')
    Call.stub(:find_last_by_sid).and_return(call)
    call.should_receive(:update_attribute).with(:status, "completed")
    post :call_callback, candidate_id: candidate.id, "CallStatus"=>"completed"
  end
end

describe "GET call_error" do

  it "redirects to start voice interview and tells candidate to try again" do
    candidate = create(:candidate)
    get :call_error, candidate_id: candidate.id
    response.should redirect_to(candidate_start_voice_interview_path(candidate))
    flash[:notice].should == "Por favor revisa tu número telefónico e intenta otra vez."
  end
end

end