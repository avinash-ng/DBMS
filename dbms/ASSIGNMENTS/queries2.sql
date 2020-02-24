
-- 1. Find out the number of documentaries with deleted scenes.
-- 2. Find out the number of sci-fi movies rented by the store managed by Jon Stephens.
-- 3. Find out the total sales from Animation movies.
-- 4. Find out the top 3 rented category of movies by “PATRICIA JOHNSON”.
-- 5. Find out the number of R rated movies rented by “SUSAN WILSON”.





--1.   
        select count(*) 
        from film 
        where film.special_features like 'Deleted Scenes' and film_id in 
                                                        (select film_id 
                                                        from film_category, 
                                                                (select category_id 
                                                                from category 
                                                                where name='Documentary') as temp 
                                                        where film_category.category_id = temp.category_id)




--2.      
        select count(distinct temp3.film_id) 
        from category c, 
                (select temp1.film_id, fc.category_id 
                from film_category fc, 
                        (select distinct film_id 
                        from staff_list sl, 
                                (select i.film_id, i.store_id 
                                from inventory i, rental r 
                                where i.inventory_id = r.inventory_id) temp 
                        where sl.SID = temp.store_id) as temp1 
                where fc.film_id = temp1.film_id ) as temp3 
        where c.category_id = temp3.category_id and c.name = 'sci-fi' ;



--3.    
        select sum(amount) , category.name as category 
        from rental inner join inventory 
        on rental.inventory_id = inventory.inventory_id inner join payment 
        on payment.rental_id = rental.rental_id inner join film_category 
        on film_category.film_id = inventory.film_id inner join category 
        on category.category_id = film_category.category_id 
        where category.name = 'Animation';





--4.    
        select cty.name, count(*) 
        from category cty, film_category fc, rental r, inventory i, customer c 
        where r. inventory_id = i.inventory_id  and r.customer_id = c.customer_id and c.first_name='PATRICIA' and c.last_name='JOHNSON' and fc.film_id = i.film_id and fc.category_id = cty.category_id 
        group by fc.category_id 
        order by count(*) desc
        limit 3;


--5.
        select count(distinct title) as count 
        from film f , 
            (select c.customer_id, temp1.film_id 
            from customer c, 
                ( select r.customer_id, i.film_id 
                from rental r, inventory i 
                where r.inventory_id=i.inventory_id ) as temp1 
            where c.customer_id=temp1.customer_id and c.first_name='SUSAN' and c.last_name='WILSON') as temp2 
        where f.film_id = temp2.film_id and f.rating='R';