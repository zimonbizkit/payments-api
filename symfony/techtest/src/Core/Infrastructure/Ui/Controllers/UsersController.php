<?php

namespace App\Core\Infrastructure\Ui\Controllers;

use Symfony\Component\DependencyInjection\ContainerAwareTrait;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

class UsersController
{
    public function get(Request $request)
    {
        return new Response($request->get('userId'),Response::HTTP_OK);
    }
}