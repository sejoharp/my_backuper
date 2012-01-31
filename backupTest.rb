load "backup.rb"

require "test/unit"

class BackkupTest < Test::Unit::TestCase

	def testPingShouldWork
		backup = Backup.new "macaddress", "localhost", "10.1.1.255", "admin", 120, true
		assert_equal(true , backup.serverOnline?)
	end

	def testPingShouldNotWork
		backup = Backup.new "macaddress", "unknownPC", "10.1.1.255", "admin", 120, true
		assert_equal(false , backup.serverOnline?)
	end

	def testClientShouldBeAtHome
		backup = Backup.new "macaddress", "unknownPC", "10.1.1.255", "admin", 120, true
		assert_equal(true, backup.clientInHomeNetwork?)
	end

	def testClientShouldNotBeAtHome
		backup = Backup.new "macaddress", "unknownPC", "10.2.2.255", "admin", 120, true
		assert_equal(false, backup.clientInHomeNetwork?)
	end
end