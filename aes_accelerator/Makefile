# ==============================================================================
# Makefile — Acelerador AES (RTL Design Track) — Semana 1
# Fluxo mínimo em um comando:  make
# ==============================================================================

RTL_DIR = rtl
SIM_DIR = sim

PKG_FILES = $(RTL_DIR)/aes_pkg.sv

RTL_FILES = \
	$(RTL_DIR)/cdc_sync.sv \
	$(RTL_DIR)/reset_controller.sv \
	$(RTL_DIR)/clock_gen.sv \
	$(RTL_DIR)/spi_slave.sv \
	$(RTL_DIR)/data_subsystem.sv \
	$(RTL_DIR)/aes_core.sv \
	$(RTL_DIR)/aes_top.sv

TB_FILES = \
	$(SIM_DIR)/sram_model.sv \
	$(SIM_DIR)/tb_aes_top.sv

TOP = tb_aes_top
TIMESCALE = 1ns/1ps

VLOGAN_FLAGS = -full64 -sverilog -kdb +lint=all
VCS_FLAGS    = -full64 -timescale=$(TIMESCALE) -debug_access+all -kdb

all: run

# Sintaxe + lint (RTL e testbench)
syntax:
	vlogan $(VLOGAN_FLAGS) $(PKG_FILES) $(RTL_FILES) $(TB_FILES)

# Lint apenas do RTL
lint:
	vlogan $(VLOGAN_FLAGS) $(PKG_FILES) $(RTL_FILES)

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
