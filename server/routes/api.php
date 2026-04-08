<?php

use App\Http\Controllers\PokemonController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\PokeController;

Route::get('/pokemon', [PokeController::class, 'index']);

Route::middleware(['auth:sanctum'])->get('/user', function (Request $request) {
    return $request->user();
});

Route::get('/pokemon/{id}', [PokemonController::class, 'show']);

require __DIR__.'/auth.php';
