# frozen_string_literal: true

class ContentsController < ApplicationController
  before_action :set_current_business
  before_action :set_content, except: %w[create index new change_state]
  before_action -> { authorize @business, :client_level_manage? }
  def index
    @data = business_contents
    @content = @data.map { |content| ContentsPresenter.new(content) }
    respond_to do |format|
      format.pdf do
        render pdf: 'content_export.pdf',
               print_media_type: true
      end
      format.json { render json: @data }
    end
  end

  def show
    render json: @content.to_json(for_view: true)
  end

  def create
    content = @business.contents.new(content_params)
    if content.save
      add_state_tracker(content, 'start', 'draft')
      render json: { status: 201,
                     content: content.to_json }
    else
      render json: { status: 406,
                     content: content,
                     errors: content.errors }
    end
  end

  def update
    if @content.update_attributes(content_params)
      render json: { status: 201,
                     content:  @content.to_json }
    else
      render json: { status: 406,
                     content: @content,
                     errors: @content.errors }
    end
  end

  def destroy
    if @content.destroy
      render json: { status: 200,
                     contents: business_contents.to_json(for_list: true) }
    else
      render json: { status: 406,
                     content: @content.to_json,
                     errors: @content.errors }
    end
  end

  def change_state
    content = Content.find(params[:id])
    old_state = content.state
    new_state = params[:new_state]
    state_action = get_content_action(params[:new_state])
    if content.send(state_action)
      add_state_tracker(content, old_state, new_state)
      render json: { status: 201,
                     content: content.to_json }
    else
      render json: { status: 406,
                     content: content.to_json,
                     errors: content.errors }
    end
  end

  def add_comment
    comment = @content.comments.new(comment_params)
    comment.user = current_user
    comment.user_name = current_user.name
    if comment.save
      render json: @content.to_json(for_view: true)
    else
      render json: { status: 406,
                     content: @content,
                     errors: @content.errors }
    end
  end

  def add_state_tracker(content, old_state, new_state)
    state_track = content.state_trackers.new
    state_track.user = current_user
    state_track.user_name = current_user.name
    state_track.from_state = old_state
    state_track.to_state = new_state
    state_track.transition_date = Time.current
    state_track.save
  end

  private

  def get_content_action(new_state)
    action =
      case new_state
      when Content::ContentStates[1] # review
        'submit_review!'
      when Content::ContentStates[2] # review_submitted
        'submit_feedback!'
      when Content::ContentStates[3] # final_proof
        'final_proof!'
      when Content::ContentStates[4] # approved
        'approve!'
      end
    action
  end

  def set_current_business
    if params[:business_id]
      @business = Business.find(params[:business_id])
    else
      @business = current_business unless current_user.super_admin?
    end
  end

  def set_content
    @content = Content.find(params[:id])
  end

  def content_params
    params.require(:content).permit(
      :id, :title, :state, :business_id, :title, :content, :link,
      :meta_title, :meta_description
    )
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def business_contents
    @business.contents.order('created_at DESC')
  end
end
