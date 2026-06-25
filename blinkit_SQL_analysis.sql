#----------------------------Sales Performance Analysis----------------------------------------------#
# Analyze Blinkit’s sales data to identify top-performing products, customer purchasing trends
# and revenue-driving categories to improve overall sales performance and profitability.

# Find the top 10 highest revenue-generating products.
select products.product_id,products.product_name,round(sum(products.mrp*order_items.quantity),2) as revenue
from products
join order_items 
on order_items.product_id=products.product_id
group by products.product_id ,products.product_name
order by revenue desc 
limit 10 ;

# Calculate total monthly sales revenue.
select Date_format(order_date,'%Y-%m') as `month`,round(sum(order_total),2) as revenue
from orders
group by `month` 
order by `month` asc ;

# Identify the product category with the highest average order value.
select p.category, 
       round(sum(o.order_total) / count(distinct o.order_id), 2) as avg_order_value
from products as p
join order_items as oi on oi.product_id = p.product_id
join orders as o on o.order_id = oi.order_id
group by p.category
order by avg_order_value desc;

# Find customers who placed more than 5 orders.
select customer_id,customer_name 
from customer 
where total_orders >5;
# Determine which city generated the highest sales revenue.
select c.area , round(sum(order_total),2) as sales_revenue
from customer as c
join orders as o 
on c.customer_id=o.customer_id
group by c.area 
order by sales_revenue desc
limit 1;



#----------------------------------------------Delivery Efficiency & Delay Analysis----------------------------------------------#

# Evaluate Blinkit’s delivery operations to identify causes of delays, analyze delivery performance trends,
# and improve customer satisfaction through operational optimization.

# Find the average delivery time for each city.
select c.area , avg(d.delivery_time_minutes) as avg_del_time
from customer as c
join orders as o 
on o.customer_id=c.customer_id
join delivery_performance as d
on o.order_id=d.order_id
group by c.area 
order by avg_del_time ; 

# Identify the percentage of delayed deliveries.
select (((select count(*)from delivery_performance where delivery_status="slightly delayed" or delivery_status="significantly delayed")/count(*))*100) as percentge_of_delayed_deliveiries
from delivery_performance;

# Find the most common reasons for delivery delays.
select reasons_if_delayed,count(reasons_if_delayed) as count_of_reasons
from delivery_performance
group by reasons_if_delayed
order by count_of_reasons desc
limit 1
;

# List orders delivered earlier than expected.
select * 
from delivery_performance
where delivery_time_minutes<0;



#----------------------------------------------Inventory & Stock Optimization----------------------------------------------#

# Analyze inventory data to detect stock shortages, overstocking patterns,
# and inventory inefficiencies to improve stock management and reduce operational losses.
 

# Find the top 10 least sold products.
select p.product_id,p.product_name,p.brand,sum(oi.quantity) as total_qty
from products as p
join order_items as oi
on p.product_id=oi.product_id
group by p.product_id ,p.product_name,p.brand
order by total_qty asc 
limit 10;

# Find products with the highest sales volume.
select p.product_id,p.product_name,p.brand,sum(oi.quantity) as total_qty
from products as p
join order_items as oi
on p.product_id=oi.product_id
group by p.product_id ,p.product_name,p.brand
order by total_qty desc 
limit 10;


# Compare stock received vs quantity sold by product.
SELECT p.product_id,
       p.product_name,
       i.total_stock_received,
       o.total_sales
FROM products p
JOIN (
      SELECT product_id,
             SUM(stock_received) AS total_stock_received
      FROM inventory
      GROUP BY product_id
     ) i
ON p.product_id = i.product_id
JOIN (
      SELECT product_id,
             SUM(quantity) AS total_sales
      FROM order_items
      GROUP BY product_id
     ) o
ON p.product_id = o.product_id;
# Identify products with the highest damaged stock.
select p.product_id,p.product_name,sum(i.damaged_stock) as total_damaged_stock
from products as p 
join inventory as i
on p.product_id = i.product_id
group by p.product_id,p.product_name
order by total_damaged_stock desc 
limit 10;

# Find products where sales exceed average stock received.
select p.product_id, p.product_name, i.total_stock_received, oi.sales
from products as p
join (
    select product_id, sum(stock_received) as total_stock_received
    from inventory
    group by product_id
) i
on p.product_id = i.product_id
join (
    select product_id, sum(quantity) as sales
    from order_items
    group by product_id
) oi
on oi.product_id = i.product_id
where oi.sales > i.total_stock_received;

#----------------------------------------------Customer Feedback & Satisfaction Analysis----------------------------------------------#

# Analyze customer feedback and ratings to understand customer satisfaction levels,
# identify recurring complaints, and improve the overall customer experience.

# Find the average customer rating for each product category.
select p.category,round(avg(cf.rating),2)
from products as p
join order_items as oi 
on p.product_id=oi.product_id
join customer_feedback as cf 
on oi.order_id=cf.order_id
group by p.category;

# Identify the most common customer complaints.
select feedback_text ,count(feedback_text) as no_of_feedbacks
from customer_feedback
group by feedback_text
order by no_of_feedbacks desc 
limit 1;

# Find customers who gave ratings below 3 more than once.
select customer_id,count(*) as low_rating_count
from customer_feedback 
where rating <3
group by customer_id
having count(*)>1;

# Calculate the relationship between delivery delays and customer ratings.
select dp.delivery_status, avg(cf.rating) as avg_rating
from delivery_performance as dp
join customer_feedback as cf
on dp.order_id=cf.order_id
group by dp.delivery_status;


# Find products with the highest positive feedback percentage.
SELECT 
    p.product_id,
    p.product_name,
    SUM(CASE
        WHEN
            sentiment = 'positive'
                AND feedback_category = 'Product Quality'
        THEN
            1
        ELSE 0
    END) AS positive_count,
    ROUND((SUM(CASE
                WHEN
                    sentiment = 'positive'
                        AND feedback_category = 'Product Quality'
                THEN
                    1
                ELSE 0
            END) * 100.0) / SUM(CASE
                WHEN feedback_category = 'Product Quality' THEN 1
                ELSE 0
            END),
            2) AS positive_feedback_percentage
FROM
    products AS p
        JOIN
    order_items AS oi ON p.product_id = oi.product_id
        JOIN
    customer_feedback AS cf ON cf.order_id = oi.order_id
GROUP BY p.product_id , p.product_name
ORDER BY positive_feedback_percentage DESC
LIMIT 1;


#----------------------------------------------Marketing Campaign Performance Analysis----------------------------------------------#
# Evaluate the effectiveness of Blinkit’s marketing campaigns by analyzing customer engagement,
# conversion rates, and return on advertising spend (ROAS) to optimize marketing strategies.

# Find the campaign with the highest return on ad spend (ROAS).
select campaign_id,campaign_name,roas from marketing_performance
order by roas desc
limit 1;
#OR 
select campaign_name,round(avg(roas),2) as avg_roas
from marketing_performance
group by campaign_name
order by avg_roas desc
limit 1;

# Calculate total revenue generated from each marketing campaign.
select campaign_name ,round(sum(revenue_generated),2) as total_revenue
from marketing_performance
group by campaign_name
order by total_revenue desc;

# Identify campaigns with the highest customer conversion rate.
# using click to conversion rate
select campaign_name ,round((sum(conversions)/sum(clicks))*100.0,2) as conversion_rate
from marketing_performance
group by campaign_name
order by conversion_rate desc
limit 1;
#OR
# using impressions to conversion
select campaign_name ,round((sum(conversions)/sum(impressions))*100.0,2) as conversion_rate
from marketing_performance
group by campaign_name
order by conversion_rate desc
limit 1;

# Find the month with the highest marketing-driven sales
select date_format(date,'%Y-%m') as `month`,round(sum(revenue_generated),2) as monthly_revenue
from marketing_performance
group by `month`
order by monthly_revenue desc
limit 1;

# Compare customer acquisition cost across campaigns.
select campaign_name,round((sum(spend)/sum(conversions)),2) as customer_acuisition_cost
from marketing_performance
group by campaign_name
order by customer_acuisition_cost;