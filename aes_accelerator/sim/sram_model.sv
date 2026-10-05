// ==============================================================================
// Módulo: sram_model
// Descrição: Modelo comportamental simples de memória SRAM síncrona para
// suporte à simulação do subsistema de dados do acelerador AES.
// ==============================================================================

module sram_model #(
    parameter int ADDR_WIDTH = 10,
    parameter int DATA_WIDTH = 32,
    parameter int DEPTH      = (1 << ADDR_WIDTH)
)(
    input  logic                  clk,
    input  logic                  ce_n,  // Chip Enable (ativo baixo)
    input  logic                  we_n,  // Write Enable (ativo baixo)
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [DATA_WIDTH-1:0] wdata,
    output logic [DATA_WIDTH-1:0] rdata
);

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [DATA_WIDTH-1:0] rdata_reg;

    always_ff @(posedge clk) begin
        if (!ce_n) begin
            if (!we_n) begin
                mem[addr] <= wdata;
            end
            rdata_reg <= mem[addr];
        end
    end

    assign rdata = rdata_reg;

endmodule : sram_model
