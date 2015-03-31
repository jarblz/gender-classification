class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :sex
      t.float :height
      t.float :weight

      t.timestamps
    end
  end
end
