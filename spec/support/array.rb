class Array
  # The sole purpose of this method is to serialize the data for the fixtures based on the strategy being used.
  def to_parentry
    case ENV.fetch('STRATEGY', nil)
    when 'array'
      self
    else
      "\"#{join('.')}\""
    end
  end
end
