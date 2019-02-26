<?php
namespace App\Controller;

use Symfony\Component\HttpFoundation\Response;

final class HelloWorldController
{
    public function hello(): Response
    {
        return new Response("Hello World!");
    }
}
