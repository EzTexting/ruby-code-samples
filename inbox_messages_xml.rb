require 'SmsTextingAPI.rb'
require 'pp'

sms = SmsTextingAPI.new "centerft", "texting121212", :xml
puts 'XML encoding.'

puts 'Get messages'
params = {
    'sortBy' => 'Message',
}
messages = sms.get_all('incoming-messages', params)
pp messages

message_id = messages[0]['ID']
message_id2 = messages[1]['ID']

puts 'Move messages to folder'
sms.move_message_to_folder([message_id, message_id2],  77)

puts 'Get message'
pp message = sms.get(message_id2,  'incoming-messages')

puts 'Delete message'
sms.del(message_id,  'incoming-messages')

puts 'Second delete. try to get error'
begin
  sms.del(message_id,  'incoming-messages')
rescue SmsTextingAPIError, NameError => e
  puts 'Get SmsTextingAPIError code:' + e.code.to_s + ', ' + e
end