# SQL-Project---Zomato-Business-Analysis-

<p align="center">
  <img src="images/Zomato-image.jpg" alt="Zomato Analysis" />
</p>

This project involves analyzing Zomato's customer, restaurant, rider, order, and delivery data to derive business insights, optimize operations, and improve decision-making. The analysis is conducted using SQL.

---

## Database and Tables

The project consists of the following main tables:

- **Customers**: Contains customer details such as `customer_id`, `customer_name`, and `reg_date`.
- **Restaurants**: Contains restaurant information like `restaurant_id`, `restaurant_name`, `city`, and `opening_hours`.
- **Riders**: Contains rider information including `rider_id`, `rider_name`, and `sign_up` date.
- **Orders**: Contains order details including `order_id`, `customer_id`, `restaurant_id`, `order_item`, `order_date`, `order_time`, `order_status`, and `total_amount`.
- **Deliveries**: Contains delivery details including `delivery_id`, `order_id`, `delivery_status`, `delivery_time`, and `rider_id`.

---

## Exploratory Data Analysis (EDA)

- Checked all tables for **null values**.  
  **Insight**: No null values were present, ensuring data completeness and reliability for analysis.

---

## CRUD / Data Management

- **Insertions and Updates**: Added new riders and updated restaurant opening hours.  
  **Insight**: Keeping the data up-to-date is essential for operational accuracy.

---

## Customer Insights / Behavior

- **Recent Registrations**: Identified customers who registered in the last 6 months.  
- **Top Ordered Dishes**: Determined the top 5 dishes ordered by a key customer.  
  **Insight**: ‘Paneer Butter Masala’ was the most frequently ordered dish.  
- **High-Spending Customers**: Identified customers who spent over 100K in total.  
  **Insight**: These 14 customers could be target customers for loyalty programs.  
- **Active Customers**: Counted customers who placed at least one order.  
  **Insight**: 23 customers are active and engaged with the platform.  
- **Inactive Customers**: Identified customers who never placed an order.  
  **Insight**: 9 customers have not engaged, indicating potential churn risks.

---

## Order & Sales Analysis

- **Top Revenue-Generating Items**: Determined the top 10 food items in terms of revenue.  
  **Insight**: ‘Chicken Biryani’ generated the highest revenue last month.  
- **Average Order Amount by City**: Calculated average order values across cities.  
  **Insight**: Delhi had the highest average order value; small variations indicate similar spending patterns across metro cities.  
- **Peak Order Time Slots**: Identified 2-hour intervals with the most orders.  
  **Insight**: Lunch and dinner times are peak periods; breakfast and late-night orders are minimal.  
- **Highest-Value Orders by Restaurant**: Found the highest-value order per restaurant.  
  **Insight**: Certain premium restaurants consistently have higher order amounts, suitable for exclusive promotions.  
- **Top-Selling Dish per Restaurant**: Identified most popular dishes by quantity and revenue.  
  **Insight**: High popularity doesn’t always correlate with high revenue; average selling price significantly affects total revenue.

---

## Revenue & Restaurant Analysis

- **Restaurant Revenue Ranking**: Ranked restaurants by total revenue in the last year.  
- **Order Cancellation Rates**: Compared cancellation rates for each restaurant between consecutive years.  
  **Insight**: Useful for evaluating restaurant reliability and customer satisfaction.  
- **Above-Average Revenue Restaurants**: Identified restaurants generating revenue above the average order value.  
  **Insight**: “Nagarjuna” restaurant leads in average revenue.  
- **Customer Segmentation**: Segmented customers into ‘Gold’ and ‘Silver’ based on total spending.  
  **Insight**: High-spending customers (‘Gold’) contribute significantly to revenue.

---

## Delivery & Rider Performance

- **Rider Monthly Earnings**: Calculated earnings assuming 8% commission on orders.  
- **High-Performing Riders**: Identified riders delivering more than 100 orders in November 2023.  
  **Insight**: Top-performing riders could be rewarded with bonuses.  
- **Rider Ratings by Delivery Time**: Assigned star ratings based on delivery speed.  
  **Insight**: Helps evaluate individual rider performance and service quality.  
- **Rider Efficiency**: Calculated average, fastest, and slowest delivery times per rider.  
  **Insight**: Identifies efficient and underperforming riders for performance management.

---

## Key Business Insights

1. Peak order periods are during lunch and dinner; marketing efforts could focus on these times.
2. High-spending customers and top-performing restaurants are ideal targets for loyalty programs and premium campaigns.
3. Delivery performance directly affects customer satisfaction; top riders should be incentivized.
4. Order cancellation rates provide insights into operational efficiency and reliability.
5. Popularity of dishes doesn’t always equate to maximum revenue; average selling price is critical.

---

This project provides a comprehensive view of **customer behavior, order trends, restaurant performance, and delivery efficiency**, enabling data-driven decisions for Zomato.

