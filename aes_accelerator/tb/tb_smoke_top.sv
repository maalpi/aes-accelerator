module tb_smoke_top;

    logic       clk;
    logic       rst_n;
    logic [7:0] data_in;
    logic       valid_in;
    logic [7:0] data_out;
    logic       ready;

    // Instanciação do Design Under Test (DUT)
    smoke_top dut (
        .clk     (clk),
        .rst_n   (rst_n),
        .data_in (data_in),
        .valid_in(valid_in),
        .data_out(data_out),
        .ready   (ready)
    );

    // Geração de clock (100 MHz, período = 10ns)
    always #5 clk = ~clk;

    initial begin
        // Inicialização de sinais
        clk      = 0;
        rst_n    = 0;
        data_in  = 8'h00;
        valid_in = 0;

        // Pulso de reset inicial
        #20 rst_n = 1;

        // Aplicação de estímulo
        #10 valid_in = 1;
        data_in  = 8'hA5;
        #10 valid_in = 0;

        // Verificação automática
        #20 if (ready === 1'b1 && data_out === (8'hA5 ^ 8'h5A)) begin
            $display("\n=======================================================");
            $display(" [SUCCESS] Ambiente Synopsys (VCS) configurado com sucesso!");
            $display(" Lint (vlogan), compilacao (vcs) e simulacao 100%% OK.");
            $display("=======================================================\n");
        end else begin
            $display("\n=======================================================");
            $display(" [ERROR] Falha na simulacao minima.");
            $display("=======================================================\n");
        end

        $finish;
    end

    // Geração de arquivo FSDB para Verdi (opcional)
    initial begin
        $fsdbDumpfile("waves.fsdb");
        $fsdbDumpvars(0, tb_smoke_top);
    end

endmodule
