class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.string :correlation_id
      t.integer :amount_cents
      t.string :processor
      t.datetime :requested_at

      t.timestamps
    end
  end
end
