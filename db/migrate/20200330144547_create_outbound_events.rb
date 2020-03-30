class CreateOutboundEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :outbound_events do |t|
      t.string :key, null: false
      t.string :name, null: false
      t.jsonb :payload, null: false
      t.datetime :processed_at
      t.datetime :published_at, null: false

      t.timestamps
    end
  end
end
