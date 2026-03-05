Rails.application.config.assets.precompile << "bootstrap.bundle.min.js"
Rails.application.config.assets.precompile << "application.css"
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap/dist/js")
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/font")
# Rails.application.config.assets.precompile << "bootstrap.min.js"
