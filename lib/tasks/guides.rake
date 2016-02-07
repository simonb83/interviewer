# encoding: UTF-8

namespace :guides do
  desc "Load initial data for Guides model"
  task :load => :environment do

    inicio = ["Ya tengo una lista de candidatos", "Todavía no tengo candidatos"]
    inicio.each do |item|
      Guide.create(name: item, subject: "Inicio Rápido")
    end

    navigation = ["Página principal", "Página de manejo de entrevista", "Página de manejo del candidato"]
    navigation.each do |item|
      Guide.create(name: item, subject: "Navegación")
    end

    crear_entrevistas = ["Crear una entrevista", "Cerrar una entrevista", "Modificar la fecha límite de una entrevista", "Re-abrir una entrevista", "Modificar preguntas de una entrevista"]
    crear_entrevistas.each do |item|
      Guide.create(name: item, subject: "Crear y Manejar Entrevistas")
    end

    attributes = ["ID de entrevista", "Nombre del puesto", "Fecha límite", "Recibir solicitudes", "Recibir copia de solicitudes", "Recomendar amigos", "Requerir referencias"]
    attributes.each do |item|
      Guide.create(name: item, subject: "Atributos de Entrevistas")
    end

    candidatos = ["Agregar candidatos a una entrevista", "Recibir solicitudes automáticamente", "Compartir un candidato", "Aceptar un candidato", "Rechazar un candidato", "Borrar un candidato", "Escuchar respuetas grabadas"]
    candidatos.each do |item|
      Guide.create(name: item, subject: "Agregar y Manejar Candidatos")
    end

    communication = ["Invitación", "Recordatorio", "Entrevista cerrada", "Cambio de fecha límite o entrevista reabierta", "Candidato aceptado", "Candidato rechazado"]
    communication.each do |item|
      Guide.create(name: item, subject: "Comunicación con Candidatos")
    end

    cuenta = ["Editar tu cuenta", "Cambiar tu contraseña"]
    cuenta.each do |item|
      Guide.create(name: item, subject: "Manejar tu Cuenta")
    end
  end

end
