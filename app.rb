class App

DATE_FROMATS = { 'year' => '%Y', 'month' => '%m', 'day' => '%d', 'hour' => '%H', 'minute' => '%M', 'second' => '%S' }


  def call(env)
    [status(env), headers, body(env)]
  end

  def query(env)
    URI.unescape(env['QUERY_STRING'].delete_prefix('format=')).split(',')
  end

  def status(env)
    if env['REQUEST_PATH'] == '/time' && env['REQUEST_METHOD'] == 'GET'
      if query(env).all? { |f| DATE_FROMATS[f] }
        200
      else
        400
      end
    else
      404
    end
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body(env)
    if status(env) == 200
      [Time.now.strftime(query(env).map{ |q| DATE_FROMATS[q] }.join('-'))]
    elsif status(env) == 400
      ["Unknown time format [#{query(env).reject { |f| DATE_FROMATS[f] }.join(', ')}]"]
    elsif status(env) == 404
      ['Page not found']
    end
  end

end
