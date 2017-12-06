require 'jasper-bridge/jasper'
class EntradasController < ApplicationController
  include Jasper::Bridge
  before_action :set_entrada, only: [:show, :edit, :update, :destroy, :reporte]
  before_action :check_entrada_not_have_partidas_with_salidas, only: [:edit, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_entrada
  
  # GET /entradas
  # GET /entradas.json
  def index
    @entradas = Entrada.validas.order("numero_entrada DESC").page(params[:page])
  end

  # GET /entradas/1
  # GET /entradas/1.json
  def show     
    @merma = Merma.new
  end

  # GET /entradas/new
  def new
    @entrada = Entrada.new
    @entrada.asignar_numero_entrada
    @entrada.partidas.build
  end

  # GET /entradas/1/edit
  def edit
    @entrada.date = @entrada.date.strftime("%d/%m/%Y %H:%M") # Trick to show the date in the form
  end

  # POST /entradas
  # POST /entradas.json
  def create
    @entrada = Entrada.new(entrada_params)
        
    respond_to do |format|
      if @entrada.save
        flash[:success] = I18n.t('.entradas.created')
        format.html { redirect_to @entrada }
        format.json { render :show, status: :created, location: @entrada }
      else
        format.html { render :new }
        format.json { render json: @entrada.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entradas/1
  # PATCH/PUT /entradas/1.json
  def update
    respond_to do |format|
      if @entrada.update(entrada_params)
        flash[:success] = I18n.t('.entradas.updated')
        format.html { redirect_to @entrada }
        format.json { render :show, status: :ok, location: @entrada }
      else
        format.html { render :edit }
        format.json { render json: @entrada.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entradas/1
  # DELETE /entradas/1.json
  def destroy
    respond_to do |format|
      if @entrada.destroyed_logical
        flash[:success] = I18n.t('.entradas.destroyed')
      else 
        flash[:error] = I18n.t('.entradas.not_destroyed')
      end
      format.html { redirect_to entradas_url }
      format.json { head :no_content }
    end
  end
  
  def reporte
    xml_data = render_to_string('reporte.xml.builder', layout: false)    
    send_file_pdf("Entrada#{@entrada.numero_entrada}", "entradas", xml_data, "entrada")
  end
  
  # GET /entradas/numero_entrada_cliente?idCliente=1.json
  def numero_entrada_cliente
    numero_entrada_cliente = {}
    cliente = Client.find(params[:idCliente])
    
    if params[:id] != ""
      entrada = Entrada.find(params[:id])
    else
      entrada = Entrada.new
    end
    
    if entrada.new_record? || !entrada.client_id.eql?(cliente.id)      
      entrada.client = cliente
      entrada.asignar_numero_entrada_por_cliente      
    end
    
    numero_entrada_cliente[:numero_entrada] = entrada.numero_entrada_cliente 
    
    respond_to do |format|
      format.json {render json: numero_entrada_cliente, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entrada
      @entrada = Entrada.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entrada_params
      params.require(:entrada).permit(:client_id,:total_partidas, :date, :numero_entrada, 
          :numero_entrada_cliente, :driver, :entregado_por, partidas_attributes: [
          :id, :identificador, :kilogramos_brutos, :numero_sacos, :numero_bolsas, 
          :tara, :kilogramos_netos, :humedad, :type_coffee_id, :observaciones, 
          :calidad_cafe, :_destroy])
    end
    
    def check_entrada_not_have_partidas_with_salidas
      if @entrada.tiene_partidas_con_salidas
        logger.error "Attempt to change entrada not modificable #{params[:id]}"
        flash[:danger] = 'Acción no realizada. Entrada tiene partidas con salidas.'
        redirect_to entradas_url
      end
    end
    
    def invalid_entrada
      logger.error "Attempt to access invalid entrada #{params[:id]}"
      flash[:danger] = 'Entrada no valida'
      redirect_to root_url
    end
end
