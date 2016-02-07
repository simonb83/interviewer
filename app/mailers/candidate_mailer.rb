# encoding: utf-8
class CandidateMailer < ActionMailer::Base
  default from: "contact@ampleo.mx"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.candidate_mailer.accepted.subject
  #
  def accepted(candidate)
    @candidate = candidate

    mail to: candidate.email, subject: "Tu entrevista virtual para el puesto de #{@candidate.position_name} en #{@candidate.company_name}."
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.candidate_mailer.deadline_passed.subject
  #
  def deadline_passed(candidate)
    @candidate = candidate

    mail to: @candidate.email, subject: "Ya se ha pasado la fecha límite para tu entrevista virtual."
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.candidate_mailer.reopened.subject
  #
  def reopened(candidate)
    @candidate = candidate

    mail to: @candidate.email, subject: "Tu entrevista virtual está abierta de nuevo, o la fecha límite se ha modificado."
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.candidate_mailer.invitation.subject
  #
  def invitation(candidate)
    @candidate = candidate

    mail to: @candidate.email, subject: "Invitación para una entrevista virtual para el puesto de #{@candidate.position_name} en #{@candidate.company_name}."
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.candidate_mailer.rejected.subject
  #
  def rejected(candidate)
     @candidate = candidate

    mail to: @candidate.email, subject: "Tu entrevista virtual para el puesto de #{@candidate.position_name} en #{@candidate.company_name}."
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.candidate_mailer.reminder.subject
  #
  def reminder(candidate)
     @candidate = candidate

    mail to: @candidate.email, subject: "Se está acercando la fecha límite para tu entrevista virtual."
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.candidate_mailer.completed.subject
  #
  def completed(candidate)
    @candidate = candidate

    mail to: @candidate.email, subject: "Tu entrevista virtual para el puesto de #{@candidate.position_name} en #{@candidate.company_name}."
  end
end
