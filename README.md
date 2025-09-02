# 🍕 Pizza Sales SQL Project

## 📌 Project Overview
This project analyzes pizza sales data using **MySQL**.  
It answers key business questions such as:
- Total revenue generated  
- Most popular pizzas and sizes  
- Sales distribution by category and time  
- Percentage contributions of pizzas to overall revenue  

---

## ⚙️ Database Setup
create database pizzadb;
use pizzadb;

create table pizzas (
    pizza_id varchar(50) primary key,
    pizza_type_id varchar(50),
    size varchar(10),
    price decimal(5,2)
);

create table order_details (
    order_details_id int primary key,
    order_id int,
    pizza_id varchar(50),
    quantity int
);

👉 **For `pizzas` and `order_details`**: tables were created first, then CSVs imported.  
👉 **For `orders` and `pizza_types`**: CSVs were imported directly.  

---

## 📊 SQL Queries

### 1. Retrieve the total number of orders placed
select count(order_id) from orders;

### 2. Calculate the total revenue generated from pizza sales
select round(sum(order_details.quantity * pizzas.price),2) as total_revenue
from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id;

### 3. Identify the highest-priced pizza
select name, price from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by price desc limit 1;

### 4. Identify the most common pizza size ordered
select pizzas.size, count(order_details.order_details_id) as order_count
from pizzas
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by order_count desc limit 1;

### 5. List the top 5 most ordered pizza types along with their quantities
select pizza_types.name, sum(order_details.quantity) as total_quantity
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by total_quantity desc limit 5;

### 6. Find the total quantity of each pizza category ordered
select pizza_types.category, sum(order_details.quantity) as total_quantity
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category;

### 7. Determine the distribution of orders by hour of the day
select hour(order_time) as orderhour, count(order_id) as ordercount
from orders
group by orderhour
order by ordercount desc;

### 8. Find the category-wise distribution of pizzas
select pizza_types.category, count(pizza_types.name) as pizza_count
from pizza_types
group by pizza_types.category;

### 9. Average number of pizzas ordered per day
select round(avg(quantity),0) from (
    select orders.order_date, sum(order_details.quantity) as quantity
    from orders
    join order_details on orders.order_id = order_details.order_id
    group by orders.order_date
) as order_quantity;

### 10. Top 3 most ordered pizza types by revenue
select pizza_types.name, sum(order_details.quantity * pizzas.price) as revenue
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by revenue desc limit 3;

### 11. Percentage contribution of each pizza category to total revenue
select pizza_types.category,
       (sum(order_details.quantity * pizzas.price) /
       (select sum(order_details.quantity * pizzas.price)
        from order_details
        join pizzas on pizzas.pizza_id = order_details.pizza_id)) * 100 as revenue
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by revenue desc;

---

## 📂 Files in Repository
- `queries.sql` → All SQL queries  
- `README.md` → Project documentation  
- `pizzas.csv`, `pizza_types.csv`, `orders.csv`, `order_details.csv` → Dataset  

---

## 🚀 Insights from Analysis
- Total revenue generated  
- Most popular pizza size and type  
- Category-wise sales distribution  
- Average daily pizza sales  
- Top pizzas by revenue  
- Revenue contribution by category  

✅ This project provides a complete **SQL case study** on a pizza store dataset.
