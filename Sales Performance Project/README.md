📊 Interactive Sales Performance Dashboard – Power BI
Overview

This Power BI dashboard analyzes actual sales performance against target sales across product categories and regions. It is designed to help stakeholders quickly identify performance gaps, growth trends, and regional contributions using interactive visuals and slicers.

Objectives

Compare Actual Sales vs Target Sales at an overall, product, and regional level

Track sales performance trends over time

Highlight variance and growth metrics through KPI indicators

Enable interactive analysis using time and region slicers

Data Description

Sales Data: Contains transaction-level sales information by date, product category, and region

Target Data: Contains predefined sales targets

A composite key was created to establish a reliable relationship between sales and target tables due to the absence of a single unique key

Data Model

Relationship type: Many-to-One (Sales → Target)

Single-direction filtering to maintain model simplicity and avoid ambiguity

Targets are treated as overall benchmark values for comparative analysis

Key KPIs

Total Sales – Aggregated actual sales value

Target Sales – Defined benchmark sales target

Variance % – Percentage difference between actual and target sales

Sales Growth % – Change in sales over time based on the selected period

All KPIs dynamically respond to slicer selections.

Visualizations Included

Actual vs Target Sales by Product Category (Column Chart)

Actual vs Target Sales by Region (Bar Chart)

Sales Trend Over Time (Line Chart)

Interactive Slicers for Quarter and Region

How to Use the Dashboard

Use the Quarter slicer at the top to filter time periods

Use the Region slicer to focus on specific geographic performance

Review KPIs to assess overall performance

Drill into charts to identify underperforming categories or regions

Tools Used

Power BI Desktop

Excel (for initial data preparation)

Deliverables

Power BI report file (.pbix)

Dashboard screenshot

This README for guidance and interpretation
