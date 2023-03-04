# frozen_string_literal: true

class WriterFormsController < ApplicationController
  def get_writer_form
    @writer_form = WriterForm.data
    render json: { status: 200,
                   data: @writer_form }
  end

  def update_writer_form
    @writer_form = WriterForm.data
    if @writer_form.update_attributes(writer_form_params)
      render json: { status: 200,
                     data: @writer_form,
                     message: 'Updated Successfully' }
    else
      render json: { status: 404,
                     message: @writer_form.errors }
    end
  end

  private

  def writer_form_params
    params.require(:writer_form).permit(:proofreading_cost, :two_star_writer, :three_star_writer,
                                        :four_star_writer, :five_star_writer, :six_star_writer,
                                        :markup_percentage)
  end
end
