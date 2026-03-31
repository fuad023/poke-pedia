<?php

namespace App\Http\Controllers;

use App\Models\UserInfo;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Http\JsonResponse;

class AuthController extends Controller
{
    public function signup(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255', 'unique:user_info,email'],
            'phone' => ['required', 'string', 'max:20'],
            'password' => ['required', 'string', 'min:8'],
            'confirmPassword' => ['required', 'same:password'],
        ], [
            'email.unique' => 'Account already created with this email.',
        ]);

        $user = UserInfo::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'phone' => $validated['phone'],
            'password' => Hash::make($validated['password']),
        ]);

        return response()->json([
            'message' => 'Signup successful',
            'user' => $user,
        ], 201);
    }

    public function login(Request $request): JsonResponse
{
    $validated = $request->validate([
        'email' => ['required', 'email'],
        'password' => ['required', 'string'],
    ], [
        'email.required' => 'Email is required.',
        'password.required' => 'Password is required.',
    ]);

    $user = \App\Models\UserInfo::where('email', $validated['email'])->first();

    if (!$user) {
        return response()->json([
            'errors' => [
                'email' => ['No account found with this email.']
            ]
        ], 422);
    }

    if (!\Illuminate\Support\Facades\Hash::check($validated['password'], $user->password)) {
        return response()->json([
            'errors' => [
                'password' => ['Incorrect password.']
            ]
        ], 422);
    }

    return response()->json([
        'message' => 'Login successful',
        'user' => $user,
    ], 200);
}
}