Interviewer::Application.routes.draw do

  constraints(host: /^www\./i) do
    match '(*any)' => redirect { |params, request|
      URI.parse(request.url).tap { |uri| uri.host.sub!(/^www\./i, '') }.to_s
    }
  end

  devise_for :recruiters
  devise_for :admins

  resources :admins
  resources :organizations do
  end

  resources :recruiters do
    get "change_password"
    put "update_password"
    resources :campaigns
    resources :messages
    resources :candidates do
      get "share"
      post "send_message", controller: 'messages'
    end
    get "technical_support", controller: "issues", action: "recruiter_technical_support"
    get "remove_account"
    get "manage"
  end

  resources :message_recipients

  resources :campaigns do
    resources :campaign_questions
    resources :candidates do
      put "accept"
      put "reject"
    end
    get "choose_filter_options"
    put "add_filter_options"
    get "choose_text_questions", controller: 'campaign_questions'
    post "create_text_questions", controller: 'campaign_questions'
    get "choose_verbal_questions", controller: 'campaign_questions'
    post "create_verbal_questions", controller: 'campaign_questions'
    get "question_confirmation", controller: 'campaign_questions'
    get "show_questions", controller: 'campaign_questions'
    get "edit_text_questions", controller: 'campaign_questions'
    get "edit_verbal_questions", controller: 'campaign_questions'
    get 'edit_filter_options'
    put 'update_filter_options'
    delete "remove_question", controller: 'campaign_questions'
    post "add_question", controller: 'campaign_questions'
    put "update_recommend_friends"
    get "enter_candidates"
    get "enter_more_candidates"
    post "add_candidates", controller: 'candidates'
    post "add_more_candidates", controller: 'candidates'
    get "confirmation"
    get "choose_deadline", controller: 'campaigns'
    put "update_deadline", controller: 'campaigns'
    put "update_candidate_references"
    put "update_receive_applications"
    put "close", controller: 'campaigns'
  end

  resources :candidates do
    resources :answers
    post "add_answers", controller: 'answers'
    get "email_edit"
    # get "share"
    put "update_email"
    get "filter_questions"
    put "interview_step_2"
    get "start_text_interview"
    get "start_voice_interview"
    post "add_phone"
    get "interview_in_progress"
    get "complete_voice_interview"
    get "recommend_friends", controller: "friends"
    post "add_friends", controller: "friends"
    get "provide_references"
    post "add_references", controller: "references"
    get "interview_confirmation"
    get "technical_support", controller: "issues", action: "candidate_technical_support"
    get "shared_external"
    get "next_stage"

    #Need to have routes set-up for different stages of voice interview
    get 'set_up', controller: 'calls'
    get 'begin', controller: 'calls'
    post 'begin', controller: 'calls'
    post 'close_greeting', controller: 'calls'
    get 'close_greeting', controller: 'calls'
    get 'begin_questions', controller: 'calls'
    post 'move_on', controller: 'calls'
    get 'finalize_call', controller: 'calls'
    get 'call_error', controller: 'calls'
    post 'call_callback', controller: 'calls'
  end
  get "candidate_start_interview", controller: 'candidates'

  resources :issues do
    put :update_status
  end
  resources :categories
  resources :questions
  resources :accounts

  #Routing for guides
  resources :guides

  #Route for creating new questions
  match 'questions/create_questions', controller: 'questions', action: 'create_questions'

  #Route for updating question drop-down options
  match 'get_drop_down_options', controller: 'campaign_questions', action: 'get_drop_down_options'
  get "technical_support", controller: "issues", action: "technical_support"

  #Routes for previewing mails
  match 'mailer(/:action(/:id(.:format)))' => 'candidate_mailer#:action'
  match 'recruiter_mailer(/:action(/:id(.:format)))' => 'recruiter_notifier#:action'
  match 'admin_mailer(/:action(/:id(.:format)))' => 'admin_notifier#:action'

  #Custom Error Pages
  match '/404', :to => 'errors#not_found'
  match '/422', :to => 'errors#internal_error'
  match '/500', :to => 'errors#server_error'
  match '/403', :to => 'errors#access_denied'

  #Health Check Action for ELB
  get "health_check" => "health_check#index"

  #Form for updating attributes
  get 'admin_form' => "admins#admin_form"
  put 'update_item' => "admins#update_item"

  #Get element attributes
  match 'get_element_attributes', controller: 'admins', action: 'find_item'

  #The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'application#home'
  devise_scope :recruiter do
    root to: "devise/sessions#new"
  end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
