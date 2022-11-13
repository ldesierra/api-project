class PacksController < ApplicationController
  before_action :load_pack, only: [:show, :destroy]
  respond_to :json
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def show
    return render json: { message: 'Pack no encontrado' }, status: 404 if @pack.blank?
  end

  def destroy
    return render json: { message: 'Pack no encontrado' }, status: 404 if @pack.blank?

    if cannot? :destroy, @pack
      return render json: { message: 'No estas autorizado para realizar la accion' }, status: 401
    end

    if @pack.destroy
      render json: { message: 'Pack eliminado correctamente' }, status: 200
    else
      render json: { message: 'Error eliminando el pack' }, status: 500
    end
  end

  private

  def load_pack
    @pack = Pack.where(id: params[:id]).first
  end
end
