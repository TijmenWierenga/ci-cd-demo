<?php

namespace App\Controller;

use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;

final class HealthController
{
    public function check(): Response
    {
        return new JsonResponse("OK");
    }
}
