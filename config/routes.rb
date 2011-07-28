Clark::Application.routes.draw do
  resources :tests

  root :to => "blog#index"
  
  match 'blog' => 'Blog#index'
  match '/tumblrconnect.js' => 'Blog#tumblrconnect'
    
  match 'volunteer' => 'Volunteer#index'
  match 'volunteer/event/:event_id' => 'Volunteer#showevent'
  match 'volunteer/listing/active' => 'Volunteer#activelisting'
  match 'volunteer/listing/all/' => 'Volunteer#alllisting'
  match 'volunteer/listing/archives/:year/:month' => 'Volunteer#archivelisting'
  match 'volunteer/signup' => 'Volunteer#signup'
  match 'volunteer/cancel' => 'Volunteer#cancel'
  match 'volunteer/discuss' => 'Volunteer#discuss'
  match 'volunteer/editdiscuss' => 'Volunteer#editdiscuss'
  match 'volunteer/schedule' => 'Volunteer#seesignups'
  
  match 'people' => 'People#index'
  match 'people/profile' => 'People#profile'
  match 'people/volunteer/:account_id' => 'People#showvolunteer'
  
  match 'login' => 'Login#index'
  match 'login/do' => 'Login#do'
  match 'login/out' => 'Login#out'
  match 'login/forgot' => 'Login#forgot'  
  match 'login/forgottendo' => 'Login#forgottendo'
  
  match 'settings/firstlogin' => 'Settings#firstlogin'
  match 'settings/profilecheck' => 'Settings#profilecheck'
  
  match 'settings' => 'Settings#index'
  match 'settings/changecontact' => 'Settings#changecontact'
  match 'settings/changeemail' => 'Settings#changeemail'
  match 'settings/changephone' => 'Settings#changephone'
  match 'settings/changeprivacy' => 'Settings#changeprivacy'
  match 'settings/uploadpicture' => 'Settings#uploadpicture'
  match 'settings/changepassword' => 'Settings#changepassword'
  
  match 'leadership' => 'Leadership#index'
  match 'leadership/listevents' => 'Leadership#listevents'
  match 'leadership/newevent' => 'Leadership#newevent'
  match 'leadership/newevent_do' => 'Leadership#newevent_do'
  match 'leadership/processtags' => 'Leadership#processtags'
  match 'leadership/editevent' => 'Leadership#editevent'
  match 'leadership/editevent_do' => 'Leadership#editevent_do'
  match 'leadership/managesignups' => 'Leadership#managesignups'
  match 'leadership/managesignups_do' => 'Leadership#managesignups_do'
  match 'leadership/exportsignups' => 'Leadership#exportsignups'
  match 'leadership/addvolunteer' => 'Leadership#addvolunteer'
  match 'leadership/adddonation' => 'Leadership#adddonation'
  match 'leadership/deletedonation' => 'Leadership#deletedonation'
  match 'leadership/deleteevent' => 'Leadership#deleteevent'
  
  match 'leadership/listaccounts' => 'Leadership#listaccounts'
  match 'leadership/newaccount' => 'Leadership#newaccount'
  match 'leadership/newaccount_do' => 'Leadership#newaccount_do'
  match 'leadership/editaccount' => 'Leadership#editaccount'
  match 'leadership/editaccount_do' => 'Leadership#editaccount_do'
  match 'leadership/deleteaccount' => 'Leadership#deleteaccount'
  
  match 'leadership/changesemester' => 'Leadership#changesemester'
  match 'leadership/definesemesters' => 'Leadership#definesemesters'
  match 'leadership/changetumblrurl' => 'Leadership#changetumblrurl'
  match 'leadership/changevolunteermotivation' => 'Leadership#changevolunteermotivation'
  match 'leadership/changevolunteerpolicy' => 'Leadership#changevolunteerpolicy'
  match 'leadership/changevolunteerdonationticket' => 'Leadership#changevolunteerdonationticket'
  match 'leadership/changepeoplemotivation' => 'Leadership#changepeoplemotivation'
  match 'leadership/changenhsemail' => 'Leadership#changenhsemail'
  match 'leadership/changeannouncements' => 'Leadership#changeannouncements'
  match 'leadership/reloadtaglist' => 'Leadership#reloadtaglist'
  match 'leadership/editaboutnhs' => 'Leadership#editaboutnhs'
  match 'leadership/editsubmitguidelines' => 'Leadership#editsubmitguidelines'
  
  
  match 'leadership/listbackups' => 'Leadership#listbackups'
  match 'leadership/runbackup' => 'Leadership#runbackup'
  match 'leadership/downloadbackup' => 'Leadership#downloadbackup'
  match 'leadership/deletebackup' => 'Leadership#deletebackup'
  #match 'account/new' => 'Accounts#new'
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
