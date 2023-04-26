
# limpar variaveis
rm(list = ls())

# pacotes
library(tidyverse)
library(dslabs)

# dados
data(polls_2008)
str(polls_2008)

# disperssao
polls_2008 %>% 
  ggplot2::ggplot(ggplot2::aes(day, margin)) + 
  ggplot2::geom_point(color = "blue") +  
  ggplot2::scale_x_continuous(breaks = seq(-155, -1, 7)) +
  ggplot2::theme_light()

# suavisazao

'
- Se faz o calculo com cada valor de x como o centro
- O que proporciona o conjunto A0 = {Y_i}, i talque |x - x0| < 3.5

'
# se x0 = -124 entao A0 = {Y_i}, i = (- 127,..., - 121)
seq(-127, -121) 
abs(-127 + 124); abs(-121 + 124)

polls_2008$margin[-seq(-128, -122)] %>% mean()

# se x0 = -54 entao A0 = {Y_i}, i = (- 57,..., - 51)
seq(-57, -51)
abs(-57 + 54); abs(-51 + 54)

  # grafica com nucleo kernel 'box': pesos iguais 

windowSize <- 7

fit <- with(polls_2008, 
            ksmooth(day, margin, kernel = "box", bandwidth = windowSize))

X11()
polls_2008 %>% 
  dplyr::mutate(smooth = fit$y) %>% 
  ggplot2::ggplot(ggplot2::aes(day, margin)) + 
  ggplot2::geom_point(size = 3, color = "gray") + 
  ggplot2::geom_line(ggplot2::aes(day, smooth), color = "red", size = 0.8) +
  ggplot2::scale_x_continuous(breaks = seq(-155, -1, 7)) + 
  ggplot2::theme_light()

  # grafica nucleo kernel 'normal': pesos diferentes, menor peso nos extremos  

windowSize <- 7

fit <- with(polls_2008, 
            ksmooth(day, margin, kernel = "normal", bandwidth = windowSize))

X11()
polls_2008 %>% 
  dplyr::mutate(smooth = fit$y) %>% 
  ggplot2::ggplot(ggplot2::aes(day, margin)) + 
  ggplot2::geom_point(size = 3, color = "gray") + 
  ggplot2::geom_line(ggplot2::aes(day, smooth), color = "red", size = 0.8) +
  ggplot2::scale_x_continuous(breaks = seq(-155, -1, 7)) + 
  ggplot2::theme_light()


  # Regressão ponderada local (loess) polinomio de grau 1

totalDays  <- diff(range(polls_2008$day))
windowSize <- 21 / totalDays

fit <- loess(margin ~ day, degree = 1, span = windowSize, data = polls_2008)

?loess

polls_2008 |> mutate(smooth = fit$fitted) |>
  ggplot(aes(day, margin)) +
  geom_point(size = 3, alpha = .5, color = "grey") +
  geom_line(aes(day, smooth), color="red")


  # Regressão ponderada local (loess) polinomio de grau 2

totalDays <- diff(range(polls_2008$day))
span      <- 28 / totalDays

fit1 <- loess(margin ~ day, degree = 1, span = span, data = polls_2008)
fit2 <- loess(margin ~ day, span = span, data = polls_2008)

X11()
polls_2008 %>% 
  ggplot2::ggplot(ggplot2::aes(day, margin)) + 
  ggplot2::geom_point(alpha = 0.8, color = "gray", size = 3) + 
  ggplot2::geom_line(ggplot2::aes(day, fit1$fitted), color = "red", size = 0.8, 
                     linetype = 2) + 
  ggplot2::geom_line(ggplot2::aes(day, fit2$fitted), color = "orange", 
                     size = 0.8) + 
  ggplot2::theme_light()


  # Regressão ponderada local (loess) polinomio de grau 2 ggplot2

span      <- 28 / totalDays

X11()
polls_2008 %>% 
  ggplot2::ggplot(ggplot2::aes(day, margin)) + 
  ggplot2::geom_point(alpha = 0.8, size = 3) +
  ggplot2::geom_smooth( method = loess, formula = y ~ x, method.args = list(span = span, degree = 1),
                       size = 1.2, color = "blue") +
  ggplot2::theme_light()



