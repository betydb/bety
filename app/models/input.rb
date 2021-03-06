class Input < ActiveRecord::Base

  include Overrides

  extend SimpleSearch
  SEARCH_INCLUDES = %w{ site }
  SEARCH_FIELDS = %w{ sites.sitename inputs.name inputs.start_date inputs.end_date inputs.notes inputs.created_at inputs.updated_at }

  has_and_belongs_to_many :runs
  has_and_belongs_to_many :variables
  has_many :likelihoods
  has_many :files, :as => :container, :class_name => 'DBFile'
  #has_one :input_file, :foreign_key => 'file_id'
  belongs_to :site
  belongs_to :user
  belongs_to :format

  #Self reference
  has_many :children, :class_name => "Input"
  belongs_to :parent, :class_name => "Input", :foreign_key => "parent_id"

  accepts_nested_attributes_for :site

  validates_presence_of     :site_id

  scope :sorted_order, lambda { |order| order(order).includes(SEARCH_INCLUDES) }
  scope :search, lambda { |search| where(simple_search(search)) }

  def to_s
    "#{name} #{site}"
  end
  def select_default
    "#{id}: #{self}"
  end

  #Columns we search when referenced from another model
  #Fields present in 'select_default'
  def self.search_columns
    return ["inputs.id"]
  end

end
