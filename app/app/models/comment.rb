class Comment < ApplicationRecord
  belongs_to :article

  VALID_STATUSES = %w[public private archived].map(&:freeze)
  validates :status, inclusion: { in: VALID_STATUSES }

  def archived?
    status == 'archived'
  end
end
