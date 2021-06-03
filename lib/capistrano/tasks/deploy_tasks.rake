namespace :deploy do
    namespace :solr do
        desc 'update solr'
        task :update do
            core_name = 'blacklight-core'
            local_solr_path = "#{current_path}/solr"
            modified_conf = "#{local_solr_path}/blacklight-core/conf"
            solr_instance_dir = "/var/solr/data/#{core_name}"
            on roles(:app) do
                within "#{current_path}" do
                    execute :rake, 'solr_config:update'
                    execute "curl http://localhost:8983/solr/admin/cores?action=RELOAD&core=#{core_name}"
                end
            end
        end
        
        desc 'update and reindex solr'
        task :reindex do
            invoke "deploy:solr:update"
            on roles(:app) do
                within "#{current_path}" do
                    execute :rake, 'sunspot:solr:reindex'
                end
            end
        end
    end
end