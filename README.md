# Blinkit Sales, Delivery & Marketing Analysis

End-to-end analysis of a Blinkit-style quick-commerce dataset — covering sales performance, delivery operations, inventory health, customer satisfaction, and marketing ROI. Built with **SQL** for querying and **Power BI** for the interactive dashboard.

## 📊 Dashboard Preview

<img width="1381" height="780" alt="Screenshot 2026-06-21 023855" src="https://github.com/user-attachments/assets/e2e8516a-0d6d-427a-a311-040ce03dcac4" />

<img width="1162" height="657" alt="image" src="https://github.com/user-attachments/assets/e9d642f5-a623-4a20-9d67-502849cbf8e8" />

<img width="1115" height="625" alt="image" src="https://github.com/user-attachments/assets/4fa2c5c3-be22-45ef-86e2-bf62791a2cc4" />

<img width="1110" height="618" alt="image" src="https://github.com/user-attachments/assets/dbe04572-487a-4ce0-852c-e26dc11d67c2" />



## 🧰 Tools Used
- **Python (Pandas)** — data validation and cleaning (type correction, null/duplicate checks)
- **SQL** — data querying, aggregation, business-question answering
- **Power BI** — data modeling (star schema, DAX measures, relationships) and 5-page interactive dashboard
- **Power Query** — additional data cleaning and transformation

## 📁 Repository Structure
```
├── README.md
├── data_cleaning_of_blinkit.ipynb # Python/Pandas data validation & cleaning
├── blinkit_SQL_analysis.sql       # corrected analysis queries
├── Blinkit_Dashboard.pbix         # full Power BI report
├── data/                          # raw CSV source tables
└── screenshots/                   # dashboard page exports
```

## 🗂️ Dataset

8 related CSV tables, joined on shared keys (`order_id`, `product_id`, `customer_id`) to form a star-schema-style model in Power BI.

| Table | Rows | Key Columns |
|---|---|---|
| `orders` | 5,000 | order_id, customer_id, order_date, order_total, delivery_status |
| `order_items` | 5,000 | order_id, product_id, quantity, unit_price |
| `products` | 268 | product_id, product_name, category, brand, mrp, margin_percentage |
| `customer` | 2,500 | customer_id, area, customer_segment, total_orders, avg_order_value |
| `delivery_performance` | 5,000 | order_id, promised_time, actual_time, delivery_time_minutes, delivery_status |
| `inventory` | 75,172 | product_id, date, stock_received, damaged_stock |
| `customer_feedback` | 5,000 | order_id, rating, sentiment, feedback_category, feedback_text |
| `marketing_performance` | 5,400 | campaign_id, channel, impressions, clicks, conversions, spend, revenue_generated, roas |

Date range: **March 2023 – November 2024** (note: November 2024 is a partial month with significantly fewer records, since the dataset cuts off mid-month — worth excluding from month-over-month trend comparisons).

Source: Kaggle (Blinkit-style synthetic e-commerce dataset).

## 🧹 Data Cleaning & Validation (Python / Pandas)

Before any SQL or Power BI work, every one of the 8 source tables was run through a standard validation pass in Pandas — checking structure, types, completeness, and integrity rather than assuming the raw data was usable as-is:

- **Schema check** — inspected `.dtypes` on every table to confirm columns were typed correctly on import
- **Completeness check** — ran `.isnull().sum()` across all 8 tables to identify missing values
- **Duplicate check** — ran `.duplicated()` checks to catch repeated records
- **Type correction** — `customer_feedback.feedback_date` and `inventory.date` were loaded as plain strings; converted both to proper `datetime` types using `pd.to_datetime()` so they could be used reliably in time-based analysis and Power BI relationships

**Result:** the dataset turned out to be largely clean already — 6 of 8 tables came back with zero nulls and zero duplicates, and the only real gaps (e.g. `delivery_performance.reasons_if_delayed`) were expected, since that field is only populated when a delivery is actually delayed. The two date columns above were the only fields needing correction.

Running this full validation pass regardless of expected data quality is intentional — it's the same process that would catch and flag real issues (missing values, duplicate rows, bad types) had this dataset been messier, rather than skipping checks just because nothing looked obviously wrong at a glance.

Full notebook: `data_cleaning_of_blinkit.ipynb`

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

## ⚠️ Known Data Quality Notes
Being upfront about this, since I found it during analysis rather than papering over it:
- The `inventory` table has a data integrity issue — roughly **39% of rows** show `damaged_stock` exceeding `stock_received` for that delivery, which isn't physically possible. This inflates the headline "damaged stock rate" shown on the Inventory dashboard page. I identified and documented the issue but chose to keep the existing data as-is rather than fabricate a correction; a production fix would involve filtering or capping these rows in Power Query.
- During SQL development, I caught and fixed 3 logic bugs before finalizing the queries: an incorrectly aggregated "average order value by category" calculation, an "oversold stock" check that compared mismatched time granularities (and as a result flagged 100% of products regardless of actual risk), and a "highest ROAS campaign" query that was missing a sort direction and returned the lowest-performing campaign instead of the highest. All three are corrected in the final SQL file.

## 🚀 How to Use
1. Open `Blinkit_Dashboard.pbix` in Power BI Desktop to explore the interactive report
2. Run `blinkit_SQL_analysis.sql` against the source tables to reproduce the underlying queries
3. Use the slicers on each page (Area, Category, Target Audience) to filter the views

## 👤 Author
**Pratham Patel** — BSc IT, Nagindas Khandwala College
