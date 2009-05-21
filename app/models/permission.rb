class Permission < ActiveRecord::Base
  has_and_belongs_to_many :roles

  def self.update_all
    controller_hash = {}
    controllers = Dir.new("#{RAILS_ROOT}/app/controllers").entries
    admin_controllers = Dir.new("#{RAILS_ROOT}/app/controllers/admin").entries
    ac = admin_controllers.map{|a| "admin/#{a}"}
    all_controllers = controllers + ac
    all_controllers.each do |controller|
      if controller =~ /_controller/ 
        cont = controller.camelize.gsub(".rb","")
        methods = []
        (eval("#{cont}.new.methods") - 
        ApplicationController.methods - 
        Object.methods -  
        ApplicationController.new.methods).sort.each {|met| 
            methods << met
        }
      end
      controller_hash[cont] = methods
    end
    
    controller_hash.keys.each do |key|
      unless key.nil?
        controller_hash[key].each do |k|
          permission = Permission.find_by_controller_and_action(key, k)
          if permission.nil?
            Permission.create(:controller => key, :action => k)
          end
        end
      end
    end
  end
end
