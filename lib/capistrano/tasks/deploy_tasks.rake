namespace :deploy do
    namespace :db do
        desc 'update and reimport database'
        task :reset do
            on roles(:db) do
                within "#{current_path}" do
                    execute :rake, 'db:reset DISABLE_DATABASE_ENVIRONMENT_CHECK=1'
                    execute :rake, 'import:all'
                    execute :rake, 'importdata:all'
                end
            end
        end
    end

    namespace :solr do
        desc 'update and reindex solr'
        task :reindex do
            core_name = 'blacklight-core'
            local_solr_path = "#{current_path}/solr"
            modified_conf = "#{local_solr_path}/blacklight-core/conf"
            solr_instance_dir = "/var/solr/data/#{core_name}"

            on roles(:app) do
                within "#{current_path}" do
                    execute :rake, 'solr_config:update'
                    execute "curl http://localhost:8983/solr/admin/cores?action=RELOAD&core=#{core_name}"
                    execute :rake, 'sunspot:solr:reindex'
                end
            end
        end
    end
end