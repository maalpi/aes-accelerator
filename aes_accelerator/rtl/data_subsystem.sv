// ==============================================================================
// Módulo: data_subsystem
// Descrição: Subsistema de interface com memória de dados.
// Controla a leitura de blocos de texto claro/cifrado da memória externa/SRAM,
// alimenta o datapath AES e armazena os blocos processados de volta.
//
// NOTA DE DESENVOLVIMENTO:
// Módulo esqueleto da Semana 01. A ser implementado na Semana 05.
// ==============================================================================

module data_subsystem #(
    parameter int ADDR_WIDTH = 10,
    parameter int DATA_WIDTH = 32
)(
    input  logic                  clk,
    input  logic                  rst_n,

    // Interface com Memória Externa (SRAM / Dual-Port RAM)
    output logic [ADDR_WIDTH-1:0] mem_addr,
    output logic [DATA_WIDTH-1:0] mem_wdata,
    input  logic [DATA_WIDTH-1:0] mem_rdata,
    output logic                  mem_we,
    output logic                  mem_en,

    // Interface com o Datapath AES
    output logic [127:0]          aes_block_in,
    input  logic [127:0]          aes_block_out,
    output logic                  aes_data_valid,
    input  logic                  aes_data_ready
);

    import aes_pkg::*;

    // Stub para compilação e linting limpos
    // TODO: Implementar controlador DMA/Buffer de dados na Semana 05
    assign mem_addr       = '0;
    assign mem_wdata      = '0;
    assign mem_we         = 1'b0;
    assign mem_en         = 1'b0;
    assign aes_block_in   = 128'h0;
    assign aes_data_valid = 1'b0;

endmodule : data_subsystem
