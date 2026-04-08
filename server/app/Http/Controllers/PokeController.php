<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class PokeController extends Controller
{
    public function index(): JsonResponse
    {
        $pokemon = DB::table('pokemon as p')
            ->leftJoin('growth_rates as gr', 'p.growth_rate_id', '=', 'gr.id')
            ->leftJoin('habitats as h', 'p.habitat_id', '=', 'h.id')
            ->select(
                'p.id',
                'p.name',
                'p.category',
                'p.height',
                'p.weight',
                'p.catch_rate',
                'p.base_exp',
                'gr.name as growth_rate',
                'h.name as habitat',
                'p.gender_ratio as g_ratio'
            )
            ->orderBy('p.id')
            ->get()
            ->map(function ($p) {
                return [
                    'id' => (int) $p->id,
                    'name' => (string) $p->name,
                    'category' => (string) $p->category,
                    'height' => (float) $p->height,
                    'weight' => (float) $p->weight,
                    'catch_rate' => (int) $p->catch_rate,
                    'base_exp' => (int) $p->base_exp,
                    'growth_rate' => $p->growth_rate ? (string) $p->growth_rate : 'Unknown',
                    'habitat' => $p->habitat ? (string) $p->habitat : 'Unknown',
                    'g_ratio' => is_null($p->g_ratio) ? -1 : (int) $p->g_ratio,
                    'image' => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/' . $p->id . '.png',
                ];
            })
            ->values();

        return response()->json($pokemon, 200, [], JSON_UNESCAPED_UNICODE);
    }
}