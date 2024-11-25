# Codebook for Dataset_For_Analysis.csv

This codebook describes each variable in the dataset `Dataset_For_Analysis.csv`, which is used in the analysis of associations between latitude, sunshine duration, vitamin D status, and COVID-19 outcomes.

## Variable Descriptions

### Country and Geographical Data

- **Country4**
  - *Description:* Name of the country.
  - *Type:* String

- **Region**
  - *Description:* Geographical region where the country is located.
  - *Type:* String
  - *Categories:*
    - Africa
    - Asia
    - Europe
    - North America
    - South America
    - Oceania

- **Hemisphere**
  - *Description:* Hemisphere where the country is located.
  - *Type:* String
  - *Categories:*
    - Northern
    - Southern

- **Latitude**
  - *Description:* Latitude coordinate of the country's capital city.
  - *Type:* Numeric
  - *Unit:* Degrees

### Demographic and Economic Data

- **Population**
  - *Description:* Estimated total population of the country.
  - *Type:* Numeric
  - *Unit:* Number of people

- **Density**
  - *Description:* Population density.
  - *Type:* Numeric
  - *Unit:* People per square kilometer

- **EDR**
  - *Description:* Elderly Dependency Ratio; the ratio of elderly dependents (aged 65+) to the working-age population (aged 15-64).
  - *Type:* Numeric
  - *Unit:* Percentage

- **GDP_PC**
  - *Description:* Gross Domestic Product per capita.
  - *Type:* Numeric
  - *Unit:* US Dollars (USD)

### Health Data

- **vitd**
  - *Description:* Mean serum vitamin D levels in the population.
  - *Type:* Numeric
  - *Unit:* Nanomoles per liter (nmol/L)

### COVID-19 Data

- **Cases_31MR**
  - *Description:* Total number of confirmed COVID-19 cases as of March 31, 2020.
  - *Type:* Numeric
  - *Unit:* Number of cases

- **Deaths_31MR**
  - *Description:* Total number of confirmed COVID-19 deaths as of March 31, 2020.
  - *Type:* Numeric
  - *Unit:* Number of deaths

- **Cases_30JN**
  - *Description:* Total number of confirmed COVID-19 cases as of June 30, 2020.
  - *Type:* Numeric
  - *Unit:* Number of cases

- **Deaths_30JN**
  - *Description:* Total number of confirmed COVID-19 deaths as of June 30, 2020.
  - *Type:* Numeric
  - *Unit:* Number of deaths

- **Cases_30S**
  - *Description:* Total number of confirmed COVID-19 cases as of September 30, 2020.
  - *Type:* Numeric
  - *Unit:* Number of cases

- **Deaths_30S**
  - *Description:* Total number of confirmed COVID-19 deaths as of September 30, 2020.
  - *Type:* Numeric
  - *Unit:* Number of deaths

### Derived COVID-19 Metrics

- **prevCases**
  - *Description:* COVID-19 prevalence; number of cases per one million population.
  - *Type:* Numeric
  - *Unit:* Cases per million people
  - *Calculation:* (Cases / Population) * 1,000,000

- **MRDeaths**
  - *Description:* COVID-19 mortality rate; number of deaths per one million population.
  - *Type:* Numeric
  - *Unit:* Deaths per million people
  - *Calculation:* (Deaths / Population) * 1,000,000

- **cfr**
  - *Description:* Case Fatality Rate; percentage of confirmed cases that resulted in death.
  - *Type:* Numeric
  - *Unit:* Percentage (%)
  - *Calculation:* (Deaths / Cases) * 100

### Environmental Data

- **Jan**
  - *Description:* Average sunshine duration in January.
  - *Type:* Numeric
  - *Unit:* Hours

- **Feb**
  - *Description:* Average sunshine duration in February.
  - *Type:* Numeric
  - *Unit:* Hours

- **Mar**
  - *Description:* Average sunshine duration in March.
  - *Type:* Numeric
  - *Unit:* Hours

- **Apr**
  - *Description:* Average sunshine duration in April.
  - *Type:* Numeric
  - *Unit:* Hours

- **May**
  - *Description:* Average sunshine duration in May.
  - *Type:* Numeric
  - *Unit:* Hours

- **June**
  - *Description:* Average sunshine duration in June.
  - *Type:* Numeric
  - *Unit:* Hours

- **July**
  - *Description:* Average sunshine duration in July.
  - *Type:* Numeric
  - *Unit:* Hours

- **Aug**
  - *Description:* Average sunshine duration in August.
  - *Type:* Numeric
  - *Unit:* Hours

- **Sept**
  - *Description:* Average sunshine duration in September.
  - *Type:* Numeric
  - *Unit:* Hours

- **avghours**
  - *Description:* Average sunshine duration January - June(e.g., first six months).
  - *Type:* Numeric
  - *Unit:* Hours
  - *Calculation:* Mean of monthly sunshine durations for specified months.

### Country-Specific Labels for Maps

- **Country_prev**
  - *Description:* Label for country with prevalence information used in maps.
  - *Type:* String

- **Country_cfr**
  - *Description:* Label for country with CFR information used in maps.
  - *Type:* String

### Notes

- Missing values are represented as `NA`.
- Zero values in certain variables (e.g., `vitd`, `EDR`, `Density`, `GDP_PC`) have been replaced with `NA` to avoid issues in logarithmic transformations.
- Adjustments have been made for zero counts in cases and deaths to prevent computational errors during log transformations (e.g., zeros replaced with small constants like `0.0001`).

---

## Additional Information

### Data Sources

- **COVID-19 Data:** World Health Organization (WHO) COVID-19 situation reports and national health ministries.
- **Population and Demographic Data:** World Bank and United Nations databases.
- **Vitamin D Levels:** Published studies and national health surveys.
- **Sunshine Duration:** National meteorological agencies and global climate databases.

### Ethical Considerations

- All data used in this study are aggregated at the country level and sourced from publicly available databases.
- No individual-level data are included, ensuring compliance with data protection regulations.

### Reproducibility

- The analysis script is designed to reproduce all results and figures presented in the manuscript.
- Set a random seed if necessary to ensure reproducibility in any random sampling procedures.

### Collaboration

- Contributions, suggestions, and collaborations are welcome. Please open an issue or submit a pull request for any changes or additions.

---

## Changelog

- **v1.0**: Initial release with data, analysis script, figures, and documentation.

---

## How to Cite This Repository

```bibtex
@misc{mogire2020covid19analysis,
  author = {Mogire, Reagan M.},
  title = {Early Pandemic Associations of Latitude, Sunshine Duration, and Vitamin D Status with COVID-19 Incidence and Fatalities: A Global Analysis of 187 Countries},
  year = {2020},
  howpublished = {\url{https://github.com/yourusername/your-repository}},
}
