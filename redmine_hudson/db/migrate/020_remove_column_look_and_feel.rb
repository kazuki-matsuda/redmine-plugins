class RemoveColumnLookAndFeel < ActiveRecord::Migration
  def self.up
    remove_column :hudson_settings, :look_and_feel
  end

  def self.down
    add_column :hudson_settings, :look_and_feel, :string
    HudsonSettings.find(:all).each do |object|
      object.look_and_feel = 'Hudson'
      object.save!
    end
  end
end
