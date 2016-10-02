# ui.R: BMR Calculator Shinny App
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

# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
    
    # Application title
    headerPanel("Basal Metabolic Rate (BMR) Calculator"),
    
    # Sidebar with controls to select BMR model and its parameters
    sidebarPanel(
        selectInput("equation", "Choose a model:", 
                    choices = c("Original Harris-Benedict Equation" = "ohb", 
                                "Revised Harris-Benedict Equation"  = "rhb", 
                                "Mifflin St Jeor Equation"          = "msj"),
                    selected = "ohb"),

        selectInput("sex", "Sex:", choices = c("Female", "Male")),
        
        numericInput("age", "Age", 30),
        numericInput("height", "Height (cm):", 165),
        numericInput("weight", "Weight (kg):", 60),
        
        selectInput("activity", "Daily Activity Level:",
                    choices = c("Little to no exercise"                 = 1.2,
                                "Light exercise (1–3 days per week)"    = 1.375,
                                "Moderate exercise (3–5 days per week)" = 1.55,
                                "Heavy exercise (6–7 days per week)"    = 1.725,
                                "Very heavy exercise (twice per day, extra heavy workouts)" = 1.9)),
        
        h5("Reference:"),
        h5(a("https://en.wikipedia.org/wiki/Basal_metabolic_rate",
             href="https://en.wikipedia.org/wiki/Basal_metabolic_rate",
             target="_blank"))
    ),
    
    # Show the selected model, the calculation result and a barplot comparing all models
    mainPanel(
        h5("Model Description"),
        verbatimTextOutput("equation"),
        
        h5("Calculated BMR"),
        verbatimTextOutput("result"),
        
        h5("Estimated Daily Calorie Consumption"),
        verbatimTextOutput("calories"),
        
        plotOutput("bars")
    )
))