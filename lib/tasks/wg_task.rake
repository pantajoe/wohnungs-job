require_relative '../wohnungs_job'

namespace :wg do
  desc 'Run the job'
  task :job, [:notification_type] do |t, args|
    require_env_keys if args[:notification_type] == :email
    WohnungsJob.perform(notification_type: args[:notification_type])
  end
end

def require_env_keys
  Dotenv.require_keys(*%w[
      SMTP_ADDRESS
      SMTP_PORT
      SMTP_DOMAIN
      SMTP_USERNAME
      SMTP_PASSWORD
      SMTP_ENABLE_STARTTLS
    ]
  )
end
