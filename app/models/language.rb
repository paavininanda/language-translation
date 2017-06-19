# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class Language < ActiveRecord::Base
include PublicActivity::Model
tracked owner: Proc.new{ |controller, model| controller && controller.current_user }
 
 def self.search(search)
    where("name iLIKE ?", "%#{search}%") 
  end
 
 has_many :articles, dependent: :destroy

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  def self.options_for_select
  order('LOWER(name)').map { |e| [e.name, e.id] }
end

end
