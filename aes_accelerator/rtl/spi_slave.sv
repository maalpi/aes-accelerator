// ==============================================================================
// Módulo: spi_slave
// Descrição: Interface escrava SPI (Modo 0: CPOL=0, CPHA=0).
// Recebe comandos, chaves criptográficas e parâmetros de configuração do
// mestre SPI, e disponibiliza o status de operação do acelerador.
//
// NOTA DE DESENVOLVIMENTO:
// Módulo esqueleto da Semana 01. A máquina de estados completa e decodificação
// dos registradores de controle serão desenvolvidos na Semana 03.
// ==============================================================================

module spi_slave (
    input  logic        clk_core,
    input  logic        rst_n,
    
    // Interface SPI Física
    input  logic        spi_sclk,
    input  logic        spi_cs_n,
    input  logic        spi_mosi,
    output logic        spi_miso,

    // Interface com o Núcleo / Registradores
    output logic [7:0]  cfg_reg,
    output logic [1:0]  key_size_sel,
    output logic        start_crypto,
    input  logic        core_busy,
    input  logic        core_done
);

    import aes_pkg::*;

    // Registradores e sinais stub para manter o ambiente funcional
    // TODO: Implementar FSM do receptor SPI e registradores na Semana 03
    logic [7:0] shift_reg;
    logic       miso_drive;

    always_ff @(posedge spi_sclk or posedge spi_cs_n) begin
        if (spi_cs_n) begin
            shift_reg  <= 8'h00;
            miso_drive <= 1'b0;
        end else begin
            shift_reg  <= {shift_reg[6:0], spi_mosi};
            miso_drive <= shift_reg[7];
        end
    end

    // Saídas padrão de stub (evitando nós flutuantes e warnings de lint)
    assign spi_miso     = (spi_cs_n) ? 1'bz : miso_drive;
    assign cfg_reg      = 8'h00;
    assign key_size_sel = AES_KEY_SIZE_128;
    assign start_crypto = 1'b0;

endmodule : spi_slave
