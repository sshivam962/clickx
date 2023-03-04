# frozen_string_literal: true

module ContactFormBuilder
  class FieldRenderer
    include ActionView::Helpers::FormTagHelper
    include ActionView::Helpers::FormOptionsHelper
    include ActionView::Context

    def initialize(field, errors)
      @field = field
      @errors = errors
    end

    def self.fetch(field, errors)
      new(field, errors).fetch
    end

    def fetch
      [
        label_tag(field.name_slug, field.label, class: 'mb-0'),
        required_tag,
        help_text_tag,
        field_tag,
        validation_text
      ]
        .join(' ')
        .html_safe
    end

    private

    def field_tag
      case field.field_type
      when 'tel'
        telephone_field_tag(field.name_slug, '', placeholder: field.placeholder,
                                                 class: input_class, pattern: '\d{3}[\-]\d{3}[\-]\d{4}',
                                                 title: '111-222-3333')

      when 'email'
        email_field_tag(field.name_slug, '', placeholder: field.placeholder,
                                             class: input_class, value: field.value)

      when 'date'
        date_field_tag(field.name_slug, '', placeholder: field.placeholder,
                                            class: input_class)

      when 'number'
        number_field_tag(field.name_slug, '', placeholder: field.placeholder,
                                              class: input_class)

      when 'url'
        url_field_tag(field.name_slug, '', placeholder: field.placeholder,
                                           class: input_class)

      when 'time'
        time_field_tag(field.name_slug, '', placeholder: field.placeholder,
                                            class: input_class)

      when 'textarea'
        text_area_tag(field.name_slug, '', placeholder: field.placeholder,
                                           class: input_class)

      when 'radio'
        field.answer_options.map do |option|
          res = radio_button_tag(field.name_slug, option, false, class: 'ml-4')
          res += label_tag('', option, class: 'ml-1')
          res = content_tag(:div, res)
        end.join('').html_safe

      when 'checkbox'
        field.answer_options.map do |option|
          res = check_box_tag(field.name_slug, option, false, class: 'ml-4')
          res += label_tag('', option, class: 'ml-1')
          res = content_tag(:div, res, class: 'checkbox')
        end.join('').html_safe

      when 'select'
        select_tag(field.name_slug, options_for_select(field.answer_options, field.name),
                   class: input_class)

      else
        text_field_tag(field.name_slug, '', placeholder: field.placeholder,
                                            class: input_class, value: field.value)
      end
    end

    def help_text_tag
      return nil if field.help_text.blank?
      content_tag(:small, field.help_text, class: 'text-muted d-block')
    end

    def input_class
      return 'form-control' if errors.blank?
      'form-control is-invalid'
    end

    def required_tag
      return nil unless field.required?
      content_tag(:span, '*', class: 'text-danger')
    end

    def validation_text
      return nil if errors.blank?
      res = ''
      errors.each do |error|
        res += content_tag(:div, error, class: 'invalid-feedback')
      end
      res
    end

    attr_reader :field, :errors
  end
end
