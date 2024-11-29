class CreateTestModels < ActiveRecord::Migration[7.2]
  def change
    create_table :test_models do |t|
      t.integer :number, default: 0, null: false
    end
  end
end
