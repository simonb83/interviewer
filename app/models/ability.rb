class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(Recruiter) && user.new_user == false && user.active? == true
      can :manage, Recruiter, id: user.id
      can :create, Campaign
      can :manage, Campaign, recruiter_id: user.id
      can :manage, Candidate, campaign: {recruiter_id: user.id}
      can :shared_external, Candidate, campaign: { recruiter: { organization_id: user.organization_id } }
      can [:create, :remove_question, :choose_text_questions, :choose_verbal_questions, :create_text_questions, :create_verbal_questions, :question_confirmation, :edit_text_questions, :edit_verbal_questions, :add_question, :show_questions, :choose_gateway_questions] , CampaignQuestion, campaign: {recruiter_id: user.id}
      can [:create, :read, :recruiter_technical_support] , Issue, {category: "recruiter", recruiter_id: user.id}
      can [:create, :send_message], Message
      can :destroy, Message do |message|
        message.sent_to_recruiter(user)
      end
      can :read, Guide
    elsif user.is_a?(Recruiter) && user.new_user == false && user.active? == false
      can can [:read, :change_password, :update_password, :edit, :update], Recruiter, id: user.id
      can [:create, :read, :recruiter_technical_support] , Issue, {category: "recruiter", recruiter_id: user.id}
      can :read, Guide
    elsif user.is_a?(Recruiter) && user.new_user
      can [:change_password, :update_password], Recruiter, id: user.id
      can [:create, :read, :recruiter_technical_support] , Issue, {category: "recruiter", recruiter_id: user.id}
      can :read, Guide
    elsif user.is_a?(Admin)
      can :manage, :all
    else
      can :manage, Call
      can [:create, :recommend_friends, :add_friends], Friend
      can [:create, :read] , Issue, { category: ["candidate", "other"] }
      can [:create, :add_answers], Answer
      can :create, QuestionAnswer
      can :shared_external, Candidate
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
