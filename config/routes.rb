Clark::Application.routes.draw do
  #resources :tests

  root :to => "blog#index"

  match 'blog' =>'blog#index'
  match 'tumblrconnect.js' =>'blog#tumblrconnect'
    
  match 'volunteer' =>'volunteer#index'
  match 'volunteer/event/:event_id' =>'volunteer#showevent'
  match 'volunteer/listing/active' =>'volunteer#activelisting'
  match 'volunteer/listing/all/' =>'volunteer#alllisting'
  match 'volunteer/listing/archives/:year/:month' =>'volunteer#archivelisting'
  match 'volunteer/signup' =>'volunteer#signup'
  match 'volunteer/cancel' =>'volunteer#cancel'
  match 'volunteer/discuss' =>'volunteer#discuss'
  match 'volunteer/editdiscuss' =>'volunteer#editdiscuss'
  match 'volunteer/schedule' =>'volunteer#seesignups'
  
  match 'people' =>'people#index'
  match 'people/profile' =>'people#profile'
  match 'people/volunteer/:account_id' =>'people#showvolunteer'
  
  match 'login' =>'login#index'
  match 'login/do' =>'login#do'
  match 'login/out' =>'login#out'
  match 'login/forgot' =>'login#forgot'  
  match 'login/forgottendo' =>'login#forgottendo'
  match 'login/reset' => 'login#reset'
  match 'login/resetdo' => 'login#resetdo'
  match 'login/success' => 'login#success'
  
  match 'settings/firstlogin' =>'settings#firstlogin'
  match 'settings/profilecheck' =>'settings#profilecheck'
  
  match 'settings' =>'settings#index'
  match 'settings/changecontact' =>'settings#changecontact'
  match 'settings/changeemail' =>'settings#changeemail'
  match 'settings/changephone' =>'settings#changephone'
  match 'settings/changeprivacy' =>'settings#changeprivacy'
  match 'settings/uploadpicture' =>'settings#uploadpicture'
  match 'settings/changepassword' =>'settings#changepassword'
  match 'settings/logoutall' =>'settings#logoutall'
  
  match 'leadership' =>'leadership#index'
  match 'leadership/listevents' =>'leadership#listevents'
  match 'leadership/newevent' =>'leadership#newevent'
  match 'leadership/newevent_do' =>'leadership#newevent_do'
  match 'leadership/processtags' =>'leadership#processtags'
  match 'leadership/editevent' =>'leadership#editevent'
  match 'leadership/editevent_do' =>'leadership#editevent_do'
  match 'leadership/managesignups' =>'leadership#managesignups'
  match 'leadership/managesignups_do' =>'leadership#managesignups_do'
  match 'leadership/exportsignups' =>'leadership#exportsignups'
  match 'leadership/addvolunteer' =>'leadership#addvolunteer'
  match 'leadership/adddonation' =>'leadership#adddonation'
  match 'leadership/deletedonation' =>'leadership#deletedonation'
  match 'leadership/deleteevent' =>'leadership#deleteevent'
  
  match 'leadership/listaccounts' =>'leadership#listaccounts'
  match 'leadership/newaccount' =>'leadership#newaccount'
  match 'leadership/newaccount_do' =>'leadership#newaccount_do'
  match 'leadership/editaccount' =>'leadership#editaccount'
  match 'leadership/editaccount_do' =>'leadership#editaccount_do'
  match 'leadership/deleteaccount' =>'leadership#deleteaccount'
  
  match 'leadership/changesemester' =>'leadership#changesemester'
  match 'leadership/definesemesters' =>'leadership#definesemesters'
  match 'leadership/changetumblrurl' =>'leadership#changetumblrurl'
  match 'leadership/changevolunteermotivation' =>'leadership#changevolunteermotivation'
  match 'leadership/changevolunteerpolicy' =>'leadership#changevolunteerpolicy'
  match 'leadership/changevolunteerdonationticket' =>'leadership#changevolunteerdonationticket'
  match 'leadership/changepeoplemotivation' =>'leadership#changepeoplemotivation'
  match 'leadership/changenhsemail' =>'leadership#changenhsemail'
  match 'leadership/changeannouncements' =>'leadership#changeannouncements'
  match 'leadership/reloadtaglist' =>'leadership#reloadtaglist'
  match 'leadership/editaboutnhs' =>'leadership#editaboutnhs'
  match 'leadership/editsubmitguidelines' =>'leadership#editsubmitguidelines'
  match 'leadership/editvolunteerannouncement' =>'leadership#editvolunteerannouncement'
  
  
  match 'leadership/listbackups' =>'leadership#listbackups'
  match 'leadership/runbackup' =>'leadership#runbackup'
  match 'leadership/downloadbackup' =>'leadership#downloadbackup'
  match 'leadership/deletebackup' =>'leadership#deletebackup'
  
  match 'bypass' => 'people#bypass'

	match ':q' => 'people#showvolunteer'
  
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
