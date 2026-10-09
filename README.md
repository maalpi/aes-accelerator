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
├── rtl/                      # RTL mínimo da Semana 1 (lógica do AES nas semanas 3–6)
│   └── smoke_top.sv          # Módulo mínimo de smoke test (clk, rst, dados)
├── tb/                       # Testbench
│   └── tb_smoke_top.sv       # Testbench com autocheck do ambiente Synopsys
├── synth/                    # Síntese lógica (Design Compiler) — semana 7
├── formal/                   # Equivalência formal (Formality) — semanas 8–9
├── upf/                      # Intenção de potência (UPF) — semanas 10–11
└── scripts/                  # Scripts auxiliares (Tcl, shell)
```

As pastas `synth/`, `formal/`, `upf/` e `scripts/` estão vazias (`.gitkeep`) e serão preenchidas nas semanas indicadas.

## Uso

```bash
make          # fluxo mínimo (critério de aceite da semana 1)
make lint     # só lint do RTL
make wave     # abre waveform no Verdi
make clean
```

Requer Synopsys VCS (`vlogan`, `vcs`) e, opcionalmente, Verdi.
