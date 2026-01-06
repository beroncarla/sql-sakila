/**comentario: Ejercicio 1- listar todos los actores*/

select *
from actor;

/**comentario: Ejercicio 2- listar todas las peliculas*/
select * 
from film; 

/**comentario: Ejercicio 3- listar todos los actores que participaron en la pelicula 'GLass Dying'  y que no participaron en la pelicula 'African Egg'*/
select actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
where (film.title = 'GLass Dying') and 
actor.actor_id not in (
	select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film.film_id = film_actor.actor_id)
    where (film.title = 'African Egg'));

/**comentario: Ejercicio 4 - Listar las categorias*/
select *
from category;

/**comentario: listar los films de la categoria 'Action'*/
select film.title
from film
inner join film_category on (film.film_id = film_category.film_id)      
inner join category on (film_category.category_id = category.category_id)
where category.name = 'Action';
