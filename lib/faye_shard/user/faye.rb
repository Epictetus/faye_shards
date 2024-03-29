module FayeShard

  module User

    # Module which is designed to be included to User model.
    # It provides helper method to get token and method to push data to user's shard.
    #
    module Faye

      #  Returns channel for a user, which is basically /ID
      #
      def faye_channel
        "/#{self.id}"
      end

      #  Pushes data to User's Faye shard
      #
      #  * <tt>data</tt>::    Data to push
      #  * <tt>ext</tt>::     Faye extensions, eg. auth_token
      #
      def push_to_faye(data, ext = {})
        faye_shard.push(self.faye_channel, data, ext)
      end

      # Returns shard for this user
      #
      def faye_shard
        FayeShards.shard(self.id)
      end

    end

  end

end
