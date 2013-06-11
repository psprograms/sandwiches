require 'openid'
require 'openid/extensions/ax'
require 'openid/store/filesystem'

#module Sinatra::Helpers
#	alias :old_uri :uri
 #       def uri(addr = nil, absolute = true, add_script_name = true)
		#if addr.match(/^\//)
		#	old_uri('sandwiches' + addr)
		#else
#			old_uri(addr)
		#end
 #       end
#	alias :to :uri
#	alias :url :uri
#end
class Routes < Sinatra::Base
  enable :sessions
  set :environment, :production
  #configure :development do
   # register Sinatra::Reloader
  #end

  get '/' do
	redirect url('/info')
  end

  get '/make_choices' do
    unless authorized?
      redirect url('/login')
    end

    @title = 'Make Choices'
    @choicePath = '/send_order'

    erb :make_choices
  end

  get '/orders' do
    @title = 'Orders'
    if !admin? && session[:studentID] != nil
      @orders = Order.all(:studentID => session[:studentID])
    elsif session[:studentID] == nil
      redirect url('/login')
    else
      @orders = Order.all()
    end

    erb :orders
  end

  get '/clone_order' do
    id = params[:id]
    theOrder = Order.first(:id => id, :studentID => session[:studentID])

    bread = theOrder.bread
    meats = theOrder.meats
    cheeses = theOrder.cheeses
    toppings = theOrder.toppings
    dressings = theOrder.dressings
    toasted = theOrder.toasted

    @maxOrders = Options.first(:optionName => 'Order Maximum').value.to_i
    uniqName = Order.all(:studentID => session[:studentID], :date => Time.now.strftime('%m/%d/%y') )
    nameCount = uniqName.count

    if nameCount >= @maxOrders
      redirect url('/order_filled')
    end

    startTime = Options.first(:optionName => 'Start Time').value.to_i
    endTime = Options.first(:optionName => 'End Time').value.to_i

    currTime = Time.now
    currTimeFrm = Time.now.strftime("%l:%M")
    currAMPM = currTime.strftime("%p")
    
    currTimeSec = currTimeFrm.seconds_from_midnight(currAMPM)    

    if currTimeSec.cmp_times(startTime) == -1 || currTimeSec.cmp_times(endTime) == 1
      redirect url('/time_range')
    end

    Order.create(:date => Time.now.strftime('%m/%d/%y'), :time => Time.now.strftime('%r'), :name => session[:name], :studentID => session[:studentID], :bread => bread, :meats => meats, :cheeses => cheeses, :toppings => toppings, :dressings => dressings, :toasted => toasted, :pickedUp => 'No')

    redirect url('/profile')
  end

  get '/supplies' do
    if session[:studentID] == nil
      redirect url('/login')
    elsif admin?
      @title = 'Supplies'

      @breads = Supply.all(:fields => [:id, :name], :type => 'Bread', :order => [:name])
      @meats = Supply.all(:fields => [:id, :name], :type => 'Meat', :order => [:name])
      @cheeses = Supply.all(:fields => [:id, :name], :type => 'Cheese', :order => [:name])
      @toppings = Supply.all(:fields => [:id, :name], :type => 'Topping', :order => [:name])
      @dressings = Supply.all(:fields => [:id, :name], :type => 'Dressing', :order => [:name])
      @prepared = Sandwiches.all(:fields => [:id, :name])

      erb :supplies
    else
      @title = 'Access Denied'
      @error = 'Access denied. You do not have permission to view this page.'
      erb :error
    end
  end

  get '/delete_supply' do
    id = params[:id]
    theSupply = Supply.all(:id => id)

    theSupply.destroy

    redirect url('/supplies')
  end

  get '/delete_pre-made' do
    id = params[:id]
    thePreMade = Sandwiches.all(:id => id)

    thePreMade.destroy

    redirect url('/supplies')
  end

  get '/delete_order' do
    startTime = Options.first(:optionName => 'Start Time').value.to_i
    endTime = Options.first(:optionName => 'End Time').value.to_i

    currTime = Time.now
    currTimeFrm = Time.now.strftime("%l:%M")
    currAMPM = currTime.strftime("%p")
    
    currTimeSec = currTimeFrm.seconds_from_midnight(currAMPM)    

    if currTimeSec.cmp_times(startTime) == -1 || currTimeSec.cmp_times(endTime) == 1
      redirect url('/time_range')
    end

    id = params[:id]
    theOrder = Order.all(:id => id, :studentID => session[:studentID])

    theOrder.destroy

    erb :profile
  end

  post '/send_order' do

    def isArray(aryVar)
      if aryVar.class == Array
        aryVar = aryVar.join(", ")
      end
    end

    @maxOrders = Options.first(:optionName => 'Order Maximum').value.to_i

    @bread = params[:bread]
    @meats = isArray(params[:meats])
    @cheeses = isArray(params[:cheeses])
    @toppings = isArray(params[:toppings])
    @dressings = isArray(params[:dressings])
    @toasted = params[:toasted]

    uniqName = Order.all(:studentID => session[:studentID], :date => Time.now.strftime('%m/%d/%y') )
    nameCount = uniqName.count

    if nameCount >= @maxOrders
      redirect url('/order_filled')
    end

    startTime = Options.first(:optionName => 'Start Time').value.to_i
    endTime = Options.first(:optionName => 'End Time').value.to_i

    currTime = Time.now
    currTimeFrm = Time.now.strftime("%l:%M")
    currAMPM = currTime.strftime("%p")
    
    currTimeSec = currTimeFrm.seconds_from_midnight(currAMPM)    

    if currTimeSec.cmp_times(startTime) == -1 || currTimeSec.cmp_times(endTime) == 1
      redirect url('/time_range')
    else
      Order.create(:date => Time.now.strftime('%m/%d/%y'), :time => Time.now.strftime('%r'), :name => session[:name], :studentID => session[:studentID], :bread => @bread, :meats => @meats, :cheeses => @cheeses, :toppings => @toppings, :dressings => @dressings, :toasted => @toasted, :pickedUp => 'No')
      @orders = Order.all

      redirect url('/profile')
    end
  end

  get '/login' do
    OpenID.fetcher.ca_file = "/usr/share/ca-certificates/cacert.pem"
    if authorized?
      @choicePath = '/send_order'
      redirect url('/make_choices')
    else
	openid_url = 'https://www.google.com/accounts/o8/id'
      begin
        oid_request = openid_consumer.begin(openid_url)
      rescue OpenID::DiscoveryFailure
        halt 401, 'Unauthorized: Open ID could not be discovered.'
      else
        ax_request = OpenID::AX::FetchRequest.new

        attr_email = OpenID::AX::AttrInfo.new('http://axschema.org/contact/email', 'email', true)
        attr_first_name = OpenID::AX::AttrInfo.new('http://axschema.org/namePerson/first', 'first_name', true)
        attr_last_name = OpenID::AX::AttrInfo.new('http://axschema.org/namePerson/last', 'last_name', true)
        [attr_email, attr_first_name, attr_last_name].each do |a|
		 ax_request.add(a)
	end

        oid_request.add_extension(ax_request)

        #oid_request.add_extension_arg('http://google.com','required','email, first_name, last_name')	


	redirect oid_request.redirect_url(root_url, url('/login/callback'))
	#"#{root_url}<br><br>#{url('/login/callback')}<br><br>#{request.url}"
      end
    end

  end

  get '/login/callback' do
    oid_response = openid_consumer.complete(params, request.url)
    openid = oid_response.display_identifier

    case oid_response.status
      when OpenID::Consumer::FAILURE
        halt 401, "Sorry, we could not authenticate you with this identifier #{openid}."

      when OpenID::Consumer::SETUP_NEEDED
        halt 401, "Immediate request failed - Setup Needed"

      when OpenID::Consumer::CANCEL
        redirect url('/info')

      when OpenID::Consumer::SUCCESS

        #"status = #{oid_response.status} <br> email = #{params['openid.ext1.value.email'.to_sym]} <br> path = #{session[:request_path]}"

        if oid_response.status == OpenID::Consumer::SUCCESS
          request_path = session[:request_path]
          session[:email] = params['openid.ext1.value.email'.to_sym]
          #"hey #{session['email']}"
          session[:request_path] = nil

          emailAry = session[:email].split("@")
          domain = emailAry[1]
          if domain != 'students.westport.k12.ct.us' && domain != 'westport.k12.ct.us' && session[:email] != 'michael.adler.a@gmail.com' && session[:email] != 'pstakoff@gmail.com' && session[:email] != 'staples.lunch@gmail.com'
            redirect url('/staples')
          else
            studentID = emailAry[0]
            firstName = params['openid.ext1.value.first_name']
            lastName = params['openid.ext1.value.last_name']

            session[:studentID] = studentID
            session[:name] = "#{firstName} #{lastName}"

            if !admin?
              redirect url('/profile')
            else
              redirect url('/lunch_console')
            end

          end

        else
          session[:request_path] = nil
          halt 401, 'Unauthorized: Open ID could not be authenticated.'
        end

    end
  end

  get '/staples' do
    @error = "This application is only available to Staples students and staff."
    erb :error
  end

  get '/order_filled' do
    @error = "You already have the maximum number of orders placed for your account. <a href=#{url('/profile')}>Click here to view your current orders.</a>"
    erb :error
  end

  get '/time_range' do
    @error = "You cannot place or delete an order outside of the valid time range. <a href=#{url('/profile')}>Click here to view your current orders.</a>"
    erb :error
  end

  get '/options_error' do
    @error = "Invalid options entered. You must enter an integer greater than zero into the max orders field.<br>
  		The two time fields must be in 12-hour format with no trailing zeroes on the same calendar day.<br>
		<a href=#{url('/admin_options')}>Click here to try again.</a>"
    erb :error
  end

  get '/profile' do

    if !authorized?
      redirect url('/login')
    end

    @studentID = session[:studentID]
    @name = session[:name]

    @orders = Order.all(:studentID => @studentID, :date => Time.now.strftime("%m/%d/%y"))

    @title = "Profile"
    erb :profile
  end

  post '/update_supplies' do
    @supplies = Supply.all
    @prepared = Sandwiches.all

    inStock = params[:stockArray]

    @supplies.each do |supply|

      if inStock.index(supply.id.to_s) == nil
        supply.update(:inStock => 'No')
      else
        supply.update(:inStock => 'Yes')
      end

    end

    redirect url('/supplies')
  end

  post '/update_pre-made' do
    @prepared = Sandwiches.all

    inStock = params[:stockArray]

    @prepared.each do |option|
      if inStock.index(option.id.to_s) == nil
        option.update(:inStock => 'No')
      else
        option.update(:inStock => 'Yes')
      end
    end

    redirect url('/supplies')
  end

  post '/update_pickups' do
    @orders = Order.all

    pickedUpArray = params[:pickedUpArray]

    @orders.each do |order|

      if pickedUpArray == nil || pickedUpArray.empty?
        # This is here to fix a previous error.
      else
        if pickedUpArray.index(order.id.to_s) == nil
          order.update(:pickedUp => 'No')
        else
          order.update(:pickedUp => 'Yes')
        end
      end
    end

    redirect url('/orders')
  end

  post '/add_supply' do
    @name = params[:name]
    @type = params[:type]

    Supply.create(:name => @name, :type => @type, :inStock => 'Yes')

    redirect url('/supplies')
  end

  get '/add_pre-made' do
    @choicePath = '/commit_pre-made'
    @title = 'Select Pre-Made Sandwich Toppings'

    #need to redirect user to select options on the make-order page
    #currently the options are hard-coded

    erb :make_choices
  end

  post '/commit_pre-made' do
    def isArray(aryVar)
      if aryVar.class == Array
        aryVar = aryVar.join(", ")
      end
    end

    @name = params[:name]
    @bread = params[:bread]
    @meats = isArray(params[:meats])
    @cheeses = isArray(params[:cheeses])
    @toppings = isArray(params[:toppings])
    @dressings = isArray(params[:dressings])
    @toasted = params[:toasted]

    Sandwiches.create(:name => @name, :bread => @bread, :meats => @meats, :cheeses => @cheeses, :toppings => @toppings, :dressings => @dressings, :toasted => @toasted, :inStock => 'Yes')

    redirect url('/supplies')
  end

  get '/info' do
    erb :info
  end

  get '/logout' do
    session[:studentID] = nil
    session[:name] = nil

    erb :info
  end

  get '/lunch_console' do
    if session[:studentID] == nil
      redirect url('/login')
    elsif admin?
      @title = "Lunch Console"
      erb :lunch_console
    else
      @title = 'Access Denied'
      @error = 'Access denied. You do not have permission to view this page.'
      erb :error
    end
  end

  get '/admin_options' do
    if session[:studentID] == nil
      redirect url('/login')
    elsif admin?
      @title = "Administrative Options"
      @cmaxOrders = Options.first(:optionName => "Order Maximum")
      @startTime = Options.first(:optionName => "Start Time").value.to_i
      @endTime = Options.first(:optionName => "End Time").value.to_i

      @startSecTime = @startTime.to_readable
      @endSecTime = @endTime.to_readable

      erb :admin_options
    
    else
      @title = 'Access Denied'
      @error = 'Access denied. You do not have permission to view this page.'
      erb :error
    end
  end

  post '/submit_options' do
    if params[:maxOrders].match(/^[1-9][0-9]?$/) && params[:startTime].match(/^((1{1}[0-2])|([1-9])):[0-5][0-9]$/) && params[:endTime].match(/^((1{1}[0-2])|([1-9])):[0-5][0-9]$/)
      @cmaxOrders = Options.first(:optionName => "Order Maximum")
      @cmaxOrders.update(:value => params[:maxOrders].to_i)

      @startTime = params[:startTime]
      @endTime = params[:endTime]

      @startAMPM = params[:startAMPM]
      @endAMPM = params[:endAMPM]

      @startSecTime = @startTime.seconds_from_midnight(@startAMPM)
      @endSecTime = @endTime.seconds_from_midnight(@endAMPM)

      if @startSecTime >= @endSecTime
      	redirect url('/options_error')
      end

      @start = Options.first(:optionName => "Start Time")
      @end = Options.first(:optionName => "End Time")
      @start.update(:value => @startSecTime.to_s)
      @end.update(:value => @endSecTime.to_s)
    else
	redirect url('/options_error')
    end

    redirect url('/admin_options')
  end

end
