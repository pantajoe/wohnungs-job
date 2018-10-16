namespace :wg do
  task job: :environment do
    WohnungsJob.perform
  end
end
