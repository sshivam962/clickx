# frozen_string_literal: true
class ApplicationPresenter < SimpleDelegator
  def present_each_item_with(presenter_class, enumerable, &block)
    presenter = presenter_class.new(nil)
    enumerable.each do |object|
      presenter.__setobj__(object)
      yield(presenter) if block
    end
  end
end
