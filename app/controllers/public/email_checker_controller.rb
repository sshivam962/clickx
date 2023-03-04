# frozen_string_literal: true

class Public::EmailCheckerController < PublicController
  def check
    condition = Freemail.disposable?(params[:email])
    render json: !condition
  end
end
