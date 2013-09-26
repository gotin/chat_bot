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
  
  def initialize(user, yourNick, site)
    @user = user
    @user.client = self
    @yourNick = yourNick
    @site = site
    greeting = @user.settings["joining_message"]
    puts greeting if greeting
  end
  
  def start_loop
    loop do
      chat = Chat.hear @site
      line = chat['text']
      speaker = chat['name']
      puts "#{speaker}: #{line}"
      if line.empty?
        @user.onSilent
      elsif @yourNick
        @user.onOtherSpeak(@yourNick, line, speaker == @yourNick)
      elsif line =~ /^(.+?) (.*)$/
        @user.onOtherSpeak($1, $2)
      else
        $stderr.print("Error\n")
      end
      sleep 5
    end
  end
  
  #補助情報を出力
  def outputInfo(s)
    Chat.say @yourNick, "(#{s})"
  end
  
  #発言する
  def speak(s)
    Chat.say @yourNick, s
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

nick = 'bot'
opt.on('-n nickname') do |v|
  nick = v
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
client = ChatClient.new(Reudy.new(directory,{},db,mecab),nick,site) #標準入出力用ロイディを作成
client.start_loop

end


