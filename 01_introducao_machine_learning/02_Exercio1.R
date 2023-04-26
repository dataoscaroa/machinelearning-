
#-----------------------------------------------------------------------------#
# Autor: Oscar J. O. Ayala
# Topico: Metricas de validacao: machilerning tarefa de clasificacao
#-----------------------------------------------------------------------------#

'
-- O problema referece ao exercicio na secao 27.5 do livro
"Irizarry, A. R. (2022). Data Analysis and Prediction Algorithms with R".

-- Apenas usar este scrips como ajuda de aprendizado
'
# limpar variaveis
rm(list = ls())

# local
# pathwd <- "C:/Users/oscar/Desktop/R_Python_SQL_PBI/R/04_machine_learning"
# setwd(pathwd)

# pacotes
library(tidyverse)
library(caret)
library(lubridate)
library(magrittr)
library(dslabs)

# importar dados

'
-- A aula de bioestatística foi ministrada em 2016
-- Duas versoes da aula: presencial e online
-- Em  25/01/2016 às 8h15 preencheram o formulario presencial duante 15 minutos
-- Os alunos online preencheram o formulario durante os proximos dias até o ultimo dia do mês
-- Definir variavel "type": inclass ou online
'

data("reported_heights")
str(reported_heights)

# preparacao dos dados
datNew <- as_tibble(reported_heights) %>% 
  dplyr::mutate(data_time = lubridate::ymd_hms(time_stamp)) %>% 
  dplyr::filter(data_time >= lubridate::make_date(2016, 01, 25) &
                  data_time < lubridate::make_date(2016, 02, 01)) %>% 
  dplyr::mutate(height = parse_number(height)) %>% 
  dplyr::mutate(type = dplyr::case_when(
    lubridate::day(data_time) == 25 & 
      lubridate::hour(data_time) == 8 &
      between(lubridate::minute(data_time), 15, 30) ~ "inclass", 
    TRUE ~ "online")) %>% 
  dplyr::mutate(sex = parse_factor(sex),
                type = parse_factor(type)) %>% 
  dplyr::select(-time_stamp) %>% 
  dplyr::relocate(data_time, .before = "sex")


#------------------------- Resumo das estatísticas ----------------------------#

summary(datNew$sex)
table(datNew$type, datNew$sex) %>% dplyr::as_tibble(.name_repair = ~ c("type", "sex", "n"))

datNew %>% 
  ggplot2::ggplot(ggplot2::aes(type, fill = sex)) +
  ggplot2::geom_bar() + 
  ggplot2::ggtitle("Composição do sexo por tipo de pesquisa")   +
  ggplot2::theme_classic() 

  
'
No grafico de perfies parece que quando as pesquisas mudam do cenario inclass para
online o numero de estudantes em participao incrementa. No entanto, a participacao
de mulheres é maior quando se solicita preencher o formulario inclass e dos homems
quando se prenchee online. Assim tem-se indicios que o type de intrumento da pesquisa
é preditivo do sexo.

Na tabela 1, tem-se que o número de estudantes de sexo masculino é maior. No 
entanto, parecem estar relativamente equilibrados

'

#--------------------------- algoritmos para prever ---------------------------#

'
- Metodo 1 (sample): Cria-se uma amostra aleatória com probabilidade, 1 - p, para 
prever a classe mulher e p para asignar homem. 
- Metodo 2 (prescricao): Se prescreve pessoas de sexo Femenino se o tipo de pesquisa
foi inclass e homem se for online.
'

# conjuto traino e teste
datNew %<>% dplyr::select(sex, type)

set.seed(2023)
index <- caret::createDataPartition(datNew$sex,
                                    times = 1, 
                                    p = 0.5, 
                                    list = FALSE) %>% 
  as.vector()

trainSet <- datNew[-index, ] 
testSet  <- datNew[index, ] 

#--------------------------------- Presicao geral -----------------------------#

# metodo sample
set.seed(2023)
yHat   <- sample(levels(trainSet$sex),
                 length(trainSet$sex),
                 replace = TRUE) %>% 
  factor(levels = levels(trainSet$sex))

pGeralMS <- mean(yHat == trainSet$sex)
table(yHat, trainSet$sex)

'Neste caso a Presicao Geral é perto de 0.5. A porcentagem de previsões acertadas
entre homem (56%) e mulheres (50%) estao relativamente estáveis. Assim, 
se esta adivinhando'

# metodo asignacao
yHat   <- dplyr::case_when(trainSet$type == "inclass" ~ "Female",
                           TRUE ~ "Male")

pGeralA <- mean(yHat == trainSet$sex)
table(yHat, trainSet$sex)

'Neste caso a Presicao Geral é melhor 0.64. A porcentagem de previsões acertadas
entre homem (57%) e mulheres (53%) estao relativamente estáveis, e maiores
que o caso anterior. Assim, em principio este método é melhor'

tibble(Metodo = c("Sample", "Asignacia"), 
       Presicao_Geral = c(pGeralMS, pGeralA))

#---------------------- Metricas de avaliacao Presicao Geral-------------------#
  
  # trainamento do metodo sample 
p <- seq(0, 1, 0.1)

methodSample <- purrr::map_dbl(p, function(x){
  pGeral <- numeric()
  
  for(i in 1:100){
    # prever 
    yHat   <- sample(levels(trainSet$sex),
                   length(trainSet$sex),
                   replace = TRUE,
                   p = c(1-x, x)) %>% 
        factor(levels = levels(trainSet$sex))
    
    # avaliacao precisao geral 
    pGeral[i] <- round(unique(caret::confusionMatrix(dat = yHat,
                                                  reference = trainSet$sex)$overall[1]), 2)
  }
  return(mean(pGeral))
  })

dplyr::bind_cols(p = p, methodSample = methodSample) %>% 
ggplot2::ggplot(ggplot2::aes(p, methodSample)) +
  ggplot2::geom_point() +
  ggplot2::geom_line(color = "blue") + 
  ggrepel::geom_text_repel(label = round(methodSample, 2), size = 3)  + 
  ggplot2::theme_light()

summary(testSet)

'Na Figura se observa, que em geral não existe muita diferencia entre os diferentes 
valores da Presicao Geral segundo a probabilidade asignada para prever o sexo dos
estudantes. Mas quando  p = 1, se tem o maior valor para esta métrica (0.55), 
isto porque no conjunto de dados tem-se mais homem do que mulheres'.

  # teste do metodo sample
p <- p[which.max(methodSample)]

  # prever 
pGeral <- numeric()
for(i in 1:100){
  yHat   <- sample(levels(testSet$sex),
                   length(testSet$sex),
                   replace = TRUE,
                   p = c(1 - p, p)) %>% 
    factor(levels = levels(testSet$sex))
  
  # avaliacao precisao geral 
  pGeral[i] <- round(unique(caret::confusionMatrix(dat = yHat,
                                                reference = testSet$sex)$overall[1]), 2)
  
}
pGeralMS <- mean(pGeral)

"No processo de avaliacao tem-se que a precisao disminui sem mudanças sustancias. 
Logo, tem-se que a presicao do algotirmo esta proxima de 0.55. Mas uma vez, 
se verifica que se esta adivinhado."

# Trainamento do metodo asignacao
yHat   <- dplyr::case_when(trainSet$type == "inclass" ~ "Female",
                           TRUE ~ "Male") %>%
  factor(levels = levels(trainSet$sex))

pGeralMA  <- round(unique(caret::confusionMatrix(dat = yHat, 
                                               reference = trainSet$sex)$overall[1]), 2)

'
Através do conjunto train tem-se que a presicao para este metodo é maior (0.64).
Porém, deve testar

'

# Teste do metodo asignacao
yHat   <- dplyr::case_when(testSet$type == "inclass" ~ "Female",
                           TRUE ~ "Male") %>%
  factor(levels = levels(testSet$sex))

pGeralMA  <- round(unique(caret::confusionMatrix(dat = yHat, 
                                               reference = trainSet$sex)$overall[1]), 2)
'
A avaliacao indica uma presicao geral (0.57) para este método disminuir,
o que parece ser mais realista. Logo, se tem indicios que esta abordagem é melhor.
'

#------------------ Metricas de avaliacao Presicao equilibrada ---------------#

# Teste do metodo asignacao
yHat <- dplyr::case_when(testSet$type == "inclass" ~ "Female",
                         TRUE ~ "Male") %>% 
  factor(levels = levels(testSet$sex))

pEquilMA  <- caret::F_meas(dat = yHat, 
                           reference = testSet$sex)
'
A avaliacao indica uma presicao geral equilibrada (0.44) para este método disminui,
o que parece ser mais realista. Logo, se tem indicios que esta abordagem é melhor.
'


#---------------------------- Sensibilidad e espeficidade ---------------------#

# metodo sample
p <- seq(0, 1, 0.1)

methodSample <- purrr::map_df(p, function(x){
  sensibMA <- numeric()
  FRP  <- numeric()
  
  for(i in 1:100){
    # prever 
    yHat   <- sample(levels(testSet$sex),
                     length(testSet$sex),
                     replace = TRUE,
                     p = c(1-x, x)) %>% 
      factor(levels = levels(testSet$sex))
    
    # avaliacao precisao geral 
    sensibMA[i] <- caret::sensitivity(dat = yHat, 
                                      reference = testSet$sex)
    FRP[i] <- 1 - caret::specificity(dat = yHat, 
                                     reference = testSet$sex)
  }
  result <- c(mean(sensibMA), mean(FRP)) %>% setNames(c("Sensibilidade", 
                                                            "FRP"))
  return(result)
  
})

dplyr::bind_cols(p = sort(p, decreasing = TRUE), 
                 methodSample = methodSample) %>%
  ggplot2::ggplot(ggplot2::aes(FRP, Sensibilidade))   +
  ggplot2::geom_line() + 
  ggplot2::geom_point(color = "blue") +
  ggrepel::geom_text_repel(ggplot2::aes(label = p), nudge_y = 0.01) + 
  ggplot2::ggtitle("ROC: FPR vs Sensibility") + 
  ggplot2::theme_light()

# metodo asignacao
yHat   <- dplyr::case_when(testSet$type == "inclass" ~ "Female",
                           TRUE ~ "Male") %>%
  factor(levels = levels(testSet$sex))

methodAsig  <- tibble(Sensibilidade = caret::sensitivity(dat = yHat, 
                                                         reference = testSet$sex), 
                      FPR = 1 - caret::specificity(dat = yHat, 
                                                          reference = testSet$sex))

'
No ponto de comparacao da gráfica ROC, tem-se que o modelo 
por asignacao oferece maior sensibilidade. Quando FRP esta perto de 0.12
a sensibilidade esta por encima de 0.3. Este mesmo ponto para o modelo Sample
a sensibilidade é perto de 0.11. Logo, o modelo a abordagem asginacao e melhor. 

'

'
Por ultimo, nao existe prevalência marcada de um sexo,
homem (56%) e mulheres (50%) (Ver parte 1).

'