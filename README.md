![adventureworkslogo](https://github.com/user-attachments/assets/8ee8d47e-54de-4f9e-af49-a9aa898066f2)

***AdventureWorks is a Microsoft sample database that simulates a fictional company, Adventure Works Cycles, and provides structured data across sales, production, HR, and other business areas.***

>[!NOTE]
>### Project Overview & Tools
>
>*In this project, I will use SSMS 22 to connect to the AdventureWorks database. I will explore and analyze the tables, writing SQL queries to practice and demonstrate my SQL skills. After completing the SQL analysis, I also plan to build my first Power BI dashboard based on the insights gathered from the dataset.*
>Tools:
>
>SQL Server Management Studio (SSMS) 22 – Querying and managing the AdventureWorks database
>
>SQL Server Express – Local SQL environment for restoring and working with the database
>
>AdventureWorks 2022 – Sample dataset used for analysis
>
>Power BI Desktop – Building the dashboard based on SQL insights

## 1. Connecting to the AdventureWorks Database

I restored the AdventureWorks2022 sample database in SSMS following the official [Microsoft installation guide](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17&tabs=ssms):

- Moving the .bak file into the SQL Server backup folder

![sql server backup location](https://github.com/user-attachments/assets/c51e97dc-dae7-4641-8f58-5c37ee215751)

- Restoring the database from SSMS

![restore database](https://github.com/user-attachments/assets/51055724-7456-420e-b5a6-542df1a8e679)

- Locating the .bak file

![bak file](https://github.com/user-attachments/assets/e30a8c9b-4b82-4b87-915b-af873a4275cc)

- That’s it: the connection is set up and ready for querying

![connection restored succesfully](https://github.com/user-attachments/assets/fb6aca1c-09c2-4d23-865e-27432ac7bffa)

## 2. Database Diagrams

To better understand the structure of the AdventureWorks database, I created diagrams for each major functional areas:

- **Production**

![production diagram](https://github.com/user-attachments/assets/37165444-0abf-4e05-8d3a-06c7db46be77)

- **Sales**

![sales diagram](https://github.com/user-attachments/assets/2700a126-94cf-4c09-811f-261971652935)

- **Human Resources**

![HR diagram](https://github.com/user-attachments/assets/1b894189-4998-4228-8242-b0a256c95fb1)

- **Person**

![person diagram](https://github.com/user-attachments/assets/425e89c7-d78e-46d5-b86b-3e2fabb6f939)

- **Purchasing**

![purchasing diagram](https://github.com/user-attachments/assets/8a9e729c-74b0-44d3-8541-071380b337e0)

Done! This is how it looks in the Object Explorer window: 

![database diagrams](https://github.com/user-attachments/assets/920a01a0-b819-4b96-93d1-eca7c909a21f)

>[!IMPORTANT]
>By showing table relationships (PK–FK) and the overall schema structure, these diagrams serve as a foundation for the SQL queries covered in the next section.

## 3. Database Exploration

*In this section, I explore each functional area by reviewing table relationships and column metadata, including table and column properties. I also run basic queries to better understand the data before moving to advanced analysis.*

I started with exploratory SQL queries to review tables across all functional areas.

![tables by functional area](https://github.com/user-attachments/assets/2f2a7760-903d-4254-a162-f8c0722d3a43)

As a result, I obtained a table listing all tables for each schema.

![canva schema tables](https://github.com/user-attachments/assets/c08d9b87-ab12-4e75-a239-3f5506e95af6)


Then, I used the Properties window to explore details for tables and columns.

![properties 1](https://github.com/user-attachments/assets/730b2498-a4f6-46d9-85ba-bbca2b4f8bab)

![properties 2](https://github.com/user-attachments/assets/e2d1fb13-8a7f-4be0-9bb1-4c0608e35220)


I then ran simple TOP (20) queries on tables from the Production schema to quickly preview the data and validate table contents:

![production basiq queries](https://github.com/user-attachments/assets/318b4543-477c-4e1a-97d8-e9a0e7bde378)

![production basic queries2](https://github.com/user-attachments/assets/89852b0e-0826-4174-a477-98ce554a4ce7)


I applied the same exploratory queries to the Sales schema to review transactional tables:

![sales basic queries](https://github.com/user-attachments/assets/da178e8b-d4a7-47ae-8c03-21e829cec892)

![sales basic queries2](https://github.com/user-attachments/assets/d6f2d593-0025-4f82-9e56-a11500764b14)


I repeated the process for the HR schema to explore employee and organizational data:

![hr basic queries](https://github.com/user-attachments/assets/7182d7a1-5f1b-4a72-905a-345038a96e5b)


The same approach was used for the Person schema:

![person basic queries](https://github.com/user-attachments/assets/1abf1ad7-4810-4901-912a-d2a0e86c3bab)

![person basic queries2](https://github.com/user-attachments/assets/cce5f08d-e600-40d3-9c97-b0fadef1b7ff)


I followed the same steps for the Purchasing schema to review vendor and procurement data:

![purchasing basic queries](https://github.com/user-attachments/assets/e210c172-0ac9-4b91-8d71-d0c99e14d3bc)


>[!IMPORTANT]
>This step helped me build a clear understanding of the database before moving on to more advanced queries.
