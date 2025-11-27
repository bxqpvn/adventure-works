# **ADVENTUREWORKS**

>[!NOTE]
>### Project Overview & Tools
>
>In this project, I will use SSMS 22 to connect to the AdventureWorks database. I will explore and analyze the tables, writing SQL queries to practice and demonstrate my SQL skills. After completing the SQL analysis, I also plan to build my first Power BI dashboard based on the insights gathered from the dataset.
>
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

![production diagram](https://github.com/user-attachments/assets/08b41cee-4061-4f46-9aaa-6b1c35f73303)

- **Sales**

![sales diagram](https://github.com/user-attachments/assets/84145dfc-eeee-48b6-a47c-47ad82f3bb79)

- **Human Resources**

![HR diagram](https://github.com/user-attachments/assets/d404af5a-e1f6-40b6-a51f-d2f9d623b212)

- **Person**

![person diagram](https://github.com/user-attachments/assets/61298b4c-d714-4764-a5ca-4510c324a3b6)

- **Purchasing**

![purchasing diagram](https://github.com/user-attachments/assets/9323abc5-d35e-45ac-8e07-666d4764c588)

These diagrams help visualize table relationship (PK-FK), connections and the overall schema structure.

>[!IMPORTANT]
>These diagrams will help with the SQL queries in the next section.

## 3. Database Exploration by Functional Area

In this section, I explore each functional area by reviewing table relationships and column metadata, including table and column properties. I also run basic queries to better understand the data before moving to advanced analysis.

### Production

![model, images, documents, reviews](https://github.com/user-attachments/assets/cd5a887f-2f9a-4602-b086-add88f137d9c) ![simple queries for the product, category, subcategory](https://github.com/user-attachments/assets/553b90a9-8609-45dd-890f-f24a2edfea1d)

### Sales



### Human Resources



### Purchasing



### Person
