class Posterior < ActiveRecord::Base

  include Overrides

  extend SimpleSearch
  SEARCH_INCLUDES = %w{ pft }
  SEARCH_FIELDS = %w{ pfts.name posteriors.filename }

  has_and_belongs_to_many :runs
  has_many :children, :class_name => "Posterior", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Posterior"
  belongs_to :pft

  validates_presence_of     :pft_id
  validates_presence_of     :filename

  scope :sorted_order, lambda { |order| order(order).includes(SEARCH_INCLUDES) }
  scope :search, lambda { |search| where(simple_search(search)) }

  comma do
    id
    pft_id
    filename
    parent_id
    created_at
    updated_at
  end
  def pft_createdat
    "#{pft} #{created_at.to_s(:db)}"
  end
  def to_s
    pft_createdat
  end
  def select_default
    "#{id}: #{self}"
  end

  #Columns we search when referenced from another model
  #Fields present in 'select_default'
  def self.search_columns
    return ["posteriors.id", "posteriors.created_at"]
  end
end
