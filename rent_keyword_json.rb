require 'net/https'
require 'uri'
require 'json'

url = URI.parse('https://app.eztexting.com/keywords')

#prepare post data
req = Net::HTTP::Post.new(url.path)

req.set_form_data({
    'format'=>'json',
    'User'=>'demo', 
    'Password'=>'texting121212', 
    'Keyword'  => 'honey',
    'StoredCreditCard' => '1111'

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
      print 'Keyword ID: ' + ruObj['Response']['Entry']['ID'].to_s() + "\n"
      print 'Keyword: ' + ruObj['Response']['Entry']['Keyword'].to_s() + "\n"
      print 'Is double opt-in enabled: ' + ruObj['Response']['Entry']['EnableDoubleOptIn'].to_s() + "\n"
      print 'Confirm message: ' + ruObj['Response']['Entry']['ConfirmMessage'].to_s() + "\n"
      print 'Join message: ' + ruObj['Response']['Entry']['JoinMessage'].to_s() + "\n"
      print 'Forward email: ' + ruObj['Response']['Entry']['ForwardEmail'].to_s() + "\n"
      print 'Forward url: ' + ruObj['Response']['Entry']['ForwardUrl'].to_s() + "\n"
      print 'Groups: ' + ruObj['Response']['Entry']['ContactGroupIDs'].join(', ') + "\n"
    else
      if !ruObj['Response']['Errors'].nil?
        print 'Errors: ' + ruObj['Response']['Errors'].join(', ') + "\n"
      end
    end

  }
}


