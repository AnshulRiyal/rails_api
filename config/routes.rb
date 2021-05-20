Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :users do
        resources :articles
      end
      post 'update_doc' => 'merge_files#merge'
    end
  end
end
