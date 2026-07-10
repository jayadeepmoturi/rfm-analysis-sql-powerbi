# RFM Customer Segmentation for Printing & Stationery Business

<p align="center">
  
  <img src="https://img.shields.io/badge/SQL-MYSQL-336791?logo=mysql" alt="MYSQL">
 
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License MIT">
</p>

A data-driven customer segmentation project that uses **RFM (Recency, Frequency, Monetary)** analysis to transform raw transactional data into actionable marketing segments. Built for a small-to-mid-size printing & stationery business selling Flyers, Business Cards, Canvas Prints, Photo Books, Posters, and Greeting Cards.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Business Problem Statement](#business-problem-statement)
3. [Numerical Problem Statement](#numerical-problem-statement)
4. [Dataset](#dataset)
5. [Methodology](#methodology)
6. [Tech Stack](#tech-stack)
7. [Project Structure](#project-structure)
8. [How to Run](#how-to-run)
9. [Key Results & Insights](#key-results--insights)
10. [Business Recommendations](#business-recommendations)
11. [Impact & ROI](#impact--roi)
12. [Future Work](#future-work)
13. [Author](#author)

---

## Project Overview

Many small businesses collect customer and order data but treat every customer the same way. This project solves that problem by applying **RFM segmentation** to identify high-value customers, at-risk customers, dormant accounts, and loyal repeat buyers. The outcome is a clear, data-backed segmentation strategy that enables personalized marketing, better retention, and higher revenue per customer.

**Key deliverables:**
- RFM score calculation for every customer
- Customer segment assignment (Champions, Loyal Customers, At Risk, Lost, etc.)
- Segment-wise revenue, order, and product insights
- SQL queries for reproducible analytics
- Visual dashboards and actionable business recommendations

---

## Business Problem Statement

> A printing & stationery business serving ~300 customers and processing ~1,000 orders in 2025 had no structured way to understand customer behavior. Every customer was treated identically — same promotions, same communication cadence, and same discounting — regardless of spend history or engagement level. This one-size-fits-all approach led to inefficient marketing spend, missed upsell opportunities, and silent customer churn.

The business needed a way to answer:
- Who are our most valuable customers?
- Which customers are about to churn?
- Which customers can be reactivated with a targeted offer?
- Which products should be promoted to which segment?

---

## Numerical Problem Statement

| Metric | Value |
| --- | --- |
| Total customers | ~300 |
| Total orders | ~1,000 |
| Time period | Full year 2025 |
| Product categories | 6 (Flyers, Business Cards, Canvas Prints, Photo Books, Posters, Greeting Cards) |
| Average order frequency | ~3.3 orders per customer |
| RFM scoring method | 1–5 scale per dimension |
| Segments produced | 8–11 actionable segments |

**Problem framed numerically:**
Given ~300 customers with varying recency (days since last order), frequency (order count), and monetary (total spend) behavior, assign each customer to a meaningful segment so the business can prioritize marketing spend, reduce churn, and increase average revenue per customer.

---

## Dataset

The dataset consists of two core tables:

### `customers`
| Column | Description |
| --- | --- |
| `customer_id` | Unique customer identifier |
| `customer_name` | Customer name / business name |
| `signup_date` | Date the customer first registered |
| `location` | City / region of the customer |

### `orders`
| Column | Description |
| --- | --- |
| `order_id` | Unique order identifier |
| `customer_id` | Foreign key to customers |
| `order_date` | Date the order was placed |
| `product_category` | Product purchased (Flyers, Business Cards, etc.) |
| `quantity` | Units ordered |
| `unit_price` | Price per unit |
| `total_amount` | `quantity × unit_price` |

A derived **`rfm_segments`** table stores computed recency, frequency, monetary scores, RFM composite score, and final segment label.

---

## Methodology

### 1. Data Cleaning & Exploration
- Removed duplicates and invalid order records
- Handled missing/null values in customer details
- Created `total_amount` from `quantity` and `unit_price`

### 2. RFM Calculation
For each customer:

- **Recency (R)** = Days since last purchase (lower = better)
- **Frequency (F)** = Total number of orders (higher = better)
- **Monetary (M)** = Total amount spent (higher = better)

Each dimension was scored on a **1–5 scale** using quintile-based ranking.

