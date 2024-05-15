### Maps
metroMap <- metroMap %>%
  mutate(CityShade = case_when(
    City %in% c("Delta", "New Westminster", "Langley", "Surrey") ~ shade_morethanFour,
    City %in% c("Tri-Cities", "White Rock", "Maple Ridge\n&\nPitt Meadows") ~ shade_aroundThree,
    City %in% c("North Vancouver", "Richmond", "Vancouver", "West Vancouver", "Burnaby") ~ shade_lessthanThree,
    TRUE ~ NA_character_ 
  ))

dummy_data <- data.frame(Group = names(city_shades))

metroMap <- metroMap %>%
  mutate(
    pos_x = st_coordinates(st_centroid(geometry))[, 1],
    pos_y = st_coordinates(st_centroid(geometry))[, 2],
    pos_x_2016 = pos_x,
    pos_x_2021 = pos_x,
    pos_y_2016 = pos_y + offset_2016_y,
    pos_y_2021 = pos_y + offset_2021_y,
    pos_x_change = pos_x + offset_change_x,
    pos_y_change = pos_y + offset_change_y,
    
    pop_label_2016 = sprintf("%-8s", sprintf("%.1f%%", percent_16)),
    pop_label_2021 = sprintf("%-8s", sprintf("%.1f%%", percent_21)),
    pop_label_change = sprintf("%.1f%%", pop_change),
    rent_label_2016 = sprintf("%-8s", sprintf("$%.0f", `2016`)),
    rent_label_2021 = sprintf("%-8s", sprintf("$%.0f", `2021`)),
    rent_label_change = sprintf("%.0f%%", rent_change),
    
    label_color = if_else((City %in% grey_cities) | (City %in% text_cities), "black", 
                          "white"),
    pos_x_2016 = case_when(
      City == "New Westminster" ~ pos_x_2016 + NW_offset_x,
      City == "Delta" ~ pos_x_2016 + DT_offset_x,
      City == "Richmond" ~ pos_x_2016 + RM_offset_x,
      TRUE ~ pos_x_2016
    ),
    pos_x_2021 = case_when(
      City == "New Westminster" ~ pos_x_2021 + NW_offset_x,
      City == "Delta" ~ pos_x_2021 + DT_offset_x,
      City == "Richmond" ~ pos_x_2021 + RM_offset_x,
      TRUE ~ pos_x_2021
    ),
    pos_y_2016 = case_when(
      City == "West Vancouver" ~ pos_y_2016 + WVan_offset_y,
      City == "White Rock" ~ pos_y_2016 + WR_offset_y,
      City == "New Westminster" ~ pos_y_2016 + NW_offset_y,
      City == "Maple Ridge\n&\nPitt Meadows" ~ pos_y_2016 + MP_offset_y,
      City == "Richmond" ~ pos_y_2016 + RM_offset_y,
      City == "Vancouver" ~ pos_y_2016 + Van_offset_y,
      TRUE ~ pos_y_2016
    ),
    pos_y_2021 = case_when(
      City == "West Vancouver" ~ pos_y_2021 + WVan_offset_y,
      City == "White Rock" ~ pos_y_2021 + WR_offset_y,
      City == "New Westminster" ~ pos_y_2021 + NW_offset_y,
      City == "Maple Ridge\n&\nPitt Meadows" ~ pos_y_2021 + MP_offset_y,
      City == "Richmond" ~ pos_y_2021 + RM_offset_y,
      City == "Vancouver" ~ pos_y_2021 + Van_offset_y,
      TRUE ~ pos_y_2021
    ),
    pos_x_change = case_when(
      City == "New Westminster" ~ pos_x_change + NW_offset_x,
      City == "Delta" ~ pos_x_change + DT_offset_x,
      City == "Richmond" ~ pos_x_change + RM_offset_x,
      TRUE ~ pos_x_change
    ),
    pos_y_change = case_when(
      City == "West Vancouver" ~ pos_y_change + WVan_offset_y,
      City == "White Rock" ~ pos_y_change + WR_offset_y,
      City == "New Westminster" ~ pos_y_change + NW_offset_y,
      City == "Maple Ridge\n&\nPitt Meadows" ~ pos_y_change + MP_offset_y,
      City == "Richmond" ~ pos_y_change + RM_offset_y,
      City == "Vancouver" ~ pos_y_change + Van_offset_y,
      TRUE ~ pos_y_change
    ),
    adjusted_y = case_when(
      City == "Maple Ridge\n&\nPitt Meadows" ~ pos_y_2016 - 0.055,
      TRUE ~ pos_y_2016 - 0.03
    )
  )

metroMap$pop_label_change <- ifelse(metroMap$pop_label_change > 0, 
                                    paste("+", metroMap$pop_label_change, sep=""), 
                                    as.character(metroMap$pop_label_change))

metroMap$rent_label_change <- ifelse(metroMap$rent_label_change > 0, 
                                     paste("+", metroMap$rent_label_change, sep=""), 
                                     as.character(metroMap$rent_label_change))

plot_data <- function(metric = "population") {
  
  if (metric == "population") {
    label_2016 <- "pop_label_2016"
    label_2021 <- "pop_label_2021"
    label_change <- "pop_label_change"
    caption <- "\nSource(s): Census of Population, 2016 and 2021"
    
  } else if (metric == "rent") {
    label_2016 <- "rent_label_2016"
    label_2021 <- "rent_label_2021"
    label_change <- "rent_label_change"
    caption <- "\nSource(s): Canada Mortgage and Housing Corporation, October 2016 and October 2021."
  }
  
  gg <- ggplot(data = metroMap) +
    geom_sf(fill = metroMap$CityShade, color = "white") +
    coord_sf(xlim = c(min(metroMap$pos_x) - 0.05, max(metroMap$pos_x) + 0.1), 
             ylim = c(min(metroMap$pos_y) - 0.05, max(metroMap$pos_y) + 0.1)) +
    
    geom_segment(data = filter(metroMap, City %in% text_cities),
                 aes(x = pos_x_2016, y = pos_y_2016 - 0.06, xend = pos_x, yend = pos_y),
                 color = "black", size = 0.5) +
    geom_segment(data = filter(metroMap, City %in% grey_cities),
                 aes(x = pos_x_2021, y = pos_y_2021, xend = pos_x, yend = pos_y),
                 color = "black", size = 0.5) +
    geom_text(aes(label = City, x = pos_x_2016, y = adjusted_y-0.01, color = label_color), size = 4) +
    scale_color_identity() +
    geom_label(aes_string(label = label_2016, x = "pos_x_2016", y = "pos_y_2016", 
                          fill = "'2016'"), fontface = "bold", color = "black", 
               size = 3, label.size = NA) +
    geom_label(aes_string(label = label_2021, x = "pos_x_2021", y = "pos_y_2021", 
                          fill = "'2021'"), fontface = "bold", color = "black", 
               size = 3, label.size = NA) +
    geom_point(aes(x = pos_x_change, y = pos_y_change, fill = "Percentage point difference"), size = 10, shape = 21, color = "white") +
    geom_point(aes(x = pos_x_2021, y = pos_y_2016 - 0.015), shape = 25, size = 3, color = "#FFF2DA", fill = "#FFF2DA") +
    geom_text(aes_string(label = label_change, x = "pos_x_change", y = "pos_y_change"
    ),
    color = "black", size = 3, hjust = 0.5, vjust = 0.5, 
    fontface = "bold") +
    scale_fill_manual(values = c("2016" = "#FFF2DA", "2021" = "#FFC225", 
                                 "Percentage point difference" = "#5BCFC6"), 
                      labels = c("2016", "2021", "Percentage point difference")) +
    
    guides(fill = guide_legend(
      override.aes = list(shape = 15, color = c("#FFF2DA", "#FFC225", "#5BCFC6"), size = 6),
      keywidth = unit(1, "lines"),  
      keyheight = unit(1, "lines"), 
      label.position = "right"
    )) +
    
    scale_x_continuous(expand = expansion(mult = 0.2)) +
    scale_y_continuous(expand = expansion(mult = 0.05)) +
    labs(fill = NULL) +
    labs(
      #title = title,
      caption = caption,
    ) +
    theme_void() +
    theme(
      plot.caption = element_text(hjust = 0, margin = margin(b = 5, t = 5)),
      #plot.title = element_text(hjust = 0.5, face = "bold", size = 20),
      legend.position = "bottom",
      legend.text = element_text(size = 8), 
      legend.title = element_text(size = 9)
      
    )
  
  return(gg)
}


rentmap <- plot_data(metric = "rent")
popmap <- plot_data(metric = "population")

rentmap <- rentmap + theme(plot.background = element_rect(fill = "transparent", colour = NA))
popmap <- popmap + theme(plot.background = element_rect(fill = "transparent", colour = NA))



### Population Growth
pop_growth <- ggplot(population_growth, aes(x = as.factor(Year))) +
  geom_bar(aes(y = NPRs + Immigrants + naturalIncrease, fill = 'NPRs'), position = "stack", stat = "identity") +
  geom_bar(aes(y = NetEmigration + NPRs, fill = 'NPRs'), position = "stack", stat = "identity") +
  geom_bar(aes(y = NetEmigration, fill = 'Net Emigration'), position = "stack", stat = "identity") +
  geom_bar(aes(y = Immigrants + naturalIncrease, fill = 'Immigrants'), position = "stack", stat = "identity") +
  geom_bar(aes(y = naturalIncrease, fill = 'Natural Increase'), position = "stack", stat = "identity") +
  
  geom_line(aes(y = totalGrowth, group = 1, color = 'Total Growth'), size = 1, stat = "identity") +
  scale_fill_manual(values = c('Natural Increase' = '#005F71', 'Immigrants' = '#FFC225', 'NPRs' = '#D35400', 'Net Emigration' = '#6FA5C5')) +
  
  scale_color_manual(values = c('Total Growth' = 'black')) +
  
  scale_y_continuous(
    labels = scales::label_number(scale = 1e-3),  # This will convert to thousands
    limits = c(min(population_growth$NPRs, na.rm = TRUE) * 1.3, 
               max(population_growth$totalGrowth, na.rm = TRUE) * 1.3), 
    expand = expansion(mult = c(0.03, 0.05)))+
  
  guides(fill = guide_legend(title = ""), color = guide_legend(title = "")) +
  theme_ipsum() +
  theme(
    text = element_text(size = 12),
    plot.caption = element_text(hjust = 0, margin = margin(b = 5, t = 5)),
    plot.margin = margin(t = 10, r = 10, b = 10, l = 10),
    panel.border = element_rect(linetype = "solid", color = "black", fill = NA, size = 0.5),
    axis.title.x = element_text(size = 15, hjust = 0.5, face = "bold"),
    axis.title.y = element_text(size = 15, hjust = 0.5, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 12), # Align x-axis text
    axis.text.y = element_text(size = 12),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 12)
  ) +
  labs(
       x = "Year", 
       y = "Population in Thousands",
       caption = "\nNote(s) Natural Increase is the result of (birth - death) population\nSource(s): Statistic Canada: Population estimates, quarterly; Estimates of the components of international migration, quarterly")

pop_growth <- pop_growth + theme(plot.background = element_rect(fill = "transparent", colour = NA))



### Rent
rental_plot <- ggplot(rents_data, aes(x = Year, y = Average_Rent)) +
  geom_line(color = "#43969F") +
  geom_point(color = "#43969F") +
  labs(caption = "Note(s): These are average of the average rent prices of one bedroom, to bedrooms, three bedroom\nand bachelor unit of the top 15 most populated Central Metropolitan Area in Canada.\nPrice Adjusted for 2024 CPI\nSource(s): Bank of Canada 2024, CMHC",
    x = "Year",
    y = "Average Rent Per Month") +
  theme_minimal() +
  theme(plot.caption = element_text(hjust = 0, size = 8, color = "black")) + 
  scale_y_continuous(labels = scales::comma_format(scale = 1))

rental_plot <- rental_plot + theme(plot.background = element_rect(fill = "transparent", colour = NA))

### Turnover
# Plot for Vancouver
vancouver_plot <- ggplot(vancouver_data, aes(x = Year, fill = Type, y = Price)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(subtitle = "Vancouver",
       x = "Year",
       y = "Rental Price (2024 Dollars)",
       caption = "\nNote(s): These are the average rent of 2 bedroom units only. Turnover units are counted as being turned\nover if they were occupied by a new tenant who moved in during the past 12 months. A unit can be\ncounted as being turned over more than once in a 12-month period.\nSource(s): Bank of Canada 2024, Canada Mortgage and Housing Corporation (CMHC)") +
  scale_fill_manual(values = c("#005F71", "#FFC225"), labels = c("Turnover", "Non-Turnover")) +
  theme_minimal() +
  theme(
    plot.subtitle = element_text(hjust = 0.5, face = "bold", size = 18),
    legend.position = "none"  
  ) +
  ylim(0, 3500)
# Plot for Toronto
toronto_plot <- ggplot(toronto_data, aes(x = Year, fill = Type, y = Price)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(subtitle = "Toronto",
       x = "Year",
       y = "Rental Price (2024 Dollars)") +
  scale_fill_manual(values = c("#005F71", "#FFC225"), labels = c("Turnover", "Non-Turnover")) +
  theme_minimal() +
  theme(
    plot.subtitle = element_text(hjust = 0.5, face = "bold", size = 18),
    legend.position = "none"
  ) +
  ylim(0, 3500)

# Combined plot for turnover data
combined_plot <- (vancouver_plot + toronto_plot) +
  plot_layout(guides = 'collect') & 
  theme(
    legend.position = "bottom",
    legend.box = "horizontal", 
    plot.caption = element_text(hjust = 0, size = 8, color = "black")
  ) 



### Model (Nathan)
Model1_plot <- plot_predictions(out, condition = c("Population_Growth"), vcov=FALSE) + 
  theme_minimal() +
  theme(
  text = element_text(size = 12),
  plot.title = element_text(hjust = 0, face = "bold", size = 20),
  plot.caption = element_text(hjust = 0, margin = margin(b = 5, t = 5)),
  plot.margin = margin(t = 10, r = 10, b = 10, l = 10),
  panel.border = element_rect(linetype = "solid", color = "black", fill = NA, size = 0.5),
  axis.title.x = element_text(size = 15, hjust = 0.5, face = "bold"),
  axis.title.y = element_text(size = 15, hjust = 0.5, face = "bold"),
  axis.text.x = element_text(angle = 45, hjust = 1, size = 12), # Align x-axis text
  axis.text.y = element_text(size = 12),
  legend.title = element_text(size = 20),
  legend.text = element_text(size = 12)
) +
  labs(subtitle = "Vancouver CMA, 2006",
       x = "Population Growth",
       y = "Predicted Average Rent (2024 CAD)",
       caption = "Source(s): Statistics Canada: Components of population change by CMA and CA,
                   Canada Mortgage and Housing Corporation: average rents")


Model1_plot <- Model1_plot + theme(plot.background = element_rect(fill = "transparent", colour = NA))  


### Model (James)
caption <- "\nNote(s): \n*The percentage of immigrants is calculated by the population of immigrants over the whole population of the\nsame city.\n*Immigrants includes persons who are, or who have ever been, landed immigrants or permanent residents.\n*Immigrants includes immigrants who were admitted to Canada from 2006 to 2019.\n\nSource(s): Census of Population 2021"

create_city_plot <- function(city) {
  # Define cities and their corresponding colors
  city_colors <- c("Vancouver" = "#007C8B", "Toronto" = "#6FA5C5", "Montréal" = "#A3C2A2",
                   "Calgary" = "#E67E22", "Winnipeg" = "#FF6F61", "Edmonton" = "#FFD966")
  
  # Prepare data for plotting based on input
  data_to_plot <- subset(pred_df1, City %in% if (city == "all") names(city_colors) else city)
  all_data_to_plot <- subset(complete_data_data, City %in% if (city == "all") names(city_colors) else city)
  
  # Generate the plot
  plot <- ggplot(data = data_to_plot, aes(x = Imm_pop100, y = fit, ymin = lwr, ymax = upr, group = City)) +
    geom_point(data = all_data_to_plot,
               aes(x = Imm_pop100, y = Adj_rent, color = City),
               alpha = 1, inherit.aes = FALSE) +
    geom_line(aes(color = "black")) +
    scale_y_continuous(breaks = seq(0, 2000, by = 500), limits = c(500, 2000)) +
    labs(x = "Inflow of Immigrants in Percentage",
         y = "Average Renting Price in Dollars",
         caption = caption,
         color = "City")
  
  if (city == "all") {
    plot <- plot + scale_color_manual(values = city_colors) +
      guides(color = guide_legend(title = "City"))
  } else {
    plot <- plot + scale_color_manual(values = setNames(city_colors[city], city)) +
      guides(color = guide_legend(title = "City"))
  }
  
  # Apply the theme with transparent plot background
  plot <- plot + 
    theme_minimal() +
    theme(plot.background = element_rect(fill = "transparent", colour = NA),  # Making the plot background transparent
          text = element_text(size = 12),
          plot.title = element_text(hjust = 0.5, face = "bold", size = 20),
          plot.caption = element_text(hjust = 0, margin = margin(b = 5, t = 5)),
          plot.margin = margin(t = 10, r = 10, b = 10, l = 10),
          panel.border = element_rect(linetype = "solid", color = "black", fill = NA, size = 0.5),
          axis.title.x = element_text(size = 15, hjust = 0.5, face = "bold"),
          axis.title.y = element_text(size = 15, hjust = 0.5, face = "bold"),
          axis.text.x = element_text(hjust = 1, size = 12),
          axis.text.y = element_text(size = 12),
          legend.title = element_text(size = 12),
          legend.text = element_text(size = 12))
  
  return(plot)
}


print("Functions loading is completed")
