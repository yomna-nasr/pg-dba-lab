SELECT c.customer_id, sum(p.amount) AS total FROM customer c JOIN payment p ON p.customer_id = c.customer_id GROUP BY c.customer_id ORDER BY total DESC LIMIT 10;
SELECT f.title, count(*) AS rentals FROM film f JOIN inventory i ON i.film_id = f.film_id JOIN rental r ON r.inventory_id = i.inventory_id GROUP BY f.title ORDER BY rentals DESC LIMIT 10;
SELECT count(*) FROM rental WHERE rental_date > '2005-07-01';
