# Dados

Os CSVs desta pasta são agregados derivados sobre vínculos formais em Santa
Catarina entre 2020 e 2022. Não há microdados, totais monetários, atributos
demográficos, cruzamentos setoriais municipais ou geometrias territoriais.

| Arquivo | Conteúdo | Linhas |
| --- | --- | ---: |
| `03_temporal_estado.csv` | Indicadores anuais do estado | 3 |
| `04_temporal_regiao_imediata.csv` | Indicadores anuais por região imediata | 72 |
| `05_temporal_regiao_intermediaria.csv` | Indicadores anuais por região intermediária | 21 |
| `06_vinculos_municipio_regiao.csv` | Vínculos e remuneração por município | 885 |
| `24_concentracao_setorial_regiao.csv` | HHI e número de setores por região imediata | 72 |

## Regra de supressão

Em `06_vinculos_municipio_regiao.csv`, quando
`n_remuneracao_valida < 20`, `remuneracao_media_nominal` recebe `NA`. As
demais informações agregadas do município são mantidas. Não existem, nessa
tabela, indicadores derivados da remuneração que precisem ser publicados como
`NA`.

Há duas remunerações municipais suprimidas no conjunto distribuído. As médias
não suprimidas estão arredondadas para duas casas decimais. Não há imputação ou
substituição de valores suprimidos.

As remunerações estaduais e regionais estão associadas a grupos acima desse
limiar. O menor denominador regional é 4.437 e o menor denominador estadual é
1.389.165. O índice HHI não contém remuneração.

As fontes conceituais, os requisitos de reprodução e a distinção de direitos
estão em [DATA_SOURCES.md](../DATA_SOURCES.md) e [NOTICE.md](../NOTICE.md).
