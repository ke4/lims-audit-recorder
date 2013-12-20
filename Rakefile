task :default => ["dev:run"]

namespace :dev do
  task :setup_env do
    ENV["LIMS_AUDITOR_ENV"] = "development"
  end

  task :run => :setup_env do
    sh "bundle exec ruby script/start_auditor.rb"
  end
end
