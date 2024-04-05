class AddColumnsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :dob, :datetime
  end
end
