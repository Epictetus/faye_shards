require 'faye_shard/shard'
require 'faye_shard/user/faye'

class FayeShards

  class << self

    #  Returns configuration for current Rails environment.
    #
    #  * <tt>env</tt>:: Rails environment, defaults to +Rails.env+.
    #
    def config
      @config ||= YAML.load(File.read(Rails.root.to_s + "/config/faye.yml"))
      @config[Rails.env]
    end

    #  Returns the object which represents a connection to a specific shard. The object is effectively
    #  an instance of +FayeShards::Shard+ class which can be found in this gem.
    #
    #  * <tt>id</tt>:: Id (an integer, string of whatever) to perform sharding based on.
    #
    def shard(id)
      @shards ||= {}

      shard_configs = config["shards"]

      @shards[id % shard_configs.size] ||= FayeShard::Shard.new(shard_configs[id % shard_configs.size])
    end

    #  Returns all configured shards
    #
    def all_shards
      @all_shards ||= config["shards"].map{ |shard_config| FayeShard::Shard.new(shard_config) }
    end

  end

end
