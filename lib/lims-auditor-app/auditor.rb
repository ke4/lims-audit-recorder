require 'lims-busclient'
require 'logger'

module Lims
  module AuditorApp
    # The auditor consumer reads all messages on the
    # bus. It stores contents of the messages in a log file.
    # The log rotation can be set in the audit config file.
    class Auditor
      include Lims::BusClient::Consumer

      attribute :queue_name, String, :required => true, :writer => :private
      attribute :audit_file, String, :required => true, :writer => :private
      attribute :log_app, Object, :required => true, :writer => :private, :reader => :private

      # @param [Hash] amqp_settings
      # @param [Hash] audit_opts
      def initialize(amqp_settings, audit_opts)
        @queue_name = amqp_settings["queue_name"]
        @exchange_name = amqp_settings["exchange_name"]
        @audit_file = audit_opts["audit_file"]
        @audit_log_age = audit_opts["audit_log_age"]

        consumer_setup(amqp_settings)
        init_audit_logger
        set_queue
      end

      # @param [Logger] logger
      def set_app_logger(logger)
        @log_app = logger
      end

      private

      # Adds the listener to the queue
      # It is processing every message and write the content to a file.
      def set_queue
        self.add_queue(queue_name) do |metadata, payload|
          log_app.debug("Processing message with routing key: '#{metadata.routing_key}' and payload: #{payload}")

          @audit_log.info(processing_message(metadata, payload))
          metadata.ack
        end
      end

      # Initialize a log file for audit.
      # The rotation of the log file can be set in the config file.
      def init_audit_logger
        unless File.exists?(@audit_file)
          dir = File.dirname(@audit_file)

          unless File.directory?(dir)
            FileUtils.mkdir_p(dir)
          end

          File.new(@audit_file, 'w')
        end

        @audit_log = Logger.new(@audit_file, @audit_log_age)
        @audit_log.level = Logger::INFO
        @audit_log.formatter = proc do |severity, datetime, progname, msg|
          "#{msg}\n"
        end
      end

      # Writes the message metadata and payload into a file.
      # Also adds the routing key and the content-type to the file.
      # Appends the message to the end of the file.
      def processing_message(metadata, payload)
        {
          "exchange"          => @exchange_name,
          "routing_key"       => metadata.routing_key,
          "payload"           => payload,
          "payload_encoding"  => "string"
        }
      end
    end
  end
end
