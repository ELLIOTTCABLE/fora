require 'database'

describe Connection do
	before(:each) do
		@init = Connection.new
	end

		it "should be assigned ident" do
			@init.assign_ident("assigned ident")
			@init.should be_in_ident("assigned ident")
		end
	
		it "should NOT be assigned ident" do
			@init = Connection.new
			@init.should_not be_in_ident("assigned ident")
		end
end

describe Database do
	before(:each) do
		@database = Database.new
	end
		it "should be given connection" do
			@database.set_connection("given connection")
			@database.should be_given_connection("given connection")
		end
		it "should NOT be given connection" do
			@database = Database.new
			@database.should_not be_given_connection("given connection")
		end
end
