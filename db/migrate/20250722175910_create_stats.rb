class CreateStats < ActiveRecord::Migration[8.0]
  def change
    create_view :stats
  end
end
