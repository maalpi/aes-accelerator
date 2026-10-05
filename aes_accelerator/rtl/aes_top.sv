// ==============================================================================
// Módulo: aes_top
// Descrição: Arquivo Top-Level do Sistema Integrado (AES Top-Level System).
// Interconecta a interface serial SPI, o subsistema de dados de memória,
// o datapath AES (FIPS-197), o controlador de reset e o gerador de clock.
//
// NOTA DE DESENVOLVIMENTO:
// Módulo de integração estrutural da Semana 01. Contém a ligação dos módulos
// esqueleto para validação imediata do fluxo de compilação, lint e simulação.
// ==============================================================================

module aes_top #(
    parameter int MEM_ADDR_WIDTH = 10,
    parameter int MEM_DATA_WIDTH = 32
)(
    // Clocks e Resets Externos
    input  logic                      ref_clk,
    input  logic                      rst_n_in,

    // Interface SPI Escrava
    input  logic                      spi_sclk,
    input  logic                      spi_cs_n,
    input  logic                      spi_mosi,
    output logic                      spi_miso,

    // Interface com Memória de Dados (SRAM)
    output logic [MEM_ADDR_WIDTH-1:0] mem_addr,
    output logic [MEM_DATA_WIDTH-1:0] mem_wdata,
    input  logic [MEM_DATA_WIDTH-1:0] mem_rdata,
    output logic                      mem_we,
    output logic                      mem_en,

    // Sinais de Interrupção e Status
    output logic                      irq_done,
    output logic                      core_busy
);

    import aes_pkg::*;

    // ==========================================================================
    // Sinais Internos de Interconexão
    // ==========================================================================
    logic        clk_core;
    logic        pll_locked;
    logic        rst_n_core;
    logic        rst_n_spi;

    logic [7:0]  cfg_reg;
    logic [1:0]  key_size_sel;
    logic        start_crypto;
    logic        core_done;

    logic [127:0] block_to_core;
    logic [127:0] block_from_core;
    logic         data_valid;
    logic         data_ready;
    aes_status_t  core_status;

    // Atribuições diretas de saída
    assign irq_done  = core_done;
    assign core_busy = core_status.busy;

    // ==========================================================================
    // 1. Gerador de Clock (PLL Model)
    // ==========================================================================
    clock_gen u_clock_gen (
        .ref_clk     (ref_clk),
        .rst_n       (rst_n_in),
        .pll_bypass  (1'b1),
        .gate_clk_en (1'b1),
        .clk_core    (clk_core),
        .pll_locked  (pll_locked)
    );

    // ==========================================================================
    // 2. Controlador e Sincronizador de Reset
    // ==========================================================================
    reset_controller u_reset_controller (
        .clk_core   (clk_core),
        .clk_spi    (spi_sclk),
        .rst_n_in   (rst_n_in),
        .rst_n_core (rst_n_core),
        .rst_n_spi  (rst_n_spi)
    );

    // ==========================================================================
    // 3. Interface SPI Slave
    // ==========================================================================
    spi_slave u_spi_slave (
        .clk_core     (clk_core),
        .rst_n        (rst_n_spi),
        .spi_sclk     (spi_sclk),
        .spi_cs_n     (spi_cs_n),
        .spi_mosi     (spi_mosi),
        .spi_miso     (spi_miso),
        .cfg_reg      (cfg_reg),
        .key_size_sel (key_size_sel),
        .start_crypto (start_crypto),
        .core_busy    (core_status.busy),
        .core_done    (core_done)
    );

    // ==========================================================================
    // 4. Subsistema de Dados de Memória
    // ==========================================================================
    data_subsystem #(
        .ADDR_WIDTH (MEM_ADDR_WIDTH),
        .DATA_WIDTH (MEM_DATA_WIDTH)
    ) u_data_subsystem (
        .clk            (clk_core),
        .rst_n          (rst_n_core),
        .mem_addr       (mem_addr),
        .mem_wdata      (mem_wdata),
        .mem_rdata      (mem_rdata),
        .mem_we         (mem_we),
        .mem_en         (mem_en),
        .aes_block_in   (block_to_core),
        .aes_block_out  (block_from_core),
        .aes_data_valid (data_valid),
        .aes_data_ready (data_ready)
    );

    // ==========================================================================
    // 5. Datapath Criptográfico AES (FIPS-197)
    // ==========================================================================
    aes_core u_aes_core (
        .clk       (clk_core),
        .rst_n     (rst_n_core),
        .start     (start_crypto),
        .key_size  (aes_key_size_t'(key_size_sel)),
        .op_mode   (AES_ENCRYPT),
        .key_in    (256'h0),
        .block_in  (block_to_core),
        .block_out (block_from_core),
        .busy      (data_ready),
        .done      (core_done),
        .status    (core_status)
    );

endmodule : aes_top
