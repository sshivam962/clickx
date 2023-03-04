class DoNotEncoder
  def self.encode(params)
    buffer = ''
    params.each do |key, value|
      buffer << "#{key}=#{value}&"
    end
    return buffer.chop
  end
end
