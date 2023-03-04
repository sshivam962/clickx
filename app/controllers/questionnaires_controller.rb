# frozen_string_literal: true

class QuestionnairesController < ApplicationController
  before_action :get_current_business
  before_action :get_questionnaire, except: %i[create index]
  before_action -> { authorize @business, :client_level_manage? }
  def index
    @questionnaires = Questionnaire.all
    render json: @questionnaires.to_json
  end

  def show
    respond_to do |format|
      format.json do
        if @questionnaire
          render json: { status: 200,
                         questionnaire: @questionnaire,
                         answer: @questionnaire.answers }
        else
          render json: { status: 406 }
        end
      end
      format.pdf do
        render pdf: 'questionnaire',
               layout: false,
               template: 'questionnaires/show.html.haml',
               disable_smart_shrinking: true,
               show_as_html: params.key?('debug'),
               margin: { top: 0, bottom: 0, left: 0, right: 0 }
      end
    end
  end

  def create
    @business = Business.find(params[:business_id])
    @questionnaire = Questionnaire.new(questionnaire_params)
    if @questionnaire.save
      @business.questionnaire = @questionnaire
      save_answers(@questionnaire)
      unless current_user.preview_user?
        Notifier.questionnaire_answered(@questionnaire, current_user)
                .deliver_later
        User.admins_mailing_list.each do |user|
          user.notifications.create(
            actor: current_user,
            target: @questionnaire,
            action: 'questionnaire.answered'
          )
        end
      end
      render json: { status: 201,
                     questionnaire: @questionnaire }
    else
      render json: { status: 406,
                     questionnaire: @questionnaire,
                     errors: @questionnaire.errors }
    end
  end

  def edit
    render json: @questionnaire.to_json
  end

  def update
    if save_answers(@questionnaire)
      unless current_user.preview_user?
        Notifier.questionnaire_answered(@questionnaire, current_user)
                .deliver_later
      end
      render json: { status: 200,
                     questionnaire: @questionnaire,
                     answer: @questionnaire.answers }
    else
      render json: { status: 406,
                     questionnaire: @questionnaire,
                     errors: @questionnaire.errors }
    end
  end

  def destroy
    if @questionnaire.destroy
      render json: { status: 200 }
    else
      render json: { status: 406,
                     questionnaire: @questionnaire,
                     errors: @questionnaire.errors }
    end
  end

  private

  def save_answers(questionnaire)
    params[:answer].each do |answers|
      answers.each do |key, ans|
        next if ans.blank?

        version_id = Question.find(key.to_i).versions.last.index + 1
        @answer = Answer.find_by(questionnaire_id: questionnaire.id, question_id: key.to_i)
        @answer ||= questionnaire.answers.new(question_id: key.to_i)
        @answer.question_v_id = version_id
        ans_type = Question.find(key).exp_ans_type

        case ans_type
        when 'oneliner'
          @answer.oneliner = ans
        when 'boolean_ans'
          @answer.boolean_ans = (ans == 'true')
        when 'paragraph'
          @answer.paragraph = ans
        when 'mcq'
          @answer.mcq = ans
        end

        @answer.save
      end
    end
  end

  def get_questionnaire
    @questionnaire = Questionnaire.find_by(business_id: params[:business_id])
  end

  def get_current_business
    @business = Business.find(params[:business_id])
  end

  def questionnaire_params
    params.require(:questionnaire).permit(:id, :business_id, :answer)
  end
end
