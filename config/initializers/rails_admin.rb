RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.main_app_name = ["Jesuit Online Bibliography"]

  config.label_methods << :display_name
  config.label_methods << :display_title

  config.model 'Subject' do
    navigation_label 'Terms'
    weight -1
    list do
      field :id
      field :name
    end
    edit do
      field :name
      field :sort_name
    end
  end

  config.model 'Location' do
    navigation_label 'Terms'
    list do
      field :id
      field :name
    end
    edit do
      field :name
      field :sort_name
    end
  end

  config.model 'Entity' do
    navigation_label 'Terms'
    label 'Jesuit'
    label_plural 'Jesuits'
    list do
      field :id
      field :name
    end
    edit do
      field :name
      field :sort_name
    end
  end

  config.model 'Period' do
    navigation_label 'Terms'
    label 'Century'
    label_plural 'Centuries'
    list do
      field :id
      field :name
    end
    edit do
      field :name
      field :sort_name
    end
  end

  config.model 'Bibliography' do
    navigation_label 'All records'
    weight -2
    label 'Citation'
    label_plural 'Citations'
    list do
      #field :id
      #field :reference_type
      #field :display_title
      #field :display_author
      #field :year_published
    end
  end

  config.model 'Citation' do
    parent Bibliography
    label 'Person'
    label_plural 'People'
    list do
      field :id
      field :display_name do
        label "Name"
      end
    end
    edit do
      field :display_name
      field :surname
      field :middlename
      field :forename
      field :title
    end
  end

  config.model 'Comment' do
    parent Bibliography
    list do
      field :id
      field :body
      field :comment_type
      field :make_public
      field :commenter
    end
    edit do
      field :body
      field :comment_type
      field :commenter
      field :make_public
    end
  end

  config.model 'Language' do
    navigation_label 'Terms'
    list do
      field :id
      field :name
    end
    edit do
      field :name
      field :sort_name
    end
  end

  config.model 'ReviewedComponent' do
    parent Bibliography
    list do
      #field :id
      #field :reviewed_author
      #field :reviewed_title
    end
    edit do
      #field :reviewed_author
      #field :reviewed_title
    end
  end

  config.model 'PublishPlace' do
    parent Bibliography
    label 'Place Published'
    label_plural 'Places Published'
  end

  config.model 'Publisher' do
    parent Bibliography
  end

  config.model 'SeriesMultimedium' do
    parent Bibliography
    label 'Multimedia Series'
    label_plural 'Mulitimedia Series'
  end

  config.model 'DissertationUniversity' do
    parent Bibliography
    label 'Dissertation University'
    label_plural 'Dissertation Universities'
  end

  config.model 'Tag' do
    parent Bibliography
  end

  config.model 'EntitySuggestion' do
    navigation_label 'Suggestions'
    label 'Jesuit Suggestion'
    label_plural 'Jesuit Suggestions'
  end

  config.model 'LocationSuggestion' do
    navigation_label 'Suggestions'
    label 'Location Suggestion'
    label_plural 'Location Suggestions'
  end

  config.model 'SubjectSuggestion' do
    navigation_label 'Suggestions'
    label 'Subject Suggestion'
    label_plural 'Subject Suggestions'
  end

  config.model 'PeriodSuggestion' do
    navigation_label 'Suggestions'
    label 'Century Suggestion'
    label_plural 'Century Suggestions'
  end

  

  config.model 'BibliographyEntity' do
    visible false
  end

  config.model 'BibliographyLocation' do
    visible false
  end

  config.model 'BibliographyPeriod' do
    visible false
  end

  config.model 'BibliographySubject' do
    visible false
  end

  config.model 'BibliographyLocation' do
    visible false
  end

  config.model 'Url' do
    visible false
  end

  config.model 'StandardIdentifier' do
    visible false
  end

  config.model 'User' do
    navigation_label 'Edit Accounts'
  end

  config.model 'Search' do
    navigation_label 'Blacklight'
  end

  config.model 'Bookmark' do
    navigation_label 'Blacklight'
  end
end
