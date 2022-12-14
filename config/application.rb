require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.time_zone = "Asia/Tokyo"
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        if Rails.env.production?
          origins ENV.fetch("FRONTEND_ORIGIN")
        else
          origins "http://localhost:3000", "http://192.168.0.8:3000", "http://192.168.0.10:3000"
        end
        resource "*",
                 headers: :any,
                 methods: [:get, :post, :options, :head, :patch, :delete],
                 credentials: true
      end
    end

    config.i18n.default_locale = :ja

    config.api_only = true
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use ActionDispatch::ContentSecurityPolicy::Middleware
  end
end
