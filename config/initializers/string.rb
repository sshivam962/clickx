class String
  def numeric_string?
    Float(self) != nil
  rescue
    false
  end

  def to_numeric
    if self.numeric_string?
      if self.index('.')
        self.to_f
      else
        self.to_i
      end
    else
      self.to_s
    end
  end
end
