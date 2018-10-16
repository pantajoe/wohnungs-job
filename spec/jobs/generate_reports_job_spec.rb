require 'rails_helper'

RSpec.describe GenerateReportsJob, type: :job do
  require "clockwork/test"
  describe Clockwork do
    after(:each) { Clockwork::Test.clear! }

    it "runs the job once" do
      Clockwork::Test.run(max_ticks: 1)

      expect(Clockwork::Test.ran_job?("generate_reports")).to be_truthy
      expect(Clockwork::Test.times_run("generate_reports")).to eq 1
    end

    it "runs the job every minute over the course of an hour" do
      start_time = Time.new(2017, 11, 2, 2, 0, 0)
      end_time = Time.new(2017, 11, 2, 3, 0, 0)

      Clockwork::Test.run(start_time: start_time, end_time: end_time, tick_speed: 1.minute)

      expect(Clockwork::Test.times_run("generate_reports")).to eq 1
    end
  end
end
