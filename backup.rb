require "timeout"
require "socket"
require "date"

class Ping 
	def self.pingecho(host, timeout=5, service="echo")
		begin
			timeout(timeout) do
				s = TCPSocket.new(host, service)
				s.close
			end
		rescue Errno::ECONNREFUSED
			return true
		rescue   Timeout::Error, StandardError 
			return false 
		end
		return true
	end
end

class Backup
	def initialize(macAddress, serverIP, clientBroadcast, user, maxWaitForWakeupInSecs, debug)
		@macAddress = macAddress
		@serverIP = serverIP
		@clientBroadcast = clientBroadcast
		@user = user
		@maxWaitForWakeupInSecs = maxWaitForWakeupInSecs
		@debug = debug
    
    STDOUT.sync = true
	end

	def startBackupProcess
		if clientInHomeNetwork?
			log "client is at home"
			shutdownAfterBackup = serverOnline? == false
			log "server already online - no shutdown after backup" if not shutdownAfterBackup
			log "server is offline - server will shutdown after backup" if shutdownAfterBackup
			if not serverOnline?
				log "waking up the machine"
				wakeupBackupMachine
			end
			if serverOnline? && afpOnline?
				log_without_new_line "backing up data"
				backupData
				if shutdownAfterBackup
					log "send shutdown command"
					shutdownServer
				end
			else 
				log "server still unavailable - no backup possible"
			end
		else
			log "client is not at home - no backup"
		end 
	end

	def log msg
		puts DateTime.now.to_s +  " " + msg if @debug
	end

	def log_without_new_line msg
		print DateTime.now.to_s +  " " + msg if @debug
	end
  
	def serverOnline?
		return Ping.pingecho(@serverIP, 5)
	end

	def afpOnline?
		return Ping.pingecho(@serverIP, 5, 548)
	end

	def clientInHomeNetwork?
		execute_command("ifconfig | grep " + @clientBroadcast) != ""
	end

	def execute_command command
		open("|" + command).read
	end
  
	def wakeupBackupMachine
		sendWakeupCommand
		connectionTries = 0
		while connectionTries < @maxWaitForWakeupInSecs && serverOnline? == false 
			sleep 1
			connectionTries = connectionTries + 1
		end
	end

	def sendWakeupCommand
		execute_command "/usr/local/Cellar/wol/HEAD/bin/wol " + @macAddress 
	end

	def backupData
		startTimeMachine
		sleep 60
		while backupInProcess?
			print "."
			sleep 30
		end
    puts ''
	end
  
	def backupInProcess?
		execute_command("ps -ax | grep /CoreServices/[b]ackupd 2>&1") != ""
	end
	
	def startTimeMachine
		execute_command "/System/Library/CoreServices/backupd.bundle/Contents/Resources/backupd-helper"
	end

	def shutdownServer
		execute_command "ssh " + @user + "@" + @serverIP + " sudo shutdown -p now"
	end


end