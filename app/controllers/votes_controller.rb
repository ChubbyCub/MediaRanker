class VotesController < ApplicationController
  def create
    if session[:user_id]
      votes_work = Work.find_by(id: params[:work_id]).vote_ids
      votes_user = User.find_by(id: session[:user_id]).vote_ids
      votes_work.each do |i|
        votes_user.each do |j|
          if i == j
            flash.now[:user] = "has already voted for this work"
            return
          end
        end
      end

      vote = Vote.new(
        work_id: params[:work_id],
        user_id: session[:user_id],
      )
      vote.save

      Work.find_by(id: vote.work_id).vote_ids << vote.id
      User.find_by(id: session[:user_id]).vote_ids << vote.id
      flash[:success] = "Successfully upvoted!"
    else
      flash[:error] = "You must log in to vote"
    end
  end
end
