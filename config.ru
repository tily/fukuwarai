require_relative "./app"
configure { set :server, :puma }
run Sinatra::Application
