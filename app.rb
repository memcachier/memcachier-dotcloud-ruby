require 'sinatra'
require 'dalli'
require 'json'

get '/' do
  # parse environment variables.
  env = JSON.parse(File.read('/home/dotcloud/environment.json'))

  # connect to MemCachier.
  cache = Dalli::Client.new(env["MEMCACHIER_SERVERS"],
                            {:username => env["MEMCACHIER_USERNAME"],
                             :password => env["MEMCACHIER_PASSWORD"]})
  # attempt to set and get a value.  Verify the value was set
  # correctly.
  val = Time.now.to_i
  cache.set("key", val)
  cached_val = cache.get("key")
  cache_is_working = val == cached_val

  erb :index, :locals => {
    :val => val,
    :cache_is_working => cache_is_working
  }
end
