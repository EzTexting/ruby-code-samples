require 'net/https'
require 'uri'
require 'xmlsimple'

url = URI.parse('https://app.eztexting.com')

#prepare post data
req = Net::HTTP::Get.new('/billing/credits/get?format=xml&User=winnie&Password=the-pooh')

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
      print 'Plan credits: ' + ruObj['Entry']['PlanCredits'].to_s() + "\n"
      print 'Anytime credits: ' + ruObj['Entry']['AnytimeCredits'].to_s() + "\n"
      print 'Total: ' + ruObj['Entry']['TotalCredits'].to_s() + "\n"
    else
      if !ruObj['Errors'].nil?
        errors = ruObj['Errors']['Error']
        print 'Errors: '+ (errors.kind_of?(Array) ? errors.join(', ') : errors) + "\n"
      end
    end

  }
}

