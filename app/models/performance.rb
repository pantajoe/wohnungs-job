class Performance < ApplicationRecord
  belongs_to :project, inverse_of: :performances
end
