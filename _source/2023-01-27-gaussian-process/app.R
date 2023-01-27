library(tidyverse)
library(viridis)
library(patchwork)
library(shiny)
library(mvtnorm)

gp <- function(N, sigma, rho) {
    x <- 1:N
    mu <- rep(0, times=N)
    K <- matrix(nrow=N, ncol=N)

    for (i in 1:N) {
        K[i, i] = sigma^2 + 1e-12
        
        for (j in i:N) {
            K[i, j] = sigma^2 * exp(-.5 * ((x[i]-x[j])/rho)^2)
            K[j, i] = K[i, j]
        }
    }
    return(list(mu=mu, K=K))
}

ui <- fluidPage(titlePanel('Gaussian Process'),
                fluidRow(
                    column(4,
                           sliderInput('N_sim', 'Number of Simulations', 1, 10, 1, step=1),
                           sliderInput('N', 'Number of Time Points', 1, 100, 1, step=1),
                           sliderInput('sigma', 'Residual Standard Deviation',
                                       0, 10, 1, step=.01),
                           sliderInput('rho', 'Timescale (%)', 0.001, 1, .1, step=.001)),
                    column(4, plotOutput('cov_plot')),
                    column(4, plotOutput('cov_mat'))
                ),
                hr(),
                plotOutput('gp_plot'))





server <- function(input, output) {
    GP <- reactive({ gp(input$N, input$sigma, input$rho*input$N) })

    output$cov_plot <- renderPlot({
        tibble(dx=seq(0, input$N, length.out=201),
               Covariance=input$sigma^2 * exp(-.5 * (dx/(input$rho*input$N))^2)) %>%
            ggplot(aes(x=dx, y=Covariance)) +
            geom_line() +
            scale_x_continuous(expand=c(0, 0)) +
            scale_y_continuous(limits=c(0, input$sigma^2), expand=c(0, 0)) +
            theme_bw()
    })
    
    output$cov_mat <- renderPlot({
        expand_grid(i=1:input$N,
                    j=1:input$N) %>%
            mutate(Covariance=as.vector(GP()$K)) %>%
            ggplot(aes(x=i, y=j, fill=Covariance)) +
            geom_tile() +
            scale_x_continuous(name='Time 1') +
            scale_y_reverse(name='Time 2') +
            coord_fixed(expand=FALSE) +
            scale_fill_viridis(limits=c(0, NA)) +
            theme_classic() +
            theme(axis.line=element_blank(),
                  axis.text=element_blank(),
                  axis.ticks=element_blank())
    })

    output$gp_plot <- renderPlot({
        if (input$N == 1) {
            tibble(x=seq(-3*input$sigma, 3*input$sigma, .001)) %>%
                mutate(y=dnorm(x, sd=input$sigma)) %>%
                ggplot(aes(x=x, y=y)) +
                geom_area() + xlab('y') +
                scale_y_continuous(name='Time', breaks=c(.2), labels='1') +
                geom_vline(xintercept=rnorm(input$N_sim, sd=input$sigma)) +
                coord_flip() +
                theme_classic()
        } else if (input$N == 2) {
            d <- expand_grid(sim=1:input$N_sim,
                             x=1:input$N) %>%
                mutate(y=as.vector(t(rmvnorm(input$N_sim, GP()$mu, GP()$K))))
            
            p.dist <- expand_grid(x=seq(-3*input$sigma, 3*input$sigma, .01),
                                  y=seq(-3*input$sigma, 3*input$sigma, .01)) %>%
                mutate(z=dmvnorm(matrix(c(x,y), ncol=2),
                                 mean=GP()$mu, sigma=GP()$K)) %>%
                ggplot(aes(x=x, y=y)) +
                geom_raster(aes(fill=z), show.legend=FALSE) +
                geom_point(data=d %>% mutate(x=ifelse(x==1, 'x', 'y')) %>%
                               pivot_wider(names_from=x, values_from=y)) +
                scale_fill_viridis() +
                xlab('Time 1') + ylab('Time 2') + coord_fixed(expand=FALSE) +
                theme_classic()
            p.time <- ggplot(d, aes(x=x, y=y, group=sim)) +
                geom_line() +
                scale_x_continuous(name='Time', expand=c(0, 0)) +
                theme_bw() 

            (p.dist | p.time)
        } else {
            expand_grid(sim=1:input$N_sim,
                        x=1:input$N) %>%
                mutate(y=as.vector(t(rmvnorm(input$N_sim, GP()$mu, GP()$K)))) %>%
                ggplot(aes(x=x, y=y, group=sim)) +
                geom_line() +
                scale_x_continuous(name='Time', expand=c(0, 0)) +
                theme_bw()
        }
    })
}

shinyApp(ui = ui, server = server)
