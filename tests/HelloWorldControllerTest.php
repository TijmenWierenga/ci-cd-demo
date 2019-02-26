<?php
namespace App\Tests;

use App\Controller\HelloWorldController;
use PHPUnit\Framework\TestCase;

class HelloWorldControllerTest extends TestCase
{
    public function testHello(): void
    {
        $controller = new HelloWorldController();
        $response = $controller->hello();

        $this->assertEquals("Hello World!", $response->getContent());
    }
}
