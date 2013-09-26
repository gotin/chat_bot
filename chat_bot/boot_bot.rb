# -*- coding: utf-8 -*-
# batch script initial snippet
require File.expand_path('../config/application', __FILE__)
Rails.application.require_environment!


# loop do
#   Chat.hear_and_say site
#   sleep 5
# end


$REUDY_DIR= "./lib/reudy" unless defined?($REUDY_DIR)

require 'optparse'
require $REUDY_DIR+'/bot_irc_client'
require $REUDY_DIR+'/reudy'
require $REUDY_DIR+'/reudy_common'

trap(:INT){ exit }

module Gimite

class ChatClient
  
  include(Gimite)
  
  def initialize(user, bot_name, site)
    @user = user
    @user.client = self
    @bot_name = bot_name || 'bot'
    @site = site
    @pre_time = nil
    greeting = @user.settings["joining_message"]
    puts greeting if greeting
  end
  
  def start_loop
    loop do
      chat = Chat.hear @site
      line = chat['text']
      speaker = chat['name']
      time = chat['created_at']
      if line.empty?
        @user.onSilent
      elsif @bot_name != speaker && time != @pre_time
        @user.onOtherSpeak speaker, line
      else
        # nothing to do here
      end
      @pre_time = time
      sleep 5
    end
  end
  
  #補助情報を出力
  def outputInfo(s)
    Chat.say @bot_name, "(#{s})"
  end
  
  #発言する
  def speak(s)
    Chat.say @bot_name, s
  end
end

opt = OptionParser.new

directory = 'public'
opt.on('-d DIRECTORY') do |v|
  directory = v
end

db = 'pstore'
opt.on('--db DB_TYPE') do |v|
  db = v
end

bot_name = 'bot'
opt.on('-n botname') do |v|
  bot_name = v
end

mecab = nil
opt.on('-m','--mecab') do |v|
  mecab = true
end

site = 'http://localhost:3000'
opt.on('-s', '--site') do |v|
  site = v
end

opt.parse!(ARGV)

puts "target site: #{site}"

# STDOUT.sync = true
client = ChatClient.new(Reudy.new(directory,{},db,mecab), bot_name, site) #標準入出力用ロイディを作成
client.start_loop

end


