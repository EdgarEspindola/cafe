xml.instruct!
xml.entrada do
  xml.fecha l(@entrada.date, format: :medium_date)
  xml.numero_entrada padded_zeros_numero_entrada(@entrada.numero_entrada)
  xml.numero_entrada_cliente padded_zeros_numero_entrada(@entrada.numero_entrada_cliente)
  xml.entregado_por @entrada.entregado_por
  xml.total_kilos_brutos number_with_precision(@entrada.total_kilos_brutos, precision: 2)
  xml.total_tara number_with_precision(@entrada.total_tara, precision: 2)
  xml.total_kilos_netos number_with_precision(@entrada.total_kilos_netos, precision: 2)
#  xml.imagen asset_data_uri('logo/logo_cafe.jpg')
  xml.imagen asset_url('logo/logo_cafe.jpg')
#  xml.imagen2 asset_path('logo/logo_cafe.jpg')
  xml.cliente do
    xml.representante_legal @entrada.client.legal_representative
    xml.direccion @entrada.client.address
    xml.organizacion @entrada.client.organization
  end
  xml.partidas do
    @entrada.partidas.limit(10).offset(@offset).order("identificador ASC").each do |partida|
      xml.partida do
        xml.numero_partida partida.identificador_with_format
        xml.kilogramos_brutos number_with_precision(partida.kilogramos_brutos, precision: 2)
        xml.tara number_with_precision(partida.tara, precision: 2)
        xml.kilogramos_netos number_with_precision(partida.kilogramos_netos, precision: 2)
        xml.numero_sacos partida.numero_sacos
        xml.numero_bolsas partida.numero_bolsas
        xml.numero_costalillas partida.numero_costalillas
        xml.humedad number_with_precision(partida.humedad, precision: 2)
        xml.tipo_cafe partida.type_coffee.name
        xml.calidad_cafe partida.calidad_cafe
        xml.observaciones partida.observaciones
      end
    end
  end
end
