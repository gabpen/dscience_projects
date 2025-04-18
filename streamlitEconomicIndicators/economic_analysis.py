import streamlit as st
import pandas as pd
import wbdata
import datetime
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter
import seaborn as sns

# Title for the file
st.title('Visualizing Key Economic Indicators')

# Function to fetch and cache country data
@st.cache_data
def get_countries():
    countries = wbdata.get_countries()
    country_df = pd.DataFrame(countries)
    country_df = country_df[country_df['region'].apply(lambda x: x['value'] if isinstance(x, dict) else None) != 'Aggregates']
    return country_df

@st.cache_data
def get_incomeg():
    income = wbdata.get_incomelevels()
    income_df = pd.DataFrame(income)
    income_df = income_df[income_df['value'] != 'Not classified']
    return income_df

@st.cache_data
def get_regions():
    regions = wbdata.get_countries()
    region_df = pd.DataFrame(regions)
    region_df = region_df['region'].apply(lambda x: x['value'] if isinstance(x, dict) else None).unique()
    region_df = [region for region in region_df if region is not None and region != 'Aggregates']
    return region_df

@st.cache_data
def get_all():
    countries_all = wbdata.get_countries()
    countries_df = pd.DataFrame(countries_all)
    return countries_df

# Function to fetch data for selected indicators
@st.cache_data
def get_indicator_data(country_code, indicators):
    data_date = (datetime.datetime(1990, 1, 1), datetime.datetime(2023, 1, 1))
    data = wbdata.get_dataframe(indicators, country=country_code, date=data_date)
    data.reset_index(inplace=True)
    data.sort_values(by='date', inplace=True)
    return data

# Create tabs
tab1, tab2 = st.tabs(['Trend Plot', 'Data'])

# Fetch the list of countries
country_df = get_countries()
country_options = country_df['name'].tolist()
country_codes = country_df['id'].tolist()
country_dict = dict(zip(country_options, country_codes))

incomegroup_df = get_incomeg()
income_options = incomegroup_df['value'].tolist()

region_options = get_regions()

all_df = get_all()
all_options = all_df['name'].tolist()

# Indicators dictionary
indicators = {
    'GDP per capita (constant 2015 US$)': 'NY.GDP.PCAP.KD',
    'Unemployment rate (% of total labor force)': 'SL.UEM.TOTL.ZS',
    'Inflation, consumer prices (annual %)': 'FP.CPI.TOTL',
    'Government expenditure on education, total (% of GDP)': 'SE.XPD.TOTL.GD.ZS',
    'Life expectancy at birth (years)': 'SP.DYN.LE00.IN',
    'Literacy rate, adult total (% of people ages 15 and above)': 'SE.ADT.LITR.ZS',
    'Poverty headcount ratio at $1.90 a day (2011 PPP) (% of population)': 'SI.POV.DDAY',
    'Renewable energy consumption (% of total final energy consumption)': 'EG.FEC.RNEW.ZS',
    'Access to electricity (% of population)': 'EG.ELC.ACCS.ZS',
    'CO2 emissions (metric tons per capita)': 'EN.ATM.CO2E.PC'
}

indicator_names = list(indicators.keys())

with tab1:
    selected_country = st.selectbox('Select a country for analysis:', country_options)
    selected_indicators = st.multiselect('Select indicators to retrieve:', indicator_names)
    
    if selected_country and selected_indicators:
        country_code = country_dict[selected_country]
        indicator_codes = {indicators[indicator]: indicator for indicator in selected_indicators}
        data = get_indicator_data(country_code, indicator_codes)
        
        # Rename columns to be more user-friendly
        data.rename(columns=indicator_codes, inplace=True)
        
        # Apply user-friendly styles
        styled_data = data.style.format(precision=2) \
                                .set_table_styles([{
                                    'selector': 'th',
                                    'props': [('border', '1px solid black'), ('background-color', '#f7f7f7')]
                                }, {
                                    'selector': 'td',
                                    'props': [('border', '1px solid black')]
                                }])

    if 'data' in locals():
        st.subheader(f'Trend of selected indicators for {selected_country}')
        # Create the plot
        fig, ax1 = plt.subplots(figsize=(14, 8))
        sns.set(style="white")

        # Define a color palette
        palette = sns.color_palette("magma", len(data.columns[1:]))

        lines = []
        labels = []

        gdp_selected = 'GDP per capita (constant 2015 US$)' in selected_indicators
        if gdp_selected and len(selected_indicators) > 1:
            ax2 = ax1.twinx()
            gdp_color = 'tab:blue'
            for i, column in enumerate(data.columns[1:]):  # Skip the 'date' column
                if column == 'GDP per capita (constant 2015 US$)':
                    line = sns.lineplot(data=data, x='date', y=column, label='GDP per capita (constant 2015 US$) [RHS]', ax=ax2, color=gdp_color)
                    lines.append(line)
                    labels.append('GDP per capita (constant 2015 US$) [RHS]')
                    ax2.set_ylabel(None)
                    ax2.tick_params(axis='y', labelsize=18)
                    ax1.tick_params(axis='x', rotation=90, labelsize=18)
                    ax1.tick_params(axis='y', labelsize=18)
                    ax1.tick_params(axis='x', labelsize=18)
                else:
                    line = sns.lineplot(data=data, x='date', y=column, label=column, ax=ax1, color=palette[i])
                    lines.append(line)
                    labels.append(column)
            
            # Collect lines and labels from both axes for the legend
            lines_ax1, labels_ax1 = ax1.get_legend_handles_labels()
            lines_ax2, labels_ax2 = ax2.get_legend_handles_labels()
            lines.extend(lines_ax1)
            labels.extend(labels_ax1)
            lines.extend(lines_ax2)
            labels.extend(labels_ax2)
            ax1.get_legend().remove()
            ax2.get_legend().remove()
        else:
            for i, column in enumerate(data.columns[1:]):  # Skip the 'date' column
                line = sns.lineplot(data=data, x='date', y=column, label=column, ax=ax1, color=palette[i])
                lines.append(line)
                labels.append(column)
            
            # Collect lines and labels from the ax1
            lines_ax1, labels_ax1 = ax1.get_legend_handles_labels()
            lines.extend(lines_ax1)
            labels.extend(labels_ax1)
            ax1.get_legend().remove()

        ax1.legend(lines, labels, loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=2, fontsize=22, frameon=False)

        # Formatter for thousands separator with decimals
        def format_with_decimals(x, pos):
            return f'{x:,.2f}'
        
        # Formatter for thousands separator without decimals
        def format_without_decimals(x, pos):
            return f'{int(x):,}'

        formatter_with_decimals = FuncFormatter(format_with_decimals)
        formatter_without_decimals = FuncFormatter(format_without_decimals)
        
        ax1.yaxis.set_major_formatter(formatter_with_decimals)
        if gdp_selected and len(selected_indicators) > 1:
            ax2.yaxis.set_major_formatter(formatter_without_decimals)

        ax1.tick_params(axis='x', rotation=90, labelsize=18)
        ax1.tick_params(axis='y', labelsize=18)
        ax1.tick_params(axis='both', which='both', direction='in', bottom=True, left=True)

        # Remove axis titles
        ax1.set_xlabel(None)
        ax1.set_ylabel(None)
        if gdp_selected and len(selected_indicators) > 1:
            ax2.set_ylabel(None)

        st.pyplot(plt)


with tab2:
    if 'data' in locals():
        st.write(f'Data for {selected_country}:')
        st.dataframe(styled_data)