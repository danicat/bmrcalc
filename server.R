# server.R: BMR Calculator Shinny App
# Copyright (C) 2016 Daniela Petruzalek
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

library(shiny)

# nul <- function(height, weight, age) {}

# BMR models per each gender
orig.hb.f <- function(height, weight, age) {
    9.5634 * weight + 1.8496 * height - 4.6756 * age + 655.0955     
}

orig.hb.m <- function(height, weight, age) {
    13.7516 * weight + 5.0033 * height - 6.7550 * age + 66.4730  
}

rev.hb.f <- function(height, weight, age) {
    9.247 * weight + 3.098 * height - 4.330 * age + 447.593     
}

rev.hb.m <- function(height, weight, age) {
    13.397 * weight + 4.799 * height - 5.677 * age + 88.362  
}

mifflin.f <- function(height, weight, age) {
    10 * weight + 6.25 * height - 5.0 * age - 161
}

mifflin.m <- function(height, weight, age) {
    10 * weight + 6.25 * height - 5.0 * age + 5  
}


# Define server logic
shinyServer(function(input, output) {
   
    # Chose equation corresponding to each model
    equationInput <- reactive({
        if( input$sex == "Female") {
            switch(input$equation,
                   "ohb" = orig.hb.f,
                   "rhb" = rev.hb.f, 
                   "msj" = mifflin.f)
        } else {
            switch(input$equation,
                   "ohb" = orig.hb.m,
                   "rhb" = rev.hb.m, 
                   "msj" = mifflin.m)
        }
    })
    
    # Helper function to build the barplot
    compareEq <- reactive({
        if( input$sex == "Female") {
            f1 <- orig.hb.f
            f2 <- rev.hb.f
            f3 <- mifflin.f
        }
        else {
            f1 <- orig.hb.m
            f2 <- rev.hb.m
            f3 <- mifflin.m
        }

        data.frame(x = 1:3, 
                   y = c(f1(input$height, input$weight, input$age),
                         f2(input$height, input$weight, input$age),
                         f3(input$height, input$weight, input$age)))
    })
    
    # Print model
    output$equation <- renderPrint({
        equation <- equationInput()
        print(equation)
    })

    # Print calculated BMR
    output$result <- renderPrint({
        equation <- equationInput()
        equation(input$height, input$weight, input$age)
    })
    
    output$calories <- renderPrint({
        equation <- equationInput()
        equation(input$height, input$weight, input$age) * as.numeric(input$activity)
    })
    
    # Print barplot
    output$bars <- renderPlot({
        df <- compareEq()
        barplot(df$y, 
                names.arg = c("Original HB", "Revised HB", "Mifflin St Jeor"),
                density = c(20, 40, 60),
                main = "Model Comparisson", 
                ylab = "BMR", 
                ylim = c(0,2500),
                col = c("red", "green", "blue")
                )
        abline(h = 2000, lty = 2, lwd = 3, col = "red")
        text(x = 1.9, y = 2100, labels = "Recommended Daily Intake", col = "red")
        text(df$x, df$y, label = round(df$y,0), pos = 3, col = c("red","green","blue"))
    })
})
