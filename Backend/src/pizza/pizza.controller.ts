import { Controller, Get, HttpCode, HttpStatus, Options, UseGuards } from '@nestjs/common';
import { PizzaService } from './pizza.service';
import { AuthGuard } from '../guards/auth.guard';

@Controller('pizza')
export class PizzaController {
    constructor (private pizzaServices: PizzaService) {}

    @Options()
    @HttpCode(200)
    launchOk() {
      return HttpStatus.OK;
    }

    @Get()
    @UseGuards(AuthGuard)
    getAllPizzas() {
        return this.pizzaServices.getAllPizzas();
    }
}
