class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable	

  # specify schema and table name
  self.table_name = "licenta.users"
  # specify primary key name
  self.primary_key = "id"

  self.sequence_name = "licenta.users_seq"

end
