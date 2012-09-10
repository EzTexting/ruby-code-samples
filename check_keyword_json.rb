require 'net/https'
require 'uri'
require 'json'

url = URI.parse('https://app.eztexting.com')

req = Net::HTTP::Get.new('/keywords/new?format=json&Keyword=honey&User=winnie&Password=the-pooh')

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
      print 'Keyword: ' + ruObj['Response']['Entry']['Keyword'].to_s() + "\n"
      print 'Availability: ' + ruObj['Response']['Entry']['Available'].to_s() + "\n"
    else
      if !ruObj['Response']['Errors'].nil?
        print 'Errors: ' + ruObj['Response']['Errors'].join(', ') + "\n"
      end
    end

  }
}
              