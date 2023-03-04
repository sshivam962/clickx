# frozen_string_literal: true

module ContactFormBuilder
  class FormRenderer
    include ActiveModel::Model
    attr_accessor :form

    def initialize(form)
      @form = form
    end

    def persisted?
      false
    end
  end
end
