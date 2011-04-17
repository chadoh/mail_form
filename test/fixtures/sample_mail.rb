class SampleMail < MailForm::Base
  attributes :name, :email, :nickname

  validates :nickname, :absence => true

  def headers
    { :to => "recipient@example.com", :from => self.email }
  end

  def before_deliver
    callbacks << :before
  end

  def after_deliver
    callbacks << :after
  end

  def callbacks
    @callbacks ||= []
  end
end
