# batch script initial snippet
require File.expand_path('../config/application', __FILE__)
Rails.application.require_environment!

site = ARGV.first || 'http://localhost:3000'
puts site
loop do
  Chat.hear_and_say site
  sleep 5
end
