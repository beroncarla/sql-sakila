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

/¨comentario: listar los films de categorias 'Action', 'Music' and 'Sci-Fi' en los que 
haya participado algun actor que también participo en un film de categoria 'Documentary en lenguaje English'*/
select distinct film.title
from film  
inner join film_category on (film.film_id = film_category.film_id)      
inner join category on (film_category.category_id = category.category_id)   
inner join film_actor on (film.film_id = film_actor.film_id)
inner join actor on (film_actor.actor_id = actor.actor_id)
where category.name in ('Action', 'Music', 'Sci-Fi') and
actor.actor_id in (
    select distinct actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film.film_id = film_actor.film_id)
    inner join film_category on (film.film_id = film_category.film_id)      
    inner join category on (film_category.category_id = category.category_id)   
    inner join language on (film.language_id = language.language_id)
    where category.name = 'Documentary' and language.name = 'English'
);