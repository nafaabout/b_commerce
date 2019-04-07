class Object
  def integer?
    self.to_s =~ /^\s*\d+\s*$/
  end

  def string?
    String === self
  end
end
