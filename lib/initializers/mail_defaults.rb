Mail.defaults do
  delivery_method :smtp, {
    address: ENV["SMTP_ADDRESS"],
    port: ENV["SMTP_PORT"].to_i,
    domain: ENV["SMTP_DOMAIN"],
    user_name: ENV["SMTP_USERNAME"],
    password: ENV["SMTP_PASSWORD"],
    enable_starttls: ENV["SMTP_ENABLE_STARTTLS"] == "true",
    authentication: :login,
  }
end
