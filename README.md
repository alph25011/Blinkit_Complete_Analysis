# Blinkit Sales, Delivery & Marketing Analysis

End-to-end analysis of a Blinkit-style quick-commerce dataset — covering sales performance, delivery operations, inventory health, customer satisfaction, and marketing ROI. Built with **SQL** for querying and **Power BI** for the interactive dashboard.

## 📊 Dashboard Preview

<img width="1381" height="780" alt="Screenshot 2026-06-21 023855" src="https://github.com/user-attachments/assets/e2e8516a-0d6d-427a-a311-040ce03dcac4" />
<img width="1162" height="657" alt="image" src="https://github.com/user-attachments/assets/e9d642f5-a623-4a20-9d67-502849cbf8e8" />
<img width="1115" height="625" alt="image" src="https://github.com/user-attachments/assets/4fa2c5c3-be22-45ef-86e2-bf62791a2cc4" />
<img width="1110" height="618" alt="image" src="https://github.com/user-attachments/assets/dbe04572-487a-4ce0-852c-e26dc11d67c2" />





## 🧰 Tools Used
- **SQL** — data querying, aggregation, business-question answering
- **Power BI** — data modeling (star schema, DAX measures, relationships) and 5-page interactive dashboard
- **Power Query** — data cleaning and transformation

## 📁 Repository Structure
```
├── README.md
├── blinkit_SQL_analysis.sql       # corrected analysis queries
├── Blinkit_Dashboard.pbix         # full Power BI report
├── data/                          # raw CSV source tables
└── screenshots/                   # dashboard page exports
```

## 🗂️ Dataset
8 related tables: `orders`, `order_items`, `products`, `customer`, `delivery_performance`, `inventory`, `customer_feedback`, `marketing_performance` — ~5,000 orders, 268 products, 2,500 customers.

## 🔍 Key Insights

**Sales**
- Total revenue: **₹69.2L** across 5,000 orders | Avg order value: **₹2,201.86**
- Top revenue driver: **Pet Treats** (₹3.88L), followed by Vitamins and Toilet Cleaner
- Highest-spending city: **Orai** (₹99.6K), followed by Deoghar and Nandyal

**Delivery**
- **69.4%** of deliveries arrive on time; **20.7%** slightly delayed, **9.9%** significantly delayed
- Delivery time is measured as a delta from the promised time — some cities consistently deliver *ahead* of schedule, others lag; see dashboard for the full city breakdown

**Customer Feedback**
- Average rating: **3.34 / 5**
- Most common sentiment: **Neutral** (~35% of all feedback) — satisfaction is moderate, not polarized
- Feedback volume is nearly evenly split across Delivery, Customer Service, App Experience, and Product Quality (~25% each)

**Marketing**
- Top-performing campaign by ROAS: **Email Campaign** (2.78x average return)
- ROAS and customer acquisition cost are fairly consistent across all 9 campaigns (no major underperformer), suggesting an evenly-optimized — if not yet differentiated — marketing mix



## 🚀 How to Use
1. Open `Blinkit_Dashboard.pbix` in Power BI Desktop to explore the interactive report
2. Run `blinkit_SQL_analysis.sql` against the source tables to reproduce the underlying queries
3. Use the slicers on each page (Area, Category, Target Audience) to filter the views

## 👤 Author
**Pratham Patel** — BSc IT, Nagindas Khandwala College
