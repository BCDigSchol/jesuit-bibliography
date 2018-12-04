namespace :deploy do
    rake_cmd = "RAILS_ENV=production /home/blacklight/.rbenv/bin/rbenv exec bundle exec rake"

    desc 'update and reimport database'
    task :reimport do
        on roles(:all) do
            within "#{current_path}" do
                execute 'ls'
                execute :rake, 'db:reset'
=begin

                execute :rake, 'import:all'
                execute :rake, 'importdata:books'
=end
            end
        end
    end

    desc 'update and reindex solr'
    task :reindex do
        core_name = 'blacklight-core'
        local_solr_path = "#{current_path}/solr"
        modified_conf = "#{local_solr_path}/blacklight-core/conf"
        solr_instance_dir = "/var/solr/data/#{core_name}"

        on roles(:app) do
            within "#{current_path}" do
                execute "cp #{modified_conf}/managed-schema #{solr_instance_dir}/conf/schema.xml"
                execute "cp #{modified_conf}/* #{solr_instance_dir}/conf/"
                execute "http://localhost:8983/solr/admin/cores?action=RELOAD&core=#{core_name}"
                execute "#{rake_cmd} sunspot:solr:reindex"
            end
        end
    end
end