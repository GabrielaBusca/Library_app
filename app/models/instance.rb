class Instance < ActiveRecord::Base

  # specify schema and table name
  self.table_name = "licenta.exemplar"
  
  self.primary_key = "id_carte"

end
