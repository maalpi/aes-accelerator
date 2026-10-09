RTL_DIR = rtl
TB_DIR  = tb

RTL_FILES = $(RTL_DIR)/smoke_top.sv
TB_FILES  = $(TB_DIR)/tb_smoke_top.sv

TOP = tb_smoke_top
TIMESCALE = 1ns/1ps

VLOGAN_FLAGS = -full64 -sverilog -kdb +lint=all -timescale=$(TIMESCALE)
VCS_FLAGS    = -full64 -timescale=$(TIMESCALE) -debug_access+all -kdb

all: run

# Sintaxe + lint (RTL e testbench)
syntax:
	vlogan $(VLOGAN_FLAGS) $(RTL_FILES) $(TB_FILES)

# Lint apenas do RTL
lint:
	vlogan $(VLOGAN_FLAGS) $(RTL_FILES)

# Compilação / elaboração
compile: syntax
	vcs $(VCS_FLAGS) -top $(TOP)

# Simulação
run: compile
	./simv

wave:
	verdi -ssf waves.fsdb &

clean:
	rm -rf csrc simv* *.daidir novas* AN.DB ucli.key verdi* DVEfiles \
		.vlogan* *.fsdb *.vcd *.log work work.lib++

.PHONY: all syntax lint compile run wave clean
