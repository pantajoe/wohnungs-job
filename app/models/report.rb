class Report < ApplicationRecord
  validates :file, :created_on, :month, presence: true
  belongs_to :project, inverse_of: :reports

  def month_in_minutes
    TimeDifference.between(month.beginning_of_month, month.end_of_month + 1.day).in_minutes
  end

  def incidents
    time_range = month.all_month
    project.incidents.closed.where(time_to: time_range)
           .or(project.incidents.closed.where(time_from: time_range))
  end

  def monthly_code_cares
    time_range = month.all_month
    project.code_cares.where(startdate: time_range)
           .or(project.code_cares.where(enddate: time_range))
            .where.not(enddate: nil)
  end

  def availability
    ((month_in_minutes - incidents.map(&:downtime_in_minutes).sum) / month_in_minutes) * 100
  end
end
