# encoding: utf-8
require 'test_helper'

class CandidateMailerTest < ActionMailer::TestCase
  test "accepted" do
    candidate = FactoryGirl.create(:candidate, email: "MyString 1")
    mail = CandidateMailer.accepted(candidate)
    assert_equal "Tu entrevista virtual para el puesto de #{candidate.position_name} en #{candidate.company_name}.", mail.subject
    assert_equal "MyString 1", mail.to
    assert_equal ["contact@ampleo.mx"], mail.from
    assert_match /Nos complace poder avisarte que has pasado a la próxima fase de entrevistas para el puesto vacante./, mail.body.encoded
  end

  test "deadline_passed" do
    candidate = FactoryGirl.create(:candidate, email: "MyString 1")
    mail = CandidateMailer.deadline_passed(candidate)
    assert_equal "Ya se ha pasado la fecha límite para tu entrevista virtual.", mail.subject
    assert_equal "MyString 1", mail.to
    assert_equal ["contact@ampleo.mx"], mail.from
    assert_match /Te queremos informar que ya se ha pasado la fecha límite para tu entrevista virtual/, mail.body.encoded
  end

  test "reopened" do
    candidate = FactoryGirl.create(:candidate, email: "MyString 1")
    mail = CandidateMailer.reopened(candidate)
    assert_equal "Tu entrevista virtual está abierta de nuevo, o la fecha límite se ha modificado.", mail.subject
    assert_equal "MyString 1", mail.to
    assert_equal ["contact@ampleo.mx"], mail.from
    assert_match /está abierta de nuevo, o que se ha modificado la fecha límite./, mail.body.encoded
  end

  test "invitation" do
    candidate = FactoryGirl.create(:candidate, email: "MyString 1")
    mail = CandidateMailer.invitation(candidate)
    assert_equal "Invitación para una entrevista virtual para el puesto de #{candidate.position_name} en #{candidate.company_name}.", mail.subject
    assert_equal "MyString 1", mail.to
    assert_equal ["contact@ampleo.mx"], mail.from
    assert_match /¡Felicidades! Estás invitado a participar en una primera entrevista para el puesto/, mail.body.encoded
  end

  test "rejected" do
    candidate = FactoryGirl.create(:candidate, email: "MyString 1")
    mail = CandidateMailer.rejected(candidate)
    assert_equal "Tu entrevista virtual para el puesto de #{candidate.position_name} en #{candidate.company_name}.", mail.subject
    assert_equal "MyString 1", mail.to
    assert_equal ["contact@ampleo.mx"], mail.from
    assert_match /Desafortunadamente tu perfil no coincide con las necesidades de la vacante/, mail.body.encoded
  end

  test "reminder" do
    candidate = FactoryGirl.create(:candidate, email: "MyString 1")
    mail = CandidateMailer.reminder(candidate)
    assert_equal "Se está acercando la fecha límite para tu entrevista virtual.", mail.subject
    assert_equal "MyString 1", mail.to
    assert_equal ["contact@ampleo.mx"], mail.from
    assert_match /Este mail es un recordatorio para tu entrevista virtual pendiente para el puesto/, mail.body.encoded
  end

  test "completed" do
    candidate = FactoryGirl.create(:candidate, email: "MyString 1")
    mail = CandidateMailer.completed(candidate)
    assert_equal "Tu entrevista virtual para el puesto de #{candidate.position_name} en #{candidate.company_name}.", mail.subject
    assert_equal "MyString 1", mail.to
    assert_equal ["contact@ampleo.mx"], mail.from
    assert_match /Gracias por terminar tu entrevista virtual para el puesto de/, mail.body.encoded
  end

end
