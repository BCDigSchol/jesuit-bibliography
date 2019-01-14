Rails.application.routes.draw do

  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  get "/dashboard/" => "dashboard#index"

  resources :manage_users, only: [:index, :show, :edit, :update], path: '/dashboard/users'
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # custom path for displaying records created by signed-in user
  get '/citations/mine' => 'bibliographies#mine'

  # custom path for displaying records containing pending suggesitions
  get '/citations/terms/suggestions' => 'bibliographies#suggestions'

  # custom path for displaying all records
  # this is effectively the same as /citations  
  get '/citations/all' => 'bibliographies#index'

  # get paths like "/citations/1"
  resources :bibliographies, path: '/citations' do
    root to: redirect('/citations/mine')
    resources :comments
    resources :standard_identifiers
    #resources :languages
    resources :reviewed_components
    resources :publishers
    resources :publish_places
    resources :dissertation_universities
    resources :series_multimedias
    resources :tags
    resources :subject_suggestions
    resources :location_suggestions
    resources :entity_suggestions
    resources :period_suggestions
    resources :language_suggestions
    resources :journal_suggestions
    resources :authors
    resources :editors
    resources :book_editors
    resources :author_of_reviews
    resources :performers
    resources :translated_authors
  end

  # get paths like "/citations/terms/subject/1"
  namespace :citationterms, path: '/citations/terms' do
    resources :subjects, path: 'subjects'
    resources :entities, path: 'jesuits'
    resources :periods, path: 'centuries'
    resources :locations, path: 'locations'
    resources :languages, path: 'languages'
    resources :people, path: 'people'
    resources :journals, path: 'journals'
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
  mount BlacklightAdvancedSearch::Engine => '/'

  Blacklight::Marc.add_routes(self)
  # custom action for root
  # root to: "catalog#index"
  root to: "catalog#job_home"
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
    concerns :range_searchable

  end
  devise_for :users, controllers: { registrations: 'registrations' }
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
