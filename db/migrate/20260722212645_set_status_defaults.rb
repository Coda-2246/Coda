class SetStatusDefaults < ActiveRecord::Migration[8.1]
  def change
    change_column_default :entries, :status, from: nil, to: 0
    change_column_default :gigs,    :status, from: nil, to: 0
  end
end
