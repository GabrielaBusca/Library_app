class Extension < ActiveRecord::Base

	self.table_name = "licenta.prelungire"
	self.primary_key = "id"

	def self.next_id_sequence
    sql_query = "SELECT prelungire_seq.nextval AS next_id from dual"
    result = ActiveRecord::Base.connection.exec_query(sql_query).to_a.first
  	result["next_id"]
  end

end
