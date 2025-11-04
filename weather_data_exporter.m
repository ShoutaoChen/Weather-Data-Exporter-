function weather_data_exporter
    % Create main window
    fig = figure('Name', 'Weather Data Export Tool', 'Position', [100 100 920 750], ...
                'NumberTitle', 'off', 'MenuBar', 'none', 'Resize', 'off', ...
                'Color', [0.95 0.95 0.95]);
    
    % Store global variables
    station_info = [];
    selected_columns = [1, 2]; % Default select first two columns
    handles = struct();
    
    % Load station information
    loadStationInfo();
    
    % Create UI components
    createUIComponents();
    
    function loadStationInfo()
        % Load station information file
        if exist('station_info.csv', 'file')
            try
                station_info = readtable('station_info.csv');
                % Check actual column names and set correct variable names
                num_cols = width(station_info);
                if num_cols >= 6
                    % Use more generic variable name setting method
                    var_names = cell(1, num_cols);
                    var_names{1} = 'StationID';
                    var_names{2} = 'StationName'; 
                    var_names{3} = 'Longitude';
                    var_names{4} = 'Latitude';
                    var_names{5} = 'FirstYear';
                    var_names{6} = 'LastYear';

                    station_info.Properties.VariableNames = var_names;
                    % Convert first column (StationID) to string format to ensure type matching
                    station_info.StationID = string(station_info.StationID);
                else
                    errordlg('station_info.csv file does not have enough columns!', 'Error');
                    station_info = [];
                    return;
                end
            catch ME
                % Display more detailed error information
                errordlg(['Unable to read station_info.csv file! Error: ', ME.message], 'Error');
                station_info = [];
                return;
            end
        else
            errordlg('station_info.csv file does not exist!', 'Error');
            station_info = [];
            return;
        end
    end
    
    function createUIComponents()
        % Title
        uicontrol('Style', 'text', 'Position', [50 700 800 30], ...
                 'String', 'Weather Data Export System', ...
                 'FontSize', 16, 'FontWeight', 'bold', ...
                 'HorizontalAlignment', 'center', 'BackgroundColor', [0.95 0.95 0.95]);
        
        % Station input section
        uicontrol('Style', 'text', 'Position', [50 660 250 30], ...
                 'String', 'Enter Station IDs (separate multiple with ";"):', ...
                 'FontSize', 10, 'FontWeight', 'bold', ...
                 'HorizontalAlignment', 'left', 'BackgroundColor', [0.95 0.95 0.95]);
        
        handles.station_edit = uicontrol('Style', 'edit', 'Position', [310 660 300 25], ...
                                        'String', '', 'BackgroundColor', 'white', ...
                                        'FontSize', 10);
        
        % Data type selection section
        uicontrol('Style', 'text', 'Position', [50 620 200 22], ...
                 'String', 'Select Data Types to Export:', ...
                 'FontSize', 10, 'FontWeight', 'bold', ...
                 'HorizontalAlignment', 'left', 'BackgroundColor', [0.95 0.95 0.95]);
        
        % Create data column selection table
        column_data = {
            1, 'STATION', 'Observation Station ID', false;
            2, 'DATE', 'Observation Date', false;
            3, 'LATITUDE', 'Latitude, WGS1984 coordinate', false;
            4, 'LONGITUDE', 'Longitude, WGS1984 coordinate', false;
            5, 'ELEVATION', 'Elevation, unit: m', false;
            6, 'NAME', 'Station Name and Country Code', false;
            7, 'TEMP', 'Average Temperature; Unit: Fahrenheit', false;
            8, 'TEMP_ATTRIBUTES', 'Number of Observations for Average Temperature', false;
            9, 'DEWP', 'Average Dew Point; Unit: Fahrenheit', false;
            10, 'DEWP_ATTRIBUTES', 'Number of Observations for Average Dew Point', false;
            11, 'SLP', 'Average Sea Level Pressure; Unit: millibar/hectopascal', false;
            12, 'SLP_ATTRIBUTES', 'Number of Observations for Average Sea Level Pressure', false;
            13, 'STP', 'Average Station Pressure; Unit: millibar/hectopascal', false;
            14, 'STP_ATTRIBUTES', 'Number of Observations for Average Station Pressure', false;
            15, 'VISIB', 'Average Visibility; Unit: miles', false;
            16, 'VISIB_ATTRIBUTES', 'Number of Observations for Average Visibility', false;
            17, 'WDSP', 'Average Wind Speed; Unit: knots', false;
            18, 'WDSP_ATTRIBUTES', 'Number of Observations for Average Wind Speed', false;
            19, 'MXSPD', 'Maximum Sustained Wind Speed; Unit: knots', false;
            20, 'GUST', 'Peak Wind Gust; Unit: knots', false;
            21, 'MAX', 'Maximum Temperature; Unit: Fahrenheit', false;
            22, 'MAX_ATTRIBUTES', 'Number of Observations for Maximum Temperature', false;
            23, 'MIN', 'Minimum Temperature; Unit: Fahrenheit', false;
            24, 'MIN_ATTRIBUTES', 'Number of Observations for Minimum Temperature', false;
            25, 'PRCP', 'Precipitation; Unit: inches', false;
            26, 'PRCP_ATTRIBUTES', 'Number of Observations for Precipitation', false;
            27, 'SNDP', 'Snow Depth; Unit: inches', false;
            28, 'FRSHTT', 'Weather Phenomena Indicators', false;
        };
        
        % Set first two columns as default selected
        column_data{1,4} = true;
        column_data{2,4} = true;
        
        handles.column_table = uitable(fig, 'Position', [50 380 820 220], ...
                                      'Data', column_data, ...
                                      'ColumnName', {'Index', 'Column Name', 'Description', 'Select'}, ...
                                      'ColumnWidth', {40, 120, 400, 60}, ...
                                      'ColumnEditable', [false, false, false, true], ...
                                      'FontSize', 9);
        
        % Year range selection section
        uicontrol('Style', 'text', 'Position', [50 340 200 22], ...
                 'String', 'Year Range Selection Method:', ...
                 'FontSize', 10, 'FontWeight', 'bold', ...
                 'HorizontalAlignment', 'left', 'BackgroundColor', [0.95 0.95 0.95]);
        
        handles.same_range_checkbox = uicontrol('Style', 'checkbox', ...
                                               'Position', [50 310 300 22], ...
                                               'String', 'Same Year Range for All Stations', ...
                                               'Value', 1, ...
                                               'FontSize', 10, ...
                                               'BackgroundColor', [0.95 0.95 0.95]);
        
        % Year input table panel
        handles.year_table_panel = uipanel('Parent', fig, 'Position', [0.05 0.18 0.9 0.15], ...
                                          'Title', 'Station Year Range Settings', ...
                                          'FontSize', 10, 'FontWeight', 'bold', ...
                                          'BackgroundColor', [0.95 0.95 0.95], ...
                                          'Visible', 'off');
        
        % Export options panel
        export_panel = uipanel('Parent', fig, 'Position', [0.05 0.05 0.9 0.12], ...
                              'Title', 'Export Settings', ...
                              'FontSize', 10, 'FontWeight', 'bold', ...
                              'BackgroundColor', [0.95 0.95 0.95]);
        
        uicontrol('Style', 'text', 'Parent', export_panel, ...
                 'Position', [20 50 80 22], ...
                 'String', 'File Format:', ...
                 'FontSize', 10, ...
                 'HorizontalAlignment', 'left', 'BackgroundColor', [0.95 0.95 0.95]);
        
        handles.format_dropdown = uicontrol('Style', 'popupmenu', ...
                                           'Parent', export_panel, ...
                                           'Position', [100 50 100 25], ...
                                           'String', {'.csv', '.txt'}, ...
                                           'FontSize', 10, ...
                                           'BackgroundColor', 'white');
        
        handles.merge_checkbox = uicontrol('Style', 'checkbox', ...
                                          'Parent', export_panel, ...
                                          'Position', [220 50 200 22], ...
                                          'String', 'Merge All Data into One File', ...
                                          'Value', 1, ...
                                          'FontSize', 10, ...
                                          'BackgroundColor', [0.95 0.95 0.95]);
        
        % Buttons
        uicontrol('Style', 'pushbutton', 'Position', [300 20 120 35], ...
                 'String', 'Preview Data', ...
                 'FontSize', 11, 'FontWeight', 'bold', ...
                 'BackgroundColor', [0.2 0.6 0.8], ...
                 'ForegroundColor', 'white', ...
                 'Callback', @previewData);
        
        uicontrol('Style', 'pushbutton', 'Position', [450 20 120 35], ...
                 'String', 'Export Data', ...
                 'FontSize', 11, 'FontWeight', 'bold', ...
                 'BackgroundColor', [0.2 0.8 0.4], ...
                 'ForegroundColor', 'white', ...
                 'Callback', @exportData);
        
        % Set callback functions
        set(handles.station_edit, 'Callback', @stationEditCallback);
        set(handles.same_range_checkbox, 'Callback', @sameRangeCallback);
        
        % Store handles
        guidata(fig, handles);
    end

    function stationEditCallback(~, ~)
        handles = guidata(gcbf);
        station_str = get(handles.station_edit, 'String');
        if ~isempty(station_str)
            updateYearTable();
        end
    end

    function sameRangeCallback(~, ~)
        updateYearTable();
    end

    function updateYearTable()
        handles = guidata(gcbf);
        station_str = get(handles.station_edit, 'String');
        
        if isempty(station_str)
            set(handles.year_table_panel, 'Visible', 'off');
            return;
        end
        
        stations = strsplit(station_str, ';');
        stations = strtrim(stations);
        n_stations = length(stations);
        
        % Clear previous UI components
        if isfield(handles, 'year_table') && ishandle(handles.year_table)
            delete(handles.year_table);
        end
        
        same_range_selected = get(handles.same_range_checkbox, 'Value');
        
        if same_range_selected || n_stations == 1
            set(handles.year_table_panel, 'Visible', 'off');
        else
            set(handles.year_table_panel, 'Visible', 'on');
            
            % Create year input table
            year_data = cell(n_stations, 5);
            for i = 1:n_stations
                station_id = stations{i}; % Directly use string format station ID
                if ~isempty(station_info)
                    % Use string matching to find station
                    station_idx = find(strcmp(station_info.StationID, station_id), 1);
                else
                    station_idx = [];
                end
                
                if ~isempty(station_idx)
                    first_year = station_info{station_idx, 5};  % FirstYear in column 5
                    last_year = station_info{station_idx, 6};   % LastYear in column 6
                    year_data{i, 1} = stations{i};
                    year_data{i, 2} = first_year;
                    year_data{i, 3} = last_year;
                    year_data{i, 4} = first_year; % Default start year
                    year_data{i, 5} = last_year;  % Default end year
                else
                    year_data{i, 1} = stations{i};
                    year_data{i, 2} = 'N/A';
                    year_data{i, 3} = 'N/A';
                    year_data{i, 4} = 1942;
                    year_data{i, 5} = 2024;
                end
            end
            
            % Create table
            panel_pos = get(handles.year_table_panel, 'Position');
            table_pos = [0.01 0.01 0.98 0.9];
            handles.year_table = uitable('Parent', handles.year_table_panel, ...
                                        'Units', 'normalized', ...
                                        'Position', table_pos, ...
                                        'Data', year_data, ...
                                        'ColumnName', {'Station ID', 'First Year', 'Last Year', 'Start Year', 'End Year'}, ...
                                        'ColumnWidth', {80, 80, 80, 80, 80}, ...
                                        'ColumnEditable', [false, false, false, true, true], ...
                                        'FontSize', 9);
            
            guidata(gcbf, handles);
        end
    end
    
    function previewData(~, ~)
        handles = guidata(gcbf);
        station_str = get(handles.station_edit, 'String');
        column_data = get(handles.column_table, 'Data');
        
        if isempty(station_str)
            errordlg('Please enter station IDs!', 'Error');
            return;
        end
        
        stations = strsplit(station_str, ';');
        stations = strtrim(stations);
        
        % Get selected columns (Fix: handle logical values)
        selected_cols = [];
        for i = 1:size(column_data, 1)
            if islogical(column_data{i, 4})
                if column_data{i, 4}
                    selected_cols = [selected_cols, column_data{i, 1}];
                end
            else
                if column_data{i, 4}
                    selected_cols = [selected_cols, column_data{i, 1}];
                end
            end
        end
        
        % Exclude column 1 (STATION) and column 2 (DATE) since we'll add StationID, Year, Month, Day
        selected_cols = selected_cols(~ismember(selected_cols, [1, 2]));
        
        % Get year ranges
        same_range_selected = get(handles.same_range_checkbox, 'Value');
        if same_range_selected || length(stations) == 1
            % Show dialog to input year range
            answer = inputdlg({'Start Year:', 'End Year:'}, 'Enter Year Range', [1, 30], {'1942', '2024'});
            if isempty(answer)
                return;
            end
            start_year = str2double(answer{1});
            end_year = str2double(answer{2});
            
            year_ranges = repmat([start_year, end_year], length(stations), 1);
        else
            % Get year ranges from table
            if isfield(handles, 'year_table')
                year_data = get(handles.year_table, 'Data');
                year_ranges = zeros(length(stations), 2);
                for i = 1:length(stations)
                    if isnumeric(year_data{i, 4})
                        year_ranges(i, 1) = year_data{i, 4};
                    else
                        year_ranges(i, 1) = str2double(year_data{i, 4});
                    end
                    if isnumeric(year_data{i, 5})
                        year_ranges(i, 2) = year_data{i, 5};
                    else
                        year_ranges(i, 2) = str2double(year_data{i, 5});
                    end
                end
            else
                year_ranges = repmat([1942, 2024], length(stations), 1);
            end
        end
        
        % Read data
        try
            data = readWeatherData(stations, selected_cols, year_ranges);
            
            % Display preview
            if ~isempty(data)
                preview_fig = figure('Name', 'Data Preview (First 100 Rows)', 'Position', [200 200 900 500], ...
                                    'NumberTitle', 'off', 'MenuBar', 'none');
                preview_table = uitable('Parent', preview_fig, 'Position', [20 20 860 460]);
                % Only show first 100 rows to avoid too much data
                preview_rows = min(100, height(data));
                preview_data_table = data(1:preview_rows, :);
                set(preview_table, 'Data', table2cell(preview_data_table), ...
                                  'ColumnName', data.Properties.VariableNames, ...
                                  'FontSize', 9);
            else
                msgbox('No data found matching the criteria!', 'Information', 'help');
            end
            
        catch ME
            errordlg(sprintf('Data reading error: %s', ME.message), 'Error');
        end
    end
    
    function exportData(~, ~)
        handles = guidata(gcbf);
        station_str = get(handles.station_edit, 'String');
        column_data = get(handles.column_table, 'Data');
        
        if isempty(station_str)
            errordlg('Please enter station IDs!', 'Error');
            return;
        end
        
        stations = strsplit(station_str, ';');
        stations = strtrim(stations);
        
        % Get selected columns (Fix: handle logical values)
        selected_cols = [];
        for i = 1:size(column_data, 1)
            if islogical(column_data{i, 4})
                if column_data{i, 4}
                    selected_cols = [selected_cols, column_data{i, 1}];
                end
            else
                if column_data{i, 4}
                    selected_cols = [selected_cols, column_data{i, 1}];
                end
            end
        end
        
        % Exclude column 1 (STATION) and column 2 (DATE) since we'll add StationID, Year, Month, Day
        selected_cols = selected_cols(~ismember(selected_cols, [1, 2]));
        
        % Get year ranges
        same_range_selected = get(handles.same_range_checkbox, 'Value');
        if same_range_selected || length(stations) == 1
            answer = inputdlg({'Start Year:', 'End Year:'}, 'Enter Year Range', [1, 30], {'1942', '2024'});
            if isempty(answer)
                return;
            end
            start_year = str2double(answer{1});
            end_year = str2double(answer{2});
            
            year_ranges = repmat([start_year, end_year], length(stations), 1);
        else
            if isfield(handles, 'year_table')
                year_data = get(handles.year_table, 'Data');
                year_ranges = zeros(length(stations), 2);
                for i = 1:length(stations)
                    if isnumeric(year_data{i, 4})
                        year_ranges(i, 1) = year_data{i, 4};
                    else
                        year_ranges(i, 1) = str2double(year_data{i, 4});
                    end
                    if isnumeric(year_data{i, 5})
                        year_ranges(i, 2) = year_data{i, 5};
                    else
                        year_ranges(i, 2) = str2double(year_data{i, 5});
                    end
                end
            else
                year_ranges = repmat([1942, 2024], length(stations), 1);
            end
        end
        
        % Read data
        try
            data = readWeatherData(stations, selected_cols, year_ranges);
            
            if isempty(data)
                msgbox('No data found matching the criteria!', 'Information', 'help');
                return;
            end
            
            % Select save location
            merge_selected = get(handles.merge_checkbox, 'Value');
            format_idx = get(handles.format_dropdown, 'Value');
            format_options = {'.csv', '.txt'};
            file_format = format_options{format_idx};
            
            if merge_selected || length(stations) == 1
                % Merge export
                if length(stations) == 1
                    default_name = ['data_', stations{1}, file_format];
                else
                    default_name = ['data_merged', file_format];
                end
                [file, path] = uiputfile({'*.csv;*.txt', 'Data Files'}, 'Select Save Location', default_name);
                
                if isequal(file, 0)
                    return;
                end
                
                exportSingleFile(data, file, path, file_format);
            else
                % Separate export
                folder_name = uigetdir(pwd, 'Select Save Folder');
                if isequal(folder_name, 0)
                    return;
                end
                
                for i = 1:length(stations)
                    station_mask = strcmp(data.StationID, stations{i});
                    station_data = data(station_mask, :);
                    if ~isempty(station_data)
                        filename = ['data_', stations{i}, file_format];
                        exportSingleFile(station_data, filename, folder_name, file_format);
                    end
                end
            end
            
            msgbox('Data exported successfully!', 'Complete', 'help');
            
        catch ME
            errordlg(sprintf('Export error: %s', ME.message), 'Error');
        end
    end
    
    function data = readWeatherData(stations, selected_cols, year_ranges)
        all_data_cell = {};
        
        for s = 1:length(stations)
            station_id = stations{s};
            start_year = year_ranges(s, 1);
            end_year = year_ranges(s, 2);
            
            for year = start_year:end_year
                year_folder = fullfile('Database_CN', num2str(year));
                
                if ~exist(year_folder, 'dir')
                    continue;
                end
                
                % Find files for this station
                file_pattern = [station_id, '_*.csv'];
                files = dir(fullfile(year_folder, file_pattern));
                
                for f = 1:length(files)
                    file_path = fullfile(year_folder, files(f).name);
                    
                    % Read CSV file
                    try
                        % Attempt to read file
                        temp_data = readtable(file_path);
                        
                        % Ensure data is not empty
                        if height(temp_data) == 0
                            continue;
                        end
                        
                        % Process date column
                        date_col = temp_data{:, 2};
                        n_rows = length(date_col);
                        dates_cell = cell(n_rows, 3);
                        
                        for i = 1:n_rows
                            if iscell(date_col)
                                current_date = date_col{i};
                            else
                                current_date = char(date_col(i));
                            end
                            
                            % Unified date format processing
                            current_date = strrep(current_date, '-', '/');
                            date_parts = strsplit(current_date, '/');
                            
                            if length(date_parts) >= 3
                                dates_cell{i, 1} = str2double(date_parts{1});
                                dates_cell{i, 2} = str2double(date_parts{2});
                                dates_cell{i, 3} = str2double(date_parts{3});
                            else
                                dates_cell{i, 1} = year;
                                dates_cell{i, 2} = 1;
                                dates_cell{i, 3} = 1;
                            end
                        end
                        
                        % Select needed columns (excluding STATION and DATE columns)
                        if ~isempty(selected_cols)
                            selected_data = table2cell(temp_data(:, selected_cols));
                        else
                            selected_data = cell(n_rows, 0);
                        end
                        
                        % Add station ID, year, month, day columns
                        station_col = repmat({station_id}, n_rows, 1);
                        
                        % Reorganize data: station ID, year, month, day + selected columns
                        final_data = [station_col, dates_cell, selected_data];
                        
                        % Add to total data
                        if isempty(all_data_cell)
                            all_data_cell = final_data;
                        else
                            all_data_cell = [all_data_cell; final_data];
                        end
                        
                    catch ME
                        fprintf('Warning: Unable to read file: %s, Error: %s\n', file_path, ME.message);
                        continue;
                    end
                end
            end
        end
        
        % Convert to table
        if ~isempty(all_data_cell)
            % Create column names
            col_names = {'StationID', 'Year', 'Month', 'Day'};
            original_col_names = {'STATION', 'DATE', 'LATITUDE', 'LONGITUDE', 'ELEVATION', 'NAME', ...
                'TEMP', 'TEMP_ATTRIBUTES', 'DEWP', 'DEWP_ATTRIBUTES', 'SLP', 'SLP_ATTRIBUTES', ...
                'STP', 'STP_ATTRIBUTES', 'VISIB', 'VISIB_ATTRIBUTES', 'WDSP', 'WDSP_ATTRIBUTES', ...
                'MXSPD', 'GUST', 'MAX', 'MAX_ATTRIBUTES', 'MIN', 'MIN_ATTRIBUTES', 'PRCP', ...
                'PRCP_ATTRIBUTES', 'SNDP', 'FRSHTT'};
            
            if ~isempty(selected_cols)
                selected_col_names = original_col_names(selected_cols);
                col_names = [col_names, selected_col_names];
            end
            
            data = cell2table(all_data_cell, 'VariableNames', col_names);
        else
            data = table();
        end
    end
    
    function exportSingleFile(data, filename, path, file_format)
        full_path = fullfile(path, filename);
        
        if strcmp(file_format, '.csv')
            writetable(data, full_path);
        else
            writetable(data, full_path, 'Delimiter', '\t');
        end
        fprintf('File saved: %s\n', full_path);
    end
end