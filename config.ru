require 'rubygems'
require 'bundler'

Bundler.require

class WebDirMiddleware
	def initialize(app)
		@app = app
	end

	def call(env)
		env["SCRIPT_NAME"] = "/sandwiches"
		puts env.inspect
		@app.call(env)
	end
end

use WebDirMiddleware

#set :public_folder, Proc.new { File.join(root, "public") }

require './controllers.rb'
require './helpers.rb'
require './models.rb'
#require './seed.rb'

run Routes
