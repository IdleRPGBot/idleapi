require "dotenv"
Dotenv.load

require "kemal"
require "redis"
require "crecto"
require "log"

require "./idleapi/**"
require "./helpers"

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

    adv_ttl = RedisDB.ttl "adv:#{id}"
    level = xp_to_level user.xp!

    if adv_ttl == -2
      adventure = nil
    else
      adventure_num = RedisDB.get "adv:#{id}"
      adventure_left = adv_ttl - 259200
      adventure = {"done": adventure_left <= 0, "time_left": adventure_left, "number": adventure_num.not_nil!.to_i}
    end

    env.response.content_type = "application/json"
    {"character_name": user.name, "level": level,
     "adventure": adventure, "race": user.race,
     "class": user.class}.to_json
  end

  Kemal.run ENV["PORT"].to_i
end
