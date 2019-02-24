<?php

namespace App\Core\Infrastructure\Ui\Controllers;

use App\Core\Application\Service\GetUserBalanceRequest;
use App\Core\Application\Service\GetUserBalanceUseCase;
use App\Core\Domain\Entity\Balance;
use App\SharedKernel\Infrastructure\Schemas\BalanceSchema;
use App\SharedKernel\Infrastructure\Ui\BaseController;
use Neomerx\JsonApi\Encoder\Encoder;
use Symfony\Component\HttpFoundation\Response;

class BalancesController
{
    /** @var GetUserBalanceUseCase */
    private $getUserBalanceUseCase;

    public function __construct(GetUserBalanceUseCase $getUserBalanceUseCase)
    {
        $this->getUserBalanceUseCase = $getUserBalanceUseCase;
    }

    public function get(string $userId)
    {
        $response = $this->getUserBalanceUseCase
            ->handle(
                new GetUserBalanceRequest($userId)
            );

        return new Response((Encoder::instance([
            Balance::class => BalanceSchema::class,
        ])
            ->withEncodeOptions(JSON_PRETTY_PRINT)
        )->encodeData(
            $response->getBalanceResource()

        ),Response::HTTP_OK);
    }
}