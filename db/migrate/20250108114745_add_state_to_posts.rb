class AddStateToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :state, :string
  end
end
