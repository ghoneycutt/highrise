require 'sinatra'
require 'json'
require 'mysql2'

CONFIG_FILE='config/highrise.json'
DOCS_URI='https://github.com/ghoneycutt/highrise/blob/master/README.md'

fh_config = open(CONFIG_FILE)
parsed_config = JSON.parse(fh_config.read)
ENV_PATH = parsed_config['env_path']

client = Mysql2::Client.new(:host     => 'localhost',
                            :username => 'highrise',
                            :password => 'puppet',
                            :database => 'highrise')

before do
  content_type 'application/json'
end

env = ENV['RACK_ENV']

get '/' do
  redirect DOCS_URI, 301
end

get '/config' do
  fh_config = open(CONFIG_FILE)
  json_config = fh_config.read
end

get '/environments' do
  h = {}
  results = Array.new
  client.query('SELECT * FROM highrise').each(:symbolize_keys => true) do |row|
    results << row[:name]
  end

  h['environments'] = results
  h.to_json
end

get '/environment/:name' do
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

get '/environment/:name/key' do
  name = params[:name]
  fh = "#{ENV_PATH}/#{name}/.ssh/id_rsa.pub"
  h = {}

  if File.readable?(fh)
    contents = File.open(fh,'r').read.chomp
    key = contents.split[1]
    h['key'] = key
    h.to_json
  else
    404
  end
end

# This should
#   * create entry in database
#   * read yaml file for environments file and add :name to array of environments on disk
#   * trigger puppet run with mcollective
post '/environment/:name/create' do
  name = params[:name]
  # copy and paste from route
  #get '/environment/:name'
  # duplicating code means i'm doing this wrong :(
  results = Array.new
  client.query("SELECT * FROM highrise where name='#{name}'").each do |row|
    results << row
  end

  result = results[0].to_json
  if result == 'null'

    data = JSON.parse request.body.read
    insert_results = client.query(
      "INSERT into highrise
      ( name,
        puppetfile_repo,
        puppetfile_ref,
        hiera_repo,
        hiera_ref,
        manifests_repo,
        manifests_ref,
        primary_name,
        primary_email,
        secondary_name,
        secondary_email)
      VALUES
      ( '#{name}',
        '#{data['puppetfile_repo']}',
        '#{data['puppetfile_ref']}',
        '#{data['hiera_repo']}',
        '#{data['hiera_ref']}',
        '#{data['manifests_repo']}',
        '#{data['manifests_ref']}',
        '#{data['primary_name']}',
        '#{data['primary_email']}',
        '#{data['secondary_name']}',
        '#{data['secondary_email']}');
    "
    )
  else
    403
  end
end
