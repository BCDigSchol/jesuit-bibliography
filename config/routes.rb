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

  # piggybacking on citationterms search controller for citation records
  get '/citations/search' => 'term_search#index'

  resources :staticpages

  get '/api/updated' => 'api#list_updated'
  get '/api/all' => 'api#all'

  get "/featuredrecords/all" => 'featuredrecords#load_all', as: 'featuredrecords_all'
  resources :featuredrecords

  namespace :about, path: '/about' do
    # root goes to dedicated home page record
    get "/" => '/staticpages#load_page', slug: :home, as: 'home_page'
    get "/:slug" => '/staticpages#load_page', as: 'page'
  end

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
    resources :bib, only: [:index], controller: "bib", action: "raw"
    resources :mla, only: [:index], controller: "bib", action: "mla"
    resources :chicago, only: [:index], controller: "bib", action: "chicago"
    resources :turabian, only: [:index], controller: "bib", action: "turabian"
  end

  # get paths like "/citations/terms/subject/1"
  namespace :citationterms, path: '/citations/terms' do
    resources :subjects, path: 'subjects' do
      get 'references', on: :member
    end
    resources :entities, path: 'jesuits' do
      get 'references', on: :member
    end
    resources :periods, path: 'centuries' do
      get 'references', on: :member
    end
    resources :locations, path: 'locations' do
      get 'references', on: :member
    end
    resources :languages, path: 'languages' do
      get 'references', on: :member
    end
    resources :people, path: 'people' do
      get 'references', on: :member
    end
    resources :journals, path: 'journals' do
      get 'references', on: :member
    end
    get 'search' => 'term_search#index'
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
