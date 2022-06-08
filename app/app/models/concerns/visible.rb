module Visible
  extend ActiveSupport::Concern

  VALID_STATUSES = %w[public private archived].map(&:freeze)

  included do
    validates :status, inclusion: { in: VALID_STATUSES }
  end

  class_methods do
    def visible_count
      where(status: 'public').count
    end
  end

  def archived?
    status == 'archived'
  end

  def status_adjective
    case status
    when 'public'
      'publicly'
    when 'private'
      'privately'
    else
      'somehow'
    end
  end
end
