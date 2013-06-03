class Routes < Sinatra::Base
  helpers do
    def current_email
      session[:email]
    end

    def authorized?
      session[:studentID] != nil
    end

    def okemail?
      ['michael.adler.a@gmail.com','pstakoff@gmail.com'].include? session[:email]
    end

    def admin?
      ['michael.adler.a', 'pstakoff'].include? session[:studentID]
    end

    def openid_consumer
      @openid_consumer ||= OpenID::Consumer.new(session,
                           OpenID::Store::Filesystem.new("tmp2/openid"))
    end

    def root_url
      request.url.match(/(^.*\/{2}[^\/]*)/)[1]
    end
  end
end
