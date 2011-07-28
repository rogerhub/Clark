Clark::Application.routes.draw do
  #resources :tests

  root :to => "blog#index"
  match '/:controller(/:action(/:id))',:defaults => {:action => "index", :format => "html"}

  match 'blog', :to => 'blog#index'
  match 'tumblrconnect.js', :to => 'blog#tumblrconnect'
    
  match 'volunteer', :to => 'volunteer#index'
  match 'volunteer/event/:event_id', :to => 'volunteer#showevent'
  match 'volunteer/listing/active', :to => 'volunteer#activelisting'
  match 'volunteer/listing/all/', :to => 'volunteer#alllisting'
  match 'volunteer/listing/archives/:year/:month', :to => 'volunteer#archivelisting'
  match 'volunteer/signup', :to => 'volunteer#signup'
  match 'volunteer/cancel', :to => 'volunteer#cancel'
  match 'volunteer/discuss', :to => 'volunteer#discuss'
  match 'volunteer/editdiscuss', :to => 'volunteer#editdiscuss'
  match 'volunteer/schedule', :to => 'volunteer#seesignups'
  
  match 'people', :to => 'people#index'
  match 'people/profile', :to => 'people#profile'
  match 'people/volunteer/:account_id', :to => 'people#showvolunteer'
  
  match 'login', :to => 'login#index'
  match 'login/do', :to => 'login#do'
  match 'login/out', :to => 'login#out'
  match 'login/forgot', :to => 'login#forgot'  
  match 'login/forgottendo', :to => 'login#forgottendo'
  
  match 'settings/firstlogin', :to => 'settings#firstlogin'
  match 'settings/profilecheck', :to => 'settings#profilecheck'
  
  match 'settings', :to => 'settings#index'
  match 'settings/changecontact', :to => 'settings#changecontact'
  match 'settings/changeemail', :to => 'settings#changeemail'
  match 'settings/changephone', :to => 'settings#changephone'
  match 'settings/changeprivacy', :to => 'settings#changeprivacy'
  match 'settings/uploadpicture', :to => 'settings#uploadpicture'
  match 'settings/changepassword', :to => 'settings#changepassword'
  
  match 'leadership', :to => 'leadership#index'
  match 'leadership/listevents', :to => 'leadership#listevents'
  match 'leadership/newevent', :to => 'leadership#newevent'
  match 'leadership/newevent_do', :to => 'leadership#newevent_do'
  match 'leadership/processtags', :to => 'leadership#processtags'
  match 'leadership/editevent', :to => 'leadership#editevent'
  match 'leadership/editevent_do', :to => 'leadership#editevent_do'
  match 'leadership/managesignups', :to => 'leadership#managesignups'
  match 'leadership/managesignups_do', :to => 'leadership#managesignups_do'
  match 'leadership/exportsignups', :to => 'leadership#exportsignups'
  match 'leadership/addvolunteer', :to => 'leadership#addvolunteer'
  match 'leadership/adddonation', :to => 'leadership#adddonation'
  match 'leadership/deletedonation', :to => 'leadership#deletedonation'
  match 'leadership/deleteevent', :to => 'leadership#deleteevent'
  
  match 'leadership/listaccounts', :to => 'leadership#listaccounts'
  match 'leadership/newaccount', :to => 'leadership#newaccount'
  match 'leadership/newaccount_do', :to => 'leadership#newaccount_do'
  match 'leadership/editaccount', :to => 'leadership#editaccount'
  match 'leadership/editaccount_do', :to => 'leadership#editaccount_do'
  match 'leadership/deleteaccount', :to => 'leadership#deleteaccount'
  
  match 'leadership/changesemester', :to => 'leadership#changesemester'
  match 'leadership/definesemesters', :to => 'leadership#definesemesters'
  match 'leadership/changetumblrurl', :to => 'leadership#changetumblrurl'
  match 'leadership/changevolunteermotivation', :to => 'leadership#changevolunteermotivation'
  match 'leadership/changevolunteerpolicy', :to => 'leadership#changevolunteerpolicy'
  match 'leadership/changevolunteerdonationticket', :to => 'leadership#changevolunteerdonationticket'
  match 'leadership/changepeoplemotivation', :to => 'leadership#changepeoplemotivation'
  match 'leadership/changenhsemail', :to => 'leadership#changenhsemail'
  match 'leadership/changeannouncements', :to => 'leadership#changeannouncements'
  match 'leadership/reloadtaglist', :to => 'leadership#reloadtaglist'
  match 'leadership/editaboutnhs', :to => 'leadership#editaboutnhs'
  match 'leadership/editsubmitguidelines', :to => 'leadership#editsubmitguidelines'
  
  
  match 'leadership/listbackups', :to => 'leadership#listbackups'
  match 'leadership/runbackup', :to => 'leadership#runbackup'
  match 'leadership/downloadbackup', :to => 'leadership#downloadbackup'
  match 'leadership/deletebackup', :to => 'leadership#deletebackup'
  
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
