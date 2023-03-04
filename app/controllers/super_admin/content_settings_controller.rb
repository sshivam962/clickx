class SuperAdmin::ContentSettingsController < ApplicationController
  layout 'base'

  def index
    @writer_form = WriterForm.data
    @content_orders = ContentOrder.order(updated_at: :desc)
  end

  def update
    @writer_form = WriterForm.data
    @writer_form.update(writer_form_params)
  end

  private

  def writer_form_params
    params.require(:writer_form).permit(
      :proofreading_cost, :two_star_writer, :three_star_writer,
      :four_star_writer, :five_star_writer, :six_star_writer, :markup_percentage
    )
  end
end
