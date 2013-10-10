require 'sinatra'
require 'json'
require 'mysql2'
require 'rest_client'

CONFIG_FILE='config/highrise.json'

fh_config = open(CONFIG_FILE)
parsed_config = JSON.parse(fh_config.read)
env_path = parsed_config['env_path']

client = Mysql2::Client.new(:host     => "localhost",
                            :username => "highrise",
                            :password => "puppet",
                            :database => 'highrise')

before do
  content_type 'application/json'
end

env = ENV["RACK_ENV"]

get "/" do
  "Hello World!"
end

get '/config' do
  fh_config = open(CONFIG_FILE)
  json_config = fh_config.read
end

get '/environments' do
  results = Array.new
  client.query("SELECT * FROM highrise").each(:symbolize_keys => true) do |row|
    results << row[:name]
  end

  results.to_json
end

get "/environment/id/:id" do
  results = Array.new
  client.query("SELECT * FROM highrise where id='#{params[:id]}'").each(:symbolize_keys => true) do |row|
    results << row[:name]
  end

  h = {}
  h['id'] = results[0]

  if results.empty?
    404
  else
    h.to_json
  end
end

get "/environment/:name" do
  results = Array.new
  name = params[:name]
  client.query("SELECT * FROM highrise where name='#{name}'").each do |row|
    results << row
  end

  result = results[0].to_json
  if result == 'null'
    404
  else
    result
  end
end

get "/environment/:env/key" do
  env = params[:env]
  h = {}
  fh = "#{env_path}/#{env}/.ssh/id_rsa.pub"

  if File.readable?(fh)
    contents = File.open(fh,'r').read.chomp
    key = contents.split[1]
    h['key'] = key
    h.to_json
  else
    404
  end
end


post "/environment/:env/create" do
  env = params[:env]
  results = Array.new
  client.query("SELECT * FROM highrise where name='gh'").each(:symbolize_keys => true) do |row|
#    if row[:name] == env
#      #results << row[:name]
#    end
#    if results.empty?
#      print "free"
#    else
#      403
#    end
  end
end
