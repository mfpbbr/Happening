# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Happening::Application.initialize!

# Configure email
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = { 
    address: "smtp.gmail.com",
    port: 587,
    domain: "heroku.com",
    user_name: "#{ENV['GMAIL_USERNAME']}",
    password: "#{ENV['GMAIL_PASSWORD']}",
    authentication: "plain",
    enable_starttls_auto: true
}
