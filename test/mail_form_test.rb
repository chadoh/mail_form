require 'test_helper'
require 'fixtures/sample_mail'

class MailFormTest < ActiveSupport::TestCase

  setup do
    ActionMailer::Base.deliveries.clear
  end

  test "delivers an email with attributes" do
    sample = SampleMail.new
    # Simulate data from the form
    sample.email = "user@example.com"
    sample.deliver

    assert_equal 1, ActionMailer::Base.deliveries.size
    mail = ActionMailer::Base.deliveries.last

    assert_equal ["user@example.com"], mail.from
    assert_match /Email: user@example\.com/, mail.body.encoded
  end

  test "validates absence of nickname" do
    sample = SampleMail.new :nickname => "Spam"
    assert !sample.valid?
    assert_equal ["is invalid"], sample.errors[:nickname]
  end

  test "provides before and after deliver hooks" do
    sample = SampleMail.new
    sample.deliver
    assert_equal [:before, :after], sample.callbacks
  end

  test "sample mail can clear attributes using clear_ prefix" do
    sample = SampleMail.new
    sample.name = "User"
    assert_equal "User", sample.name
    sample.email = "user@example.com"
    assert_equal "user@example.com", sample.email
    sample.clear_name
    sample.clear_email
    assert_nil sample.name
    assert_nil sample.email
  end

  test "sample mail can ask if an attribute is present or not" do
    sample = SampleMail.new
    assert !sample.name?

    sample.name = "User"
    assert sample.name?

    sample.email = ""
    assert !sample.email?
  end

  test "model_name exposes singular and human name" do
    model = SampleMail.new
    assert_equal "sample_mail", model.class.model_name.singular
    assert_equal "Sample mail", model.class.model_name.human
  end

  test "model_name.human uses I18n" do
    model = SampleMail.new
    begin
      I18n.backend.store_translations :en,
        :activemodel => { :models => { :sample_mail => "My Sample Mail" } }

      assert_equal "My Sample Mail", model.class.model_name.human
    ensure
      I18n.reload!
    end
  end

  test "can retreive all attributes" do
    sample = SampleMail.new
    sample.name = "John Doe"
    sample.email = "john.doe@example.com"
    assert_equal "John Doe", sample.attributes['name']
    assert_equal "john.doe@example.com", sample.attributes['email']
  end
end
