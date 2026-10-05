# Acelerador AES com interface SPI e baixo consumo — RTL Design Track

Projeto hands-on de 15 semanas (um entregável por semana). Este repositório está na **Semana 1**: estrutura, backlog, estudo e fluxo mínimo (sintaxe/lint → compilação → simulação).

## Estrutura

```
aes_accelerator/
├── Makefile                  # make = sintaxe/lint + compilação + simulação
├── .gitignore
├── docs/
│   ├── architecture.md       # AES Top-Level System (blocos e interfaces)
│   ├── backlog.md            # Backlog das 15 semanas
│   ├── study_aes_spi.md      # Estudo AES (FIPS-197) e SPI
│   └── reports/
│       ├── template_semanal.md
│       └── semana_01.md
├── rtl/                      # Esqueletos (portas); lógica vem nas semanas 3–6
│   ├── aes_pkg.sv  aes_top.sv  aes_core.sv  spi_slave.sv
│   ├── data_subsystem.sv  reset_controller.sv  clock_gen.sv  cdc_sync.sv
└── sim/
    ├── sram_model.sv         # Modelo de memória
    └── tb_aes_top.sv         # Smoke test
```

As pastas `synth/`, `formal/` e `upf/` serão criadas nas semanas 7, 8 e 10, respectivamente.

## Uso

```bash
make          # fluxo mínimo (critério de aceite da semana 1)
make lint     # só lint do RTL
make wave     # abre waveform no Verdi
make clean
```

Requer Synopsys VCS (`vlogan`, `vcs`) e, opcionalmente, Verdi.
