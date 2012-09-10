require 'net/https'
require 'uri'
require 'json'

url = URI.parse('https://app.eztexting.com/sending/messages')

#prepare post data
req = Net::HTTP::Post.new(url.path)

req.set_form_data({
    'format'=>'json',
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
    ruObj = JSON.parse(res.body)
    print 'Status: ' + ruObj['Response']['Status'].to_s() + "\n"
    print 'Code: ' + ruObj['Response']['Code'].to_s() + "\n"
    case res
    when Net::HTTPSuccess
      print 'Message ID: ' + ruObj['Response']['Entry']['ID'].to_s() + "\n"
      print 'Subject: ' + ruObj['Response']['Entry']['Subject'].to_s() + "\n"
      print 'Message: ' + ruObj['Response']['Entry']['Message'].to_s() + "\n"
      print 'Message Type ID: ' + ruObj['Response']['Entry']['MessageTypeID'].to_s() + "\n"
      print 'Total Recipients: ' + ruObj['Response']['Entry']['RecipientsCount'].to_s() + "\n"
      print 'Credits Charged: ' + ruObj['Response']['Entry']['Credits'].to_s() + "\n"
      print 'Time To Send: ' + ruObj['Response']['Entry']['StampToSend'].to_s() + "\n"
      if !ruObj['Response']['Entry']['PhoneNumbers'].nil?
        print 'Phone Numbers: ' + ruObj['Response']['Entry']['PhoneNumbers'].join(', ') + "\n"
      end
      if !ruObj['Response']['Entry']['LocalOptOuts'].nil?
        print 'Locally Opted Out Numbers: ' + ruObj['Response']['Entry']['LocalOptOuts'].join(', ') + "\n"
      end
      if !ruObj['Response']['Entry']['GlobalOptOuts'].nil?
        print 'Globally Opted Out Numbers: ' + ruObj['Response']['Entry']['GlobalOptOuts'].join(', ') + "\n"
      end
    else
      if !ruObj['Response']['Errors'].nil?
        print 'Errors: ' + ruObj['Response']['Errors'].join(', ') + "\n"
      end
    end
  }
}

              