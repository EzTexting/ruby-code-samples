require 'SmsTextingAPI.rb'
require 'pp'

sms = SmsTextingAPI.new "centerft", "texting121212", :json
puts 'JSON encoding.'

puts 'Get folders'
pp sms.get_all('messages-folders')

folder = {
    'Name'        => 'Customer',
}

puts 'Create folder'
pp folder = sms.put(folder,  'messages-folders')
folder_id = folder['ID']

puts 'Get folder'
pp folder = sms.get(folder_id,  'messages-folders')

puts 'Update folder'
folder['Name'] = 'test'
folder['ID'] = folder_id
sms.put(folder,  'messages-folders')

puts 'Delete folder'
sms.del(folder_id,  'messages-folders')

puts 'Second delete. try to get error'
begin
  sms.del(folder_id,  'messages-folders')
rescue SmsTextingAPIError, NameError => e
  puts 'Get SmsTextingAPIError code:' + e.code.to_s + ', ' + e
end