require 'net/https'
require 'uri'
require 'json'

url = URI.parse('https://app.eztexting.com/billing/credits')

#prepare post data
req = Net::HTTP::Post.new(url.path)

req.set_form_data({
    'format'=>'json',
    'User'=>'demo', 
    'Password'=>'texting121212', 
    'NumberOfCredits'  => '1000',
    'CouponCode'       => 'honey2011',
    'StoredCreditCard' => '1111'
})

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true if url.scheme == "https"  # enable SSL/TLS
http.ca_file = "cacert.pem"
http.verify_mode = OpenSSL::SSL::VERIFY_PEER
http.start {
  http.request(req) {|res|

    print res.body+"\n===================================\n"

    if res.body.length > 0
      ruObj = JSON.parse(res.body)
      print 'Status: ' + ruObj['Response']['Status'].to_s() + "\n"
      print 'Code: ' + ruObj['Response']['Code'].to_s() + "\n"
      case res
      when Net::HTTPSuccess
        print 'Credits purchased: ' + ruObj['Response']['Entry']['BoughtCredits'].to_s() + "\n"
        print 'Amount charged: ' + ruObj['Response']['Entry']['Amount'].to_s() + "\n"
        print 'Discount: ' + ruObj['Response']['Entry']['Discount'].to_s() + "\n"
        print 'Plan credits: ' + ruObj['Response']['Entry']['PlanCredits'].to_s() + "\n"
        print 'Anytime credits: ' + ruObj['Response']['Entry']['AnytimeCredits'].to_s() + "\n"
        print 'Total: ' + ruObj['Response']['Entry']['TotalCredits'].to_s() + "\n"
      else
        if !ruObj['Response']['Errors'].nil?
          print 'Errors: ' + ruObj['Response']['Errors'].join(', ') + "\n"
        end
      end
    end

  }
}
