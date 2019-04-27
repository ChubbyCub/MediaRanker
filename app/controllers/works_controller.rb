class WorksController < ApplicationController
  before_action :find_work, only: [:show, :edit, :update, :destroy]

  def index
    @works = Work.all.sort_by { |work| work.vote_ids.length }.reverse!
  end

  def show
    if @work.nil?
      flash[:error] = "Invalid work"
      redirect_to root_path
    end
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)

    is_successful = @work.save

    if is_successful
      flash[:success] = "Successfully created new work!"
      redirect_to work_path(@work.id)
    else
      @work.errors.messages.each do |field, messages|
        flash.now[field] = messages
      end
      render :new, status: :bad_request
    end
  end

  def edit
    if @work.nil?
      flash[:error] = "Invalid work"
      redirect_to works_path
    end
  end

  def update
    is_successful = @work.update(work_params)

    if is_successful
      flash[:success] = "Successfully updated #{@work.title}"
      redirect_to work_path(@work.id)
    else
      @work.errors.messages.each do |field, messages|
        flash.now[field] = messages
      end
      render :edit, status: :bad_request
    end
  end

  def destroy
    if @work.nil?
      flash[:error] = "Invalid work"
      redirect_to works_path
    else
      if !@work.vote_ids.empty?
        vote = Vote.find_by(work_id: @work.id)
        user = User.find_by(id: vote.user_id)
        vote.destroy
      end
      @work.destroy
      flash[:success] = "Successfully deleted #{@work.title}"
      redirect_to works_path
    end
  end

  private

  def work_params
    return params.require(:work).permit(:title, :category, :publication_year, :creator, :description, vote_ids: [])
  end

  def find_work
    @work = Work.find_by(id: params[:id])
  end
end
