require "crecto"
require "pg"

class Idleapi::Profile < Crecto::Model
  alias Float64 = PG::Numeric | Float32
  schema "profile" do
    field :user, Int64
    field :name, String
    field :money, Int64
    field :xp, Int32
    field :pvpwins, Int64, default: 0
    field :money_booster, Int64, default: 0
    field :time_booster, Int64, default: 0
    field :luck_booster, Int64, default: 0
    field :marriage, Int64, default: 0
    field :background, String, default: "0"
    field :guild, Int64, default: 0
    field :class, Array(String), default: ["No Class", "No Class"]
    field :deaths, Int64, default: 0
    field :completed, Int64, default: 0
    field :lovescore, Int64, default: 0
    field :guildrank, String, default: "Member"
    field :backgrounds, Array(String)
    field :atkmultiply, Float64, default: 1.0
    field :defmultiply, Float64, default: 1.0
    field :crates_common, Int64, default: 0
    field :crates_uncommon, Int64, default: 0
    field :crates_rare, Int64, default: 0
    field :crates_magic, Int64, default: 0
    field :crates_legendary, Int64, default: 0
    field :luck, Float64, default: 1.0
    field :god, String, default: nil
    field :favor, Int64, default: 0
    field :race, String, default: "Human"
    field :cv, Int64, default: -1
    field :reset_points, Int64, default: 2
    field :chocolates, Int32, default: 0
    field :trickortreat, Int64, default: 0
    field :eastereggs, Int64, default: 0
  end

  def to_s(io : IO) : Nil
    io << "#<Profile:0x"
    object_id.to_s io, 16
    io << '>'
  end
end
