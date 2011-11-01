module FayeShard

  class Shard

    attr_accessor :configuration

    #  Creates a shard instance and assigns the config to it.
    #
    #  * <tt>config</tt>:: Config to use.
    #
    def initialize(config)
      self.configuration = config.with_indifferent_access
    end

    #  Returns URL for client.
    #
    #  * <tt>https</tt>:: Specifies whether to use SSL connection or not
    #
    def url(https = false)
      secured = (configuration['secured'] || false) & https
      port = secured ? configuration["secured_port"] : configuration["port"]
      "http#{secured ? 's' : ''}://#{configuration["host"]}:#{port}/faye"
    end

    #  Returns default client JS url
    #
    def js_url
      url + '.js'
    end

    #  Local url, needed for RoR <-> Faye communication
    #
    def local_url
      host = configuration["local_host"] || configuration["host"]
      "http://#{host}:#{configuration["port"]}/faye"
    end

    #  Pushes data to a Faye shard
    #
    #  * <tt>channel</tt>:: User's channel
    #  * <tt>data</tt>::    Data to push
    #  * <tt>ext</tt>::     Faye extensions, eg. auth_token
    #
    def push(channel, data, ext = {})
      uri = URI.parse(self.local_url)
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Post.new uri.path
      req.set_form_data('message' => {'channel' => channel, 'data' => data, 'ext' => ext}.to_json)
      http.request req
    end

  end

end
