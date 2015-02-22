class HomeController < ApplicationController
  def index
   @env = ENV["API_AUTH_NAME"]
   puts ENV["API_AUTH_PASSWORD"]
    e = 3
  end
end
