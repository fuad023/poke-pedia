<?php

use App\Http\Controllers\PokemonController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::middleware(['auth:sanctum'])->get('/user', function (Request $request) {
    return $request->user();
});

Route::get('/pokemon', [PokemonController::class, 'index']);
Route::get('/pokemon/{id}', [PokemonController::class, 'show']);

require __DIR__.'/auth.php';
