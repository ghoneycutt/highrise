require 'sinatra'
require 'json'
require 'mysql2'

CONFIG    = JSON.parse(File.read('config/highrise.json'))
DB_CONFIG = JSON.parse(File.read('config/database.json'))
DOCS_URI  ='https://github.com/ghoneycutt/highrise/blob/master/README.md'
ENV_PATH  = CONFIG['env_path']

client = Mysql2::Client.new(DB_CONFIG)

before do
  content_type 'application/json'
end

env = ENV['RACK_ENV']

get '/' do
  erb :index
end

get '/doc' do
  redirect DOCS_URI, 301
end

get '/config' do
  CONFIG.to_json
end

get '/environments' do
  h = {}
  results = []
  client.query('SELECT * FROM highrise').each do |row|
    results << row.merge(:href => "/environment/#{row['id']}",
      :meta => {
        :sub_resources => [
          :create => { :href => '/environments/create', :description => 'Create an environment' }
        ]
      }
    )
  end

  h['environments'] = results
  h.to_json
end

get '/environment/:id' do
  results = []
  id = client.escape(params[:id])
  client.query("SELECT * FROM highrise where id = #{id}").each do |row|
    results << row.merge(:href => "/environments/#{row['id']}",
      :meta => {
        :sub_resources => [
          :update => { :href => "/environment/#{row['id']}/update", :description => 'Update environment data' },
          :delete => { :href => "/environment/#{row['id']}/delete", :description => 'Delete environment' },
          :keys   => { :href => "/environment/#{row['id']}/keys",   :description => 'Show environment public SSH key'}
        ]
      }
    )
  end

  result = results.first.to_json
  if result == 'null'
    404
  else
    result
  end
end

get '/environment/:id/keys' do
  id = params[:id]
  fh = "#{ENV_PATH}/#{id}/.ssh/id_rsa.pub"
  h = {}

  if File.readable?(fh)
    contents = File.read(fh).chomp
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
post '/environments/create' do
  name = client.escape(params[:name])
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
        '#{client.escape(data['puppetfile_repo'])}',
        '#{client.escape(data['puppetfile_ref'])}',
        '#{client.escape(data['hiera_repo'])}',
        '#{client.escape(data['hiera_ref'])}',
        '#{client.escape(data['manifests_repo'])}',
        '#{client.escape(data['manifests_ref'])}',
        '#{client.escape(data['primary_name'])}',
        '#{client.escape(data['primary_email'])}',
        '#{client.escape(data['secondary_name'])}',
        '#{client.escape(data['secondary_email'])}');
    "
    )
  else
    403
  end
end
