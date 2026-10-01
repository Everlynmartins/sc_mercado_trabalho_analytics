# Agregação de indicadores da RAIS para Santa Catarina

pacotes_necessarios <- c("data.table", "stringr")
pacotes_ausentes <- pacotes_necessarios[
  !vapply(pacotes_necessarios, requireNamespace, logical(1), quietly = TRUE)
]

if (length(pacotes_ausentes) > 0) {
  stop(
    "Instale os pacotes necessários antes de executar: ",
    paste(pacotes_ausentes, collapse = ", ")
  )
}

obter_pasta_projeto <- function() {
  argumentos <- commandArgs(trailingOnly = FALSE)
  caminho_script <- sub("--file=", "", argumentos[grep("^--file=", argumentos)])

  if (length(caminho_script) > 0) {
    return(dirname(dirname(normalizePath(caminho_script[1], winslash = "/", mustWork = TRUE))))
  }

  normalizePath(getwd(), winslash = "/", mustWork = TRUE)
}

projeto <- obter_pasta_projeto()
fontes <- file.path(projeto, "fontes")
resultados <- file.path(projeto, "resultados")

arquivos_rais <- file.path(fontes, paste0("rais_", 2020:2022, ".csv"))
arquivo_municipios <- file.path(fontes, "municipios_sc.csv")
arquivos_necessarios <- c(arquivos_rais, arquivo_municipios)
ausentes <- arquivos_necessarios[!file.exists(arquivos_necessarios)]

if (length(ausentes) > 0) {
  stop(
    "Arquivos ausentes em fontes/: ",
    paste(basename(ausentes), collapse = ", "),
    ". Consulte DATA_SOURCES.md."
  )
}

dir.create(resultados, recursive = TRUE, showWarnings = FALSE)

converter_numero <- function(x) {
  x <- trimws(as.character(x))
  x <- gsub(" ", "", x, fixed = TRUE)
  tem_virgula <- grepl(",", x)
  tem_ponto <- grepl("\\.", x)
  x[tem_virgula & tem_ponto] <- gsub(".", "", x[tem_virgula & tem_ponto], fixed = TRUE)
  x <- gsub(",", ".", x, fixed = TRUE)
  suppressWarnings(as.numeric(x))
}

agregar <- function(tabela, chaves) {
  saida <- tabela[
    ,
    .(
      vinculos_ativos = .N,
      n_remuneracao_valida = sum(!is.na(remuneracao_valida)),
      soma_remuneracao_valida = sum(remuneracao_valida, na.rm = TRUE)
    ),
    by = chaves
  ]

  saida[, remuneracao_media_nominal := data.table::fifelse(
    n_remuneracao_valida > 0,
    soma_remuneracao_valida / n_remuneracao_valida,
    NA_real_
  )]
  saida[, soma_remuneracao_valida := NULL]
  saida
}

municipios <- data.table::fread(arquivo_municipios)
colunas_municipios <- c(
  "cod_municipio_rais", "cod_municipio_completo", "nome_municipio",
  "cod_regiao_imediata", "nome_regiao_imediata",
  "cod_regiao_intermediaria", "nome_regiao_intermediaria"
)

if (!all(colunas_municipios %in% names(municipios))) {
  stop("municipios_sc.csv não contém todas as colunas documentadas.")
}

municipios <- municipios[, ..colunas_municipios]
municipios[, cod_municipio_rais := stringr::str_pad(
  gsub("\\D", "", as.character(cod_municipio_rais)), width = 6, pad = "0"
)]

colunas_rais <- c("mun_trab", "ano", "vinculo_ativo_31_12", "vl_remun_media_nom")

processar_ano <- function(arquivo, ano_referencia) {
  tabela <- data.table::fread(arquivo, select = colunas_rais)
  tabela[, vinculo_ativo_31_12 := as.integer(as.character(vinculo_ativo_31_12))]
  tabela <- tabela[vinculo_ativo_31_12 == 1]
  tabela[, ano := as.integer(ano_referencia)]
  tabela[, remuneracao := converter_numero(vl_remun_media_nom)]
  tabela[, remuneracao_valida := data.table::fifelse(
    !is.na(remuneracao) & remuneracao > 0, remuneracao, NA_real_
  )]
  tabela[, cod_municipio_rais := stringr::str_pad(
    gsub("\\D", "", as.character(mun_trab)), width = 6, pad = "0"
  )]
  municipios[tabela, on = "cod_municipio_rais"]
}

vinculos <- data.table::rbindlist(
  Map(processar_ano, arquivos_rais, 2020:2022),
  fill = TRUE
)

estado <- agregar(vinculos, "ano")
regioes_imediatas <- agregar(
  vinculos,
  c("ano", "cod_regiao_imediata", "nome_regiao_imediata")
)
regioes_intermediarias <- agregar(
  vinculos,
  c("ano", "cod_regiao_intermediaria", "nome_regiao_intermediaria")
)
municipios_agregados <- agregar(
  vinculos,
  c(
    "ano", "cod_municipio_completo", "nome_municipio",
    "cod_regiao_imediata", "nome_regiao_imediata",
    "cod_regiao_intermediaria", "nome_regiao_intermediaria"
  )
)

municipios_agregados[n_remuneracao_valida < 20, remuneracao_media_nominal := NA_real_]

salvar <- function(tabela, nome) {
  data.table::fwrite(tabela, file.path(resultados, nome), bom = TRUE)
}

salvar(estado, "temporal_estado.csv")
salvar(regioes_imediatas, "temporal_regiao_imediata.csv")
salvar(regioes_intermediarias, "temporal_regiao_intermediaria.csv")
salvar(municipios_agregados, "vinculos_municipio_regiao.csv")

message("Agregados gravados em resultados/.")
