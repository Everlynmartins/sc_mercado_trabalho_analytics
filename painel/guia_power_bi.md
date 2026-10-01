# Guia de modelagem no Power BI

## Importação

Importe os cinco CSVs da pasta `dados/` e atribua nomes simples às tabelas:

- `Estado` para `03_temporal_estado.csv`;
- `Regioes Imediatas` para `04_temporal_regiao_imediata.csv`;
- `Regioes Intermediarias` para `05_temporal_regiao_intermediaria.csv`;
- `Municipios` para `06_vinculos_municipio_regiao.csv`;
- `Concentracao Setorial` para `24_concentracao_setorial_regiao.csv`.

Ao importar `Municipios`, converta o texto `NA` da coluna
`remuneracao_media_nominal` em valor nulo. Mantenha as contagens e os códigos
territoriais como números inteiros ou texto, conforme seu papel no modelo.

## Relacionamentos

As tabelas podem ser usadas sem relacionamentos obrigatórios. Para filtros de
ano compartilhados, crie uma tabela calendário e relacione-a pela coluna `ano`
com cada tabela. Os códigos de região permitem comparações entre as tabelas
regionais e a tabela municipal.

## Páginas sugeridas

### Estado

Mostre a evolução de vínculos ativos e remuneração média nominal por ano.

### Regiões

Compare vínculos, remuneração e número de remunerações válidas entre regiões
imediatas e intermediárias.

### Municípios

Exiba ranking de vínculos e tabela municipal. Identifique remunerações
suprimidas como indisponíveis; não substitua `NA` por zero.

### Concentração setorial

Mostre o HHI e o número de setores com vínculos por região imediata.

## Cuidados de divulgação

Mantenha a regra de supressão para qualquer visual municipal que use
remuneração. Não acrescente médias, razões ou classificações calculadas a
partir de valores `NA` sem uma revisão de risco de reidentificação.
