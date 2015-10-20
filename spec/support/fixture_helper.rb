module FixtureHelper
  def fixture_parentry(*entries)
    case ENV['STRATEGY']
    when 'array'
      "\"{#{entries.join(',')}}\""
    else
      entries.join('.')
    end
  end
end
