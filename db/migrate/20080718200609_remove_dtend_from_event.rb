class RemoveDtendFromEvent < ActiveRecord::Migration
# no longer want to track dtend for events, only need start time and recurrenced, reminders have no duration, just a start
  def self.up
    remove_column :events, :dtend
  end

  def self.down
    add_column :events, :dtend, :datetime 
  end
end
