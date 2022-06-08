module Visible
  extend ActiveSupport::Concern

  VALID_STATUSES = %w[public private archived].map(&:freeze)

  included do
    validates :status, inclusion: { in: VALID_STATUSES }
  end

  def archived?
    status == 'archived'
  end
end
