class FormatTime

  DATE_FROMATS = { 'year' => '%Y', 'month' => '%m', 'day' => '%d', 'hour' => '%H', 'minute' => '%M', 'second' => '%S' }

  def initialize(env)
    @query = URI.unescape(env['QUERY_STRING'].delete_prefix('format=')).split(',')
  end

  def valid?
      @query.all? { |f| DATE_FROMATS[f] }
  end

  def time
    [Time.now.strftime(@query.map{ |q| DATE_FROMATS[q] }.join('-'))]
  end

  def invalid_formats
    ["Unknown time formats [#{@query.reject { |f| DATE_FROMATS[f] }.join(', ')}]"]
  end

end
