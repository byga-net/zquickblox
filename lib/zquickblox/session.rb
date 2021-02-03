module ZQuickblox
  class Session < Request
    attr_accessor :login, :password, :config
    attr_reader :token, :session

    class << self
      def create(login=nil, password=nil, config=ZQuickblox.config)
        session = ZQuickblox::Session.new
        session.login    = login
        session.password = password
        session.config   = config
        session.execute
        return session
      end
    end

    def initialize
      super
      @uri = "/session.json"
      @method = :post
    end

    def before_request
      build_params
    end

    def execute
      super
      @session = @response_body["session"]
      @token   = @session["token"]
    end

    private

    def build_params
      @params = {
        "application_id": @config.app_id,
        "auth_key": @config.auth_key,
        "timestamp": Time.now.to_i,
        "nonce": rand(2000)
      }
      @params["user[login]"] = @login if @login
      @params["user[password]"] = @password if @password
      @params["signature"] = ZQuickblox::Signature.generate_signature(@params, @config.auth_secret)
    end
  end
end
