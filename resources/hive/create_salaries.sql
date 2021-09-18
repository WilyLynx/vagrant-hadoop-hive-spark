create external table salaries (
    employee_id INT,
    salary INT,
    start_date DATE,
    end_date DATE)
row format serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
with serdeproperties (
    "separatorChar" = ",",
    "quoteChar"     = "'"
)
stored as textfile
location '/hive/salaries/';

LOAD DATA INPATH '/data/salaries.csv' 
INTO TABLE salaries;