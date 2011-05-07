module RequestsHelper
  def get_address_from_zip (address)
    geocoder = "http://maps.googleapis.com/maps/api/geocode/json?address="
    output = "&sensor=false"
    #address = "424+ellis+st+san+francisco"
    request = geocoder + address + output
    url = URI.escape(request)
    resp = Net::HTTP.get_response(URI.parse(url))
    #parse result if result received properly
    if resp.is_a?(Net::HTTPSuccess)
      #parse the json
      parse = Crack::JSON.parse(resp.body)
      #check if google went well
      if parse["status"] == "OK"
       # return parse if raw == true
        array = []
        parse["results"].each do |result|
          array <<{
            :lat => result["geometry"]["location"]["lat"],
            :long => result["geometry"]["location"]["lng"],
            :matched_address => result["formatted_address"],
            :bounds => result["geometry"]["bounds"]
          }
        end
        return array
      end
    end

    return parse
  end

end
