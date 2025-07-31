# IMDB-Movies-Data-Analysis-using-SQL
SQL analysis for RSVP Movies using IMDB data

# 🎬 RSVP Movies SQL Analysis

This project contains advanced SQL queries performed on the IMDB-style movie dataset to help RSVP Movies gain actionable insights for content planning and production.

---

## 📄 File Included

| File Name              | Description                             |
|------------------------|-----------------------------------------|
| `RSVP_movies_queries.sql` | 17+ SQL queries for in-depth analysis  |

---

## 🔍 Key Questions Answered

1. 🎞 Total movies by year & month
2. 🌍 Country-wise production (India & USA focus)
3. 🎭 Most common and single-genre movies
4. 🧠 Average rating, median rating, total votes
5. 🏆 Top 10 rated movies and production houses
6. 🗣️ Language-based analysis (German vs Italian)
7. 📅 Date filtering and ranking by genre

---

## 🧰 SQL Concepts Used

- ✅ Joins
- ✅ Aggregates (`COUNT`, `AVG`, `MIN`, `MAX`)
- ✅ `GROUP BY`, `ORDER BY`
- ✅ `RANK()` & `DENSE_RANK()`
- ✅ CTEs (Common Table Expressions)
- ✅ Filtering with `LIKE`, `IN`, and date ranges

---

## 📌 Business Context

RSVP Movies plans to:
- Pick a profitable genre (e.g., Drama, Thriller)
- Partner with top-rated production houses
- Understand movie popularity by language, region, votes

---

## 🧠 Sample Query

### Q13. Which production house has the most hit movies (avg_rating > 8)?

```sql
SELECT m.production_company, COUNT(*) AS hit_count
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE r.avg_rating > 8
GROUP BY m.production_company
ORDER BY hit_count DESC;
