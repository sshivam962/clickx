class SuperAdmin::QuestionsController < ApplicationController
  layout 'base'
  before_action :current_question, only: [:edit, :update, :destroy, :move_position]

  def index
    @groups = Group.includes(:questions)
    @groups.each do |x|
      x.questions.order(:position)
    end
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to super_admin_questions_path
      flash[:notice] = "Successfully created"
    else
      redirect_to new_super_admin_question_path
      flash[:notice] = "Failed"
    end
  end

  def edit
  end

  def new
    @groups = Group.all
    @question = Question.new
  end

  def update
    if @question.update(question_params)
      redirect_to super_admin_questions_path
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to super_admin_questions_path
  end

  def move_position
    @question.insert_at(params[:position].to_i)
    head :ok
  end

  private

  def question_params
    params.require(:question).permit(:question, :description, :exp_ans_type, :is_published, :is_mandatory, :group_id, mcq_choices: [])
  end

  def current_question
    @question = Question.find(params[:id])
  end

end
