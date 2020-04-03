class CreateInboundEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :inbound_events do |t|
      t.string :name, null: false
      t.jsonb :payload, null: false

      t.timestamps
    end
  end
end
