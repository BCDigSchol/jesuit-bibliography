# README

## Development dependencies

### Java 
Rails requires Java version 8 or higher.

Be sure the `JAVA_HOME` environmental variable is set.

### Postgres

#### Install

On macOS: 

```shell
brew install postgres
```

#### Set up user account

On macOS: 

```shell
psql postgres
```

```sql
CREATE user blacklight WITH PASSWORD 'password';
ALTER user blacklight createdb;
CREATE DATABASE jesuit_bibliography_development WITH ENCODING='UTF8' OWNER='blacklight';
```

### Solr

#### Install
Install the most recent [Solr](https://solr.apache.org/) 8.x version through the [official package installer](https://solr.apache.org/downloads.html) or through the local system package manager, e.g., [brew](https://formulae.brew.sh/formula/solr).

#### Add new core
Once installed, add a new `blacklight-core` core.

```shell
/path/to/solr-install/bin/solr create -c blacklight-core
```

#### Use custom Solr config files
Copy the following config files to the `blacklight-core` directory.

```shell
cp /path/to/project/jesuit-bibligraphy/solr/blacklight-core/conf/* /path/to/solr/8.8.2/server/solr/blacklight-core/conf/
```

Then restart Solr.

```shell
/path/to/solr-install/bin/solr restart
```

## Generate Rails SECRET_KEY_BASE

This command will generate a unique and secure string, which will be used for environment's SECRET_KEY_BASE value.

```shell
rake -T secret
```

## Rails environmental variables
Add the following to your `~/.bashrc`, `~/.profile`, `~/.zshrc` or `~/.bash_profile` file.

```shell
export SECRET_KEY_BASE="abcdef...7890"
export RAILS_ENV="development"
export SOLR_URL=http://localhost:8983/solr/blacklight-core
export SOLR_CONF_HOME=/path/to/solr-install/server/solr/blacklight-core/conf
export TEST_ACCOUNT_PASSWORD=password
```

Activate the new environment variables in your current shell.

```shell
source ~/.bash_profile
```


| **Hint** |
| -------- |
| if you used `brew` to install Solr then `SOLR_CONF_HOME` should be similar to `/usr/local/Cellar/solr/8.8.2/server/solr/blacklight-core/conf` |

## Useful import commands for development

### Drop the local database
```shell
rake db:drop
```

### Rebuild the database with all the migrations
```shell
rake db:migrate
```

### Import test users:
```shell
rake import:users
```

| **Warning** |
| -------- |
| The `import:pages` task will create the static page records if they do not already exist. This task will not overwrite existing records. |

### Import default static pages
To load all the static 'About' pages into the app.

```shell
rake import:pages
```

### Import test users and default static pages
```shell
rake import:all
```

| **Warning** |
| -------- |
| All `importdata` tasks are interactive and will require user interaction to run. |

### Seed Thesis Types:
Seed the database with a set of default thesis_types.

```shell
rake db:seed
```

#### Reseed Thesis Types:
```shell
rake db:seed:replant
```

### Import set of sample records
```shell
rake importdata:books
```

```shell
rake importdata:book_chapters
```

### Import all sample records (and create their citations)
```shell
rake importdata:all
```

### Clear all Bibliograhy records
```shell
rake importdata:clear_all
```

### Update local Solr instance with project config files ([see this directory](solr/blacklight-core/conf).)
```shell
rake solr_config:update
```

### Restart local Solr instance
```shell
/path/to/solr-install/bin/solr restart
```

### Solr indexing
Use the Rails [sunspot](https://github.com/sunspot/sunspot) gem to index all the Bibliography records.

```shell
rake sunspot:reindex
```

### Rebuild citations
We have a separate task to (re)build the citations for all citation records in the database.

| **Warning** |
| -------- |
| This task will take a while to complete! |

```shell
rake importdata:generate_citations
```

### Make DB backups

```shell
rake db:dump:all                       # dump all database tables; saves with name format `20210617_jesuit_bibliography_development_development.sql`
rake db:dump:table                     # dump a specific database table
rake db:dump:restore pattern=20210617  # restore a specific db backup; note the pattern parameter
rake db:dump:list                      # list all db backups
```


### Going NUCLEAR

Want to completely clear out and restart your local development database? Run the following commands in succession:

```shell
rake solr_config:update    # update Solr config
solr restart               # restart Solr instance
rake solr_config:dropall   # drop all records from Solr instance
rake db:reset              # runs the following commands: `db:drop` and  `db:create` and  `db:migrate`
rake db:seed               # seed the thesis types
rake import:all            # import sample users and sample static pages
rake importdata:all        # import 2635 sample bib records
rake sunspot:reindex       # reindex Solr
```

## Deployment to Staging

1. Update the [staging.rb](config/deploy/staging.rb) config file `:branch` parameter with your staging branch name. The default branch name is `staging`.

2. Update `credentials.yml.enc`
```shell
EDITOR=vim rails credentials:edit
```

The file will look similar to this:
```shell
secret_key_base: 01234567890
test_account_password: password

staging:
  secret_key_base: 01234567890
  db_user: blacklight
  db_pass: password
  db_name: staging_database_name
  db_host: localhost

```

3. Add the following env vars to the `/etc/environment` or equivalent file on the staging server:
```shell
export RAILS_ENV=staging
export SOLR_URL=http://localhost:8983/solr/blacklight-core
export SOLR_CONF_HOME=/home/blacklight/apps/bc-jesuit-bibliography/shared/solr-8.8.2/server/solr/blacklight-core/conf
```

4. Copy over the `master.key` file over to the staging server at `/home/blacklight/apps/bc-jesuit-bibliography/shared/config/master.key`

Note: An alternative to using the `master.key` file is to include the following var to `/etc/environment`

```shell
export RAILS_MASTER_KEY=0123456789
```


### Deploy commands

```shell
cap staging deploy                                          # deploy the app and run any new migrations

cap staging deploy:rake task=solr_config:dropall            # drop all records from Solr instance
cap staging deploy:rake task=solr_config:update             # update Solr config  -- alias to `cap staging deploy:solr:update`
cap staging deploy:rake task=sunspot:reindex                # reindex Solr;       -- alias to `cap staging deploy:solr:reindex`

cap staging deploy:rake task=db:drop                        # drop the database   -- better to run `cap staging deploy:db:reset`
cap staging deploy:rake task=db:create                      # create the database -- better to run `cap staging deploy:db:reset`
cap staging deploy:rake task=db:migrate                     # run migrations      -- better to run `cap staging deploy:db:reset`
cap staging deploy:rake task=db:seed                        # seed the thesis types
cap staging deploy:rake task=import:all                     # import sample users and sample static pages
cap staging deploy:rake task=importdata:all_noninteractive  # import 2635 sample bib records
cap staging debug:env                                       # show all env vars that capistrano can access on the staging server

cap staging deploy:rake task=db:dump:all                    # dump all database tables
cap staging deploy:rake task=db:dump:table                  # dump a specific database table
cap staging deploy:rake task="db:dump:restore pattern=foo"  # restore a specific db backup by using a pattern to match an sql dump -- run `cap staging puma:stop` before running, and `cap staging puma:start` after
cap staging deploy:rake task=db:dump:list                   # list all db backups

cap staging deploy:db:reset                                 # clears then rebuilds database with `db:reset` and `db:seed` and `import:all` and `importdata:all_noninteractive`
```

See [staging.rb](config/deploy/staging.rb) for more details on these rake tasks.

### Reindex SOLR index by document reference type

The following deploy commands can be used on any of the following document reference types:
* book
* book_chapter
* book_review
* journal_article
* dissertation
* conference_paper
* multimedia

Reindex all citation records by type.

```shell
cap staging deploy:rake task=solr_config:reindex_by_type:book
```

Update and reindex all citation records by type by type. Note: This command will change the `modified_by` and `updated_at` values for each record.

```shell
cap staging deploy:rake task=solr_config:update_by_type:book
```

See [solr_config.rake](lib/tasks/solr_config.rake) for more details on these rake tasks.

### Restart Solr

Log into the staging server and run:

```shell
cd /home/blacklight/apps/bc-jesuit-bibliography/shared/solr-8.8.2/
./bin/solr [restart|stop|start]
```

or

```shell
sudo systemctl restart solr
```

## Deployment to Production

Make sure you have access to the production server. To deploy master to production:

```shell
cap production deploy                # deploy the app and run any new migrations
cap production deploy:solr:update    # update Solr config
cap production deploy:solr:reindex   # reindex Solr
```