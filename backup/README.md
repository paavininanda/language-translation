# Data Backup for Photo Language Translation

* Update/Verify the configuration details in systers_plt_db_backup.rb.example before proceeding. These configurations are the ones which will be used to setup the backup in production server.

* Modify the backup time based on need in crontab_setup.sh file

* Mailer option has also been provided through SMTP to send notification in case there's any failure.

* Once you are in the backup directory of language-translation, execute the following in order :
  1. `./backup_setup.sh`
  2. `./crontab_setup.sh`