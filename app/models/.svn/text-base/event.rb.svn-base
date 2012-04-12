class Event < ActiveRecord::Base

  belongs_to  :user

  validates_presence_of :url
  #validates_numericality_of :count, :interval, :only_integer => :true

  FREQUENCIES = ["DAILY", "WEEKLY", "MONTHLY", "YEARLY"]
  BYDAYS = ["MO", "TU", "WE", "TH", "FR", "SA", "SU", "MO,WE,FR", "TU,TH", "SA,SU", "MO,TU,WE,TH,FR", "1MO", "2MO", "3MO", "4MO"]

  include Comparable
  
  def <=>(other)
    # sort oldest last
    other.dtstart <=> self.dtstart
  end

  def self.find_events_for_user
    find(:all, :order => "dtstart")
  end

  # 'frequency' is a virtual attribute 
  def frequency 
    @frequency
  end 
  def frequency=(freq) 
    @frequency = 'FREQ=' + freq.upcase unless freq.blank? 
  end 

  # 'count' is a virtual attribute 
  def count 
    @count
  end 
  def count=(cnt) 
    @count = 'COUNT=' + cnt.upcase unless cnt.blank?
  end 

  # 'interval' is a virtual attribute 
  def interval 
    @interval
  end 
  def interval=(intvl) 
    @interval = 'INTERVAL=' + intvl.upcase unless intvl.blank?
  end 

  # 'until' is a virtual attribute 
  def until 
    @until
  end 
  def until=(untl) 
    @until = 'UNTIL=' + untl.upcase unless untl.blank?
  end 

  # 'byday' is a virtual attribute 
  def byday 
    @byday
  end 
  def byday=(bydy) 
    @byday = 'BYDAY=' + bydy.upcase unless bydy.blank?
  end
  
  def update_recurrence(freq, cnt, intvl, untl, bydy)
    self.frequency = freq
    self.count = cnt
    self.interval = intvl
    self.until = untl
    self.byday = bydy
    update_recurrence
  end
  
  def update_recurrence
    unless (self.frequency.nil? or self.frequency.blank?) and (self.count.nil? or self.count.blank?) and (self.interval.nil? or self.interval.blank?) and (self.until.nil? or self.until.blank?) and (self.byday.nil? or self.byday.blank?) 
      self.recurrence = ''
      unless self.frequency.nil? or self.frequency.blank?
        self.recurrence += self.frequency
        unless (self.count.nil? or self.count.blank?) and (self.interval.nil? or self.interval.blank?) and (self.until.nil? or self.until.blank?) and (self.byday.nil? or self.byday.blank?)
          self.recurrence += ';'
        end
      end 
      unless self.count.nil? or self.count.blank?
        self.recurrence += self.count
        unless (self.interval.nil? or self.interval.blank?) and (self.until.nil? or self.until.blank?) and (self.byday.nil? or self.byday.blank?)
          self.recurrence += ';'
        end
      end
      unless self.interval.nil? or self.interval.blank?
        self.recurrence += self.interval 
        unless (self.until.nil? or self.until.blank?) and (self.byday.nil? or self.byday.blank?)
          self.recurrence += ';'
        end
      end
      unless self.until.nil? or self.until.blank?
        self.recurrence += self.until
        unless self.byday.nil? or self.byday.blank?
          self.recurrence += ';'
        end
      end
      unless self.byday.nil? or self.byday.blank?
        self.recurrence += self.byday
      end
    end
    self.recurrence = '' if self.recurrence.nil? 
  end
  
  
end
