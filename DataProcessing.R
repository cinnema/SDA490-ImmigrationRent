### Maps
metroVanGeo <- municipalities() %>%
  filter(ADMIN_AREA_ABBREVIATION == "Richmond"|
           ADMIN_AREA_ABBREVIATION == "Coquitlam"|
           ADMIN_AREA_ABBREVIATION == "Port Coquitlam"|
           ADMIN_AREA_ABBREVIATION == "Langley - District"|
           ADMIN_AREA_ABBREVIATION == "Langley - City"|
           ADMIN_AREA_ABBREVIATION == "Anmore"|
           ADMIN_AREA_ABBREVIATION == "Belcarra"|
           ADMIN_AREA_ABBREVIATION == "White Rock"|
           ADMIN_AREA_ABBREVIATION == "Surrey"|
           ADMIN_AREA_ABBREVIATION == "Delta"|
           ADMIN_AREA_ABBREVIATION == "Vancouver"|
           ADMIN_AREA_ABBREVIATION == "Port Moody"|
           ADMIN_AREA_ABBREVIATION == "North Vancouver - District"|
           ADMIN_AREA_ABBREVIATION == "North Vancouver - City"|
           ADMIN_AREA_ABBREVIATION == "West Vancouver"|
           ADMIN_AREA_ABBREVIATION == "Pitt Meadows"|
           ADMIN_AREA_ABBREVIATION == "Maple Ridge"|
           ADMIN_AREA_ABBREVIATION == "New Westminster"|
           ADMIN_AREA_ABBREVIATION == "Burnaby") %>%
  rename(City = ADMIN_AREA_ABBREVIATION) %>%
  mutate(City = ifelse(City == "Anmore", "Anmore (VL)", City)) %>%
  mutate(City = ifelse(City == "Surrey", "Surrey (CY)", City)) %>%
  mutate(City = ifelse(City == "Belcarra", "Belcarra (VL)", City)) %>%
  mutate(City = ifelse(City == "Burnaby", "Burnaby (CY)", City)) %>%
  mutate(City = ifelse(City == "Coquitlam", "Coquitlam (CY)", City)) %>%
  mutate(City = ifelse(City == "Port Coquitlam", "Port Coquitlam (CY)", City)) %>%
  mutate(City = ifelse(City == "Delta", "Delta (DM)", City)) %>%
  mutate(City = ifelse(City == "Langley - District", "Langley (DM)", City)) %>%
  mutate(City = ifelse(City == "Langley - City", "Langley (CY)", City))  %>%
  mutate(City = ifelse(City == "Maple Ridge", "Maple Ridge (CY)", City)) %>%
  mutate(City = ifelse(City == "New Westminster", "New Westminster (CY)", City)) %>%
  mutate(City = ifelse(City == "North Vancouver - City", "North Vancouver (CY)", City)) %>%
  mutate(City = ifelse(City == "North Vancouver - District", "North Vancouver (DM)", City)) %>%
  mutate(City = ifelse(City == "Pitt Meadows", "Pitt Meadows (CY)", City)) %>%
  mutate(City = ifelse(City == "Port Moody", "Port Moody (CY)", City)) %>%
  mutate(City = ifelse(City == "Richmond", "Richmond (CY)", City)) %>%
  mutate(City = ifelse(City == "Vancouver", "Vancouver (CY)", City)) %>%
  mutate(City = ifelse(City == "West Vancouver", "West Vancouver (DM)", City)) %>%
  mutate(City = ifelse(City == "White Rock", "White Rock (CY)", City))

metroVanGeo <- lwgeom::st_transform_proj(metroVanGeo, "+proj=longlat +datum=WGS84")

RentPrices_data <- RentPrices_data %>%
  mutate(AverageRent = as.numeric(gsub(",", "", AverageRent))) %>%
  mutate(City = case_when(
    City %in% c("Central Park/Metrotown", "Southeast Burnaby", "North Burnaby") ~ "Burnaby",
    City %in% c("West End/Stanley Park", "English Bay", "Downtown", "South Granville/Oak", "Kitsilano/Point Grey", "Westside/Kerrisdale", "Marpole", "Mount Pleasant/Renfrew Heights", "East Hastings", "Southeast Vancouver", "Vancouver") ~ "Vancouver",
    City == "Langley City and Langley DM" ~ "Langley",
    City == "Maple Ridge/Pitt Meadows" ~ "Maple Ridge\n&\nPitt Meadows",
    City %in% c("North Vancouver CY", "North Vancouver DM") ~ "North Vancouver",
    TRUE ~ City
  )) %>%
  filter(City != "University Endowment Lands") %>%
  group_by(City, Year) %>%
  summarise(MeanAverageRent = round(mean(AverageRent, na.rm = TRUE)),2) %>%
  ungroup() %>%
  filter(Year %in% c(2016, 2021)) %>%
  pivot_wider(names_from = Year, values_from = MeanAverageRent) %>%
  mutate(rent_change = (`2021` - `2016`)/`2016`*100)

BC_census_16 <- get_census(dataset='CA16', regions=list(CSD=c("55915001","1216", "5915004", "5915025", "5915015","5915034","5915001", "5915011","5915046","5915075","5915029","5915051","5915055","5915043","5915002","5915007","5915070","5915062","2442098","5915038","1311001","59933","5915051", "5915002", "5915039")),vectors=c("v_CA16_3405","v_CA16_3408","v_CA16_3411","v_CA16_3414","v_CA16_3417","v_CA16_3420","v_CA16_3423","v_CA16_3432","v_CA16_3435","v_CA16_3390","v_CA16_3396","v_CA16_3399","v_CA16_3402","v_CA16_3393","v_CA16_401", "v_CA16_3435"),level='CSD', use_cache = FALSE, geo_format = NA, quiet = TRUE)

BC_census_16 <- BC_census_16 %>%
  filter(GeoUID == "5915001"|
           GeoUID == "5915022"|
           GeoUID == "5915004"|
           GeoUID == "5915007"|
           GeoUID == "5915011"|
           GeoUID == "5915015"|
           GeoUID == "5915025"|
           GeoUID == "5915029"|
           GeoUID == "5915034"|
           GeoUID == "5915036"|
           GeoUID == "5915038"|
           GeoUID == "5915043"|
           GeoUID == "5915046"|
           GeoUID == "5915055"|
           GeoUID == "5915062"|
           GeoUID == "5915070"|
           GeoUID == "5915075"|
           GeoUID == "5915051"|
           GeoUID == "5915002"|
           GeoUID == "5915039") %>%
  
  rename(Total_pop_16 = "v_CA16_401: Population, 2016") %>%
  rename(Immigrants_16 = "v_CA16_3411: Immigrants") %>%
  rename(nonpr_16 = "v_CA16_3435: Non-permanent residents...22") %>%
  rename(City = "Region Name") %>%
  dplyr::select(City, Immigrants_16, Total_pop_16, nonpr_16)

BC_census_21 <- get_census(dataset='CA21', regions=list(CSD=c("55915001","1216", "5915004", "5915025", "5915015","5915034","5915001", "5915011","5915046","5915075","5915029","5915051","5915055","5915043","5915002","5915007","5915070","5915062","2442098","5915038","1311001","59933","5915051", "5915002", "5915039")),vectors=c("v_CA21_4404","v_CA21_1","v_CA21_4407","v_CA21_4410","v_CA21_4425", "v_CA21_4434"),level='CSD', use_cache = FALSE, geo_format = NA, quiet = TRUE)

BC_census_21 <- BC_census_21 %>%
  filter(GeoUID == "5915001"|
           GeoUID == "5915022"|
           GeoUID == "5915004"|
           GeoUID == "5915007"|
           GeoUID == "5915011"|
           GeoUID == "5915015"|
           GeoUID == "5915025"|
           GeoUID == "5915029"|
           GeoUID == "5915034"|
           GeoUID == "5915036"|
           GeoUID == "5915038"|
           GeoUID == "5915043"|
           GeoUID == "5915046"|
           GeoUID == "5915055"|
           GeoUID == "5915062"|
           GeoUID == "5915070"|
           GeoUID == "5915075"|
           GeoUID == "5915051"|
           GeoUID == "5915002"|
           GeoUID == "5915039") %>%
  rename(Total_pop_21 = "v_CA21_1: Population, 2021") %>%
  rename(Immigrants_21 = "v_CA21_4410: Immigrants") %>%
  rename(nonpr_21 = "v_CA21_4434: Non-permanent residents") %>%
  rename(City = "Region Name") %>%
  dplyr::select(City, Total_pop_21, Immigrants_21, nonpr_21)

metroMap <- dplyr::full_join(metroVanGeo, BC_census_16, by="City")
metroMap <- dplyr::full_join(metroMap, BC_census_21, by="City")

metroMap <- metroMap %>%
  filter(City != "Delta (CY)") %>%
  mutate(
    Immigrants_21 = case_when(
      City == "Delta (DM)" ~ 35555,
      TRUE ~ Immigrants_21
    ),
    Total_pop_21 = case_when(
      City == "Delta (DM)" ~ 102238,
      TRUE ~ Total_pop_21
    ),
    nonpr_21 = case_when(
      City == "Delta (DM)" ~ 3750,
      TRUE ~ nonpr_21
    ),
    City = case_when(
      City == "Anmore (VL)" ~ "Tri-Cities",
      City == "Surrey (CY)" ~ "Surrey",
      City == "Belcarra (VL)" ~ "Tri-Cities",
      City == "Burnaby (CY)" ~ "Burnaby",
      City == "Coquitlam (CY)" ~ "Tri-Cities",
      City == "Port Coquitlam (CY)" ~ "Tri-Cities",
      City == "Delta (DM)" ~ "Delta",
      City == "Langley (DM)" ~ "Langley",
      City == "Langley (CY)" ~ "Langley",
      City == "Maple Ridge (CY)" ~ "Maple Ridge\n&\nPitt Meadows",
      City == "New Westminster (CY)" ~ "New Westminster",
      City == "North Vancouver (CY)" ~ "North Vancouver",
      City == "North Vancouver (DM)" ~ "North Vancouver",
      City == "Pitt Meadows (CY)" ~ "Maple Ridge\n&\nPitt Meadows",
      City == "Port Moody (CY)" ~ "Tri-Cities",
      City == "Richmond (CY)" ~ "Richmond",
      City == "Vancouver (CY)" ~ "Vancouver",
      City == "West Vancouver (DM)" ~ "West Vancouver",
      City == "White Rock (CY)" ~ "White Rock",
      TRUE ~ City
    )
  ) %>%
  group_by(City) %>%
  summarize(
    Immigrants_16 = sum(Immigrants_16, na.rm = TRUE),
    nonpr_16 = sum(nonpr_16, na.rm = TRUE),
    Total_pop_16 = sum(Total_pop_16, na.rm = TRUE),
    Total_pop_21 = sum(Total_pop_21, na.rm = TRUE),
    Immigrants_21 = sum(Immigrants_21, na.rm = TRUE),
    nonpr_21 = sum(nonpr_21, na.tm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    percent_16 = (Immigrants_16 + nonpr_16) / Total_pop_16 * 100,
    percent_21 = (Immigrants_21 + nonpr_21) / Total_pop_21 * 100,
    pop_change = percent_21 - percent_16
  )

metroMap <- full_join(metroMap, RentPrices_data, by = "City")

text_cities <- c("West Vancouver")
grey_cities <- c("White Rock", "New Westminster") 

shade_morethanFour <- "#004A5E" 
shade_aroundThree <- "#006D85"  
shade_lessthanThree <- "#0098A1"

offset_2016_y <- 0.045
offset_2021_y <- 0.063
offset_change_x <- 0.045
offset_change_y <- 0.054
WVan_offset_y <- 0.07
WR_offset_y <- -0.1
NW_offset_x <- -0.5
NW_offset_y <- -0.2
DT_offset_x <- 0.05
MP_offset_y <- 0.03
RM_offset_x <- -0.045
RM_offset_y <- -0.02
Van_offset_y <- -0.02

city_shades <- c("More than Four" = "#004A5E", 
                 "Around Three" = "#006D85",  
                 "Less than Three" = "#0098A1")



### population plot
ImmigrantEstimates_data <- ImmigrantEstimates_data %>%
  select(REF_DATE, `Components.of.population.growth`, VALUE) %>%
  mutate(Year = substr(REF_DATE, 1, 4),
         VALUE = if_else(`Components.of.population.growth` == "Net emigration", 
                         -VALUE, VALUE)) %>%
  group_by(Year) %>%
  summarise(Immigrants = sum(VALUE[`Components.of.population.growth` == "Immigrants"], 
                             na.rm = TRUE),
            NetEmigration = sum(VALUE[`Components.of.population.growth` == 
                                        "Net emigration"], na.rm = TRUE),
            NPRs = sum(VALUE[`Components.of.population.growth` == 
                               "Net non-permanent residents"], na.rm = TRUE),
            .groups = "drop") %>%
  mutate(NetImmigrantValue = Immigrants + NetEmigration + NPRs)


naturalIncrease_data <- naturalIncrease_data %>%
  mutate(Year = substr(REF_DATE, 1, 4)) %>%
  group_by(Year, Estimates) %>%
  summarise(NaturalIncreaseValue = sum(VALUE, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = Estimates, values_from = NaturalIncreaseValue) %>%
  mutate(naturalIncrease = `Births` - `Deaths`) %>%
  select(Year, naturalIncrease)

population_growth <- merge(ImmigrantEstimates_data, naturalIncrease_data, by = "Year") %>%
  mutate(totalGrowth = naturalIncrease + Immigrants + NetEmigration + NPRs) 

# Processing rental price data
data_2022 <- subset(`Rental price_data`, REF_DATE == 2022)
data_2022 <- data_2022[order(-data_2022$Population_Estimate), ]
top_15_cities <- head(data_2022$City, 15)
top_15_data <- `Rental price_data`[`Rental price_data`$City %in% top_15_cities, ]

# Processing turnover data
`Turnover Van Tor_data`$Year <- factor(`Turnover Van Tor_data`$Year)
`Turnover Van Tor_data`$Turnover.Price <- as.numeric(gsub(",", "", `Turnover Van Tor_data`$Turnover.Price))
`Turnover Van Tor_data`$Non.Turnover.Price <- as.numeric(gsub(",", "", `Turnover Van Tor_data`$Non.Turnover.Price))
`Turnover Van Tor_data_long` <- melt(`Turnover Van Tor_data`, id.vars = c("City", "Year"), measure.vars = c("Turnover.Price", "Non.Turnover.Price"))
colnames(`Turnover Van Tor_data_long`) <- c("City", "Year", "Type", "Price")
vancouver_data <- subset(`Turnover Van Tor_data_long`, City == "Vancouver CMA")
toronto_data <- subset(`Turnover Van Tor_data_long`, City == "Toronto CMA")



### Rent and Turnover Plot
cpi_2024 <- 158.8
avg_rents <- numeric(21)  
for (year in 2002:2022) {
  total_rent <- 0
  for (city in top_15_cities) {
    city_data <- subset(top_15_data, City == city)
    cpi_year <- city_data$CPI_current[city_data$REF_DATE == year]
    adj_factor <- cpi_2024 / cpi_year
    total_rent <- total_rent + city_data$Average_Rent[city_data$REF_DATE == year] * adj_factor
  }
  avg_rents[year - 2001] <- total_rent / length(top_15_cities)
}
rents_data <- data.frame(
  Year = 2002:2022,
  Average_Rent = avg_rents
)



### Model (Nathan)
Data_filtered <- Data_Pop_Growth_filtered_data %>%
  mutate(City = str_replace(City, "Vancouver", "0 Vancouver")) %>% arrange(City, REF_DATE)

out <- feols(Adj_rent ~ Population_Growth + Adj_M_Income + Unemployment_rate + Housing_completions + Vacancy_Rate + GDP_pro | City + REF_DATE, Data_filtered)

models1 <- list(
  
  "Fixed Effects 1" = feols(Adj_rent ~ Population_Growth + Adj_M_Income + Unemployment_rate + Housing_completions + Vacancy_Rate + GDP_pro | City + REF_DATE, Data_filtered),
  
  "Fixed Effects 2" = feols(Adj_rent ~ Population_Growth + Adj_M_Income + Unemployment_rate + Housing_completions + Vacancy_Rate + GDP_pro | City, Data_filtered)
)

models2 <- list("OLS" = lm(Adj_rent ~ Adj_M_Income + Imm_pop100 + Unemployment_rate + Housing_completions + Vacancy_Rate + GDP_pro, data = Data_filtered))

modelsummary(out)

modelsummary(models1, stars = TRUE, fmt=4)
modelsummary(models2, stars = TRUE)


a <- predictions(out, newdata = Data_filtered)



### Model (James)

model2 <- lm(Adj_rent ~ Adj_M_Income + Imm_pop100 + Unemployment_rate + Housing_completions + Vacancy_Rate + GDP_pro, data = complete_data_data)

min_immi <- min(complete_data_data$Imm_pop100, na.rm = TRUE)
max_immi <- max(complete_data_data$Imm_pop100, na.rm = TRUE)

# control for all variables except Imm_pop100, based on six CMAs
pred_df <- expand.grid(Imm_pop100 = (seq(from = min_immi,
                                         to = max_immi,
                                         length.out = 1000)),
                       Adj_M_Income = income <- mean(complete_data_data$Adj_M_Income, na.rm = TRUE),
                       Unemployment_rate = median(complete_data_data$Unemployment_rate, na.rm = TRUE),
                       Housing_completions = mean(complete_data_data$Housing_completions, na.rm = TRUE),
                       Vacancy_Rate = mean(complete_data_data$Vacancy_Rate, na.rm = TRUE),
                       GDP_pro = mean(complete_data_data$GDP_pro, na.rm = TRUE),
                       City = c("Vancouver", "Toronto", "Montréal","Calgary","Winnipeg","Edmonton"))


# Make predictions
pred_out <- predict(object = model2,
                    newdata = pred_df,
                    interval = "predict")

# Combine the predicted Ys with dataset
pred_df1 <- cbind(pred_df, pred_out)




print("dataProcessing is completed")

