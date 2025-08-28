<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class WelcomeController extends Controller
{
    public function welcome() {
        return '🎊 Welcome to ' . '<a href="https://diploi.com">diploi.com</a>';
    }
}
