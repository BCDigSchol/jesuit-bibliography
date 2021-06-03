# Original source: https://gist.github.com/hopsoft/56ba6f55fe48ad7f8b90
# Merged with: https://gist.github.com/kofronpi/37130f5ed670465b1fe2d170f754f8c6
# Copied from: https://gist.github.com/joelvh/f50b8462611573cf9015e17d491a8a92

namespace :db do

    namespace :dump do
      desc 'Dumps the database to backups'
      task all: :environment do
          dump_fmt   = ensure_format(ENV['format'])
          dump_sfx   = suffix_for_format(dump_fmt)
          backup_dir = backup_directory(Rails.env, create: true)
          full_path  = nil
          cmd        = nil
      
          with_config do |app, host, db, user, pw|
            full_path = "#{backup_dir}/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{db}.#{dump_sfx}"
            # pg_dump on Ubuntu 20.x doesn't use the -o flag
            # cmd       = "pg_dump -F #{dump_fmt} -v -O -o -U '#{user}' -h '#{host}' -d '#{db}' -f '#{full_path}'"
            # export PGPASSWORD to session running pg_dump since it will prompt for a password if it doesn't find PGPASSWORD or ~/.pgpass file
            cmd  = "export PGPASSWORD=#{pw}; pg_dump -F #{dump_fmt} -v -O -U '#{user}' -h '#{host}' -d '#{db}' -f '#{full_path}'"
          end

          puts "Using backup dir: #{backup_dir}"
      
          puts cmd
          system cmd
          puts ''
          puts "Dumped to file: #{full_path}"
          puts ''
      end

      desc 'Dumps a specific table to backups'
      task table: :environment do
        table_name = ENV['table']
        
        if table_name.present?
          dump_fmt   = ensure_format(ENV['format'])
          dump_sfx   = suffix_for_format(dump_fmt)
          backup_dir = backup_directory(Rails.env, create: true)
          full_path  = nil
          cmd        = nil
  
          with_config do |app, host, db, user|
            full_path = "#{backup_dir}/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{db}.#{table_name.parameterize.underscore}.#{dump_sfx}"
            cmd       = "pg_dump -F #{dump_fmt} -v -O -o -U '#{user}' -h '#{host}' -d '#{db}' -t '#{table_name}' -f '#{full_path}'"
          end
  
          puts cmd
          system cmd
          puts ''
          puts "Dumped to file: #{full_path}"
          puts ''
        else
          puts 'Please specify a table name'
        end
      end

      desc 'Show the existing database backups'
      task list: :environment do
        backup_dir = backup_directory
        puts "#{backup_dir}"
        system "/bin/ls -lLtR #{backup_dir}"
      end

      desc 'Restores the database from a backup using PATTERN'
      task restore: :environment do
        pattern = ENV['pattern']
    
        if pattern.present?
          file = nil
          cmd  = nil
    
          with_config do |app, host, db, user, pw|
            backup_dir = backup_directory
            files      = Dir.glob("#{backup_dir}/**/*#{pattern}*")
            
            case files.size
            when 0
              puts "No backups found for the pattern '#{pattern}'"
            when 1
              file = files.first
              fmt  = format_for_file file
    
              case fmt
              when nil
                puts "No recognized dump file suffix: #{file}"
              when 'p'
                cmd = "export PGPASSWORD=#{pw}; psql -U '#{user}' -h '#{host}' -d '#{db}' -f '#{file}'"
              else
                cmd = "export PGPASSWORD=#{pw}; pg_restore -F #{fmt} -v -c -C -U '#{user}' -h '#{host}' -d '#{db}' -f '#{file}'"
              end
            else
              puts "Too many files match the pattern '#{pattern}':"
              puts ' ' + files.join("\n ")
              puts ''
              puts "Try a more specific pattern"
              puts ''
            end
          end
          unless cmd.nil?
            Rake::Task["db:drop"].invoke
            Rake::Task["db:create"].invoke
            puts cmd
            system cmd
            puts ''
            puts "Restored from file: #{file}"
            puts ''
          end
        else
          puts 'Please specify a file pattern for the backup to restore (e.g. timestamp)'
        end
      end
    end
  
    private
  
    def ensure_format(format)
      return format if %w[c p t d].include?(format)
  
      case format
      when 'dump' then 'c'
      when 'sql' then 'p'
      when 'tar' then 't'
      when 'dir' then 'd'
      else 'p'
      end
    end
  
    def suffix_for_format(suffix)
      case suffix
      when 'c' then 'dump'
      when 'p' then 'sql'
      when 't' then 'tar'
      when 'd' then 'dir'
      else nil
      end
    end
  
    def format_for_file(file)
      case file
      when /\.dump$/ then 'c'
      when /\.sql$/  then 'p'
      when /\.dir$/  then 'd'
      when /\.tar$/  then 't'
      else nil
      end
    end
  
    def backup_directory(suffix = nil, create: false)
      backup_dir = File.join(*[Rails.root, 'db/backups', suffix].compact)
  
      if create and not Dir.exists?(backup_dir)
        puts "Creating #{backup_dir} .."
        FileUtils.mkdir_p(backup_dir)
      end
      
      backup_dir
    end
  
    def with_config
        host = ActiveRecord::Base.connection_config[:host]
        db   = ActiveRecord::Base.connection_config[:database]
        user = ActiveRecord::Base.connection_config[:username]
        pw   = ActiveRecord::Base.connection_config[:password]
        
        yield Rails.application.class.parent_name.underscore, host, db, user, pw
    end
  end