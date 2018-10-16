class Incident < ApplicationRecord
  FILTER_OPTIONS = %w[all with without_pm].freeze
  EDITABLE_ATTRIBUTES = %i[what_happened which_server impacts solution
                           realized_error future_approach].freeze

  validates :time_from, :time_to, :what_happened, :which_server, presence: true
  validates :which_server, length: {maximum: 140}
  validates :what_happened, :realized_error, :solution, :impacts,
            :future_approach, length: {maximum: 300}

  belongs_to :project, inverse_of: :incidents
  has_many :incident_logs, inverse_of: :incident, dependent: :destroy

  scope :without_pm, -> { where(what_happened: nil) }
  scope :with, -> { where('what_happened IS NOT NULL') }
  scope :closed_without, -> { without_pm.closed }
  scope :closed, -> { where.not(time_to: nil) }
  scope :opened, -> { where(time_to: nil) }
  scope :in_time_range, ->(from, to) do
    where('time_from >= (?) AND time_to <= (?)', from, to)
  end

  def downtime_in_minutes
    TimeDifference.between(time_from, time_to).in_minutes
  end

  def with_post_mortem?
    what_happened.present?
  end

  def clear!
    self.what_happened = nil
    self.which_server = nil
    self.realized_error = nil
    self.impacts = nil
    self.solution = nil
    self.future_approach = nil

    save(validate: false)
  end
end
