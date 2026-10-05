// ==============================================================================
// Módulo: cdc_sync
// Descrição: Sincronizador de duplo flip-flop (2-stage synchronizer) para
// sinais de controle que cruzam domínios de clock assíncronos.
//
// NOTA DE DESENVOLVIMENTO:
// Módulo esqueleto da Semana 01. Aprimoramentos e sincronizadores de pulso
// ou FIFO assíncrona serão desenvolvidos conforme o cronograma (Semana 04).
// ==============================================================================

module cdc_sync #(
    parameter int WIDTH = 1
)(
    input  logic             clk_dest,
    input  logic             rst_n_dest,
    input  logic [WIDTH-1:0] din,
    output logic [WIDTH-1:0] dout
);

    // Registradores do sincronizador de 2 estágios
    logic [WIDTH-1:0] stage1_reg;
    logic [WIDTH-1:0] stage2_reg;

    always_ff @(posedge clk_dest or negedge rst_n_dest) begin
        if (!rst_n_dest) begin
            stage1_reg <= '0;
            stage2_reg <= '0;
        end else begin
            stage1_reg <= din;
            stage2_reg <= stage1_reg;
        end
    end

    assign dout = stage2_reg;

endmodule : cdc_sync
