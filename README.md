# Weather-Data-Exporter-
Overview
--------
The Weather Data Export Tool is a MATLAB-based GUI application designed to export historical weather data from Chinese meteorological stations. The tool allows users to select multiple stations, specify data types, set year ranges, and export data in various formats.
Available year range: 1942-2024(Sep)

Features
-------
Multi-Station Support: Input multiple station IDs separated by semicolons

Flexible Data Selection: Choose specific meteorological data columns to export

Custom Year Ranges: Set individual year ranges for each station or use same range for all

Multiple Export Options: Export as merged file or separate files per station

Format Support: Export data in CSV or TXT format

Data Preview: Preview data before exporting

File Structure
--------------
    
    Root Directory/
    
    ├── Database_CN/                    # Main database folder
    
    │   ├── 1942/                      # Year folders (1942-2024)
    
    │   ├── 1943/
    
    │   ├── ...
    
    │   └── 2024/
    
    ├── station_info.csv               # Station metadata file

    ├── Data_explanation.xlsx          # Explanation of raw data file
    
    └── weather_data_exporter.m        # Main MATLAB program

Data File Format
----------------
Meteorological data files are organized as follows:

Location: Database_CN/[YEAR]/ folders

Naming: [StationID]_[StationName]_[Country]_([Longitude],[Latitude]).csv

Example: 59134099999_GAOQI_CHINA_(118.127739,24.544036).csv

Station Information File
-----------------------
station_info.csv contains station metadata with the following columns:

StationID: Unique station identifier

StationName: Name of the station

Longitude: Geographic longitude (WGS84)

Latitude: Geographic latitude (WGS84)

FirstYear: Earliest available data year for the station

LastYear: Latest available data year for the station

Available Data Columns
----------------------
The tool supports exporting 28 different meteorological parameters:
    
    No.   Column Name          Description
    
    1     STATION              Observation Station ID
    
    2     DATE                 Observation Date
    
    3     LATITUDE             Latitude, WGS1984 coordinate (Positive for North, Negative for South)
    
    4     LONGITUDE            Longitude, WGS1984 coordinate (Positive for East, Negative for West)
    
    5     ELEVATION            Elevation, unit: m
    
    6     NAME                 Station Name and Country Code
    
    7     TEMP                 Average Temperature; Unit: Fahrenheit; Missing Value: 9999.9
    
    8     TEMP_ATTRIBUTES      Number of Observations for Average Temperature
    
    9     DEWP                 Average Dew Point; Unit: Fahrenheit; Missing Value: 9999.9
    
    10    DEWP_ATTRIBUTES      Number of Observations for Average Dew Point
    
    11    SLP                  Average Sea Level Pressure; Unit: millibar/hectopascal; Missing Value: 9999.9
    
    12    SLP_ATTRIBUTES       Number of Observations for Average Sea Level Pressure
    
    13    STP                  Average Station Pressure; Unit: millibar/hectopascal; Missing Value: 9999.9
    
    14    STP_ATTRIBUTES       Number of Observations for Average Station Pressure
    
    15    VISIB                Average Visibility; Unit: miles; Missing Value: 999.9
    
    16    VISIB_ATTRIBUTES     Number of Observations for Average Visibility
    
    17    WDSP                 Average Wind Speed; Unit: knots; Missing Value: 999.9
    
    18    WDSP_ATTRIBUTES      Number of Observations for Average Wind Speed
    
    19    MXSPD                Maximum Sustained Wind Speed; Unit: knots; Missing Value: 999.9
    
    20    GUST                 Peak Wind Gust; Unit: knots; Missing Value: 999.9
    
    21    MAX                  Maximum Temperature; Unit: Fahrenheit; Missing Value: 9999.9
    
    22    MAX_ATTRIBUTES       Number of Observations for Maximum Temperature
    
    23    MIN                  Minimum Temperature; Unit: Fahrenheit; Missing Value: 9999.9
    
    24    MIN_ATTRIBUTES       Number of Observations for Minimum Temperature
    
    25    PRCP                 Precipitation; Unit: inches; Missing Value: 99.99
    
    26    PRCP_ATTRIBUTES      Number of Observations for Precipitation
    
    27    SNDP                 Snow Depth; Unit: inches; Missing Value: 999.9
    
    28    FRSHTT               Weather Phenomena Indicators: (1 = Occurred, 0 = Did Not Occur or Not Reported) 
                              1st digit: Fog; 2nd digit: Rain/Drizzle; 3rd digit: Snow/Hail; 4th digit: Thunder;
                              5th digit: Tornado/Funnel Cloud


Missing Value Indicators
------------------------

Different parameters use specific missing value indicators:

Temperature parameters: 9999.9

Wind speed and snow depth: 999.9

Precipitation: 99.99

Usage Instructions
------------------
1. Launch the Application

Run the MATLAB function:

    weather_data_exporter.m

<img width="1125" height="964" alt="STEP1" src="https://github.com/user-attachments/assets/a6053596-0710-4ce7-9032-65d03a77b762" />

2. Input Station IDs

Look up station_info.csv for target station numbers

Enter one or more station IDs separated by semicolons

Example: 58367099999;59758099999

3. Select Data Columns
   
Use the table to select which meteorological parameters to export

Columns 1 and 2 are selected by default

Check additional columns as needed

<img width="1055" height="460" alt="image" src="https://github.com/user-attachments/assets/bb8f3a1e-ecf7-488d-8735-fc98c27ab6b9" />

4. Set Year Range

Option 1: Same year range for all stations

Option 2: Individual year ranges for each station

The interface will show available year ranges from station_info.csv

5. Export Data

Preview: Click "Preview Data" to review selected data (first 100 rows)

Export: Click "Export Data" to save files

Single Station: Automatically exports as data_[StationID].[format]

Multiple Stations: Choose between:

Merged file: data_merged.[format]

Separate files: data_[StationID].[format] for each station

Format Selection: Choose between CSV or TXT format

<img width="1061" height="450" alt="image" src="https://github.com/user-attachments/assets/896119e3-40d1-4f2b-bf7f-ef2b596c784e" />


Output Format
-------------
Exported data includes:

First four columns: StationID, Year, Month, Day

Followed by selected meteorological parameters

Date column from original data is split into separate Year, Month, Day columns

<img width="470" height="58" alt="image" src="https://github.com/user-attachments/assets/bef4ae42-9c68-4c84-9610-e7db6de9d392" />

<img width="661" height="396" alt="image" src="https://github.com/user-attachments/assets/e2b58d43-784d-486d-bfb2-168937a19965" />


Requirements
------------
MATLAB R2018b or later
