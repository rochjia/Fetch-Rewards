USE fetch_rewards;
# Q2.1
SELECT b.name AS brand_name, COUNT(*) AS receipts_scanned
FROM Receipts r
JOIN ItemList i ON r.id = i.receipt_id
JOIN Brands b ON i.barcode = b.barcode
WHERE r.dateScanned >= DATE_FORMAT(NOW(), '%Y-%m-01')
  AND r.dateScanned < DATE_FORMAT(NOW(), '%Y-%m-01') + INTERVAL 1 MONTH
GROUP BY b.name
ORDER BY receipts_scanned DESC
LIMIT 5;

# Q2.2
# Recent month receipts
WITH cte1 AS (
  SELECT r.id, i.barcode
  FROM Receipts r
  JOIN ItemList i ON r.id = i.receipt_id
  WHERE r.dateScanned >= DATE_FORMAT(NOW(), '%Y-%m-01') -- Start of the recent month
    AND r.dateScanned < DATE_FORMAT(NOW(), '%Y-%m-01') + INTERVAL 1 MONTH -- End of the recent month
),
# Previous month receipts
cte2 AS (
  SELECT r.id, i.barcode
  FROM Receipts r
  JOIN ItemList i ON r.id = i.receipt_id
  WHERE r.dateScanned >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01') -- Start of the previous month
    AND r.dateScanned < DATE_FORMAT(NOW(), '%Y-%m-01') -- End of the previous month
),
# Recent Month counts
cte3 AS (
  SELECT b.name AS brand_name, COUNT(*) AS receipts_scanned, 
         ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS ranking
  FROM cte1 c
  JOIN Brands b ON c.barcode = b.barcode
  GROUP BY b.name
  ORDER BY receipts_scanned DESC
  LIMIT 5
),
# Previous Month counts
cte4 AS (
  SELECT b.name AS brand_name, COUNT(*) AS receipts_scanned, 
         ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS ranking
  FROM cte2 c
  JOIN Brands b ON c.barcode = b.barcode
  GROUP BY b.name
  ORDER BY receipts_scanned DESC
  LIMIT 5
)
SELECT
  a.brand_name,
  a.receipts_scanned AS recent_month_scanned,
  b.receipts_scanned AS previous_month_scanned,
  CASE
    WHEN a.ranking < b.ranking THEN 'Higher'
    WHEN a.ranking > b.ranking THEN 'Lower'
    ELSE 'Same'
  END AS comparison
FROM cte3 a
LEFT JOIN cte4 b ON a.brand_name = b.brand_name;

# Q2.3
SELECT rewardsReceiptStatus, AVG(totalSpent) AS average_spend
FROM Receipts
WHERE rewardsReceiptStatus IN ('ACCEPTED', 'REJECTED')
GROUP BY rewardsReceiptStatus;

# Q2.4
SELECT rewardsReceiptStatus, SUM(purchasedItemCount) AS total_items_purchased
FROM Receipts
WHERE rewardsReceiptStatus IN ('ACCEPTED', 'REJECTED')
GROUP BY rewardsReceiptStatus;

# Q2.5
SELECT b.name, SUM(i.finalPrice) AS total_spend
FROM Brands AS b
JOIN ItemList AS i ON b.barcode = i.barcode
JOIN Receipts AS r ON i.receipt_id = r.id
JOIN Users AS u ON r.user_id = u.id
WHERE u.createdDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY b.name
ORDER BY total_spend DESC
LIMIT 1;

# Q2.6
SELECT b.name, COUNT(*) AS transaction_count
FROM Brands AS b
JOIN ItemList AS i ON b.barcode = i.barcode
JOIN Receipts AS r ON i.receipt_id = r.id
JOIN Users AS u ON r.user_id = u.id
WHERE u.createdDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY b.name
ORDER BY transaction_count DESC
LIMIT 1;
