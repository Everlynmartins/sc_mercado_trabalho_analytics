# Fontes de dados

## RAIS

Os microdados não identificados da RAIS podem ser obtidos no
[Ministério do Trabalho e Emprego](https://www.gov.br/trabalho-e-emprego/pt-br/acesso-a-informacao/acoes-e-programas/programas-projetos-acoes-obras-e-atividades/estatisticas-trabalho/microdados-rais-e-caged).
O recorte analisado utiliza os anos de 2020, 2021 e 2022.

## Referências auxiliares

- [IBGE/CONCLA — CNAE](https://cnae.ibge.gov.br/classificacoes/download-concla/8265-download)
- [IBGE — Divisões regionais](https://www.ibge.gov.br/geociencias/cartas-e-mapas/redes-geograficas/15778-divisoes-regionais-do-brasil.html?lang=pt-BR)
- [IBGE — Malhas territoriais](https://www.ibge.gov.br/geociencias/organizacao-do-territorio/malhas-territoriais/15774-malhas.html)

Registre a versão e a data de download das referências utilizadas em qualquer
nova reprodução.

## Arquivos necessários para `scripts/preparar_dados_rais.R`

Crie localmente a pasta `fontes/`, que permanece fora do versionamento, e
inclua arquivos obtidos das fontes oficiais:

- `rais_2020.csv`, `rais_2021.csv` e `rais_2022.csv`;
- `municipios_sc.csv`, com as colunas `cod_municipio_rais`,
  `cod_municipio_completo`, `nome_municipio`, `cod_regiao_imediata`,
  `nome_regiao_imediata`, `cod_regiao_intermediaria` e
  `nome_regiao_intermediaria`.

Os CSVs anuais devem conter as colunas `mun_trab`, `ano`,
`vinculo_ativo_31_12` e `vl_remun_media_nom`. A construção da tabela de
municípios e regiões deve usar uma referência territorial oficial compatível
com o período analisado.

## Agregados distribuídos

Os arquivos em [dados](dados/README.md) são agregados derivados para análise.
Eles não são cópias dos microdados nem substituem os arquivos oficiais. A
reprodução deve validar esquema, cobertura, totais anuais e critérios de
agregação antes de comparar resultados.

Em tabelas municipais com remuneração, valores com menos de 20 remunerações
válidas são publicados como `NA`; totais monetários e indicadores diretamente
derivados dessas remunerações não são distribuídos.

## Direitos e licenças

A licença MIT cobre apenas o código e a documentação autorais. RAIS, CNAE,
divisões territoriais, geometrias e demais materiais de terceiros seguem os
termos de seus respectivos responsáveis. Consulte [NOTICE.md](NOTICE.md).
