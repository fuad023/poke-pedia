<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PokemonController extends Controller
{
    public function show(string $id)
    {
        return DB::select('
            SELECT 
                pokemon.*,
                pokedex_entry.flavour_text,
                growth_rates.name          AS growth_rate,
                habitats.name              AS habitat
            FROM pokemon 

            JOIN pokedex_entry ON pokemon.flavour_text_id = pokedex_entry.id
            JOIN growth_rates  ON pokemon.growth_rate_id  = growth_rates.id
            JOIN habitats      ON pokemon.habitat_id      = habitats.id

            WHERE pokemon.id = ?
        ', [$id]);
    }
}
