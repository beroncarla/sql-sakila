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

/**comentario: Ejercicio 5 - listar los films de la categoria 'Action'*/
select film.title
from film
inner join film_category on (film.film_id = film_category.film_id)      
inner join category on (film_category.category_id = category.category_id)
where category.name = 'Action';

/*comentario: Ejercicio 6 - listar los films de categorias 'Action', 'Music' and 'Sci-Fi' en los que 
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

//comentario:Ejercicio 7: mostrar cuantos films de cada categoria estan almacenados en cada uno de los almacenes store

select store.store_id, category.name, count(film.film_id) as total_films
from store
inner join inventory on (store.store_id = inventory.store_id)
inner join film on (inventory.film_id = film.film_id)   
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
group by store.store_id, category.name
order by store.store_id, total_films desc;

//rehacer desde aca
//comentario :Ejercicio 8: mostrar nombre y apellido y categoria de fiilm de aquellos actores que hayan participado en más de 6 films de la misma categoría.
select actor.first_name, actor.last_name, category.name, count(film.film_id) as total_films
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category.category_id)
group by actor.actor_id, category.category_id
having count(film.film_id) > 6
order by total_films desc;

//Muestre los titulos de los films y la categoría de los mismos, en cuyo texto descriptivo aparece la palabra 'Car' o 'Cars' pero no aparece la palabra 'Teacher'
select film.title, category.name
from film
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (film.description like '%Car%' or film.description like '%Cars%')
and film.description not like '%Teacher%';

/* Mostrar un listado de títulos de films junto una columna denominada TIPO que muestre
los siguientes valores:
Para categorías ‘Action’, ‘Drama’, ‘Horror’, ‘Sci.Fi’ : ‘ADULTOS’
Para categorías ‘Animation’, ‘Children’, ‘Comedy’, ‘Family’, ‘Games’: ‘FAMILIAR’
Para el resto de las categorías: ’OTROS’ */
select film.title,
case 
    when category.name in ('Action', 'Drama', 'Horror', 'Sci-Fi') then 'ADULTOS'
    when category.name in ('Animation', 'Children', 'Comedy', 'Family', 'Games') then 'FAMILIAR'
    else 'OTROS'
end as TIPO 
from film
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category.category_id);


/*Mostrar todos los datos de los actores junto con el titulo de cada film en la que
participaron. Si un actor no participó en ningún film igualmente debe aparecer en el
listado.
*/
select actor.*, film.title
from actor
left join film_actor on (actor.actor_id = film_actor.actor_id)
left join film on (film_actor.film_id = film.film_id);

//*revisar
/*Mostrar el nombre y apellido de los actores que hayan participado en films de
todas las categorías existentes en la base de datos.*/
select actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
group by actor.actor_id
having count(distinct category.category_id) = (select count(*) from category);

/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ pero no en films de la categoría ‘Comedy’.*/
select actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where category.name = 'Action' and
actor.actor_id not in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Comedy'
);

/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ y en films de la categoría ‘Comedy’.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where category.name = 'Action' and
actor.actor_id in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Comedy'
);

/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where category.name = 'Action' or
category.name = 'Comedy';

/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ pero no en ambas
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id not in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);

/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ y en ambos
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);

/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ pero no en ambas
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id not in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);

/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ pero no en ambas
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id not in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);

/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ pero no en ambas
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id not in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);

/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ pero no en ambas
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id not in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);


/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ pero no en ambas
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id not in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);

/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ pero no en ambas
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id not in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);

/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ pero no en ambas
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id not in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);

/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ pero no en ambas
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id not in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);
/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ pero no en ambas 
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id not in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);

/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ pero no en ambas
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id not in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);

/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ pero no en ambas
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id not in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);
/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ pero no en ambas
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id not in (

    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);

/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ pero no en ambas
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id not in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);
/*Mostrar el nombre y apellido de los actores que hayan participado en films de
la categoría ‘Action’ o en films de la categoría ‘Comedy’ pero no en ambas
categorías.*/
select distinct actor.first_name, actor.last_name
from actor
inner join film_actor on (actor.actor_id = film_actor.actor_id)
inner join film on (film_actor.film_id = film.film_id)
inner join film_category on (film.film_id = film_category.film_id)
inner join category on (film_category.category_id = category
.category_id)
where (category.name = 'Action' or
category.name = 'Comedy') and
actor.actor_id not in (
    select actor.actor_id
    from actor
    inner join film_actor on (actor.actor_id = film_actor.actor_id)
    inner join film on (film_actor.film_id = film.film_id)
    inner join film_category on (film.film_id = film_category.film_id)
    inner join category on (film_category.category_id = category
    .category_id)
    where
    category.name = 'Action' and
    category.name = 'Comedy'
);



