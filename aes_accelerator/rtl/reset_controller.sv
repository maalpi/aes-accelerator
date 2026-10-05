// ==============================================================================
// Módulo: reset_controller
// Descrição: Controlador de reset responsável por gerar resets com asserção
// assíncrona e desasserção síncrona para os diferentes domínios de clock.
//
// NOTA DE DESENVOLVIMENTO:
// Módulo esqueleto da Semana 01. A ser refinado na Semana 04.
// ==============================================================================

module reset_controller (
    input  logic clk_core,
    input  logic clk_spi,
    input  logic rst_n_in,       // Reset externo (ativo em nível baixo)

    output logic rst_n_core,     // Reset sincronizado para o domínio Core
    output logic rst_n_spi       // Reset sincronizado para o domínio SPI
);

    // Sincronizador de reset para o domínio Core (2 estágios)
    logic [1:0] sync_core;
    always_ff @(posedge clk_core or negedge rst_n_in) begin
        if (!rst_n_in) begin
            sync_core <= 2'b00;
        end else begin
            sync_core <= {sync_core[0], 1'b1};
        end
    end
    assign rst_n_core = sync_core[1];

    // Sincronizador de reset para o domínio SPI (2 estágios)
    logic [1:0] sync_spi;
    always_ff @(posedge clk_spi or negedge rst_n_in) begin
        if (!rst_n_in) begin
            sync_spi <= 2'b00;
        end else begin
            sync_spi <= {sync_spi[0], 1'b1};
        end
    end
    assign rst_n_spi = sync_spi[1];

endmodule : reset_controller
