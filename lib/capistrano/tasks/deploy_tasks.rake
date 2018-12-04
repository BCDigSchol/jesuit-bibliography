namespace :deploy do
    rake_cmd = "RAILS_ENV=#{rails_env} /usr/blacklight/.rbenv/bin/rbenv exec bundle exec rake"

    desc 'update and reimport database'
    task :reimport do
        within "#{current_path}" do
            run "DISABLE_DATABASE_ENVIRONMENT_CHECK=1 #{rake_cmd} db:reset"
            run "#{rake_cmd} import:all"
            run "#{rake_cmd} importdata:books"
        end
    end

    desc 'update and reindex solr'
    task :reindex do
        core_name = 'blacklight-core'
        local_solr_path = "#{current_path}/solr"
        modified_conf = "#{local_solr_path}/blacklight-core/conf"
        solr_instance_dir = "/var/solr/data/#{core_name}"

        within "#{current_path}" do
            run "cp #{modified_conf}/managed-schema #{solr_instance_dir}/conf/schema.xml"
            run "cp #{modified_conf}/* #{solr_instance_dir}/conf/"
            run "http://localhost:8983/solr/admin/cores?action=RELOAD&core=#{core_name}"
            run "#{rake_cmd} sunspot:solr:reindex"
        end
    end
end