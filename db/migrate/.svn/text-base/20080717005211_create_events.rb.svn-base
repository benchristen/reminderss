class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :url
      t.text :description
      t.datetime :dtstart
      t.datetime :dtend
      t.string :recurrence

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
