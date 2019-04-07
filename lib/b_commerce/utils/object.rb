class Object
  def integer?
    self.to_s =~ /^\s*\d+\s*$/
  end
end
