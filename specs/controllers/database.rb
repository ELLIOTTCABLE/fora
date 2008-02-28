#!/usr/bin/ruby

require 'activerecord'

class Connection
	def in_ident?(ident)
		ident == @ident
	end

	def assign_ident(ident)
		@ident = ident
	end
end

class Database
	def given_connection?(connection)
		connection == @connection	
	end

	def set_connection(connection)
		@connection = connection
	end

	def config
		db_config = { ":adapter => 'mysql'",
			":username => 'yreality'",
			":password => 'yreality'",
			":host => 'localhost'"
			}
		ActiveRecord::Base.configurations['development'] = {
			:database => 'specs_test',
			:adapter  => db_config[:adapter],
			:username => db_config[:username],
			:password => db_config[:password],
			:host     => db_config[:host],
			:socket   => db_config[:socket]
			}
		puts db_config 
	end	

	def enddb
		puts "Connection Closed"
	end
end
