module ActivityTracked
    extend ActiveSupport::Concern

    include PublicActivity::Model

    included do
        #Create virtual attribute for owner
        attr_accessor :owner
        #Set owner of notification to owner virtual attribute
        tracked owner: Proc.new{ |controller, model| model.owner }, only: [:create, :update]
        before_save :check_owner
        after_destroy :delete_associated_activities
    end

    private
    def delete_associated_activities
        PublicActivity::Activity.where(trackable: self).destroy_all
    end

    #Raise error if tracking enabled but owner not set
def check_model
        raise "No owner on model" if PublicActivity.enabled? && owner == nil
    end
end
