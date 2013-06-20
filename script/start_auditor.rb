ENV["LIMS_AUDITOR_ENV"] = "development" unless ENV["LIMS_AUDITOR_ENV"]

require 'yaml'
require 'lims-auditor-app'
require 'logging'
require 'rubygems'

module Lims
  module AuditorApp
    env = ENV["LIMS_AUDITOR_ENV"]
    amqp_settings = YAML.load_file(File.join('config','amqp.yml'))[env]
    audit_opts = YAML.load_file(File.join('config','audit.yml'))[env]

    auditor = Auditor.new(amqp_settings, audit_opts)
    auditor.set_app_logger(Logging::LOGGER)

    Logging::LOGGER.info("Auditor has started")
    auditor.start
    Logging::LOGGER.info("Auditor has stopped")
  end
end
