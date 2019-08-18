# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

run Rails.application

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  [username, password] == [ENV.fetch("USERNAME", "ipman2019"), ENV.fetch("PASSWORD", "ipman2019")]
end
