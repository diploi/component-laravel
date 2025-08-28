<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return 'Hello ' . '<a href="https://diploi.com">Giao.com</a>';
});

Route::get('/test', function () {
    return '🔥 HOT RELOADING IS WORKING! 🎉 ' . date('Y-m-d H:i:s') . ' - Changes are live!';
});
