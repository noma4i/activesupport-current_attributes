require 'active_support'

module CurrentAttributesBackport # :nodoc:
  class Middleware # :nodoc:
    def initialize(app)
      @app = app
    end

    def call(env)
      ActiveSupport::CurrentAttributes.clear_all
      status, headers, response = @app.call(env)
      ActiveSupport::CurrentAttributes.clear_all

      [status, headers, response]
    end
  end
end

module ActiveSupport
  class Railtie < Rails::Railtie # :nodoc:
    initializer "active_support.reset_all_current_attributes_instances", before: "active_support.deprecation_behavior" do |app|
      app.middleware.use CurrentAttributesBackport::Middleware

      # app.reloader.before_class_unload { ActiveSupport::CurrentAttributes.clear_all }
      # app.executor.to_run              { ActiveSupport::CurrentAttributes.reset_all }
      # app.executor.to_complete         { ActiveSupport::CurrentAttributes.reset_all }
    end
  end
end
