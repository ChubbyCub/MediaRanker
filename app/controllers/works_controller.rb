class WorksController < ApplicationController
  def index
    @works = Work.all
  end

  def show
    @work = Work.find_by(id: params[:id])
    if @work.nil?
      head :not_found
    end
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)

    is_successful = @work.save

    if is_successful
      redirect_to work_path(@work.id)
    else
      render :new, status: :bad_request
    end
  end

  def update
  end

  def edit
  end

  def destroy
  end

  private

  def work_params
    return params.require(:work).permit(:title, :category, :publication_year, :creator)
  end
end
