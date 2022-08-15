class AddRefToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :group, index: true, foreign_key: true
  end
end
