class Micropostimage < ActiveRecord::Migration
  def self.up
    add_attachment :microposts, :image
  end

  def self.down
    remove_attachment :microposts, :image
  end
end
