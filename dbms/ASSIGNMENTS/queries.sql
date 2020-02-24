


--1. Find out the PG-13 rated comedy movies. DO NOT use the film_list table.
--2. Find out the top 3 rented horror movies.
--3. Find out the list of customers from India who have rented sports movies.
--4. Find out the list of customers from Canada who have rented “NICK WAHLBERG” movies.
--5. Find out the number of movies in which “SEAN WILLIAMS” acted.



--1.
    select c.name as category , t.title as `movie name`  
    from category c , 
            (select f.title, fc.category_id 
            from film f inner join film_category fc on f.film_id = fc.film_id 
            where f.rating='PG-13') as t 
    where c.category_id = t.category_id and c.name = 'comedy';




--2.  
    select f.title, temp.name as category
    from film f, 
    (select j.film_id , cat.name
    from category cat,
        (select t.film_id, fc.category_id 
        from film_category fc, 
                (select i.film_id 
                from rental r, inventory i 
                where r.inventory_id = i.inventory_id ) as t  
        where fc.film_id = t.film_id  ) as j  
    where cat.category_id = j.category_id and cat.name = 'horror' ) as temp
    where f.film_id = temp.film_id
    group by f.film_id 
    order by count(*) desc
    limit 3;





--3.                              
				select temp6.first_name, temp6.last_name
                                from country cty ,(select ct.country_id, temp5.first_name, temp5.last_name
                                from city ct, (select a.city_id, temp4.first_name, temp4.last_name
                                from address a, (select distinct cust.address_id , cust.first_name, cust.last_name
                                from customer cust, (select temp2.customer_id 
                                from category c , (select fc.category_id, temp1.customer_id 
                                from film_category fc, 
                                        (select r.customer_id, i.film_id 
                                        from rental r, inventory i 
                                        where r.inventory_id = i.inventory_id) as temp1 
                                where fc.film_id = temp1.film_id) as temp2
                                where c.category_id=temp2.category_id and c.name = 'sports' ) as temp3 
                                where cust.customer_id = temp3.customer_id  ) as temp4
                                where a.address_id = temp4.address_id ) as temp5
                                where ct.city_id = temp5.city_id ) as temp6
                                where cty.country_id = temp6.country_id and cty.country = 'India';












--4.      
	select temp6.first_name , temp6.last_name 
        from country cty, 
                (select c.country_id, temp5.first_name, temp5.last_name 
                from city c, 
                        (select a.city_id, temp4.first_name, temp4.last_name 
                        from address a, 
                                (select distinct c.address_id,  c.first_name, c.last_name 
                                from customer c, 
                                        (select temp2.customer_id 
                                        from actor a, 
                                                (select temp1.customer_id, fa.actor_id 
                                                from film_actor fa, 
                                                        (select r.customer_id , i.film_id 
                                                        from rental r, inventory i 
                                                        where r.inventory_id = i.inventory_id) as temp1 
                                                where fa.film_id = temp1.film_id ) as temp2 
                                        where a.actor_id = temp2.actor_id and a.first_name = 'NICK' and a.last_name = 'WAHLBERG' ) as temp3 
                                where c.customer_id = temp3.customer_id ) as temp4 
                        where a.address_id = temp4.address_id ) as temp5 
                where temp5.city_id = c.city_id ) as temp6 
        where  cty.country_id = temp6.country_id and cty.country='Canada'; 











--5.      
	select count(*) 
        from film_actor fm , 
                (select actor_id 
                 from actor 
                 where first_name = 'SEAN' and last_name = 'WILLIAMS' ) as temp 
        where fm.actor_id = temp.actor_id ;
















