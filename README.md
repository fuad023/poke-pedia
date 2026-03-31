# PokéPedia

A Pokémon enclyclopedia of Kanto region (LeefGreen). It contains detained information about the first 151 Pokémon.

## Tack Stacks

Frontend
- JavaScript, NPM, React.js, Vite, CSS

Backend
- PHP, Composer, Laravel, Pest

Database
- Microsoft SQL Server, Eloquent ORM

## Team Members

| Name           | Role     | Email                             | ID          |
| -------------- | -------- | --------------------------------- | ----------- |
| Rashedul Hasan | Frontend | rashedul.cse.20230104022@aust.edu | 20230104022 |
| Sajid Al Amin  | Frontend | sajidalaminsaa2003@gmail.com      | 20230104025 |
| Nafis Fuad     | Backend  | nafisfuadisc@gmail.com            | 20230104023 |

## Run the Project

To clone the repo
- `git@github.com:fuad023/poke-pedia.git`

To prepare the database (Dockerized Microsoft SQL Server)
- `docker compose pull sqlserver`
- `docker compose up sqlserver`
- `./db-poke-pedia.sh`

To start the server
- `cd server`
- `composer install`
- `php artisan serve`

Starts @ `http://localhost:8000/`

To start the client
- `cd client`
- `npm install`
- `npm run dev`

Starts @ `http://localhost:5173/`

## Special Thanks

- [PokéAPI](https://pokeapi.co/)
- [sharon kuo](https://github.com/cherun/pokedb)
