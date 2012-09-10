require 'net/https'
require 'uri'
require 'xmlsimple'

url = URI.parse('https://app.eztexting.com/billing/credits')

#prepare post data
req = Net::HTTP::Post.new(url.path)

req.set_form_data({
    'format'=>'xml',
    'User'=>'winnie', 
    'Password'=>'the-pooh', 
    'NumberOfCredits'  => '1000',
    'CouponCode'       => 'honey2011',
    'FirstName'        => 'Winnie',
    'LastName'         => 'The Pooh',
    'Street'           => 'Hollow tree, under the name of Mr. Sanders',
    'City'             => 'Hundred Acre Woods',
    'State'            => 'New York',
    'Zip'              => '12345',
    'Country'          => 'US',
    'CreditCardTypeID' => 'Visa',
    'Number'           => '4111111111111111',
    'SecurityCode'     => '123',
    'ExpirationMonth'  => '10',
    'ExpirationYear'   => '2017'
})

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true if url.scheme == "https"  # enable SSL/TLS
http.ca_file = "cacert.pem"
http.verify_mode = OpenSSL::SSL::VERIFY_PEER
http.start {
  http.request(req) {|res|

    print res.body+"\n===================================\n"
    if res.body.length > 0
      ruObj = XmlSimple.xml_in(res.body, {'ForceArray' => false })
      print 'Status: ' + ruObj['Status'].to_s() + "\n"
      print 'Code: ' + ruObj['Code'].to_s() + "\n"
      case res
      when Net::HTTPSuccess
          print 'Credits purchased: ' + ruObj['Entry']['BoughtCredits'].to_s() + "\n"
          print 'Amount charged: ' + ruObj['Entry']['Amount'].to_s() + "\n"
          print 'Discount: ' + ruObj['Entry']['Discount'].to_s() + "\n"
          print 'Plan credits: ' + ruObj['Entry']['PlanCredits'].to_s() + "\n"
          print 'Anytime credits: ' + ruObj['Entry']['AnytimeCredits'].to_s() + "\n"
          print 'Total: ' + ruObj['Entry']['TotalCredits'].to_s() + "\n"
      else
        if !ruObj['Errors'].nil?
          errors = ruObj['Errors']['Error']
          print 'Errors: '+ (errors.kind_of?(Array) ? errors.join(', ') : errors) + "\n"
        end
      end
    end

  }
}

                    