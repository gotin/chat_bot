# require 'active_resource'
class Chat < ActiveResource::Base
  self.site = 'http://localhost:3000'

  def self.hear_and_say site = 'http://localhost:3000'
    self.site = site if site.present?
    chat = get :last_one
    name = chat && chat['name']
    if name.present? && name != 'bot'
      new(name: 'bot', text: "Hello, #{name}-san").save 
    end
  end
  # attr_accessible :name, :text
end
