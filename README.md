# Introduction
This script saves macos x data onto an remote time machine. 

# The way it works
* check whether the macos is at home. The script continues only in this case.
* wakes the remote time machine up if it is offline
* saves the data if the time machine is available
* shuts down the remote time machine if it was offline

# Howto start the backup
1. clone this repo
2. instantiate the backup class and call the method startBackupProcess in a starterfile. Example content:  
```
backup = Backup.new "00:23:45:87:09:12", "192.168.0.1", "192.168.0.255", "admin", 120,true  
backup.startBackupProcess  
```
3. create a file for the launchd-daemon in the folder ~/Library/LaunchAgents
for example org.mydomain.mybackup.plist Example content:  
```
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
```
4. active the new job: launchctl load ~/Library/LaunchAgents/org.mydomain.mybackup.plist
5. deactivate the automatic time maschine backup

# Dependencies
* ruby
* homebrew formula wol

# My setup
My "time machine" is a freebsd 8.2 with netatalk 2.2.1.
