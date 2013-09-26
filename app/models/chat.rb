class Chat < ActiveRecord::Base
  def self.last_one
    order('updated_at desc').first
  end
end
