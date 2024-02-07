import { BadRequestException, Body, Controller, Get, HttpCode, HttpStatus, Options, Post, Req, UseGuards, UsePipes, ValidationPipe } from '@nestjs/common';
import { OrderService } from './order.service';
import { AuthGuard } from '../guards/auth.guard';
import { User } from '../entities/user.entity';
import { Order } from '../entities/order.entity';
import { OrderDto } from '../dtos/order.dto';
import { PizzaService } from '../pizza/pizza.service';
import { AuthUserDto } from '../dtos/authUser.dto';

@Controller('order')
export class OrderController {
    constructor(private orderService : OrderService,
        private pizzaService: PizzaService) {}

    @Options()
    @HttpCode(200)
    launchOk() {
      return HttpStatus.OK;
    }

    @Get()
    @UseGuards(AuthGuard)
    async getOrders(@Body('user') user: AuthUserDto) : Promise<Order[]> {
        return await this.orderService.getOrdersByUser(user.id);
    }

    @Post()
    @UseGuards(AuthGuard)
    @UsePipes(ValidationPipe)
    async postOrder(@Body('user') user : AuthUserDto, @Body('order') order: OrderDto) {
        for (const i in order.pizzas) {
            const tempPizza = await this.pizzaService.getOnePizza(order.pizzas[i].id);

            if (!tempPizza) {
                throw new BadRequestException('pizza id is not found');
            }
        }

        await this.orderService.createOrder(order, user.id);

        return HttpStatus.CREATED;
    }
}
