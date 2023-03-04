# frozen_string_literal: true

require 'multi_json'

class QuestionsController < ApplicationController
  before_action :get_current_user
  before_action -> { authorize :businesses, :manage? }, except: %i[index show get_previous_version]
  before_action :get_question, except: %i[create index set_order]
  before_action :get_question_of_version, only: [:show]

  def index
    render json: Question.all.to_json
  end

  def show
    render json: { status: 200,
                   question: @question,
                   question_of_version_passed: @version_question }
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      render json: { status: 201,
                     question: @question }
    else
      render json: { status: 406,
                     question: @question,
                     errors: @question.errors }
    end
  end

  def edit
    render json: @question.to_json
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(question_params)
      render json: { status: 200,
                     question: @question }
    else
      render json: { status: 406,
                     question: @question,
                     errors: @question.errors }
    end
  end

  def destroy
    if @question.destroy
      render json: { status: 200 }
    else
      render json: { status: 406,
                     question: @question,
                     errors: @question.errors }
    end
  end

  def set_order
    group_set = MultiJson.load(params[:question_ordering])
    if group_set != {}
      group_set.each do |_k, group|
        group.each do |k, obj|
          @question = Question.find(obj)
          @question.order = k.to_i
          @question.save
        end
      end
      render json: { status: 200 }
    else
      render json: { status: 406 }
    end
  end

  private

  def get_question_of_version
    @version_question = @question
    params[:version_difference].to_i.times do |_i|
      @version_question = @version_question.previous_version
    end
  end

  def get_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:id, :question, :description, :exp_ans_type, :is_published, :is_mandatory, :group_id, mcq_choices: [])
  end
end
