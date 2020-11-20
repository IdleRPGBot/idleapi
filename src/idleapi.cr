require "dotenv"
Dotenv.load

require "kemal"
require "redis"
require "crecto"
require "log"

require "./idleapi/**"

module Idleapi
  if ENV["IDLEAPI_ENV"]? == "dev"
    Log.setup "*", :debug
  end

  Query   = Crecto::Repo::Query
  RedisDB = Redis::PooledClient.new url: "redis://#{ENV["REDIS_HOST"]}:#{ENV["REDIS_PORT"]}#{ENV["REDIS_PASS"]? ? "?password=#{ENV["REDIS_PASS"]}" : ""}"

  get "/" do |env|
    "uwu~ welcome to my webby sewvew~~ teehee~!"
  end

  get "/user" do |env|
    begin
      id = env.params.query["id"].to_i64
    rescue ex
      Log.debug { "Exception:\n#{ex}" }
      halt env, status_code: 400
    end

    begin
      user = Repo.get_by! Profile, user: id
    rescue ex
      Log.debug { "Exception:\n#{ex}" }
      halt env, status_code: 404
    end

    adv = RedisDB.pttl "adv:#{id}"

    env.response.content_type = "application/json"
    {"character_name": user.name, "level": user.xp,
     "adventure_time_left": adv < 0 ? 0 : adv, "race": user.race,
     "class": user.class}.to_json
  end

  Kemal.run ENV["PORT"].to_i
end
