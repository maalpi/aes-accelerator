// Descrição: Módulo simples de smoke test para validação do ambiente (Semana 01).


module smoke_top (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] data_in,
    input  logic       valid_in,
    output logic [7:0] data_out,
    output logic       ready
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 8'h00;
            ready    <= 1'b0;
        end else begin
            ready    <= 1'b1;
            if (valid_in) begin
                data_out <= data_in ^ 8'h5A; // Operação combinacional para verificar lógica
            end
        end
    end

endmodule : smoke_top
