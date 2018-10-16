class Api::V1::GithubSecurityWebhooksController < Api::BaseController
  skip_before_action :verify_authenticity_token
  before_action :signature_valid

  def webhook
    payload = JSON.parse(@payload_body)
    if request.headers["HTTP_X_GITHUB_EVENT"] == 'repository_vulnerability_alert'
      project = Project.find_by(tech_name: payload["repository"]["name"])
      unless project.code_cares.exists?(advisory_id: payload["alert"]["external_identifier"])
        project.code_cares.create(code_care_params)
      end
      if payload["action"] == "resolve"
        care = project.code_cares.find_by(advisory_id: payload["alert"]["external_identifier"])
        care.update(enddate: Date.today)
      end
    end
  end

  private

  def signature_valid
    @payload_body = request.body.read
    signature_valid?(@payload_body)
  end

  def signature_valid?(payload_body)
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
    Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end

  def code_care_params
    {
      name: payload["alert"]["affected_package_name"],
      version: payload["alert"]["affected_range"],
      advisory_id: payload["alert"]["external_identifier"],
      startdate: Date.today
    }
  end
end
