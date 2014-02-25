class TokenConfirm < ActiveRecord::Migration
  def change
  	add_column :users, :token_confirm, :string
  end
end
