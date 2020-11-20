require "crecto"
require "pg"

module Idleapi::Repo
  extend Crecto::Repo

  config do |conf|
    conf.adapter = Crecto::Adapters::Postgres
    # conf.uri = "postgresql://#{ENV["PG_USER"]}:#{ENV["PG_PASS"]}@#{ENV["PG_HOST"]}:#{ENV["PG_PORT"]}/#{ENV["PG_DB"]}"
    conf.uri = "postgresql://#{ENV["PG_USER"]}#{ENV["PG_PASS"]? ? ":#{ENV["PG_PASS"]}" : ""}@#{ENV["PG_HOST"]}:#{ENV["PG_PORT"]}/#{ENV["PG_DB"]}"
  end
end
