# RAIS Santa Catarina

Análise do mercado de trabalho formal de Santa Catarina entre 2020 e 2022,
com foco em vínculos ativos, remuneração média nominal, distribuição regional
e concentração setorial.

## Perguntas analisadas

- Como evoluíram os vínculos formais e a remuneração média no estado?
- Como os vínculos e a remuneração se distribuem entre regiões e municípios?
- Quais regiões apresentam maior concentração setorial?

## Dados

Os arquivos em [dados](dados/README.md) são agregados derivados para os anos
de 2020, 2021 e 2022. Eles cobrem o estado, regiões imediatas, regiões
intermediárias, municípios e o índice HHI de concentração setorial regional.

Os microdados e classificações devem ser obtidos diretamente nas fontes
oficiais indicadas em [DATA_SOURCES.md](DATA_SOURCES.md).

## Tratamento

O processamento seleciona vínculos ativos em 31 de dezembro, padroniza as
chaves territoriais e calcula remuneração média nominal somente com valores
positivos. As tabelas distribuídas não incluem totais monetários.

## Indicadores

- vínculos ativos;
- número de remunerações válidas;
- remuneração média nominal;
- índice HHI de concentração setorial;
- número de setores com vínculos por região imediata.

## Privacidade

Para resultados municipais, remunerações com
`n_remuneracao_valida < 20` são apresentadas como `NA`. A supressão não é
substituída por estimativas e não há indicadores municipais derivados de
remunerações suprimidas. Os demais campos agregados permanecem disponíveis.

Não são distribuídas tabelas por setor e município, atributos demográficos,
cruzamentos de perfil ou geometrias territoriais.

## Painel

O script [scripts/painel.R](scripts/painel.R) cria um painel Shiny usando
somente os cinco CSVs distribuídos. O guia de modelagem e as medidas DAX ficam
em [painel](painel/guia_power_bi.md).

Mapas não são incluídos porque esta distribuição não contém geometrias
territoriais. Qualquer visual cartográfica requer uma fonte geográfica oficial
e seus termos de uso próprios.

## Resultados principais

A série estadual registra 1.465.363 vínculos ativos em 2020 e 2.337.448 em
2022. A remuneração média nominal passa de R$ 2.992,45 para R$ 3.924,80 no
mesmo período. As tabelas regionais permitem examinar a distribuição desse
movimento e o HHI resume a concentração setorial em cada região imediata.

## Como executar

Para explorar os dados distribuídos, instale R com os pacotes `data.table`,
`ggplot2`, `DT`, `shiny` e `shinydashboard`, abra a pasta do projeto e execute:

```r
source("scripts/painel.R")
```

Para reproduzir agregados a partir de microdados, obtenha os arquivos oficiais
descritos em [DATA_SOURCES.md](DATA_SOURCES.md), coloque-os em `fontes/` e
execute:

```r
source("scripts/preparar_dados_rais.R")
```

O processamento completo depende da compatibilidade entre o esquema baixado e
as colunas documentadas. Antes de comparar resultados, valide as contagens e
as versões das fontes utilizadas.

O script reproduz os agregados de estado, regiões e municípios. A reconstrução
do HHI exige uma especificação pública adicional para a classificação setorial
e não é executada por este script.

## Limitações

- A RAIS cobre vínculos formais registrados e não representa todo o mercado de trabalho.
- As remunerações são nominais e não foram deflacionadas.
- Os indicadores são descritivos e não estabelecem relações causais.
- A supressão municipal limita comparações de remuneração em grupos pequenos.

## Fontes

As fontes oficiais e os requisitos de reprodução estão em
[DATA_SOURCES.md](DATA_SOURCES.md). A distinção entre o código do projeto e
materiais de terceiros está em [NOTICE.md](NOTICE.md).
