# encoding: UTF-8

class GuidesController < ApplicationController

  load_and_authorize_resource

  def get_guides
    @guides_1 = Guide.where(subject: "Inicio Rápido")
    @guides_2 = Guide.where(subject: "Navegación")
    @guides_3 = Guide.where(subject: "Crear y Manejar Entrevistas")
    @guides_4 = Guide.where(subject: "Atributos de Entrevistas")
    @guides_5 = Guide.where(subject: "Agregar y Manejar Candidatos")
    @guides_6 = Guide.where(subject: "Comunicación con Candidatos")
    @guides_7 = Guide.where(subject: "Manejar tu Cuenta")
  end

  def index
    get_guides
  end

  def show
    @guide = Guide.find(params[:id])
  end

  def new
    @guide = Guide.new
  end

  def create
    @guide = Guide.new(params[:guide])
    respond_to do |format|
      if @guide.save
        format.html { redirect_to guides_path }
        format.json {}
      else
        format.html { render action: "new" }
        format.json { render json: @guide.errors, status: :unprocessable_entity }
      end
    end
  end

end
