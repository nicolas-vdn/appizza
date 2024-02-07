import { Controller, Get, UseGuards } from '@nestjs/common';
import { PizzaService } from './pizza.service';
import { AuthGuard } from '../guards/auth.guard';

@Controller('pizza')
export class PizzaController {
    constructor (private pizzaServices: PizzaService) {}

    @Get()
    @UseGuards(AuthGuard)
    getAllPizzas() {
        return this.pizzaServices.getAllPizzas();
    }
}
