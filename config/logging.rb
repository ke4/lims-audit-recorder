require 'logger'

module Lims
  module AuditorApp
    module Logging

      def self.logger_instance
        ::Logger.new(STDOUT) 
      end

      LOGGER = logger_instance
    end
  end
end
