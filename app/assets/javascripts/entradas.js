//<editor-fold desc="Crea, elimina entradas, habilita, desabilita el boton para agregar entradas">

var $partidasLink = $('.add_fields');
var $totalPartidasBadge = $('.badge');
var partidas;
$(function () {

    if ($('#formulario-entradas').length) {
        /**
        ** Se agregan las partidas a las entradas
        */
        $partidasLink = $('.add_fields');
        $totalPartidasBadge = $('.badge');
        totalPartidasServer = parseInt($('#total_partidas').html());
        $entrada = $("#entrada_numero_entrada");
        partidas = {

            minimum: 1,

            maximum: 30,

            $partidas: [],

            initialize: function () {
                this.$partidas = [];
                var $partidaDiv = $('.nested-fields');
                var that = this;
                for (var i = $partidaDiv.length - 1, j = 0; i >= 0; i--, j++) {
                    that.$partidas[j] = $($partidaDiv[i]);
                }
                this.actualizarTotalPartidas();

                console.log("Total partidas Server: " + totalPartidasServer);

                return;
            },

            add: function ($partida) {
                this.$partidas.push($partida);
                this.asignarNumero($partida);
                this.actualizarTotalPartidas();
                return;
            },

            show: function () {
                this.$partidas.forEach(function ($partida) {
                    console.log($partida);
                });

                return;
            },

            remove: function ($partidaToDestroy) {
                var that = this;
                that.$partidas.forEach(function ($partida, index) {
                    if ($partida.is($partidaToDestroy)) {
                        that.$partidas.splice(index, 1);
                        return;
                    }
                    return;
                });

                this.reordenarNumeros();
                this.actualizarTotalPartidas();
                return;
            },

            notDeleteFirst: function () {
                var $removePartidaLink = this.$partidas[0].find('.remove_fields');
                $removePartidaLink.remove();
                return;
            },

            size: function () {
                return this.$partidas.length;
            },

            /**
             * Asigna el número correspondiente a la partida
             * @param {type} $partida
             * @returns {undefined}
             */
            asignarNumero: function ($partida) {
                var $identificadorInput = this.obtenerIdentificadorInput($partida);
                var $identificadorStringInput = this.obtenerIdentificadorStringInput($partida);
                console.log("pasa por aqiu");
                $identificadorInput.val(this.size() + totalPartidasServer);
                $identificadorStringInput.val("UNT " + $entrada.val() + "-" + $identificadorInput.val());
                return;
            },

            /**
             * Ordena los números de las partidas de acuerdo a su posición en el arreglo
             * de partidas, usado al momento de eliminar una partida
             * @returns {undefined}
             */
            reordenarNumeros: function () {
                var that = this;
                that.$partidas.forEach(function ($partida, index) {
                    var $identificadorInput = that.obtenerIdentificadorInput($partida);
                    var $identificadorStringInput = that.obtenerIdentificadorStringInput($partida);
                    $identificadorInput.val(index + 1 + totalPartidasServer);
                    $identificadorStringInput.val("UNT " + $entrada.val() + "-" + $identificadorInput.val());

                    return;
                });
                return;
            },

            obtenerIdentificadorInput: function ($partida) {
                return $partida.find('.identificador');
            },

            obtenerIdentificadorStringInput: function ($partida) {
                return $partida.find('.identificador_string');
            },

            /**
             * Actualiza el total de las partidas que se muestran en la interfaz
             * @returns {undefined}
             */
            actualizarTotalPartidas: function () {
                $totalPartidasBadge.text(this.size());
                return;
            }
        };

        partidas.initialize();
        partidas.show();
        partidas.notDeleteFirst();
        disableAddPartidaLink();
    }

    $('#partidas').on('cocoon:after-insert', function (e, insertedPartida) {
        partidas.add(insertedPartida);
        partidas.show();
        partidas.notDeleteFirst();
        disableAddPartidaLink();

        return;
    });

    $('#partidas').on('cocoon:before-remove', function (e, deletedPartida) {

        partidas.remove(deletedPartida);
        if (partidas.size() < partidas.maximum) {
            enableAddPartidaLink($partidasLink);
        }

        return;
    });

    function disableAddPartidaLink() {
        if (partidas.size() >= partidas.maximum) {
            disableAddPartidaLink($partidasLink);
        }

        // Private function
        function disableAddPartidaLink($partidasLink) {
            $partidasLink.addClass('disabled');
            return;
        }
    }

    function enableAddPartidaLink($partidasLink) {
        $partidasLink.removeClass('disabled');
        return;
    }
});

//</editor-fold>

//<editor-fold desc="Obtiene el valor de la tara a partir del número de sacos y número de bolsas">

var partida;

$(function () {

    /**
     * Objeto que almacena el numero de sacos, numero de bolsas y el valor de la tara.
     * Obtiene el valor de los kilogramos netos a partir de los kilogramos brutos y tara
     * @type type
     */
    partida = {
        $numeroSacos: null,

        $numeroBolsas: null,

        $numeroCostalillas: null,

        $tara: null,

        $kilogramosBrutos: null,

        $kilogramosNetos: null,

        obtenerValorTara: function () {
            var totalSacos = parseFloat(this.$numeroSacos.val());
            var totalBolsas = parseFloat(this.$numeroBolsas.val()) * 0.200;
            var totalCostalillas = parseFloat(this.$numeroCostalillas.val()) * 0.100;
            var valor_tara = (totalSacos + totalBolsas + totalCostalillas);

            if (isNaN(totalSacos) || isNaN(totalBolsas) || isNaN(totalCostalillas)) {
                return;
            }

            this.$tara.val(valor_tara.toFixed(2));
            this.$tara.change(); // Trick to trigger change event and update input kilogramos netos
            return;
        },

        obtenerValorKilogramosNetos: function () {
            var kilogramosBrutos = parseFloat(this.$kilogramosBrutos.val());
            var tara = parseFloat(this.$tara.val());
            var difference = kilogramosBrutos - tara;

            if (isNaN(kilogramosBrutos) || isNaN(tara)) {
                return;
            }

            this.$kilogramosNetos.val(difference.toFixed(2));
            return;
        }
    };

    /**
     * Funcion que observa por cambios en el campo numero de sacos
     */
    $(document).on('keyup', '.numero-sacos', partida, function () {

        var $numeroSacosInput = $(this);
        var $padre = $numeroSacosInput.closest('.nested-fields');

        partida.$numeroSacos = $numeroSacosInput;
        partida.$numeroBolsas = findNumeroBolsas($padre);
        partida.$tara = findTara($padre);
        partida.$numeroCostalillas = findNumeroCostalillas($padre);

        return partida.obtenerValorTara();
    });

    /**
     * Funcion que observa por cambios en el campo numero de bolsas
     */
    $(document).on('keyup', '.numero-bolsas', partida, function () {

        var $numeroBolsasInput = $(this);
        var $padre = $numeroBolsasInput.closest('.nested-fields');

        partida.$numeroBolsas = $numeroBolsasInput;
        partida.$numeroSacos = findNumeroSacos($padre);
        partida.$tara = findTara($padre);
        partida.$numeroCostalillas = findNumeroCostalillas($padre);

        return partida.obtenerValorTara();
    });

    /**
     * Funcion que observa por cambios en el campo numero de costalillas
     */
    $(document).on('keyup', '.numero-costalillas', partida, function () {

        var $numeroCostalillasInput = $(this);
        var $padre = $numeroCostalillasInput.closest('.nested-fields');

        partida.$numeroCostalillas = $numeroCostalillasInput;
        partida.$numeroBolsas = findNumeroBolsas($padre);
        partida.$numeroSacos = findNumeroSacos($padre);
        partida.$tara = findTara($padre);

        return partida.obtenerValorTara();
    });

    /**
     * Funcion que observa por cambios en el campo kilogramos brutos
     */
    $(document).on('keyup', '.kilogramos-brutos', partida, function () {

        var $kilogramosBrutosInput = $(this);
        var $padre = $kilogramosBrutosInput.closest('.nested-fields');

        partida.$kilogramosBrutos = $kilogramosBrutosInput;
        partida.$tara = findTara($padre);
        partida.$kilogramosNetos = findKilogramosNetos($padre);

        return partida.obtenerValorKilogramosNetos();
    });

    /**
     * Funcion que observa por cambios en el campo tara
     */
    $(document).on('change', '.tara', partida, function () {
        var $taraInput = $(this);
        var $padre = $taraInput.closest('.nested-fields');

        partida.$tara = $taraInput;
        partida.$kilogramosBrutos = findKilogramosBrutos($padre);
        partida.$kilogramosNetos = findKilogramosNetos($padre);

        return partida.obtenerValorKilogramosNetos();
    });

    function findNumeroSacos($padre) {
        var $numeroSacosInput = $padre.find('.numero-sacos');
        return $numeroSacosInput;
    }

    function findTara($padre) {
        var $taraInput = $padre.find('.tara');
        return $taraInput;
    }

    function findNumeroBolsas($padre) {
        var $numeroBolsasInput = $padre.find('.numero-bolsas');
        return $numeroBolsasInput;
    }

    function findNumeroCostalillas($padre) {
        var $numeroCostalillasInput = $padre.find('.numero-costalillas');
        return $numeroCostalillasInput;
    }

    function findKilogramosNetos($padre) {
        var $kilogramosNetosInput = $padre.find('.kilogramos-netos');
        return $kilogramosNetosInput;
    }

    function findKilogramosBrutos($padre) {
        var $kilogramosNetosInput = $padre.find('.kilogramos-brutos');
        return $kilogramosNetosInput;
    }

});

//</editor-fold>

//<editor-fold desc="Configuracion de picker hora-fecha, agregación de mascara">
$(function () {

    /**
     * Configuración de picker hora-fecha
     */
    $('.datetimepicker_for_date').datetimepicker({
        format: "DD/MM/YYYY",
        sideBySide: true,
        ignoreReadonly: true
    });
    $('#entrada_date').mask('00/00/0000 00:00');

    /**
     * Configuración de picker para exportación Excel
     * Se inicializa cuando se abre el modal
     */
    $('#exportarExcelModal').on('shown.bs.modal', function () {
        $('.datetimepicker_export_range').datetimepicker({
            format: "DD/MM/YYYY",
            sideBySide: true,
            ignoreReadonly: true
        });
    });

    /**
     * Validación de fechas para exportación Excel
     */
    $('#excel_export_form').on('submit', function (e) {
        var fechaInicio = moment($('#fecha_inicio').val(), 'DD/MM/YYYY');
        var fechaFin = moment($('#fecha_fin').val(), 'DD/MM/YYYY');

        if (!fechaInicio.isValid() || !fechaFin.isValid()) {
            alert('Por favor ingrese fechas válidas en formato DD/MM/YYYY');
            e.preventDefault();
            return false;
        }

        if (fechaFin.isBefore(fechaInicio)) {
            alert('La fecha final debe ser mayor o igual a la fecha inicial');
            e.preventDefault();
            return false;
        }

        // Cerrar el modal antes de descargar
        $('#exportarExcelModal').modal('hide');
        return true;
    });

    /**
     * Configuración de mascara para kilogramos brutos, tara,
     * kilogramos netos, numero bultos
     */
    var formatKilogramos = "##0.00";
    var formatBultos = "##0";
    var formatHumedad = "00.00";

    $('.kilogramos-brutos').mask(formatKilogramos, { reverse: true });
    addMask($('.container'), ".kilogramos-brutos", formatKilogramos);

    $('.tara').mask(formatKilogramos, { reverse: true });
    addMask($('.container'), ".tara", formatKilogramos);

    $('.kilogramos-netos').mask(formatKilogramos, { reverse: true });
    addMask($('.container'), ".kilogramos-netos", formatKilogramos);

    $('.numero-sacos').mask(formatBultos, { reverse: true });
    addMask($('.container'), ".numero-sacos", formatBultos);

    $('.numero-bolsas').mask(formatBultos, { reverse: true });
    addMask($('.container'), ".numero-bolsas", formatBultos);

    $('.humedad').mask(formatHumedad, { reverse: true });
    addMask($('.container'), ".humedad", formatHumedad);

    function addMask($container, element, format) {
        $container.arrive(element, function () {
            var $newElement = $(this);
            $newElement.mask(format, { reverse: true });
        });
    }

});

//</editor-fold>

//<editor-fold desc="Obtiene el total de entradas por organización">
/**
 * Realiza la petición para obtener el total de entradas por organizacion
 */
var entrada;
$(function () {

    if ($('#formulario-entradas').length) {

        /**
        * Objeto que almacena el cliente, numero de entrada por cliente
        * @type type
        */
        entrada = {
            $idInput: $('#entrada_id'),

            $clienteInput: $('#entrada_client_id'),

            $numeroEntradaClienteInput: $('#entrada_numero_entrada_cliente'),

            obtenerValorEntradaCliente: function () {
                var datosEnviar = {
                    id: this.$idInput.val(),
                    idCliente: this.$clienteInput.val()
                };
                var that = this;
                var jqxhr = $.getJSON("/entradas/numero_entrada_cliente",
                    datosEnviar, function (data) {
                        that.asignarValorEntrada(data.numero_entrada);
                    });
            },

            asignarValorEntrada: function (numeroEntradaCliente) {
                this.$numeroEntradaClienteInput.val(numeroEntradaCliente);

                return;
            }
        };

        /**
        * Funcion que observa por cambios en el campo cliente
        */
        $(document).on('change', '#entrada_client_id', entrada, function () {
            entrada.obtenerValorEntradaCliente();
            return;
        });
    }
});

//</editor-fold>
