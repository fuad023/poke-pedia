<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;

class PokemonController extends Controller
{
    public function index()
    {
        $pokemonList = DB::select('
            SELECT 
                p.id,
                p.name,
                s.link AS sprites,

                st.hp,
                st.attack,
                st.defense,
                st.sp_atk,
                st.sp_def,
                st.speed

            FROM pokemon p
            LEFT JOIN sprites s ON p.id = s.id
            LEFT JOIN stats st  ON p.id = st.id

            ORDER BY p.id
        ');

        $typesRaw = DB::select('
            SELECT 
                pt.poke_id,
                t.name,
                pt.slot
            FROM pokemon_type pt
            JOIN type t ON pt.type_id = t.id
        ');

        $typesGrouped = [];

        foreach ($typesRaw as $t) {
            $typesGrouped[$t->poke_id][] = [
                'name' => $t->name,
                'slot' => $t->slot
            ];
        }

        $response = array_map(function ($p) use ($typesGrouped) {

            $types = $typesGrouped[$p->id] ?? [];

            usort($types, fn($a, $b) => $a['slot'] <=> $b['slot']);

            return [
                'id'      => (int) $p->id,
                'name'    => $p->name,
                'sprites' => $p->sprites,

                'types'   => array_column($types, 'name'),

                'stats' => [
                    'hp'      => $p->hp,
                    'attack'  => $p->attack,
                    'defense' => $p->defense,
                    'sp_atk'  => $p->sp_atk,
                    'sp_def'  => $p->sp_def,
                    'speed'   => $p->speed,
                ]
            ];
        }, $pokemonList);

        return response()->json($response);
    }

    public function show(string $id)
    {
        $pokemonData = DB::select('
            SELECT 
                pokemon.*,
                pokedex_entry.flavour_text,
                growth_rates.name AS growth_rate,
                habitats.name AS habitat,
                sprites.link AS sprites,

                stats.hp,
                stats.attack,
                stats.defense,
                stats.sp_atk,
                stats.sp_def,
                stats.speed

            FROM pokemon 

            JOIN pokedex_entry 
                ON pokemon.flavour_text_id = pokedex_entry.id

            JOIN growth_rates  
                ON pokemon.growth_rate_id = growth_rates.id

            JOIN habitats      
                ON pokemon.habitat_id = habitats.id

            JOIN sprites      
                ON pokemon.id = sprites.id

            LEFT JOIN stats
                ON pokemon.id = stats.id

            WHERE pokemon.id = ?
        ', [$id]);

        if (empty($pokemonData)) {
            return response()->json(['message' => 'Pokemon not found'], 404);
        }

        $pokemon = $pokemonData[0];

        $types = DB::select('
            SELECT 
                [type].name,
                pokemon_type.slot

            FROM pokemon

            LEFT JOIN pokemon_type 
                ON pokemon.id = pokemon_type.poke_id

            LEFT JOIN [type]
                ON pokemon_type.type_id = [type].id

            WHERE pokemon.id = ?

            ORDER BY pokemon_type.slot
        ', [$id]);


        $abilities = DB::select('
            SELECT 
                ability.name,
                ability.flavour_text,
                pokemon_ability.slot

            FROM pokemon

            LEFT JOIN pokemon_ability 
                ON pokemon.id = pokemon_ability.poke_id

            LEFT JOIN ability
                ON pokemon_ability.ability_id = ability.id

            WHERE pokemon.id = ?

            ORDER BY pokemon_ability.slot
        ', [$id]);


        $typesFormatted = array_map(function ($t) {
            return [
                'name' => $t->name,
                'slot' => (int) $t->slot,
            ];
        }, $types);


        $abilitiesFormatted = array_map(function ($a) {
            return [
                'name' => $a->name,
                'flavour_text' => $a->flavour_text,
                'slot' => (int) $a->slot,
            ];
        }, $abilities);


        $pokemonName = $pokemon->name;
        $evo_chain = DB::select('
        WITH WalkUp AS (
            -- walk up to find root
            SELECT p.id, p.name
            FROM Pokemon p
            WHERE p.name = ?

            UNION ALL

            SELECT p.id, p.name
            FROM WalkUp w
            JOIN Evolution e ON e.to_poke_id = w.id
            JOIN Pokemon p   ON p.id = e.from_poke_id
        ),

        Root AS (
            -- select root (no Pokémon evolves into it)
            SELECT TOP 1 w.id, w.name
            FROM WalkUp w
            WHERE NOT EXISTS (
                SELECT 1 FROM Evolution e WHERE e.to_poke_id = w.id
            )
        ),

        WalkDown AS (
            -- anchor: only root Pokémon, no joins to Evolution/Evo_Condition
            SELECT
                p.id,
                p.name,
                0 AS stage,
                CAST(NULL AS VARCHAR(10)) AS condition_type,
                CAST(NULL AS TINYINT) AS level_value,
                CAST(NULL AS TINYINT) AS stone_id
            FROM Root r
            JOIN Pokemon p ON p.id = r.id

            UNION ALL

            -- recursive: now join Evolution + Evo_Condition
            SELECT
                p.id,
                p.name,
                w.stage + 1,
                ec.condition_type,
                ec.level_value,
                ec.stone_id
            FROM WalkDown w
            JOIN Evolution e      ON e.from_poke_id = w.id
            JOIN Pokemon p        ON p.id = e.to_poke_id
            JOIN Evo_Condition ec ON ec.evo_id = e.id
        )

        SELECT
            w.stage,
            w.id AS poke_id,
            w.name AS poke_name,
            w.condition_type,
            w.level_value,
            i.name AS stone_name
        FROM WalkDown w
        LEFT JOIN Items i ON i.id = w.stone_id
        ORDER BY w.stage, w.name;
        ', [$pokemonName]);


        $response = [
            'id'           => $pokemon->id,
            'name'         => $pokemon->name,
            'category'     => $pokemon->category,
            'height'       => $pokemon->height,
            'weight'       => $pokemon->weight,
            'flavour_text' => $pokemon->flavour_text,

            'catch_rate'   => $pokemon->catch_rate,
            'base_exp'     => $pokemon->base_exp,
            'growth_rate'  => $pokemon->growth_rate,
            'habitat'      => $pokemon->habitat,
            'gender_ratio' => $pokemon->gender_ratio,
            'sprites'      => $pokemon->sprites,

            'types'        => $typesFormatted,
            'abilities'    => $abilitiesFormatted,

            'stats' => [
                'hp'       => $pokemon->hp,
                'attack'   => $pokemon->attack,
                'defense'  => $pokemon->defense,
                'sp_atk'   => $pokemon->sp_atk,
                'sp_def'   => $pokemon->sp_def,
                'speed'    => $pokemon->speed,
            ],

            'evo_chain'    => $evo_chain
        ];

        return response()->json($response);
    }
}
