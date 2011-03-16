Sequel.migration do
  up do
    alter_table(:static_days) do
      add_column :avg_width, BigDecimal, :default => 0
      add_column :avg_height, BigDecimal, :default => 0
      add_column :avg_size, BigDecimal, :default => 0
    end
    
    DB[:static_days].select(:date).all.each do |day|
      set = DB[:images].filter(:created_date => day[:date])
      DB[:static_days].filter(:date => day[:date]).update(
        :avg_size => set.avg(:size), 
        :avg_width => set.avg(:width), 
        :avg_height => set.avg(:height)
      )
    end
    
    alter_table(:static_days) do
      add_index :avg_width
      add_index :avg_height
      add_index :avg_size
      add_index :count
    end
  end
  
  down do
    alter_table(:static_days) do
      drop_index :avg_width
      drop_index :avg_height
      drop_index :avg_size
      drop_index :count
      
      drop_column :avg_width
      drop_column :avg_height
      drop_column :avg_size
    end
  end
end