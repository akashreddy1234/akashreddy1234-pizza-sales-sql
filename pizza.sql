-- ===========================
-- 🍕 Pizza Sales SQL Analysis
-- ===========================

-- =====================
-- BASIC QUERIES
-- =====================

-- Retrieve the total number of orders placed.
select count(order_id) as total_orders 
from orders;

-- Calculate the total revenue generated from pizza sales.
select round(sum(order_details.quantity * pizzas.price),2) as total_revenue
from order_details 
join pizzas on order_details.pizza_id = pizzas.pizza_id;

-- Identify the highest-priced pizza.
select pizza_types.name, pizzas.price
from pizzas 
join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
order by pizzas.price desc 
limit 1;

-- Identify the most common pizza size ordered.
select pizzas.size, count(order_details.order_details_id) as total_orders
from order_details 
join pizzas on order_details.pizza_id = pizzas.pizza_id
group by pizzas.size
order by total_orders desc 
limit 1;

-- List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name, sum(order_details.quantity) as total_quantity
from order_details 
join pizzas on order_details.pizza_id = pizzas.pizza_id
join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.name
order by total_quantity desc 
limit 5;

-- =====================
-- INTERMEDIATE QUERIES
-- =====================

-- Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category, sum(order_details.quantity) as total_quantity
from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id
join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.category
order by total_quantity desc;

-- Determine the distribution of orders by hour of the day.
select hour(order_time) as order_hour, count(order_id) as order_count
from orders
group by hour(order_time)
order by order_count desc;

-- Join relevant tables to find the category-wise distribution of pizzas.
select pizza_types.category, sum(order_details.quantity) as catwise
from pizzas
join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category
order by catwise desc;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0) 
from (
    select orders.order_date, sum(order_details.quantity) as quantity
    from orders 
    join order_details on orders.order_id = order_details.order_id
    group by orders.order_date
) as order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name, sum(order_details.quantity * pizzas.price) as revenue
from order_details 
join pizzas on order_details.pizza_id = pizzas.pizza_id
join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.name
order by revenue desc 
limit 3;

-- =====================
-- ADVANCED QUERIES
-- =====================

-- Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category,
(sum(order_details.quantity * pizzas.price) / 
 (select sum(order_details.quantity * pizzas.price) 
  from order_details 
  join pizzas on pizzas.pizza_id = order_details.pizza_id)
) * 100 as revenue
from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by revenue desc;
