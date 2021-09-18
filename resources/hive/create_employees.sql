create external table employees (
    employee_id INT,
    birthday DATE,
    first_name STRING,
    family_name STRING,
    gender CHAR(1),
    work_day DATE)
row format serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
with serdeproperties (
    "separatorChar" = ",",
    "quoteChar"     = "'"
)
stored as textfile
location '/hive/employees/';

LOAD DATA INPATH '/data/employees.csv' 
INTO TABLE employees;
