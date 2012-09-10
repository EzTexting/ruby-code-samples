require 'rubygems'
require 'httparty'
require 'pp'

class SmsTextingAPI
  include HTTParty
  base_uri 'https://app.eztexting.com'

  def initialize(u, p, encoding=:json)
    self.class.default_params :User=> u, :Password => p, :format => encoding
  end

  # get object by id
  # which can be :groups or :contacts
  def get(id, which=:groups)
    resp = self.class.get("/#{which}/#{id}")
    check_errors resp
    res = resp.parsed_response['Response']['Entry']
    rebuild_groups! res
    res
  end

  # Delete object by id
  # which can be :groups or :contacts
  def del(id, which=:groups)
    resp = self.class.delete("/#{which}/#{id}")
    check_errors resp
  end


  # Create or update the object
  # which can be :groups or :contacts
  def put(obj, which=:groups)
    path = "/#{which}"
    path += "/#{obj['ID']}" unless obj['ID'].nil? 
    resp = self.class.post(path, { :body => obj })
    check_errors resp
    res = resp.parsed_response['Response']['Entry']
    rebuild_groups! res
    res
  end

  # get array of objects
  # which can be :groups or :contacts
  # options depends on type of objects
  # Common:
  # Sorting
  #  sortBy (Optional) Property to sort by.
  #  sortDir (Optional) Direction of sorting. Available values: asc, desc
  # Pagination
  #  itemsPerPage (Optional) Number of results to retrieve. By default, 10 most recently added contacts are retrieved.
  #  page (Optional) Page of results to retrieve
  # Additional contact options:
  # Filters
  #  query (Optional) Search contacts by first name / last name / phone number
  #  source (Optional) Source of contacts. Available values: 'Unknown', 'Manually Added', 'Upload', 'Web Widget', 'API', 'Keyword'
  #  optout (Optional) Opted out / opted in contacts. Available values: true, false.
  #  group (Optional) Name of the group the contacts belong to
  def get_all(which=:groups, options={})
    resp = self.class.get("/#{which}", { :query => options })
    check_errors resp
    rebuild_xml_array!(resp.parsed_response['Response'], 'Entries', 'Entry')
    res = resp.parsed_response['Response']['Entries']
    if which == :contacts
      res.each { |c| rebuild_groups! c }
    end
    res
  end

  private

  def check_errors(response)
    if !response.nil? && !response.parsed_response.nil?
      errors = response.parsed_response['Response']['Errors']
      unless errors.nil?
        err_code = response.parsed_response['Response']['Code']
        #json errors
        raise SmsTextingAPIError.new err_code, errors.join('; ') if errors.kind_of?(Array) 

        # xml version
        xml_errors = errors['Error'] 
        raise SmsTextingAPIError.new err_code, xml_errors.kind_of?(Array) ? xml_errors.join('; ') : xml_errors
      end
    end
  end

  def rebuild_groups!(obj)
    rebuild_xml_array!(obj, 'Groups', 'Group')
  end

  def rebuild_xml_array!(obj, key, innerKey)
    unless obj[key].nil?
       if obj[key].kind_of?(Hash) && !obj[key][innerKey].nil?
         if obj[key][innerKey].kind_of?(Array)
           obj[key] = obj[key][innerKey]
         else 
           obj[key] = [ obj[key][innerKey] ]
         end
       end
    end
  end
end

class SmsTextingAPIError < StandardError
  attr_reader :code
  def initialize(code, message)
    super(message)
    @code = code
  end
end