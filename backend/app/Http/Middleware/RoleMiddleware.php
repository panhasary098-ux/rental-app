<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class RoleMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response)  $next
     */
    public function handle(Request $request, Closure $next, ...$roles): Response
    {
        // Get the auth user added by firebaseAuthMiddleware
        // $user = $request->attributes->get('auth-user');
        $user = $request->user();

        // if there is no authenticated user
        if(!$user){
            return response()->json([
                'success' => false,
                'message' => 'Unauthenticated',
            ],401);
        }

        // Authorization
        //Check whether user's role is allowed 
        if(!in_array($user->role, $roles)){
            return response()->json([
                'success' =>false,
                'message' => 'You are not authorized to access this resource',
            ],403);
        }

        //user is allowed
        return $next($request);
    }
}
