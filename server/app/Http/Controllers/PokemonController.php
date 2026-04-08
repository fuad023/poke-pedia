<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;

class PokemonController extends Controller
{
    public function show(string $id)
    {
        $pokemonId = (int) $id;

        if ($pokemonId < 1 || $pokemonId > 151) {
            return response()->json([
                'message' => 'Pokemon id must be between 1 and 151'
            ], 404);
        }

        $this->ensurePokemonProfileExists($pokemonId);

        $pokemon = DB::table('vw_pokemon_profile_base')
            ->where('id', $pokemonId)
            ->first();

        if (!$pokemon) {
            return response()->json([
                'message' => 'Pokemon not found'
            ], 404);
        }

        $types = DB::table('pokemon_types')
            ->where('pokemon_id', $pokemonId)
            ->orderBy('slot_no')
            ->pluck('type_name')
            ->toArray();

        $abilities = DB::table('pokemon_abilities')
            ->where('pokemon_id', $pokemonId)
            ->orderBy('ability_order')
            ->pluck('ability_name')
            ->toArray();

        $stats = DB::table('pokemon_stats')
            ->where('pokemon_id', $pokemonId)
            ->orderBy('stat_order')
            ->get(['stat_label as label', 'stat_value as value', 'stat_max as max'])
            ->map(function ($row) {
                return [
                    'label' => $row->label,
                    'value' => (int) $row->value,
                    'max'   => (int) $row->max,
                ];
            })
            ->toArray();

        $evolutions = DB::table('pokemon_evolutions as pe')
            ->join('pokemon as p', 'p.id', '=', 'pe.evolution_pokemon_id')
            ->join('pokemon_images as pi', 'pi.pokemon_id', '=', 'p.id')
            ->where('pe.pokemon_id', $pokemonId)
            ->orderBy('pe.evolution_order')
            ->get([
                'p.id',
                'p.name',
                'pe.evolution_level as level',
                'pi.image_url as image'
            ])
            ->map(function ($row) {
                $item = [
                    'id'    => (int) $row->id,
                    'name'  => $row->name,
                    'image' => $row->image,
                ];

                if (!empty($row->level)) {
                    $item['level'] = $row->level;
                }

                return $item;
            })
            ->toArray();

        $entries = DB::table('pokemon_version_entries')
            ->where('pokemon_id', $pokemonId)
            ->orderBy('entry_order')
            ->get(['version_name as version', 'entry_text as text'])
            ->map(function ($row) {
                return [
                    'version' => $row->version,
                    'text'    => $row->text,
                ];
            })
            ->toArray();

        $typeText = implode(' / ', $types);

        return response()->json([
            'name' => $pokemon->name,
            'subtitle' => $pokemon->category . ' Pokémon' . ($typeText ? ' · ' . $typeText : ''),
            'pokemonId' => (int) $pokemon->id,
            'mainImage' => $pokemon->image_url,

            'theme' => [
                'bodyBackground'      => $pokemon->body_background,
                'accent'              => $pokemon->accent,
                'accentSoft'          => $pokemon->accent_soft,
                'secondary'           => $pokemon->secondary_color,
                'titleColor'          => $pokemon->title_color,
                'textColor'           => $pokemon->text_color,
                'cardBackground'      => $pokemon->card_background,
                'hoverShadow'         => $pokemon->hover_shadow,
                'statNumberColor'     => $pokemon->stat_number_color,
                'statBarGradient'     => $pokemon->stat_bar_gradient,
                'sectionLineGradient' => $pokemon->section_line_gradient,
                'entryVersionColor'   => $pokemon->entry_version_color,
            ],

            'pokedexData' => [
                [ 'label' => 'National No.', 'value' => str_pad((string) $pokemon->id, 4, '0', STR_PAD_LEFT) ],
                [ 'label' => 'Species', 'value' => $pokemon->category . ' Pokémon' ],
                [ 'label' => 'Type', 'value' => $typeText ],
                [ 'label' => 'Height', 'value' => $this->formatHeight((float) $pokemon->height) ],
                [ 'label' => 'Weight', 'value' => $this->formatWeight((float) $pokemon->weight) ],
                [ 'label' => 'Abilities', 'value' => implode(', ', $abilities) ],
            ],

            'training' => [
                [ 'label' => 'EV Yield', 'value' => $pokemon->ev_yield_text ],
                [ 'label' => 'Catch Rate', 'value' => (string) $pokemon->catch_rate ],
                [ 'label' => 'Base Friendship', 'value' => (string) $pokemon->base_friendship ],
                [ 'label' => 'Growth Rate', 'value' => $pokemon->growth_rate ],
            ],

            'stats' => $stats,
            'evolutions' => $evolutions,
            'entries' => $entries,
        ]);
    }

    private function ensurePokemonProfileExists(int $pokemonId): void
    {
        $exists = DB::table('pokemon_images')
            ->where('pokemon_id', $pokemonId)
            ->exists();

        if ($exists) {
            return;
        }

        $pokemonResponse = $this->pokeRequest("https://pokeapi.co/api/v2/pokemon/{$pokemonId}");
        $speciesResponse = $this->pokeRequest("https://pokeapi.co/api/v2/pokemon-species/{$pokemonId}");

        if (!$pokemonResponse->successful() || !$speciesResponse->successful()) {
            return;
        }

        $pokemonData = $pokemonResponse->json();
        $speciesData = $speciesResponse->json();

        DB::transaction(function () use ($pokemonId, $pokemonData, $speciesData) {
            $typesSorted = collect($pokemonData['types'] ?? [])
                ->sortBy('slot')
                ->values();

            $primaryType = strtolower($typesSorted->first()['type']['name'] ?? 'normal');

            DB::table('pokemon_images')->updateOrInsert(
                ['pokemon_id' => $pokemonId],
                [
                    'image_url' => $pokemonData['sprites']['other']['official-artwork']['front_default']
                        ?? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/{$pokemonId}.png"
                ]
            );

            DB::table('pokemon_theme')->updateOrInsert(
                ['pokemon_id' => $pokemonId],
                $this->themeForType($primaryType)
            );

            DB::table('pokemon_types')->where('pokemon_id', $pokemonId)->delete();

            foreach ($typesSorted as $type) {
                DB::table('pokemon_types')->insert([
                    'pokemon_id' => $pokemonId,
                    'slot_no'    => (int) $type['slot'],
                    'type_name'  => $this->labelize($type['type']['name']),
                ]);
            }

            DB::table('pokemon_abilities')->where('pokemon_id', $pokemonId)->delete();

            $abilitiesSorted = collect($pokemonData['abilities'] ?? [])
                ->sortBy('slot')
                ->values();

            foreach ($abilitiesSorted as $index => $ability) {
                DB::table('pokemon_abilities')->insert([
                    'pokemon_id'    => $pokemonId,
                    'ability_order' => $index + 1,
                    'ability_name'  => $this->labelize($ability['ability']['name']),
                ]);
            }

            DB::table('pokemon_stats')->where('pokemon_id', $pokemonId)->delete();

            $statMap = [
                'hp' => 'HP',
                'attack' => 'Attack',
                'defense' => 'Defense',
                'special-attack' => 'Sp. Atk',
                'special-defense' => 'Sp. Def',
                'speed' => 'Speed',
            ];

            $evParts = [];

            foreach (collect($pokemonData['stats'] ?? [])->values() as $index => $stat) {
                $apiName = $stat['stat']['name'] ?? '';
                $label = $statMap[$apiName] ?? $this->labelize($apiName);
                $effort = (int) ($stat['effort'] ?? 0);

                DB::table('pokemon_stats')->insert([
                    'pokemon_id' => $pokemonId,
                    'stat_order' => $index + 1,
                    'stat_label' => $label,
                    'stat_value' => (int) ($stat['base_stat'] ?? 0),
                    'stat_max'   => 255,
                    'ev_yield'   => $effort,
                ]);

                if ($effort > 0) {
                    $evParts[] = $effort . ' ' . $label;
                }
            }

            DB::table('pokemon_training_extra')->updateOrInsert(
                ['pokemon_id' => $pokemonId],
                [
                    'ev_yield_text'   => empty($evParts) ? '—' : implode(', ', $evParts),
                    'base_friendship' => (int) ($speciesData['base_happiness'] ?? 0),
                ]
            );

            DB::table('pokemon_version_entries')->where('pokemon_id', $pokemonId)->delete();

            $rbText = null;
            $yellowText = null;

            foreach (($speciesData['flavor_text_entries'] ?? []) as $entry) {
                if (($entry['language']['name'] ?? '') !== 'en') {
                    continue;
                }

                $version = $entry['version']['name'] ?? '';
                $text = $this->cleanText($entry['flavor_text'] ?? '');

                if (in_array($version, ['red', 'blue'], true) && $rbText === null) {
                    $rbText = $text;
                }

                if ($version === 'yellow' && $yellowText === null) {
                    $yellowText = $text;
                }
            }

            $entryOrder = 1;

            if ($rbText) {
                DB::table('pokemon_version_entries')->insert([
                    'pokemon_id'   => $pokemonId,
                    'entry_order'  => $entryOrder++,
                    'version_name' => 'Red / Blue',
                    'entry_text'   => $rbText,
                ]);
            }

            if ($yellowText) {
                DB::table('pokemon_version_entries')->insert([
                    'pokemon_id'   => $pokemonId,
                    'entry_order'  => $entryOrder++,
                    'version_name' => 'Yellow',
                    'entry_text'   => $yellowText,
                ]);
            }

            DB::table('pokemon_evolutions')->where('pokemon_id', $pokemonId)->delete();

            $chainUrl = $speciesData['evolution_chain']['url'] ?? null;

            if ($chainUrl) {
                $chainResponse = $this->pokeRequest($chainUrl);

                if ($chainResponse->successful()) {
                    $chainList = [];
                    $this->flattenEvolutionChain($chainResponse->json()['chain'] ?? [], $chainList);

                    $safeOrder = 1;

                    foreach ($chainList as $evolution) {
                        $targetId = (int) ($evolution['id'] ?? 0);

                        if ($targetId <= 0) {
                            continue;
                        }

                        $targetExists = DB::table('pokemon')
                            ->where('id', $targetId)
                            ->exists();

                        if (!$targetExists) {
                            continue;
                        }

                        DB::table('pokemon_evolutions')->insert([
                            'pokemon_id'           => $pokemonId,
                            'evolution_order'      => $safeOrder++,
                            'evolution_pokemon_id' => $targetId,
                            'evolution_level'      => $evolution['level'],
                        ]);

                        DB::table('pokemon_images')->updateOrInsert(
                            ['pokemon_id' => $targetId],
                            [
                                'image_url' => "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/{$targetId}.png"
                            ]
                        );
                    }
                }
            }
        });
    }

    private function pokeRequest(string $url)
    {
        return Http::withoutVerifying()
            ->timeout(30)
            ->acceptJson()
            ->get($url);
    }

    private function flattenEvolutionChain(array $node, array &$result): void
    {
        if (empty($node)) {
            return;
        }

        $speciesUrl = $node['species']['url'] ?? '';
        preg_match('~/(\d+)/?$~', $speciesUrl, $matches);
        $id = isset($matches[1]) ? (int) $matches[1] : 0;

        $details = $node['evolution_details'][0] ?? null;
        $level = null;

        if (!empty($details['min_level'])) {
            $level = 'Level ' . $details['min_level'];
        } elseif (!empty($details['item']['name'])) {
            $level = $this->labelize($details['item']['name']);
        } elseif (!empty($details['trigger']['name'])) {
            $level = $this->labelize($details['trigger']['name']);
        }

        $result[] = [
            'id'    => $id,
            'level' => $level,
        ];

        foreach (($node['evolves_to'] ?? []) as $child) {
            $this->flattenEvolutionChain($child, $result);
        }
    }

    private function themeForType(string $type): array
    {
        $themes = [
            'grass' => [
                'body_background' => 'linear-gradient(135deg, #e8fff1 0%, #d8f6e7 45%, #eefbf3 100%)',
                'accent' => '#2f9e44',
                'accent_soft' => '#69db7c',
                'secondary_color' => '#4dabf7',
                'title_color' => '#16351f',
                'text_color' => '#334155',
                'card_background' => 'rgba(255, 255, 255, 0.88)',
                'hover_shadow' => 'rgba(47, 158, 68, 0.22)',
                'stat_number_color' => '#2f9e44',
                'stat_bar_gradient' => 'linear-gradient(90deg, #2f9e44 0%, #69db7c 50%, #4dabf7 100%)',
                'section_line_gradient' => 'linear-gradient(90deg, #2f9e44 0%, #4dabf7 100%)',
                'entry_version_color' => '#1971c2',
            ],
            'fire' => [
                'body_background' => 'linear-gradient(135deg, #fff4e6 0%, #ffe8cc 45%, #fff0f6 100%)',
                'accent' => '#f76707',
                'accent_soft' => '#ffa94d',
                'secondary_color' => '#fa5252',
                'title_color' => '#5f2500',
                'text_color' => '#334155',
                'card_background' => 'rgba(255, 255, 255, 0.88)',
                'hover_shadow' => 'rgba(247, 103, 7, 0.22)',
                'stat_number_color' => '#f76707',
                'stat_bar_gradient' => 'linear-gradient(90deg, #f76707 0%, #ffa94d 50%, #fa5252 100%)',
                'section_line_gradient' => 'linear-gradient(90deg, #f76707 0%, #fa5252 100%)',
                'entry_version_color' => '#c92a2a',
            ],
            'water' => [
                'body_background' => 'linear-gradient(135deg, #e7f5ff 0%, #d0ebff 45%, #edf7ff 100%)',
                'accent' => '#1c7ed6',
                'accent_soft' => '#74c0fc',
                'secondary_color' => '#15aabf',
                'title_color' => '#0b3558',
                'text_color' => '#334155',
                'card_background' => 'rgba(255, 255, 255, 0.88)',
                'hover_shadow' => 'rgba(28, 126, 214, 0.22)',
                'stat_number_color' => '#1c7ed6',
                'stat_bar_gradient' => 'linear-gradient(90deg, #1c7ed6 0%, #74c0fc 50%, #15aabf 100%)',
                'section_line_gradient' => 'linear-gradient(90deg, #1c7ed6 0%, #15aabf 100%)',
                'entry_version_color' => '#1864ab',
            ],
            'electric' => [
                'body_background' => 'linear-gradient(135deg, #fff9db 0%, #fff3bf 45%, #fff9e6 100%)',
                'accent' => '#f59f00',
                'accent_soft' => '#ffd43b',
                'secondary_color' => '#fab005',
                'title_color' => '#5c4500',
                'text_color' => '#334155',
                'card_background' => 'rgba(255, 255, 255, 0.88)',
                'hover_shadow' => 'rgba(245, 159, 0, 0.22)',
                'stat_number_color' => '#f59f00',
                'stat_bar_gradient' => 'linear-gradient(90deg, #f59f00 0%, #ffd43b 50%, #fab005 100%)',
                'section_line_gradient' => 'linear-gradient(90deg, #f59f00 0%, #fab005 100%)',
                'entry_version_color' => '#e67700',
            ],
            'poison' => [
                'body_background' => 'linear-gradient(135deg, #f8f0fc 0%, #f3d9fa 45%, #fbf0ff 100%)',
                'accent' => '#9c36b5',
                'accent_soft' => '#d0bfff',
                'secondary_color' => '#7048e8',
                'title_color' => '#3f0d4d',
                'text_color' => '#334155',
                'card_background' => 'rgba(255, 255, 255, 0.88)',
                'hover_shadow' => 'rgba(156, 54, 181, 0.22)',
                'stat_number_color' => '#9c36b5',
                'stat_bar_gradient' => 'linear-gradient(90deg, #9c36b5 0%, #d0bfff 50%, #7048e8 100%)',
                'section_line_gradient' => 'linear-gradient(90deg, #9c36b5 0%, #7048e8 100%)',
                'entry_version_color' => '#5f3dc4',
            ],
            'normal' => [
                'body_background' => 'linear-gradient(135deg, #f8f9fa 0%, #f1f3f5 45%, #ffffff 100%)',
                'accent' => '#868e96',
                'accent_soft' => '#ced4da',
                'secondary_color' => '#adb5bd',
                'title_color' => '#343a40',
                'text_color' => '#334155',
                'card_background' => 'rgba(255, 255, 255, 0.88)',
                'hover_shadow' => 'rgba(134, 142, 150, 0.22)',
                'stat_number_color' => '#868e96',
                'stat_bar_gradient' => 'linear-gradient(90deg, #868e96 0%, #ced4da 50%, #adb5bd 100%)',
                'section_line_gradient' => 'linear-gradient(90deg, #868e96 0%, #adb5bd 100%)',
                'entry_version_color' => '#495057',
            ],
        ];

        return $themes[$type] ?? $themes['normal'];
    }

    private function labelize(string $value): string
    {
        return ucwords(str_replace('-', ' ', $value));
    }

    private function cleanText(string $text): string
    {
        $text = str_replace(["\n", "\r", "\f"], ' ', $text);
        return trim(preg_replace('/\s+/', ' ', $text));
    }

    private function formatHeight(float $meters): string
    {
        $totalInches = round($meters * 39.3701);
        $feet = intdiv((int) $totalInches, 12);
        $inches = (int) $totalInches % 12;

        return number_format($meters, 1) . " m ({$feet}′" . str_pad((string) $inches, 2, '0', STR_PAD_LEFT) . "″)";
    }

    private function formatWeight(float $kg): string
    {
        $lbs = round($kg * 2.20462, 1);
        return number_format($kg, 1) . " kg ({$lbs} lbs)";
    }
}