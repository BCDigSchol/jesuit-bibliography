# README

## Development dependencies

### Java 
Rails requires Java version 8 or higher.

Be sure the `JAVA_HOME` environmental variable is set.

### Postgres

#### Install

TK

### Solr

#### Install
Install the most recent [Solr](http://lucene.apache.org/solr/) 7.x version through the [official package installer](http://lucene.apache.org/solr/downloads.html) or through the local system package manager, e.g., [brew](https://formulae.brew.sh/formula/solr).

#### Add new core
Once installed, add a new `blacklight-core` core.

```solr create -c blacklight-core```

#### Use custom solr config files
Copy the following config files to the `blacklight-core` directory.

```cp /path/to/project/jesuit-bibligraphy/solr/blacklight-core/conf/* /path/to/solr/7.5.0/server/solr/blacklight-core/conf/```

Then restart solr.

```solr restart```

## Rails environmental variables
Add the following to your `~/.bashrc`, `~/.profile` or `~/.bash_profile` file.

This only needs to be done once.

Add `SECRET_KEY_BASE`

```echo 'export SECRET_KEY_BASE="abcdef...7890"' >> ~/.bash_profile```

Add `RAILS_ENV`

```echo 'export RAILS_ENV="development"' >> ~/.bash_profile```

Activate the new environment variables in your current shell.

```source ~/.bash_profile```

Add `SOLR_CONF_HOME`

```echo 'export SOLR_CONF_HOME="/path/to/solr/blacklight-core/conf"' >> ~/.bash_profile```

| **Hint** |
| -------- |
| if you used `brew` to install Solr then `SOLR_CONF_HOME` should be `/usr/local/Cellar/solr/7.5.0/server/solr/blacklight-core/conf` |

## Useful import commands for development

### Drop the local database
```rake db:drop```

### Rebuild the database with all the migrations
```rake db:migrate```

### Import test users:
```rake import:users```

### Import set of sample records
```rake importdata:books```

```rake importdata:book_chapters```

### Import all sample records
```rake importdata:all```

### Clear all Bibliograhy records
```rake importdata:clear_all```

### Update local Solr instance with project config files ([see this directory](solr/blacklight-core/conf).)
```rake solr_config:update```

### Restart local Solr instance
```solr restart```

## Solr indexing
Use the Rails [sunspot](https://github.com/sunspot/sunspot) gem to index all the Bibliography records.

```rake sunspot:reindex```

## Going NUCLEAR

Want to completely clear out and restart your local development database? Run the following commands in succession:

```shell
rake solr_config:update
solr restart
rake db:drop
rake db:migrate
rake import:users
rake importdata:all
rake sunspot:reindex
```

## Deployment

Make sure you have access to the production server. To deploy master to production:

```shell
cap production deploy
cap production deploy:solr:reindex   # if Solr needs reindexing
cap production deploy:db:reset       # if the database needs to be rebuilt


```