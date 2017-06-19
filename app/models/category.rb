# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
include PublicActivity::Model
tracked owner: Proc.new{ |controller, model| controller && controller.current_user }

def self.search(search)
    where("name iLIKE ?", "%#{search}%")
  end
  has_many :articles
  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false
  # default order when calling the Category model
  default_scope -> { order('created_at DESC') }
  def self.options_for_select
  order('LOWER(name)').map { |e| [e.name, e.id] }
end

end
