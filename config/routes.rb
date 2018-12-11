Rails.application.routes.draw do

  get "/dashboard/" => "dashboard#index"
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # get paths like "/citations/1"
  resources :bibliographies, path: '/citations' do
    resources :comments
    resources :standard_identifiers
    resources :citations
    resources :languages
    resources :reviewed_components
  end

  # get paths like "/citations/terms/subject/1"
  namespace :citationterms, path: '/citations/terms' do
    resources :subjects, path: 'subjects'
    resources :entities, path: 'jesuits'
    resources :periods, path: 'centuries'
    resources :locations, path: 'locations'
  end

  get '/form_partial/:id/:reference_type' => 'bibliographies#form_partial'


  namespace :terms do
    root to: redirect('/')
    resources :entities, only: [:index], path: 'jesuits'
    resources :locations, only: [:index], path: 'locations'
    resources :subjects, only: [:index], path: 'subjects'
    resources :periods, only: [:index], path: 'centuries'
  end


  mount Blacklight::Engine => '/'
  Blacklight::Marc.add_routes(self)
  root to: "catalog#index"
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end
  devise_for :users
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
