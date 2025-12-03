I created a complete mini-project involving two SQL databases and two Python programs. 
First, I built the HOTELS database, which included four important tables: users, bookings, booking_commercials, and items. 
These tables stored customer details, room booking information, item consumption, and menu item rates. 
After inserting sample data for all of them, I wrote several SQL queries to perform meaningful business analysis. 
My first query identified the most recent booking made by each user by comparing booking dates. 
The second query calculated the total amount spent for each booking made in November 2021 by multiplying item quantities with item rates. 
The third query computed bills from October 2021 and filtered only those bills whose total exceeded ₹1000. 
The fourth query used window functions to find, for each month, the most ordered and least ordered items based on total quantity. 
The fifth query calculated the second-highest bill amount for each month of 2021 and displayed the related month, user, bill ID, and final amount.

Next, I created another independent database called CLINIC, containing information about clinic branches, customers, sales transactions, and expenses. 
After inserting detailed sample data, I wrote SQL queries that analyzed the clinic business. 
One query calculated the total revenue for each sales channel (online, offline, insurance). 
Another query found the top ten customers who spent the highest amounts during 2021. 
A more advanced query compared monthly revenue against monthly expenses to determine profit and identified whether each month was profitable or not. 
I also wrote a query that determined which clinic generated the highest profit within each city for the month of September 2021. After completing the analysis, I dropped the CLINIC database.

Along with SQL, I also wrote simple and effective Python functions. 

One function removed duplicate characters from a given string by looping through each letter and collecting only unique ones, so for the word “banana” I got “ban.” 
Another function converted a total number of minutes into a human-readable format by calculating hours and minutes, returning results like “2 hrs 10 minutes” for an input of 130.

Overall, I created two full relational databases, inserted structured data, and performed analytical SQL queries involving joins, 
aggregation, subqueries, ranking functions, and monthly calculations. In addition, I implemented two beginner-friendly Python programs demonstrating string handling, loops, 
arithmetic operations, and formatting. Together, this work shows my strong understanding of database design, SQL query writing, and Python logic.
