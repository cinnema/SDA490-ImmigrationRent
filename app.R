suppressWarnings({
  source("DataLoading.R")
  source("DataProcessing.R")
  source("Functions.R")
})

ui <- navbarPage(
  title = div("2024 SDA Capstone Seminar - Housing Crisis", class = "title"),
  windowTitle = "Immigration and Rental Prices",
  # Apply custom styles
  tags$head(
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Futura&display=swap"),
    tags$style(HTML('
    /* General Layout and Typography */
    .title {
    font-family: "Futura", sans-serif; 
    font-size: 1.5vh;
    margin-bottom: 10px;
    color: #1D495C;
    }
    h1 {
    font-family: "Futura", sans-serif;
    font-size: 6vh;
    color: #1D495C;
    font-weight: bold;
    line-height: 1.2;
    padding-top: 5vw;
    padding-bottom: 3vw;
    margin: 0;
    color: #1D495C; 
    text-shadow: 
    0 0 10px #FFFFFF, 
    0 0 20px #FFFFFF, 
    1px 1px #FFFFFF;
    }
    h2 {font-family: "Futura", sans-serif;
    font-size: 4vh;
    color: #1D495C;
    font-weight: bold;
    text-align: center;
    line-height: 1.5;
    }
    h3 {
    font-family: "Futura", sans-serif;
    font-size: 4vh;
    color: #1D495C;
    font-weight: bold;
    text-align: center;
    line-height: 1.5;
    
    }
    h4{
    font-family: "Futura", sans-serif;
    font-size: 4vh;
    color: #1D495C;
    font-weight: bold;
    text-align: right;
    line-height: 1.5;
    }
    h5{
    font-family: "Futura", sans-serif;
    font-size: calc(0.8vw + 0.8vh + 0.8vmin);
    color: #1D495C;
    font-weight: bold;
    text-align: left;
    line-height: 1.5;
    }
    p {
    font-size: calc(0.6vw + 0.6vh + 0.6vmin);
    font-family: "Futura", sans-serif;
    color: #133243;
    text-align: left; 
    line-height: 1.5;
    }
     @media (max-width: 767px) {
     p {
     font-size: 10px !important;
     }
     }
    /* Navigation Bar */
    .navbar {
    
    background-color: #ffffff;
    border: 0;
    padding-right: 110px;
    padding-left: 110px;
    }
    .navbar-default .navbar-nav > li > a {
    color: #1D495C;
    }
    .navbar-default .navbar-nav > .active > a,
    .navbar-default .navbar-nav > .active > a:hover,
    .navbar-default .navbar-nav > .active > a:focus {
    background-color: #ffffff;
    color: #43969F;
    }
    .navbar .navbar-nav { 
    font-family: "Futura", sans-serif;
    float: right; 
    font-size: 1.5vh;
    }
    .dot-navigation {
        position: fixed;
        top: 50%;
        right: 50px;
        transform: translateY(-50%);
        z-index: 1000;
      }
      .nav-dot {
        cursor: pointer;
        height: 1vw;
        width: 1vw;
        margin: 20px 0;
        background-color: #007C8B;
        border-radius: 50%;
        display: block;
        transition: background-color 0s;
      }
      .nav-dot:hover {
        background-color: #5BCFC6;
      }
      .nav-dot.active {
        background-color: #FFC225;
      }
      .nav-dot::after {
        content: attr(title);
        position: absolute;
        bottom: 100%;
        left: 100%;
        transform: translateX(-50%);
        color: #fff;
        background-color: #133243;
        padding: 2px 6px;
        border-radius: 3px;
        opacity: 0;
        visibility: hidden;
        transition: opacity 0.2s, visibility 0.2s;
        z-index: 10;
        font-size: 1.2vh;
      }
      .nav-dot:hover::after {
        opacity: 1;
        visibility: visible;
      }
      
      /* Content Sections */
      .header-section {
      background-image: url("https://expeditevisa.co/wp-content/uploads/2023/09/Trusted-Institutions-Framework-and-the-Housing-Crisis-1.png"); /* Adjust path accordingly */
      background-position: center; 
      background-size: cover; 
      background-repeat: no-repeat;
      padding: 30px;
      text-align: left;
      position: relative; 
      display: flex;
      flex-direction: column;
      justify-content: center;
      max-height: 800px;
      }
      .image-container {
        width: auto; /* Container takes the full width of its parent */
        overflow: hidden; /* Hides parts of the image that exceed the dimensions */
        position: relative; /* Needed for absolute positioning of the image */
        min-height: 300px; /* Minimum height to ensure container is visible */
      }
      .image-container img {
        max-width: 100%; /* Ensures image is not wider than the container */
        height: auto; /* Maintains aspect ratio */
        position: relative; /* Changed to relative */
        display: block; /* Ensures that img uses block layout */
        margin: 0 auto; /* Centers image horizontally */
      }
      .header-section p {
      background-color: rgba(255, 255, 255, 0.8);
      padding: 10px;
      border-radius: 5px;
      color: #1D495C; 
      display: flex;
      max-width: 30vw;
      
      margin: 0;
      }
      .content-section{
      margin-top: 100px;
      margin-bottom: 100px;
      }
      .name-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 1vw; /* Spacing between the columns */
      margin-top: 1vh;
      font-size: calc(1.5vw + 1.5vh);
      font-family: "Futura", sans-serif;
      color: #133243;
      text-align: center;

      justify-content: center; /* Centers grid items along the row/inline-axis */
      width: 100%; /* Ensures the grid takes full width of its container */
      margin-left: auto; /* Together with margin-right, centers the grid horizontally */
      margin-right: auto;
      }



      .col-sm-4 {
      min-height: 70vh;
      max-height: 60%;
      max-width: 33.333%;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-item: center;
      }
      .col-sm-8 {
      padding: 0;
      margin: 0;
      margin-top: 30px;
      margin-bottom: 30px;
      height: 55vh;
      max-height: 550px;
      max-width: 66.666%;
      border: 5px solid #005F71;
      border-radius: 1%;
      }
      .col-sm-7 {
      padding: 0;
      margin: 0;
      margin-top: 20vh;
      margin-bottom: 20vh;
      height: 55vh;
      max-height: 550px;
      max-width: 1000px;
      }
      .shiny-plot-output{
      min-height: 100%;
      max-height: 100%;
      }
      .row {
      margin: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      }
      .tab-content {
      padding-right: 80px;
      padding-left: 80px;
      }
      .shiny-input-container .selectize-input, .shiny-input-container .selectize-dropdown {
        font-size: 1vw !important;
      }
        .btn-custom {
        background-color: white;
        color: #007C8B;
        border: none; 
        padding: 8px 16px;
        text-align: center;
        text-decoration: none;
        display: block;
        font-size: 1.5vw;
        font-weight: bold;
        margin: 4px 2px;
        transition-duration: 0s; 
        cursor: pointer;
      }
      .btn-custom:hover {
        background-color: #white; 
      }
      .btn-custom:active {
        background-color: #007C8B; 
        box-shadow: 0 5px 666;
        transform: translateY(4px);
      }
                    ')),
    
    
    
    tags$script(HTML('
  $(document).ready(function(){
    $(".nav-dot").on("click", function(event) {
      event.preventDefault();
      var targetSection = $(this).attr("data-target");
      var sectionOffset = $(targetSection).offset().top;
      var sectionHeight = $(targetSection).outerHeight();
      var windowHeight = $(window).height();
      var scrollTo = sectionOffset - ((windowHeight / 2) - (sectionHeight / 2));
      
      $("html, body").animate({
        scrollTop: scrollTo
      }, 800);
    });
    $(window).on("scroll", function() {
      $(".content-section").each(function() {
        var topOfWindow = $(window).scrollTop();
        var windowHeight = $(window).height();
        var sectionOffset = $(this).offset().top;
        var sectionHeight = $(this).outerHeight();
        var dot = $(".nav-dot[data-target=\'#" + $(this).attr("id") + "\']");
        
        if (sectionOffset < topOfWindow + windowHeight/2 && sectionOffset + sectionHeight > topOfWindow + windowHeight/2) {
          dot.addClass("active");
        } else {
          dot.removeClass("active");
        }
      });
    });
  });
'))
    
    
  ),
  
  

  tabPanel("Home",
           div(class = "dot-navigation",
               a(class = "nav-dot", "data-target" = "#section1", title = "Cover Page"),
               a(class = "nav-dot", "data-target" = "#section2", title = "Overview"),
               a(class = "nav-dot", "data-target" = "#section3", title = "Growth Components"),
               a(class = "nav-dot", "data-target" = "#section4", title = "Average Rent"),
               a(class = "nav-dot", "data-target" = "#section5", title = "Turnover Rent"),
               a(class = "nav-dot", "data-target" = "#section6", title = "Distribution Map"),
               a(class = "nav-dot", "data-target" = "#section7", title = "Rent Map"),
               a(class = "nav-dot", "data-target" = "#section8", title = "Intro to Model"),
               a(class = "nav-dot", "data-target" = "#section9", title = "Population Growth on Rent"),
               a(class = "nav-dot", "data-target" = "#section10", title = "Immigrants on Rent"),
               a(class = "nav-dot", "data-target" = "#section11", title = "Conclusion")
           ),
           
           div(class = "header-section", id = "section1", 
               h1(HTML("Immigrants,<br>Population Growth<br>and Canadian Rental Prices")),
               p(HTML("Canada is now at a pivotal point with increasing immigration rates and rental prices.
                    This study aims to delve deeper into the current debate surrounding
                    the effects of immigration and population growth on Canadian rental prices,
                    in light of ongoing policy changes and public narratives."))
           ),
           
           div(class = "content-section", id = "section2",
               fluidRow(
                 column(5, style='text-align: left;',
                        h4(HTML("<span style='color: #FFC225;'>Overview<br></span> of Canada Population and Rent Prices"))
                 ),
                 column(7, style = 'border: none;',
                        div(class = "image-container", # Encapsulating the img in a container div
                            img(src = "https://bloximages.chicago2.vip.townnews.com/thestar.com/content/tncms/assets/v3/editorial/0/bd/0bdcc909-0f22-5905-8c54-2aa88648b755/65bd51f5e0a54.image.jpg?resize=1200%2C800",
                                alt = "Description of Image"))))),
           
           div(class = "content-section", id="section3",
               h3("Population Growth Components Estimates, 2002-2023"),
               fluidRow(
                 column(8, plotOutput("displayPop_growth")),
                 column(4, 
                 h5(HTML("In 2022 and 2023, Non-PR accounts for <span style='color: #FFC225;'><u>more than half</u></span> of our population growth components.")),
                 p(HTML("Recent data highlights a shift in Canadian population growth, with immigrants and non-permanent residents (NPRs) 
                 playing increasingly significant roles, while the natural increase declines,
                 marking a significant departure from previous trends."))
                        ))
           ),
           div(class = "content-section", id="section4",
               h3("Average Rent for Top 15 CMA Cities, 2002-2022, (Adjusted to 2024 CAD)"),
               fluidRow(
                 column(8, plotOutput("displayRentalPlot")),
                 column(4,
                        p("Average rent prices for housing units in Canada's most populous metropolitan areas have risen over the two decades 
                 from 2002 to 2022, with the data adjusted for inflation to 2024 values."),
                        style = "text-align: justify;"))
           ),
           div(class = "content-section", id="section5",
               h3("Turnover v.s Non-Turnover Rent Price for 2 Bedroom Units"),
               fluidRow(
                 column(8, plotOutput("displayTurnoverPlot")),
                 column(4,
                        p("Rental prices for two-bedroom units in Vancouver and Toronto are higher for turnover units, where new tenants have 
                 moved in within the past year, compared to non-turnover units, highlighting the effects of tenant turnover on rent 
                 levels. The difference in rent between turnover and non-turnover units is particularly pronounced in recent years, 
                 suggesting a link to increased immigration."),
                        style = "text-align: justify;"))
           ),
           div(class = "content-section", id = "section6",
               h3(HTML("Immigrant and Non-PR Population Distribution in Metro Vancouver, 2016 and 2021")),
               fluidRow(
                 column(8, plotOutput("displayPopMap")),
                 column(4,
                        h5(HTML("Immigrants and NPRs constitute
                       <span style='color: #FFC225;'><u>two-fifths</u></span> of the 
                       population in the Metro Vancouver Area in 2021<br><br>3.1% Increase")),
                        p(HTML("<br>in the population of Immigrants and NPRs in the whole Metro Vancouver area since 2016."))
                 )
               )
           ),
           div(class = "content-section", id="section7",
               h3("Metro Vancouver's Average Rent in 2016 and 2021"),
               fluidRow(
                 column(8, plotOutput("displayRentMap")),
                 column(4,
                        h5(HTML(
                          "Average Rent in Metro Vancouver Area increased by
                        <span style='color: #FFC225;'><u>25.6%</u></span> in 2021<br><br>
                          $1515:")),
                        p("Average rent in Metro Vancouver 2021.")))
           ),
           
           div(class = "content-section", id = "section8",
               fluidRow(
                 column(5, style='text-align: left;',
                        h4(HTML("Introduction to <span style='color: #FFC225;'><br>Our Model</span>"))
                 ),
                 column(7, style = 'border: none;',
                        div(class = "image-container", # Encapsulating the img in a container div
                            img(src = "https://www.pewtrusts.org/-/media/post-launch-images/2023/04/hf-analysis-photo-illo-v6-blue.jpg?h=346&w=615&la=en&hash=E6628E60081508A757EFA92AC8317F85",
                                alt = "Descriptive Image Alt"))))),
           
           div(class = "content-section", id="section9",
               h3("Marginal Effect of Population Growth on Average Predicted Rent"),
               fluidRow(
                 column(8, plotOutput("displayModel1_plot")),
                 column(4, style='text-align: justify;',
                        p(HTML((paste0("There is a <b><span style='color: #FFC225;'> positive correlation </span></b>
                        between average rental prices and population growth in Vancouver <br> 
                        <b><br>Dependent Variable:<br></b>Average Rent (2024 CAD)<br><br><b>Independent Variable:<br></b>
                  - Population Growth and Inflow of Immigrants as a percentage of total population
                  <br>
                  - Unemployment Rate
                  <br>
                  - Vacancy Rate
                  <br>
                  - Medium Income (2024 CAD)
                  <br>
                  - Housing Completions
                  <br>
                  - GDP (Provincial level)"))))
           ))),
           div(class = "content-section", id="section10",
               h3("Predicted Renting Price Based on Growth of Immigrants in Major CMAs"),
               fluidRow(
                 column(8, plotOutput("cityPlot")),  
                 column(4,  
                        p(HTML(paste0("Overall, there is a <b><span style='color: #FFC225;'>positive relationship</span></b>
                        between changes in average rent and immigrant inflow indicating that higher 
                          immigrant inflows have an impact on average rental prices."))),
                        selectInput("city",
                                    label = p(HTML("Choose a city:")),
                                    choices = c("All", "Vancouver", "Toronto", "Montréal", "Calgary", "Winnipeg", "Edmonton"),
                                    selected = "All")  
                 ))),
           
           div(class = "content-section", id="section11",
               h3(style='text-align: center;', "But Hey, We Still Need Immigrants in Our Country"),
               fluidRow(
                 column(4,# Adjust padding-top as needed
                        img(src = "https://static01.nyt.com/images/2018/08/20/opinion/20torres-cao/20torres-cao-superJumbo.jpg",
                            style = "width:100%; height:auto;")),
                 column(8, style='text-align: center; border: none;',
                        p(HTML("So far we have explored the <span style='color: #43969F;'>effects</span> of population growth on 
     rental prices, noting a positive correlation, particularly due to immigration. This isn't a detriment 
     to Canada, however. Statistics Canada reports that international students, many of whom become residents, 
     contributed <b>$21 billion</b> to the economy in 2018 alone.<br><br>With a fifth of the workforce nearing retirement, 
     immigration is <span style='color: #FFC225;'>key to filling the labor gap.</span><br><br><b>Immigrants don't just add numbers; 
     they pay taxes, enriching government coffers and enhancing our communities with cultural diversity.</b>"))
                 )))),

  tabPanel("About",
           div(class = "about-section",
               h2("Hello! 您好！Ciao!"),
               img(src = "https://cdn.symphonyx.in/fetch/15/7/CONTENT/BACKGROUND/Resources-Course-mgmt_1624966009460.png",
                   style = "width:25%; max-width: 600px; height: auto; margin-bottom: 20px; display: block; margin-left: auto; margin-right: auto;"),
               p("As a group of first, second, and third-generation immigrants, we come from diverse academic backgrounds in economics, statistics, and political science. Our deep connection to the issues of immigration and rental prices in Canada drives our commitment to exploring these dynamics thoroughly."),
               div(class = "name-grid",
                   actionButton("btn1", "Lucas Chan", class = "btn-custom"),
                   actionButton("btn2", "Sonia Ma", class = "btn-custom"),
                   actionButton("btn3", "Nathan Tesan", class = "btn-custom"),
                   actionButton("btn4", "James Zhang", class = "btn-custom")
               ),
               uiOutput("infoText")
           )
           )
  )


server <- function(input, output) {
  output$displayPop_growth <- renderPlot({
    return(pop_growth)
  })
  output$displayRentalPlot <- renderPlot({
    return(rental_plot)
  })
  output$displayTurnoverPlot <- renderPlot({
    return(combined_plot)
  })
  output$displayPopMap <- renderPlot({
    return(popmap)
  })
  output$displayRentMap <- renderPlot({
    return(rentmap)
  })
  output$displayModel1_plot <- renderPlot({
    return(Model1_plot)
  })
  output$cityPlot <- renderPlot({
    city <- if(input$city == "All") "all" else input$city
    create_city_plot(city)
  })
  
  lastButtonClicked <- reactiveVal()
  
  observeEvent(input$btn1, {
    lastButtonClicked("btn1")
  })
  observeEvent(input$btn2, {
    lastButtonClicked("btn2")
  })
  observeEvent(input$btn3, {
    lastButtonClicked("btn3")
  })
  observeEvent(input$btn4, {
    lastButtonClicked("btn4")
  })
  
  output$infoText <- renderUI({
    if (is.null(lastButtonClicked())) {
      return(p("Please click the names to show information."))
    } else {
    switch(lastButtonClicked(),
           "btn1" = p(HTML("<b>Lucas Chan</b><br>Economics and Social Data Analytics<br><span style='color: #007C8B;'><u>lmc17@sfu.ca</span><i></u><br>'This project was a great chance for me 
                           to use what I've learned in class to tackle real-life problems and work with actual data.'</i><br>")),
           "btn2" = p(HTML("<b>Sonia Ma</b><br>Political Science and Social Data Analytics<br><span style='color: #007C8B;'><u>soniama7301@gmail.com<br></u></span><i>
                      'This project has enabled me to reflect on my role as an immigrant in Canada. It has honed my critical thinking skills, 
                           allowing me to understand the reasoning behind policy changes effectively. Additionally, it has equipped me with the 
                           ability to critically assess data and present it in a compelling manner.'</i><br>")),
           "btn3" = p(HTML("<b>Nathan Tesan<br></b>Economics and Social Data Analytics<br><span style='color: #007C8B;'><u>nathandtesan@gmail.com<br></u></span><i>
                      'Our project allowed me to apply what I have learned in my degree to analyze real-world phenomena using real-world data.'</i><br>")),
           "btn4" = p(HTML("<b>James Zhang<br></b>Statistic and Social Data Analytics<br><span style='color: #007C8B;'><u>jameousz2007@outlook.com<br></u></span><i>
                      'Social data analytics is not just about calculation and modeling, it's about improving society, and it has always been my motivation to be a statistician.'</i><br>"))
    )
  }})
  
}
  

shinyApp(ui = ui, server = server)
