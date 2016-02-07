require 'test_helper'

class CallsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  #   TWILIO_ACCOUNT = Twilio::RestAccount.new(TWILIO_CONFIG[:sid], TWILIO_CONFIG[:token])
  #   TWILIO_ACCOUNT.stubs(:request).returns(Net::HTTPSuccess.new(nil, nil, nil).tap { |n|
  #     n.stubs(:body).returns("<?xml version=\"1.0\"?>\n<TwilioResponse></TwilioResponse>\n")
  #   })

  # def setup_candidate
  #   @campaign = campaigns(:one)
  #   @candidate = @campaign.candidates.create(email: "string", completed_verbal_interview: false)
  # end

  # def stub_twilio_account
  #   Twilio::REST::Client.any_instance.stubs(:account).returns(Twilio::REST::Client.new("string1","string2"))
  #   @calls = []
  #   Twilio::REST::Client.any_instance.stubs(:calls).returns(@calls)
  # end

  # test "call is not generated if candidate has completed verbal interview" do
  #   @campaign = campaigns(:one)
  #   @candidate = @campaign.candidates.create(email: "string", completed_verbal_interview: true)
  #   get :set_up, candidate_id: @candidate.id
  #   assert_redirected_to candidate_complete_voice_interview_path(@candidate)
  # end

  # test "existing in progress calls are hung-up" do
  #   setup_candidate
  #   stub_twilio_account
  #   @call = @candidate.calls.create(status: "in-progress")
  #   @calls.stubs(:get).returns(@call)
  #   @call.expects(:hangup).once
  #   @calls.stubs(:create)
  #   get :set_up, candidate_id: @candidate.id
  # end

  # test "call is generated with correct parameters" do
  #   setup_candidate
  #   stub_twilio_account
  #   @calls.expects(:create).with(from: '+525556598547', to: '1234', url: candidate_begin_url(@candidate), method: 'get', statusCallback: candidate_call_callback_url(@candidate), timeout: 10)
  #   get :set_up, candidate_id: @candidate.id, number: '1234'
  # end

  # test 'candidate is redirected to interview in progress if call is successfully created' do
  #   setup_candidate
  #   stub_twilio_account
  #   @calls.stubs(:create).returns(Net::HTTPSuccess.new(nil, nil, nil).tap { |n|
  #   n.stubs(:body).returns("<?xml version=\"1.0\"?>\n<TwilioResponse></TwilioResponse>\n")})
  #   get :set_up, candidate_id: @candidate.id, number: '1234'
  #   assert_template 'candidates/interview_in_progress'
  # end

  # test 'candidate is redirected to start voice interview if error is raised' do
  #   setup_candidate
  #   stub_twilio_account
  #   @calls.stubs(:create).raises(Twilio::REST::RequestError, "error message")
  #   get :set_up, candidate_id: @candidate.id, number: '1234'
  #   assert_template 'candidates/start_voice_interview'
  #   assert_equal 'error message', flash[:alert]
  # end

  # test 'if call is successfully connected, a new call instance is created' do
  #   setup_candidate
  #   Call.expects(:create).with(sid: "string", status: "string", candidate_id: @candidate.id)
  #   get :begin, {"candidate_id"=>@candidate.id, "CallSid" => "string", "CallStatus" => "string"}
  # end

  # test 'if call is successfully connected, xml is rendered' do
  #   setup_candidate
  #   Call.stubs(:create)
  #   get :begin, candidate_id: @candidate.id
  #   assert_response :success
  #   assert_equal Mime::XML , @response.content_type
  # end

  # test 'if call is successfully connected, xml includes Play Greeting, Gather Input, Play Menu' do
  #   setup_candidate
  #   Call.stubs(:create)
  #   get :begin, candidate_id: @candidate.id
  #   assert_not_nil @response.body =~ /(<Play>http:\/\/).*(\/greeting-v1.mp3<\/Play>)/
  #   assert_not_nil @response.body =~ /(<Gather action="http:\/\/)(.*)(\/close_greeting" numDigits="1">)/
  #   assert_not_nil @response.body =~ /(<Play>http:\/\/)(.*)(\/assets\/menu_1.mp3<\/Play>)/
  # end

  # test "if candidate presses 2, is redirected back to beginning of call" do
  #   setup_candidate
  #   post :close_greeting, candidate_id: @candidate.id, "Digits" => "2"
  #   assert_redirected_to controller: "calls", action: "begin"
  # end

  # test "if candidate presses 1, is directed to begin_questions" do
  #   setup_candidate
  #   Candidate.any_instance.stubs(:verbal_question_ids).returns(["1","2","3"])
  #   post :close_greeting, candidate_id: @candidate.id, "Digits" => "1"
  #   assert_redirected_to candidate_begin_questions_url(assigns(:candidate), list: ["1","2","3"])
  # end

  # test "if candidate presses other key, response is XML" do
  #   setup_candidate
  #   post :close_greeting, candidate_id: @candidate.id, "Digits" => "3"
  #   assert_response :success
  #   assert_equal Mime::XML , @response.content_type
  # end

  # test "if candidate presses other key, xml includes Gather Input and Play Menu" do
  #   setup_candidate
  #   Call.stubs(:create)
  #   get :begin, candidate_id: @candidate.id
  #   assert_not_nil @response.body =~ /(<Gather action="http:\/\/)(.*)(\/close_greeting" numDigits="1">)/
  #   assert_not_nil @response.body =~ /(<Play>http:\/\/)(.*)(\/assets\/menu_1.mp3<\/Play>)/
  # end

  # test "when candidate begins questions, if answer exists is directed to the next one as long as there are other questions" do
  #   setup_candidate
  #   Answer.stubs(:where).returns(["1"])
  #   get :begin_questions, candidate_id: @candidate.id, list: ["1","2","3"]
  #   assert_redirected_to candidate_begin_questions_url(assigns(:candidate), list: ["2","3"])
  # end

  # test "when candidate begins questions, if answer exists and there are no other questions is directed to end of interview" do
  #   setup_candidate
  #   Answer.stubs(:where).returns(["1"])
  #   get :begin_questions, candidate_id: @candidate.id, list: ["1"]
  #   assert_redirected_to candidate_finalize_call_path(assigns(:candidate))
  # end

  # test "if answer does not exist, response is xml" do
  #   setup_candidate
  #   get :begin_questions, candidate_id: @candidate.id, list: ["1"]
  #   assert_response :success
  #   assert_equal Mime::XML , @response.content_type
  # end

  # test "if answer does not exist, response includes Play Question, Play Menu 2, Pause and Record" do
  #   setup_candidate
  #   get :begin_questions, candidate_id: @candidate.id, list: ["1"]
  #   assert_not_nil @response.body =~ /(<Play>http:\/\/)(.*)(\/assets\/question_1.mp3<\/Play>)/
  #   assert_not_nil @response.body =~ /(<Play>http:\/\/)(.*)(\/assets\/menu_2-v2.mp3<\/Play>)/
  #   assert_not_nil @response.body =~ /(<Pause length="3"\/>)/
  #   assert_not_nil @response.body =~ /(<Record action="http:\/\/)(.*)(finishOnKey="1" maxLength="480"\/>)/
  # end

  # test "when candidate has finished, answer is created" do
  #   setup_candidate
  #   Candidate.any_instance.stubs(:answers).returns(Answer.new)
  #   Answer.any_instance.expects(:create!).with(content: "url", question_id: 1).returns(Answer.new)
  #   Answer.any_instance.stubs(:question_answers).returns(QuestionAnswer.new)
  #   QuestionAnswer.any_instance.expects(:create).with(question_id: 1)
  #   get :move_on, candidate_id: @candidate.id, "RecordingUrl"=>"url", "q_id"=>"1", list: ["1"]
  # end

  # test "when answer has been created, is directed to next question if it exists" do
  #   setup_candidate
  #   Candidate.any_instance.stubs(:answers).returns(Answer.new)
  #   Answer.any_instance.stubs(:create!).returns(Answer.new)
  #   Answer.any_instance.stubs(:question_answers).returns(QuestionAnswer.new)
  #   QuestionAnswer.any_instance.stubs(:create)
  #   get :move_on, candidate_id: @candidate.id, list: ["1","2"]
  #   assert_redirected_to candidate_begin_questions_path(assigns(:candidate), list: ["2"])
  # end

  # test "when answer has been created, is directed to finish interview when no more questions" do
  #   setup_candidate
  #   Candidate.any_instance.stubs(:answers).returns(Answer.new)
  #   Answer.any_instance.stubs(:create!).returns(Answer.new)
  #   Answer.any_instance.stubs(:question_answers).returns(QuestionAnswer.new)
  #   QuestionAnswer.any_instance.stubs(:create)
  #   get :move_on, candidate_id: @candidate.id, list: ["1"]
  #   assert_redirected_to candidate_finalize_call_path(assigns(:candidate))
  # end

  # test "if answer exists, ActiveRecord exception is raised" do
  #   setup_candidate
  #   @candidate.answers.create(content: "url", question_id: 1)
  #   get :move_on, candidate_id: @candidate.id, list: ["1"], q_id: "1"
  #   assert_raise(ActiveRecord::RecordInvalid) { @answer = @candidate.answers.create!(content: "string", question_id: 1) }
  # end

  # test "if exception is raised, question_answer is not created" do
  #   setup_candidate
  #   @candidate.answers.create(content: "url", question_id: 1)
  #   Answer.any_instance.expects(:questions_answers).never
  #   get :move_on, candidate_id: @candidate.id, list: ["1"]
  # end

  # test "if exception is raised, is redirected to next question" do
  #   setup_candidate
  #   @candidate.answers.create(content: "url", question_id: 1)
  #   get :move_on, candidate_id: @candidate.id, list: ["1","2"]
  #   assert_redirected_to candidate_begin_questions_path(assigns(:candidate), list: ["2"])
  # end

  # test "finalize call marks interiew as closed and adds number and sid" do
  #   setup_candidate
  #   Candidate.any_instance.expects(:update_attributes).with(call_sid: "string", called_number: "1234", completed_verbal_interview: true)
  #   get :finalize_call, candidate_id: @candidate.id, "CallSid"=>"string", "To"=>"1234"
  # end

  # test "finalize call renders XML" do
  #   setup_candidate
  #   Candidate.any_instance.stubs(:update_attributes)
  #   get :finalize_call, candidate_id: @candidate.id
  #   assert_response :success
  #   assert_equal Mime::XML , @response.content_type
  # end

  # test "finalize call xml includes Hangup" do
  #   setup_candidate
  #   Candidate.any_instance.stubs(:update_attributes)
  #   get :finalize_call, candidate_id: @candidate.id
  #   assert_not_nil @response.body =~ /(<Hangup\/>)/
  # end

  # test "call callback changes status of terminated call" do
  #   setup_candidate
  #   @candidate.calls.create(sid: "call123")
  #   Call.stubs(:find_last_by_sid).returns(Call.new)
  #   Call.any_instance.expects(:update_attribute).with(:status, "completed")
  #   post :call_callback, candidate_id: @candidate.id, "CallStatus"=>"completed"
  # end

end
