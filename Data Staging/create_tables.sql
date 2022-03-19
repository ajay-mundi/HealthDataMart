CREATE TABLE "Event" (
  "Event_Key" int,
  "Disaster_Subgroup" varchar,
  "Disaster_Type" varchar,
  "Disaster_Subtype" varchar,
  "Start_Month" int,
  "End_Month" int,
  "Start_Year" int,
  "End_Year" int,
  "Total_Deaths" int,
  "Total_Injuries" int,
  "Total_Homeless" int,
  "Total_Affected" int,
  PRIMARY KEY ("Event_Key")
);

CREATE TABLE "QualityofLife" (
  "QOL_Key" int,
  "Maternal_Leave_Benefits" int,
  "Access_To_Basic_Drinking_Water_Total" real,
  "Access_To_Basic_Drinking_Water_Urban" real,
  "Access_To_Basic_Sanitation_Total" real,
  "Access_To_Basic_Sanitation_Urban" real,
  "Access_To_Managed_Drinking_Water_Total" real,
  "Access_To_Managed_Sanitation_Total" real,
  "Access_To_Basic_Handwashing_Facilities_Total" real,
  "Access_To_Basic_Handwashing_Facilities_Urban" real,
  "Unemployment_Female" real,
  "Unemployment_Male" real,
  "Unemployment_Total" real,
  PRIMARY KEY ("QOL_Key")
);

CREATE TABLE "Health" (
  "Health_Key" int,
  "Adults_And_Children_Living_With_HIV" int,
  "Adults_Newly_Infected_With_HIV" int,
  "%Births_By_Skilled_Health_Staff" real,
  "Capital_Health_Expenditure_%GDP" real,
  "DeathByNonCommunicableDiseasePercent" real,
  "Domestic_General_Health_Expenditure_%GDP" real,
  "Hospital_Beds_Per_1000ppl" real,
  "Immunization_HepB3_%OneYearOld" int,
  "ImmunizationMeasles%Children12To23Months" int,
  "Number_Under-five_Deaths" int,
  "Nurses_Per_1000ppl" real,
  "Physicians_Per_1000ppl" real,
  "Prevalence_of_Anemia_%Non-pregnant" real,
  "Prevalence_of_Anemia_%Pregnant" real,
  "Prevalence_of_Overweight_%Adult" real,
  "Suicide_Mortality_Rate_per_100000ppl" real,
  "Survival to age 65, female (% of cohort)" real,
  "Survival to age 65, male (% of cohort)" real,
  "Total_Alcohol_Consumption_Per_Capita" real,
  "Tuberculosis_Death_Rate_per_100000ppl" real,
  PRIMARY KEY ("Health_Key")
);

CREATE TABLE "Country" (
  "Country_Key" int,
  "Continent" varchar,
  "Region" varchar,
  "Capital" varchar,
  "Currency" varchar,
  "Birth_Rate_Crude_Per_1000" real,
  "Population_Total_Count" int,
  "Death_Rate_Crude_Per_1000" real,
  "GNI_Per_Capita_USD" int,
  "Labour_Force_Female_%" real,
  "Labour_Force_Total_Count" int,
  "Age_Dependency_Ratio_Percent_Working_Age" real,
  "Age_First_Marriage_Male" real,
  "Age_First_Marriage_Female" real,
  "Age_Dependency_Ratio_Old" real,
  "Age_Dependency_Ratio_Young" real,
  "Completeness_Birth_Registration_%" real,
  PRIMARY KEY ("Country_Key")
);

CREATE TABLE "Education" (
  "Education_Key" int,
  "Public_Education_Spending" real,
  "School_Enrollment_Primary_%Gross" real,
  "School_Enrollment_Primary_Female_%Gross" real,
  "School_Enrollment_Primary_Male_%Gross" real,
  "School_Enrollment_Primary_%Net" real,
  "School_Enrollment_Secondary_%Gross" real,
  "School_Enrollment_Secondary_Female_%Gross" real,
  "School_Enrollment_Secondary_Male_%Gross" real,
  "School_Enrollment_Secondary_%Net" real,
  "Primary_Completion_Rate" real,
  "Primary_Completion_Rate_Female" real,
  "Primary_Completion_Rate_Male" real,
  PRIMARY KEY ("Education_Key")
);

CREATE TABLE "Month" (
  "Month_Key" int,
  "Name" varchar,
  "Month_Num" int,
  "Quarter" int,
  "Year" int,
  "Decade" int,
  PRIMARY KEY ("Month_Key")
);

CREATE TABLE "Population" (
  "Population_Key" int,
  "Population_15To64_%" real,
  "Population_65andUp_%" real,
  "Population_Growth_%" real,
  "Population_Female_%" real,
  "Population_Male_%" real,
  "Rural_Population_%" real,
  "Rural_Population_Growth_%" real,
  "Urban_Population_%" real,
  "Urban_Population_Growth_%" real,
  "Life_Exp_Birth_Total_Yr" real,
  "Life_Exp_Birth_Male_Yr" real,
  "Life_Exp_Birth_Female_Yr" real,
  PRIMARY KEY ("Population_Key")
);

CREATE TABLE "FactTable" (
  "Fact_Key" int,
  "Month_Key" int,
  "Country_Key" int,
  "Population_Key" int,
  "Education_Key" int,
  "Health_Key" int,
  "QOL_Key" int,
  "Event_Key" int,
  "HDI_Measure" int,
  "QOL_Measure" int,
  "Dev_Measure" int,
  PRIMARY KEY ("Fact_Key"),
  CONSTRAINT "FK_FactTable.Event_Key"
    FOREIGN KEY ("Event_Key")
      REFERENCES "Event"("Event_Key"),
  CONSTRAINT "FK_FactTable.QOL_Key"
    FOREIGN KEY ("QOL_Key")
      REFERENCES "QualityofLife"("QOL_Key"),
  CONSTRAINT "FK_FactTable.Health_Key"
    FOREIGN KEY ("Health_Key")
      REFERENCES "Health"("Health_Key"),
  CONSTRAINT "FK_FactTable.Country_Key"
    FOREIGN KEY ("Country_Key")
      REFERENCES "Country"("Country_Key"),
  CONSTRAINT "FK_FactTable.Education_Key"
    FOREIGN KEY ("Education_Key")
      REFERENCES "Education"("Education_Key"),
  CONSTRAINT "FK_FactTable.Month_Key"
    FOREIGN KEY ("Month_Key")
      REFERENCES "Month"("Month_Key"),
  CONSTRAINT "FK_FactTable.Population_Key"
    FOREIGN KEY ("Population_Key")
      REFERENCES "Population"("Population_Key")
);

