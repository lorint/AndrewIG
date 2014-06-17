class HomeController < ApplicationController
	before_action :set_acc_code, only: [:feed, :search]

	def index
	end

	def instagram
		# Find the access token
		res = HTTParty.post("https://instagram.com/oauth/access_token/",
		 {body:{client_id: "*** your client ID ***",
		  client_secret: "*** your client secret ***",
		  grant_type:'authorization_code',
		  redirect_uri:'http://localhost:3000/instagram',
		  code: params[:code]}})
		redirect_to feed_path(acc_token: res.parsed_response["access_token"])
	end

	def feed
		# Show a feed of pictures
		if params[:user_id] # For a given user
			@feed = HTTParty.get("https://api.instagram.com/v1/users/" + URI::escape(params[:user_id]) + "/media/recent?access_token=" +
			 @acc_token)
		else	# This user's folks they follow
			@feed = HTTParty.get("https://api.instagram.com/v1/users/self/feed?access_token=" +
			 @acc_token)
		end
	end

	def search
		# Search users
		@url = "https://api.instagram.com/v1/users/search?q=" + URI::escape(params[
			:search][:query]) + "&access_token=" +
		 params[:acc_token]
		@results = HTTParty.get(@url)
	end

	def set_acc_code
		@acc_token = params[:acc_token]
	end
end
