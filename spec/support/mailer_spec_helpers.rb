module MailerSpecHelpers
  def deliver(mail_method, *arguments)
    @mailer = described_class.new
    @mailer.process(mail_method, *arguments)
    @mail = @mailer.message.tap do |message|
      message.deliver
    end
  end

  def assigns(key)
    @mailer.view_assigns[key.to_s]
  end

  def mail
    @mail
  end
end
