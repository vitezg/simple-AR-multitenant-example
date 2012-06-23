require 'dbconnect'

# quick and dirty table creation

ActiveRecord::Migration.create_table :shop do |t|
  t.string :name
end

ActiveRecord::Migration.create_table :coffee do |t|
  t.string :name
  t.references :shop
end

ActiveRecord::Migration.add_index :coffee, :shop_id
