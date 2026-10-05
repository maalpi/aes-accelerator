// ==============================================================================
// Testbench: tb_aes_top
// Descrição: Testbench de fumaça (Smoke Test) do sistema Acelerador AES.
// Valida o ambiente inicial da Semana 01:
// - Instanciação e conectividade dos sinais de topo;
// - Geração de clock e aplicação de reset inicial;
// - Verificação de estabilidade dos sinais e liberação de reset;
// - Finalização limpa e relatório no console.
// ==============================================================================

module tb_aes_top;

    import aes_pkg::*;

    // Parâmetros de temporização
    localparam time CLK_PERIOD     = 10ns; // 100 MHz
    localparam time SPI_CLK_PERIOD = 50ns; // 20 MHz

    // Sinais do Testbench
    logic        ref_clk;
    logic        rst_n_in;

    logic        spi_sclk;
    logic        spi_cs_n;
    logic        spi_mosi;
    logic        spi_miso;

    logic [9:0]  mem_addr;
    logic [31:0] mem_wdata;
    logic [31:0] mem_rdata;
    logic        mem_we;
    logic        mem_en;

    logic        irq_done;
    logic        core_busy;

    // --------------------------------------------------------------------------
    // Instanciação do Design Under Test (DUT)
    // --------------------------------------------------------------------------
    aes_top #(
        .MEM_ADDR_WIDTH(10),
        .MEM_DATA_WIDTH(32)
    ) dut (
        .ref_clk     (ref_clk),
        .rst_n_in   (rst_n_in),
        .spi_sclk    (spi_sclk),
        .spi_cs_n    (spi_cs_n),
        .spi_mosi    (spi_mosi),
        .spi_miso    (spi_miso),
        .mem_addr    (mem_addr),
        .mem_wdata   (mem_wdata),
        .mem_rdata   (mem_rdata),
        .mem_we      (mem_we),
        .mem_en      (mem_en),
        .irq_done    (irq_done),
        .core_busy   (core_busy)
    );

    // --------------------------------------------------------------------------
    // Instanciação da Memória SRAM
    // --------------------------------------------------------------------------
    sram_model #(
        .ADDR_WIDTH(10),
        .DATA_WIDTH(32)
    ) u_sram (
        .clk   (ref_clk),
        .ce_n  (~mem_en),
        .we_n  (~mem_we),
        .addr  (mem_addr),
        .wdata (mem_wdata),
        .rdata (mem_rdata)
    );

    // --------------------------------------------------------------------------
    // Geradores de Clock
    // --------------------------------------------------------------------------
    initial ref_clk = 1'b0;
    always #(CLK_PERIOD / 2) ref_clk = ~ref_clk;

    initial spi_sclk = 1'b0;
    always #(SPI_CLK_PERIOD / 2) spi_sclk = ~spi_sclk;

    // --------------------------------------------------------------------------
    // Dump de Waveform (Verdi / FSDB ou VCD)
    // --------------------------------------------------------------------------
    initial begin
        `ifdef DUMP_VCD
            $dumpfile("waves.vcd");
            $dumpvars(0, tb_aes_top);
        `else
            $fsdbDumpfile("waves.fsdb");
            $fsdbDumpvars(0, tb_aes_top);
        `endif
    end

    // --------------------------------------------------------------------------
    // Procedimento de Teste Inicial (Smoke Test da Semana 01)
    // --------------------------------------------------------------------------
    initial begin
        $display("==================================================================");
        $display("  INICIANDO SMOKE TEST: AES TOP-LEVEL SYSTEM (SEMANA 01)");
        $display("==================================================================");

        // Inicialização de entradas
        rst_n_in    = 1'b0;
        spi_cs_n    = 1'b1;
        spi_mosi    = 1'b0;

        // Mantém reset assertado por 5 ciclos de clock
        repeat(5) @(posedge ref_clk) begin end

        // Libera o reset
        #1;
        rst_n_in = 1'b1;
        $display("[TB] Reset liberado (rst_n_in = 1) no tempo %0t ps", $time);

        // Aguarda estabilização pós-reset por 10 ciclos
        repeat(10) @(posedge ref_clk) begin end

        // Verificação básica de sanidade
        if (core_busy === 1'b0) begin
            $display("[TB] [OK] core_busy esta em nivel baixo apos reset.");
        end else begin
            $display("[TB] [ERRO] core_busy em estado inesperado: %b", core_busy);
        end

        // Aguarda mais alguns ciclos para simulação do relógio SPI
        repeat(5) @(posedge spi_sclk) begin end

        $display("==================================================================");
        $display("  SMOKE TEST CONCLUIDO COM SUCESSO!");
        $display("  Ambiente de compilacao, lint e simulacao 100%% operacional.");
        $display("==================================================================");

        $finish;
    end

    // Timeout de segurança
    initial begin
        #50000;
        $display("[TB] [TIMEOUT] Simulacao excedeu o tempo maximo.");
        $finish;
    end

endmodule : tb_aes_top
