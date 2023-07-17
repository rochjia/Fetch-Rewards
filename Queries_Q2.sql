USE fetch_rewards;
-- Q2.1: What are the top 5 brands by receipts scanned for most recent month?
-- We assume the "most recent month" is the LAST month, to ensure a full-month data report
SELECT b.name AS brand_name, COUNT(*) AS receipts_scanned
FROM Receipts r
JOIN ItemList i ON r.id = i.receipt_id
JOIN Brands b ON i.barcode = b.barcode
-- filter the dateScanned within the previous month
WHERE r.dateScanned >= DATE_FORMAT(NOW(), '%Y-%m-01') - INTERVAL 1 MONTH -- Get the first day of LAST month 
  AND r.dateScanned < DATE_FORMAT(NOW(), '%Y-%m-01') -- Get the first day of current month 
GROUP BY b.name
ORDER BY receipts_scanned DESC
LIMIT 5;

-- Q2.2: How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?
-- Get the top 5 brands of the two months respectively, then combine them together for comparison
SELECT ROW_NUMBER() OVER() AS rank, a.brand_name AS brand_name_recent, a.receipts_scanned AS receipts_scanned_recent, b.brand_name AS brand_name_prev, b.receipts_scanned AS receipts_scanned_prev
FROM 
-- Get the Top 5 Brands for recent month (the same as Q2.1)
(
	SELECT b.name AS brand_name, COUNT(*) AS receipts_scanned
	FROM Receipts r
	JOIN ItemList i ON r.id = i.receipt_id
	JOIN Brands b ON i.barcode = b.barcode
	-- filter the dateScanned within the previous month
	WHERE r.dateScanned >= DATE_FORMAT(NOW(), '%Y-%m-01') - INTERVAL 1 MONTH
	  AND r.dateScanned < DATE_FORMAT(NOW(), '%Y-%m-01')
	GROUP BY b.name
	ORDER BY receipts_scanned DESC
	LIMIT 5
) a,
-- Get the Top 5 Brands for previous month (Here we assume the previous month is the month before the last month)
(
	SELECT b.name AS brand_name, COUNT(*) AS receipts_scanned
	FROM Receipts r
	JOIN ItemList i ON r.id = i.receipt_id
	JOIN Brands b ON i.barcode = b.barcode
	-- filter the dateScanned within the previous month
	WHERE r.dateScanned >= DATE_FORMAT(NOW(), '%Y-%m-01') - INTERVAL 2 MONTH 
	  AND r.dateScanned < DATE_FORMAT(NOW(), '%Y-%m-01') - INTERVAL 1 MONTH
	GROUP BY b.name
	ORDER BY receipts_scanned DESC
	LIMIT 5
) b

# Q2.3: When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
# Q2.4: When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
SELECT rewardsReceiptStatus, AVG(totalSpent) AS average_spend, SUM(purchasedItemCount) AS total_items_purchased
FROM Receipts
WHERE rewardsReceiptStatus IN ('ACCEPTED', 'REJECTED')
AND totalSpent IS NOT NULL # Exclude the null values
GROUP BY rewardsReceiptStatus
ORDER BY average_spend DESC; -- For 2.3
-- ORDER BY total_items_purchased DESC; -- For 2.4 

-- Q2.5: Which brand has the most spend among users who were created within the past 6 months?
-- Q2.6: Which brand has the most transactions among users who were created within the past 6 months?
SELECT b.name, SUM(i.finalPrice) AS total_spend, COUNT(*) AS transaction_count
FROM Brands AS b
JOIN ItemList AS i ON b.barcode = i.barcode
JOIN Receipts AS r ON i.receipt_id = r.id
JOIN Users AS u ON r.user_id = u.id
WHERE u.createdDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY b.name
ORDER BY total_spend DESC -- For 2.5
-- ORDER BY transaction_count DESC -- For 2.6
LIMIT 1;
