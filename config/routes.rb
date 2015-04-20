Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'home#index'

  get 'home/index'

  post 'api/signup'
  post 'api/signin'
  post 'api/reset_password'

  post 'api/upload_photo'
  get 'api/get_photos'
  delete 'api/delete_photo'
    
  get 'api/get_token'  
  get 'api/clear_token'
  get 'api/get_user', to:"api#get_user"
  get 'api/get_courses'#1
  get 'api/get_user_attendance_by_course_id'  #4
  get 'api/get_student_list_by_lecture_session_id' #6
  get 'api/get_attended_sessions_by_course_id' #7



  get 'api/get_course_entities'
  get 'api/get_term_start_date'
  get 'api/get_attendees_by_course_id'
  get 'api/get_attendance_count_for_graph'
  post 'api/attend'



  #match "*path", to: "application#page_not_found", via: :all



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # 

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
