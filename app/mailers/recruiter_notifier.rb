#encoding: utf-8
class RecruiterNotifier < ActionMailer::Base
  default from: "contact@ampleo.mx"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.recruiter_notifier.shared_internal.subject
  #
  def shared_internal(sender,recipient)
    @sender = sender
    @recipient = recipient

    mail to: @recipient.email, subject: "Un colega ha compartido una entrevista contigo."
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.recruiter_notifier.shared_external.subject
  #
  def shared_external(sender,recipient, candidate)
    @sender = sender
    @candidate = candidate

    mail to: recipient, subject: "Un colega quisiera compartir una entrevista contigo."
  end
end
