class Confirmemail < ActiveRecord::Migration
  def change
  	add_column :users, :confirm_email, :boolean, default: false
  end
end
