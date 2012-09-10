require 'net/https'
require 'uri'
require 'xmlsimple'

url = URI.parse('https://app.eztexting.com/sending/messages')

#prepare post data
req = Net::HTTP::Post.new(url.path)

req.set_form_data({
    'format'=>'xml',
    'User'=>'winnie', 
    'Password'=>'the-pooh', 
    'PhoneNumbers[0]'=>'2123456785', 
    'PhoneNumbers[1]'=>'2123456786', 
    'Subject'=>'From Winnie', 
    'Message'=>'I am a Bear of Very Little Brain, and long words bother me', 
    'StampToSend'=>'1305582245', 
    'MessageTypeID'=>1
})

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true if url.scheme == "https"  # enable SSL/TLS
http.ca_file = "cacert.pem"
http.verify_mode = OpenSSL::SSL::VERIFY_PEER
http.start {
  http.request(req) {|res|

    print res.body+"\n===================================\n"

    ruObj = XmlSimple.xml_in(res.body, {'ForceArray' => false })
    print 'Status: ' + ruObj['Status'].to_s() + "\n"
    print 'Code: ' + ruObj['Code'].to_s() + "\n"
    case res
    when Net::HTTPSuccess
      print 'Message ID: ' + ruObj['Entry']['ID'].to_s() + "\n"
      print 'Subject: ' + ruObj['Entry']['Subject'].to_s() + "\n"
      print 'Message: ' + ruObj['Entry']['Message'].to_s() + "\n"
      print 'Message Type ID: ' + ruObj['Entry']['MessageTypeID'].to_s() + "\n"
      print 'Total Recipients: ' + ruObj['Entry']['RecipientsCount'].to_s() + "\n"
      print 'Credits Charged: ' + ruObj['Entry']['Credits'].to_s() + "\n"
      print 'Time To Send: ' + ruObj['Entry']['StampToSend'].to_s() + "\n"
      if !ruObj['Entry']['PhoneNumbers'].nil?
        numbers = ruObj['Entry']['PhoneNumbers']['PhoneNumber']
        print 'Phone Numbers: ' + (numbers.kind_of?(Array) ? numbers.join(', ') : numbers) + "\n"
      end
      if !ruObj['Entry']['LocalOptOuts'].nil?
        numbers = ruObj['Entry']['LocalOptOuts']['PhoneNumber']
        print 'Locally Opted Out Numbers: '+ (numbers.kind_of?(Array) ? numbers.join(', ') : numbers) + "\n"
      end
      if !ruObj['Entry']['GlobalOptOuts'].nil?
        numbers = ruObj['Entry']['GlobalOptOuts']['PhoneNumber']
        print 'Globally Opted Out Numbers: '+ (numbers.kind_of?(Array) ? numbers.join(', ') : numbers) + "\n"
      end
    else
      if !ruObj['Errors'].nil?
        errors = ruObj['Errors']['Error']
        print 'Errors: '+ (errors.kind_of?(Array) ? errors.join(', ') : errors) + "\n"
      end
    end
  
  }
}

              