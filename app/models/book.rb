class Book < ActiveRecord::Base

	# specify schema and table name
  self.table_name = "licenta.carte"
  # specify primary key name
  self.primary_key = "id"
  # specify sequence name
  self.sequence_name = "licenta.carte_seq"

  mount_uploader :imagine_coperta, BookUploader

  def self.next_id_sequence
    sql_query = "SELECT carte_seq.nextval AS next_id from dual"
    result = ActiveRecord::Base.connection.exec_query(sql_query).to_a.first
  	result["next_id"]
  end

end
