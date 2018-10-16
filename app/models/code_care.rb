class CodeCare < ApplicationRecord
  belongs_to :project, inverse_of: :code_cares
end
