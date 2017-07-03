require 'active_support'

module ActiveSupport
  class Railtie < Rails::Railtie # :nodoc:
    initializer "active_support.reset_all_current_attributes_instances", before: "active_support.deprecation_behavior" do |app|
      app.executor.to_run      { ActiveSupport::CurrentAttributes.reset_all }
      app.executor.to_complete { ActiveSupport::CurrentAttributes.reset_all }
    end
  end
end
