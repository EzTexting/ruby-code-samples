require 'net/https'
require 'uri'
require 'json'

url = URI.parse('https://app.eztexting.com/keywords/honey')

#prepare post data
req = Net::HTTP::Post.new(url.path)

req.set_form_data({
    'format'=>'json',
    '_method'=>'DELETE',
    'User'=>'winnie', 
    'Password'=>'the-pooh', 
})

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true if url.scheme == "https"  # enable SSL/TLS
http.ca_file = "cacert.pem"
http.verify_mode = OpenSSL::SSL::VERIFY_PEER
http.start {
  http.request(req) {|res|
    case res
    when Net::HTTPSuccess
      print "Success!"
    else
      print res.body+"\n===================================\n"

      ruObj = JSON.parse(res.body)

      print 'Status: ' + ruObj['Response']['Status'].to_s() + "\n"
      if !ruObj['Response']['Errors'].nil?
        print 'Errors: ' + ruObj['Response']['Errors'].join(', ') + "\n"
      end
    end

  }
}

