require 'net/https'
require 'uri'
require 'xmlsimple'

url = URI.parse('https://app.eztexting.com/keywords/honey')

#prepare post data
req = Net::HTTP::Post.new(url.path)

req.set_form_data({
    'format'=>'xml',
    'User'=>'winnie', 
    'Password'=>'the-pooh', 
    'EnableDoubleOptIn' => 1,
    'ConfirmMessage'    => 'Reply Y to join our sweetest list',
    'JoinMessage'       => 'The only reason for being a bee that I know of, is to make honey. And the only reason for making honey, is so as I can eat it.',
    'ForwardEmail'      => 'honey@bear-alliance.co.uk',
    'ForwardUrl'        => 'http://bear-alliance.co.uk/honey-donations/',
    'ContactGroupIDs[0]'   => 'honey',
    'ContactGroupIDs[1]'   => 'lovers'
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
      print 'Keyword ID: ' + ruObj['Entry']['ID'].to_s() + "\n"
      print 'Keyword: ' + ruObj['Entry']['Keyword'].to_s() + "\n"
      print 'Is double opt-in enabled: ' + ruObj['Entry']['EnableDoubleOptIn'].to_s() + "\n"
      print 'Confirm message: ' + ruObj['Entry']['ConfirmMessage'].to_s() + "\n"
      print 'Join message: ' + ruObj['Entry']['JoinMessage'].to_s() + "\n"
      print 'Forward email: ' + ruObj['Entry']['ForwardEmail'].to_s() + "\n"
      print 'Forward url: ' + ruObj['Entry']['ForwardUrl'].to_s() + "\n"
      if !ruObj['Entry']['ContactGroupIDs'].nil?
        groups = ruObj['Entry']['ContactGroupIDs']['Group']
        print 'Groups: '+ (groups.kind_of?(Array) ? groups.join(', ') : groups) + "\n"
      end
    else
      if !ruObj['Errors'].nil?
        errors = ruObj['Errors']['Error']
        print 'Errors: '+ (errors.kind_of?(Array) ? errors.join(', ') : errors) + "\n"
      end
    end

  }
}
