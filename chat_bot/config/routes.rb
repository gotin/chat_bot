ChatBot::Application.routes.draw do
  get 'hear_and_say/:site' => 'chats#hear_and_say'
end
