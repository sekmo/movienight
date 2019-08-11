class TMDB::RequestError < StandardError
  attr_reader :code, :message

  def initialize(http_code, message = nil)
   super
   @http_code = http_code
   @message = message
  end
end
