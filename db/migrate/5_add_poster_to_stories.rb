class AddPosterToStories < ActiveRecord::Migration
  def change
    add_column :stories, :poster_id, :integer
    add_index  :stories, :poster_id
  end
end
