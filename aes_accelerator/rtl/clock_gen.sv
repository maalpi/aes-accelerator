// ==============================================================================
// Módulo: clock_gen
// Descrição: Gerador de clock e modelo comportamental de PLL/Clock Divider.
// Responsável por fornecer o clock principal do sistema e gerenciar
// eventuais divisores e sinais de clock gating.
//
// NOTA DE DESENVOLVIMENTO:
// Módulo esqueleto da Semana 01. Detalhamento e integração previstos para a Semana 04.
// ==============================================================================

module clock_gen (
    input  logic ref_clk,        // Clock de referência externo
    input  logic rst_n,          // Reset
    input  logic pll_bypass,     // Bypass para teste/simulação direta
    input  logic gate_clk_en,    // Habilitação para clock gating em baixo consumo

    output logic clk_core,       // Clock principal do núcleo AES
    output logic pll_locked      // Indicador de PLL travado / clock estável
);

    // Na simulação inicial / esqueleto de Semana 1, repassa o clock de referência
    // Em etapas posteriores, integrará o modelo de síntese/PLL com clock gating.
    logic clk_internal;
    assign clk_internal = ref_clk;

    // Lógica preliminar de lock e saída (placeholder)
    always_ff @(posedge ref_clk or negedge rst_n) begin
        if (!rst_n) begin
            pll_locked <= 1'b0;
        end else begin
            pll_locked <= 1'b1; // Simula travamento imediato na baseline
        end
    end

    // Gating básico de relógio para suporte a baixo consumo futuro
    assign clk_core = (gate_clk_en || pll_bypass) ? clk_internal : 1'b0;

endmodule : clock_gen
