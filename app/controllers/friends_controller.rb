class FriendsController < ApplicationController

  load_and_authorize_resource

  def recommend_friends
    @candidate = Candidate.find(params[:candidate_id])
    raise CanCan::AccessDenied.new() unless @candidate.started?
    redirect_to candidate_next_stage_path(@candidate) if @candidate.recommended_friends? || !@candidate.completed_interview
  end

  def add_friends
    @candidate = Candidate.find(params[:candidate_id])
    if params[:commit] == "Saltar"
      redirect_to candidate_interview_confirmation_path(@candidate)
    else
      list = params[:Candidate][:friend_list]
      array = list.strip.gsub(/\r\n?/, ", ").split(/\s*,\s*/)
      array.each do |email|
        @candidate.friends.create(email: email)
      end
      redirect_to candidate_interview_confirmation_path(@candidate), notice: "#{help.pluralize(array.size, 'amigo recomendado', 'amigos recomendados')}"
    end
  end

end
