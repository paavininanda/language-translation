# Setting up periodic backup for Photo Language Translation rails application
# READ THROUGH THIS SCRIPT BEFORE SETTING UP THE BACKUP
#
#	BACKUP SETUP
#
# Install 'backup' gem
echo "Install backup gem for multiple server backup configuration with mail notification"
read -r -p "Do you want to proceed ? [y/n] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  echo "Installing backup gem..."
  gem install backup
fi

# Generate config file and model to initialize params
# For more info :
# $ backup help generate:model

# Usage:
#   backup generate:model -t, --trigger=TRIGGER

# Options:
#   -t, --trigger=TRIGGER            # Trigger name for the Backup model
#       [--config-file=CONFIG_FILE]  # Path to your Backup configuration file
#       [--databases=DATABASES]      # (mongodb, mysql, openldap, postgresql, redis, riak, sqlite)
#       [--storages=STORAGES]        # (cloud_files, dropbox, ftp, local, qiniu, rsync, s3, scp, sftp)
#       [--syncers=SYNCERS]          # (cloud_files, rsync_local, rsync_pull, rsync_push, s3)
#       [--encryptor=ENCRYPTOR]      # (gpg, openssl)
#       [--compressor=COMPRESSOR]    # (bzip2, custom, gzip)
#       [--notifiers=NOTIFIERS]      # (campfire, command, datadog, flowdock, hipchat, http_post, mail, nagios, pagerduty, prowl, pushover, ses, slack, twitter)
#       [--archives]                 # Model will include tar archives.
#       [--splitter]                 # Add Splitter to the model

# Description:
#   Generates a Backup model file.

#   If your configuration file is not in the default location at /Users/<user_name>/Backup/config.rb
#   you must specify it's location using '--config-file'. If no configuration file exists at
#   this location, one will be created.

#   The model file will be created as '<config_path>/models/<trigger>.rb' Your model file will
#   be created in a 'models/' sub-directory where your config file is located. The default
#   location would be: /Users/<user_name>/Backup/models/<trigger>.rb

echo "The backup file will be compressed in gzip format."
read -r -p "Generate backup gem configuration file for language-translation on current system with email notification ? [y/n] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
	backup generate:model --trigger='systers_plt_db_backup' --databases='postgresql' --compressor='gzip' --notifiers='mail'
fi

#
#	DATABASE BACKUP CONFIG
#
# This will generate a directory called Backup at ~/Backup
# Navigate to ~/Backup/models/ to find systers_plt_db_backup_s3.rb and systers_plt_db_backup_scp.rb files
# Setup the PostgreSQL database. (Refer config/database.yml for more info on the server config details)
# The details for the above depend on how PostgreSQL is setup on the VM
# The lines, db.skip_tables and db.only_tables can be commented out, if there aren't any restrictions on what tables to be backed up from the admin end
# For PostgreSQL backup config update (~/Backup/models/systers_plt_db_backup_s3.rb AND ~/Backup/models/systers_plt_db_backup_scp.rb):
# i.e.
  # database PostgreSQL do |db|
  #   # To dump all databases, set `db.name = :all` (or leave blank)
  #   db.name               = "PLT_production"
  #   db.username           = "my_username"
  #   db.password           = "my_password"
  #   db.host               = "localhost"
  #   db.port               = 5432
  #   db.socket             = "/tmp/pg.sock"
  #   # When dumping all databases, `skip_tables` and `only_tables` are ignored.
  #   # db.skip_tables        = ["skip", "these", "tables"]
  #   # db.only_tables        = ["only", "these", "tables"]
  #   db.additional_options = ["-xc", "-E=utf8"]
  # end

#
#	MAILER NOTIFICATION CONFIG
#
# To setup a mailer for notification, configure the mailer (in the mail notifier section)
# Alternatively, you can use SendGrid SMTP and get the necessary details like user_name, password, address (smtp.sendgrid.net) etc. 
# The rest can be filled based on admin's needs
# i.e.
  # notify_by Mail do |mail|
  #   mail.on_success           = true
  #   mail.on_warning           = true
  #   mail.on_failure           = true
  #   mail.from                 = "sender@email.com"
  #   mail.to                   = "receiver@email.com"
  #   mail.cc                   = "cc@email.com"
  #   mail.bcc                  = "bcc@email.com"
  #   mail.reply_to             = "reply_to@email.com"
  #   mail.address              = "smtp.gmail.com"
  #   mail.port                 = 587
  #   mail.domain               = "your.host.name"
  #   mail.user_name            = "sender@email.com"
  #   mail.password             = "my_password"
  #   mail.authentication       = "plain"
  #   mail.encryption           = :starttls
  # end

read -r -p "Have you updated the systers_plt_db_backup.rb.example file in the language-translation/backup directory ? [y/n] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
	echo "Updating the backup gem database and mailer configuration file..."
	cat systers_plt_db_backup.rb.example > ~/Backup/models/systers_plt_db_backup.rb
	echo "Updated database and mailer configuration."
else
  echo "Update the database and mailer configuration file before proceeding."
  exit 0
fi

#
#	BACKUP COMMAND
#
read -r -p "Do you want to perform a backup now ? [y/n] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
	echo "Performing backup now..."
	backup perform -t systers_plt_db_backup
else
  echo "Backup not performed. Backup setup complete."
fi