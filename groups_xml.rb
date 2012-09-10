require 'SmsTextingAPI.rb'
require 'pp'

sms = SmsTextingAPI.new "demouser", "password", :xml
puts 'XML encoding.'

puts 'Get contacts'
params = {
    'source'        => 'upload',
    'optout'        => 'false',
    'group'         => 'Honey Lovers',
    'sortBy'        => 'PhoneNumber',
    'sortDir'       => 'asc',
    'itemsPerPage'  => '10',
    'page'          => '3'
}
pp sms.get_all(:contacts, params)

contact = {
    'PhoneNumber' => '2123456985',
    'FirstName'   => 'Piglet',
    'LastName'    => 'P.',
    'Email'       => 'piglet@small-animals-alliance.org',
    'Note'        => 'It is hard to be brave, when you are only a Very Small Animal.',
    'Groups'   => ['Friends', 'Neighbors']
}

puts 'Create contact'
pp contact = sms.put(contact,  :contacts)

puts 'Get contact'
pp contact = sms.get(contact['ID'],  :contacts)

puts 'Update contact'
contact['LastName'] = 'test'
pp contact = sms.put(contact,  :contacts)

puts 'Delete contact'
sms.del(contact['ID'],  :contacts)

puts 'Second delete. try to get error'
begin
  sms.del(contact['ID'],  :contacts)
rescue SmsTextingAPIError, NameError => e
  puts 'Get SmsTextingAPIError code:' + e.code.to_s + ', ' + e  
end
