require_relative '../jobs/wohnungs_job'

namespace :wg do
  desc 'Run the job'
  task :job do
    WohnungsJob.perform
  end
end
