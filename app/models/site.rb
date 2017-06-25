# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  name       :string
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Site < ActiveRecord::Base
	include PublicActivity::Model
	tracked owner: Proc.new{ |controller, model| controller && controller.current_user }
 
 	resourcify #This line is added to add Site model as a resource for the Rolify gem. (contributors, volunteers)
	belongs_to :country

	validates_presence_of :name
	validates_uniqueness_of :name, case_sensitive: false, scope: :country_id
  
	# default order when calling the Site model
	default_scope -> { order('created_at DESC') }
  
  # add search feature
	def self.search(search)
		where("name iLIKE ?", "%#{search}%")
	end
end