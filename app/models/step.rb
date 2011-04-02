class Step < ActiveRecord::Base
  belongs_to :user
  belongs_to :person_in_charge, :class_name => "User", 
             :foreign_key => :my_step_user_id
  belongs_to :created_user, :class_name => "User"
  belongs_to :project

  def close!
    ActiveRecord::Base::transaction do
      history = History.create(:name => name, :user => user, 
                               :project => project)
      if history.id.nil?
        raise ActiveRecord::RecordInvalid.new(self)
      end

      self.closed = true

      unless self.save
        raise ActiveRecord::RecordInvalid.new(self)
      end
    end
  end

end
