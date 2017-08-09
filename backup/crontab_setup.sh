
#
#	SCHEDULER SETUP
#
# To perform a backup periodically everyday at a specific time, we need to set up a cron job.
# To ease our work, we can use 'whenever' gem
cd ~/Backup
mkdir config

echo "Install whenever gem for easy crontab update"
read -r -p "Do you want to proceed ? [y/n] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
	echo "Installing whenever gem..."
	gem install whenever
fi

echo "Setting up whenever gem"
wheneverize .

# This will create a file called schedule.rb (~/Backup/config/schedule.rb) which will have the ruby code we write to schedule a cron job

# The below code is written to take backup everyday at 11:30 pm (can be modified based on admin's needs)
# Replace the code below in ~/Backup/config/schedule.rb

read -r -p "Have you updated the schedule.rb.example file in the language-translation/backup directory ? [y/n] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
	echo "Updating the scheduler cron job for wheneverize..."
	# MODIFY NEXT LINE BASED ON NEED (BACKUP TIME)
	echo 'every 1.day, :at => "11:30 pm" do
  command "backup perform -t systers_plt_db_backup"
end'  > ~/Backup/config/schedule.rb
	echo "Updated wheneverize schedule.rb configuration."
fi

#
#	SCHEDULER COMMAND
#
# To actually run the cronjob:
echo "The cron job is now set, but not activated."
read -r -p "Do you want to initiate the cron job ? [y/n] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
	echo "Initiating cron job..."
	whenever --update-crontab
	echo "The backup will be initiated everyday at the time specified in this script."
else
	echo "Crontab not initiated. Backup automation setup complete."
	echo "To initiate crontab, run 'whenever --update-crontab'"
fi

# That's it! You are good to go. The database will now be backed up every day at the specified time.