class CreateGradings < ActiveRecord::Migration
  def self.up
    create_table :gradings do |t|
      t.integer             :user_id
      t.timestamps
    end

    create_table :grading_assignments do |t|
      t.integer             :grading_component_id
      t.integer             :grading_id
      t.integer             :value
      t.string              :rating
      t.timestamps
    end
    
    create_table :grading_components do |t|
      t.string              :name
      t.timestamps
    end
    
  end

  def self.down
    drop_table :gradings
    drop_table :grading_assignments
    drop_table :grading_components
  end
end
