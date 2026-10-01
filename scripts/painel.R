# Painel exploratório com os agregados distribuídos

pacotes_necessarios <- c("data.table", "ggplot2", "DT", "shiny", "shinydashboard")
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
dados <- file.path(projeto, "dados")
ler <- function(nome) data.table::fread(file.path(dados, nome))

estado <- ler("03_temporal_estado.csv")
regioes_imediatas <- ler("04_temporal_regiao_imediata.csv")
regioes_intermediarias <- ler("05_temporal_regiao_intermediaria.csv")
municipios <- data.table::fread(
  file.path(dados, "06_vinculos_municipio_regiao.csv"),
  na.strings = "NA"
)
concentracao <- ler("24_concentracao_setorial_regiao.csv")
anos <- sort(unique(estado$ano))

ui <- shinydashboard::dashboardPage(
  shinydashboard::dashboardHeader(title = "RAIS Santa Catarina"),
  shinydashboard::dashboardSidebar(
    shiny::selectInput("ano", "Ano", choices = anos, selected = max(anos)),
    shinydashboard::sidebarMenu(
      shinydashboard::menuItem("Estado", tabName = "estado"),
      shinydashboard::menuItem("Regiões", tabName = "regioes"),
      shinydashboard::menuItem("Municípios", tabName = "municipios"),
      shinydashboard::menuItem("Concentração", tabName = "concentracao")
    )
  ),
  shinydashboard::dashboardBody(
    shiny::tabItems(
      shiny::tabItem(
        tabName = "estado",
        shiny::fluidRow(
          shinydashboard::valueBoxOutput("vinculos", width = 6),
          shinydashboard::valueBoxOutput("remuneracao", width = 6)
        ),
        shiny::fluidRow(shiny::column(12, shiny::plotOutput("serie_estado", height = 360)))
      ),
      shiny::tabItem(tabName = "regioes", DT::DTOutput("tabela_regioes")),
      shiny::tabItem(tabName = "municipios", DT::DTOutput("tabela_municipios")),
      shiny::tabItem(tabName = "concentracao", DT::DTOutput("tabela_concentracao"))
    )
  )
)

server <- function(input, output, session) {
  ano_atual <- shiny::reactive({ estado[ano == as.integer(input$ano)] })

  output$vinculos <- shinydashboard::renderValueBox({
    shinydashboard::valueBox(
      format(ano_atual()$vinculos_ativos, big.mark = "."),
      "Vínculos ativos",
      icon = shiny::icon("briefcase")
    )
  })

  output$remuneracao <- shinydashboard::renderValueBox({
    shinydashboard::valueBox(
      paste0("R$ ", format(round(ano_atual()$remuneracao_media_nominal, 2), nsmall = 2, big.mark = ".", decimal.mark = ",")),
      "Remuneração média nominal",
      icon = shiny::icon("money-bill")
    )
  })

  output$serie_estado <- shiny::renderPlot({
    ggplot2::ggplot(estado, ggplot2::aes(x = ano, y = vinculos_ativos)) +
      ggplot2::geom_line(linewidth = 1, color = "#1b5e20") +
      ggplot2::geom_point(size = 2, color = "#1b5e20") +
      ggplot2::scale_y_continuous(labels = function(x) format(x, big.mark = ".")) +
      ggplot2::labs(x = NULL, y = "Vínculos ativos") +
      ggplot2::theme_minimal()
  })

  output$tabela_regioes <- DT::renderDT({
    DT::datatable(
      regioes_imediatas[ano == as.integer(input$ano)],
      rownames = FALSE,
      options = list(pageLength = 24, scrollX = TRUE)
    )
  })

  output$tabela_municipios <- DT::renderDT({
    DT::datatable(
      municipios[ano == as.integer(input$ano)],
      rownames = FALSE,
      options = list(pageLength = 25, scrollX = TRUE)
    )
  })

  output$tabela_concentracao <- DT::renderDT({
    DT::datatable(
      concentracao[ano == as.integer(input$ano)],
      rownames = FALSE,
      options = list(pageLength = 24, scrollX = TRUE)
    )
  })
}

shiny::shinyApp(ui, server)
