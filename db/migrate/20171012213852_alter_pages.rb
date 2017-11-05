class AlterPages < ActiveRecord::Migration[5.0]

  def up
      change_column("pages", "permalink", :string)
  end
end
