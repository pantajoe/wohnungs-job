class Project < ApplicationRecord
  extend FriendlyId

  friendly_id :repo_name, use: :slugged

  validate :presence_of_customer_title
  validate :uniqueness_of_appsignal_id
  validates :title, :repo_name, :customer, :email, presence: true
  validates :repo_name, uniqueness: true
  validates_email_format_of :email, message: 'Bitte E-Mail im Format: customer@example.com'

  has_many :incidents, dependent: :destroy, inverse_of: :project
  has_many :reports, dependent: :destroy, inverse_of: :project
  has_many :sentry_errors, dependent: :destroy, inverse_of: :project
  has_many :uploads, dependent: :destroy, inverse_of: :project
  has_many :performances, dependent: :destroy, inverse_of: :project
  has_many :code_cares, dependent: :destroy, inverse_of: :project
  has_many :gemfiles, dependent: :destroy, inverse_of: :project

  scope :not_archived, -> { where(archived: false) }

  def archived?
    archived
  end

  private

  def should_generate_new_friendly_id?
    slug.blank? || repo_name_changed?
  end

  def uniqueness_of_appsignal_id
    if appsignal_id.present?
      errors.add(:appsignal_id, :taken, 'Die Appsignal ID ist bereits vergeben.') if Project.where.not(id: id).where(appsignal_id: appsignal_id).exists?
    end
  end

  def presence_of_customer_title
    unless customer.nil?
      errors.add(:customer, :missing_title, "Bitte geben sie einen Namenszusatz \'Herr/Frau\' an.") unless customer.starts_with?('Herr', 'Frau')
    end
  end
end
