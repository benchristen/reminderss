class FeedController < ApplicationController

  skip_before_filter :authorize
  after_filter :set_content_type_rss, :only => :rss
  after_filter :set_content_type_ical, :only => :ical

  #caches_page :rss, :ical

  layout "standard", :except => [:rss, :ical] 

  require 'vpim/icalendar'

  def index
    @current_user = User.find(session[:user_id]) unless (session[:user_id].nil?)
    unless (params[:id].nil?)
      @user = User.find_by_name(params[:id])
      @events = @user.events
    else
      @users = User.find(:all) 
      @events = Event.find(:all)
    end
  end
  
  def rss
    @current_user = User.find_by_name(params[:id])
    all_events = @current_user.events(:order => "dtstart")
    @events = Array.new
    now = Time.now
    logger.debug "now=#{now}"
    for e in all_events
      #logger.debug "BEGIN EVENT #{e.url}"
      #logger.debug "event=#{e.url} dtstart=#{e.dtstart}"
      if (e.recurrence.nil? or e.recurrence.blank?)
        # single time event that already happened, add to begining of feed if already happened
        @events.push e if e.dtstart <= now 
        logger.debug "ADDED event=#{e.url} dtstart=#{e.dtstart}"
      else
        # figure out the recurrence
        rrule = Vpim::Rrule.new(e.dtstart, e.recurrence)
        #logger.debug "Rule: #{e.recurrence}"
        rrule.each_with_index do |t, count|
          #logger.debug "event=#{e.url} count=#{count} t=#{t.to_s}"
          next if count == 0
          break if t > now 
          e2 = Event.new
          #logger.debug "t is #{t.to_s}"
          #logger.debug "e2.dtstart before t is #{e2.dtstart}"
          #e.dtstart = t.getutc
          #e.dtstart = t
          e2.url = e.url
          e2.description = e.description
          ta = t.to_a
          e2.dtstart = Time.utc(ta[0],ta[1],ta[2],ta[3],ta[4],ta[5],ta[6],ta[7],ta[8],ta[9])
          e2.recurrence = ''
          #logger.debug "e2.dtstart after t is #{e2.dtstart}"
          @events.push e2 
          logger.debug "ADDED event=#{e2.url} dtstart=#{e2.dtstart}"
        end
        
      end
    end
    #@events.reverse
    @events = @events.sort         
  end

  def ical
    @current_user = User.find_by_name(params[:id])
    events = @current_user.events(:order => "dtstart")
    @cal = create_cal_from_events(events)
  end


protected

  def create_cal_from_events(events)
    cal = Vpim::Icalendar.create2(producer = 'reminderss')

    #=begin comment
    #X-WR-CALNAME:reminderss
    #producer = Vpim::PRODID
    #=end
    for event in events 
      logger.debug "event: #{event}"
      logger.debug "event.recurrence: #{event.recurrence}"
      e = Vpim::Icalendar::Vevent.create(event.dtstart, 
  		  'RRULE'    =>  event.recurrence,
    		'SUMMARY' => event.url,
    		'DESCRIPTION' =>	event.description,
    		'URL'        =>   event.url,
    		'CREATED'    =>   event.created_at,
    		'LASTMOD'    =>   event.updated_at)
    	cal.push e
    end
    return cal
  end
  
  def set_content_type_ical
    #content_type = @headers["Content-Type"] || 'text/calendar'
    content_type = 'text/calendar'
    #if /^text\//.match(content_type)
    #@headers["Content-Type"] = "#{content_type}; charset=utf-8" 
    headers["Content-Type"] = "#{content_type}; charset=utf-8" 
    #end
  end
  
  def set_content_type_rss
    #content_type = @headers["Content-Type"] || 'application/rss+xml'
    content_type = 'application/rss+xml'
    #if /^text\//.match(content_type)
    headers["Content-Type"] = "#{content_type}; charset=utf-8" 
    #end
  end


end
