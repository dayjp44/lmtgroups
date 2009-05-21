ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resources :sessions, :collection => { :recover_password => :any },
                           :member => { :contacted => :get }
  map.resources :site, :member => { :email_coach => :post, 
                                    :profile => :get,
                                    :change_profile => :post,
                                    :attendance_report => :get,
                                    :report_new => :any,
                                    :report_create => :post,
                                    :report_edit => :post,
                                    :report_delete => :get,
                                    :report_update => :post,
                                    :report_view => :get
                                  }

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  
  map.namespace :admin do |admin|
    admin.resources :users
    admin.resources :coaches, :member => { :facilitators => :get, 
                                           :unassign_facilitator => :post, 
                                           :assign_facilitator => :post, 
                                           :notes => :get,
                                           :add_notes => :post,
                                           :create_notes => :post,
                                           :edit_notes => :post,
                                           :update_notes => :post,
                                           :delete_notes => :post,
                                           :facilitator_status => :post,
                                           :facilitator_status_update => :post,
                                           :grading => :get,
                                           :new_grading => :get,
                                           :create_grading => :put,
                                           :edit_grading => :get,
                                           :update_grading => :post,
                                           :delete_grading => :delete
                                          }
    admin.resources :facilitators, :member => { :members => :get, 
                                                :unassign_member => :post, 
                                                :assign_member => :post, 
                                                :member_reports => :get,
                                                :edit_member_report => :post,
                                                :view_member_report => :get }
    admin.resources :groups
    admin.resources :reports
    admin.resources :visitors
    admin.resources :members, :member => { :activate => :any },
                              :collection => { :inactive_members => :get,
                                               :unassigned_members => :get }
    admin.resources :permissions, :collection => { :refresh_permissions => :any }
    admin.resources :roles, :member => { :permissions => :get, :update_permissions => :post }
    admin.resources :site, :member => { :meeting_dates => :get, 
                                        :create_meeting_dates => :post,
                                        :edit_meeting_date => :get,
                                        :delete_meeting_date => :any }
  end
  

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "sessions", :action => "index"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.connect '*path', :controller => "sessions", :action => "index"
end
