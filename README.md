# Introduction
This script saves macos x data onto an remote time machine. 

# The way it works
* check whether the macos is at home. The script continues only in this case.
* wakes the remote time machine up if it is offline
* saves the data if the time machine is available
* shuts down the remote time machine if it was offline

# Howto start the backup
* clone this repo
* instantiate the backup class and call the method startBackupProcess in a starterfile. Example:  

##
    backup = Backup.new "00:23:45:87:09:12", "192.168.0.1", "192.168.0.255", "admin", 120, true  
    backup.startBackupProcess  
* create a file for the launchd-daemon in the folder ~/Library/LaunchAgents
 example org.mydomain.mybackup.plist Example:

##
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    	<dict>
    		<key>Label</key>
    		<string>org.mydomain.mybackup</string>
    		<key>ProgramArguments</key>
    		<array>
    			<string>/Users/joscha/backupStarter.rb</string>
    		</array>
    		<key>StartInterval</key>
    		<integer>3600</integer>
    		<key>StandardErrorPath</key>
    		<string>/Users/joscha/backupError</string>
    		<key>StandardOutPath</key>
    		<string>/Users/joscha/backupOutput</string>
    	</dict>
    </plist>
* active the new job. Example: 

##
    launchctl load ~/Library/LaunchAgents/org.mydomain.mybackup.plist
* deactivate the automatic time maschine backup

# Dependencies
* ruby
* homebrew formula wol

# My setup
My "time machine" is a freebsd 8.2 with netatalk 2.2.1.
