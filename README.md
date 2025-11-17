**Project Overview**

**1. Data Architecture**
-The warehouse is built on the Medallion Architecture.
-Bronze layer stores the raw incoming data.
-Silver layer contains cleaned, standardized, and validated data.
-Gold layer contains business-ready fact and dimension tables designed for analytics.

**2. ETL Pipelines**
ETL pipelines were developed to extract data from source systems, apply business rules, clean and validate fields, and load it into the respective layers. This includes fixing date formats, correcting invalid records, enriching data through lookups, and ensuring consistency across the data model.

**3. Data Modeling**
-A star schema is used in the Gold layer.
-Dimension tables include customers, products, dates, and other descriptive attributes.
-A central fact table stores sales metrics.
-Surrogate keys, standardized attributes, and hierarchical structures are included to support analytical use cases.

**4. Analytics and Reporting**
The Gold layer is optimized for analytical queries and reporting. The dataset supports common business analyses such as revenue trends, product performance, customer behaviour, and order-level insights.


**Architecture Structure**

Source Systems  
      ↓  
Bronze Layer  (Raw Data)  
      ↓  
Silver Layer  (Cleaned and Standardized Data)  
      ↓  
Gold Layer    (Fact and Dimension Tables)  
      ↓  
Analytics and Reporting  
