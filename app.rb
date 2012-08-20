%w(rubygems sinatra rest-client json).each { |lib| require lib }

get '/' do
  erb :index, :layout => :application
end


get "/lookup" do
  
  @q = params["q"]
  puts @q
  
  @url = "http://www.eventbrite.com/json/event_search?app_key=IEP2UEFAULB6J2QEA2&keywords=#{@q}"

  begin
    @jdata = JSON.parse(RestClient.get @url,  {:accept => :json, :content_type => :json})
    # @jdata = JSON.parse(RestClient.get @url)
  rescue
  end
  
  puts @jdata

  if @jdata

    @items = @jdata["events"] 
  
    @names = '<table class="table table-striped table-bordered"><tr><th>Event Name</th><th>Time</th><th>Link</th></tr>'
  
    @items.each do |item|    
    
      @names << '<tr><td>' + item["event"]["title"] + '</td>' rescue "<tr><td>&nbsp;</td>"
      @names << '<td>' + item["event"]["start_date"] + '</td>' rescue "<td>&nbsp;</td>"
      @names << '<td><a href="' + item["event"]["url"] + '">' + item["event"]["url"] + '</a></td>' rescue "<td>&nbsp;</td>"
    end
  
    @names << '</table>'

  else
    @names = "No results found."
  end
  
  @names
  
end 




get "/lookupmobile" do
  
  @q = params["q"]
  puts @q
  
  @url = "http://www.eventbrite.com/json/event_search?app_key=IEP2UEFAULB6J2QEA2&keywords=#{@q}"

  begin
    @jdata = JSON.parse(RestClient.get @url,  {:accept => :json, :content_type => :json})
    # @jdata = JSON.parse(RestClient.get @url)
  rescue
  end
  
  puts @jdata

  if @jdata
  
    @items = @jdata["events"]
  
    @names = '<ul data-role="listview" data-inset="true">'  
  
    @items.each do |item|
    
      # @names << '<li><a href="' + item["event"]["url"] + '">' + item["event"]["title"] + '</a></li>' rescue '<li></li>'
      @names << '<li><a onclick="javascript:loadPage(\'' + item["event"]["url"] + '\')">' + item["event"]["title"] + '</a></li>' rescue '<li></li>'
    
    end
  
    @names << '</ul>'  

  else
    @names = "No results found."
  end
  
  @names
  
end 




get "/details" do
  
  @q = params["q"]
  @url = "https://api.mypsn.com/svc1/v2/contacts/#{@q}"

  begin
    @jdata = JSON.parse(RestClient.get @url,  {:accept => :json, :content_type => :json, "X-myPSN-AppKey"=> APP_KEY, "Authorization" => session["token"]})
  rescue
  end
  
  puts @jdata
  
  @names = '<table class="table table-striped table-bordered">'
  @names << "<tr><td>Name</td><td>" + @jdata["items"][0]["DisplayName"] + "</td></tr>" rescue ""
  @names << "<tr><td>Title</td><td>" + @jdata["items"][0]["Title"] + "</td></tr>" rescue ""
  @names << "<tr><td>Status</td><td>" + @jdata["items"][0]["Status"] + "</td></tr>" rescue ""
  @names << "<tr><td>Location</td><td>" + @jdata["items"][0]["Location"] + "</td></tr>" rescue ""
  @names << "<tr><td>PhoneNumber</td><td>" + @jdata["items"][0]["PhoneNumber"] + "</td></tr>" rescue ""
  @names << "<tr><td>Supervisor</td><td>" + @jdata["items"][0]["SupervisorName"] + "</td></tr>" rescue ""
  @names << "</table>"
  
  @names
  
end




