# frozen_string_literal: true
module KeywordsGenerator
  module_function

  def generate_combinations(keywords)
    return [] if keywords.empty?

    combinations = []

    generate = Proc.new { |text, position|
      text = text || ''
      position = position || 0
      i = 0
      while i < keywords[position].length do
        if position + 1 < keywords.length
          generate.call(text + ( text == '' ? '' : ' ') + keywords[position][i], position + 1)
        else
          combinations.push(text + ' ' + keywords[position][i])
        end
        i += 1
      end
    }
    generate.call
    combinations
  end
end
