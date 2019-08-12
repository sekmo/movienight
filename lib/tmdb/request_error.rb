class TMDB::RequestError < StandardError
  attr_reader :http_code, :message

  def initialize(http_code, message = nil)
   @http_code = http_code
   @message = message
   super(message)
  end
end
