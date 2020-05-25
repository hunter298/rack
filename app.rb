require_relative 'format_time'

class App

  attr_accessor :formatter

  ROUTES = { '/time' => FormatTime }

  def call(env)
    @formatter = ROUTES[env['REQUEST_PATH']]&.new(env)
    [status, headers, body]
  end


  def status
    if @formatter
      if @formatter.valid?
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

  def body
    if @formatter
      if @formatter.valid?
        @formatter.time
      else
        @formatter.invalid_formats
      end
    else
      ['No page found']
    end
  end

end
