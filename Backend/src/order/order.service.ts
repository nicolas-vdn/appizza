import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order } from '../entities/order.entity';
import { OrderDto } from '../dtos/order.dto';
import { UserService } from '../user/user.service';
import { CreateOrderDto } from '../dtos/createOrder.dto';
import { PizzaDto } from '../dtos/pizza.dto';
import { PizzaService } from '../pizza/pizza.service';

@Injectable()
export class OrderService {
  constructor(
    @InjectRepository(Order)
    private ordersRepository: Repository<Order>,
    private pizzaService: PizzaService,
    private usersService: UserService,
  ) {}

  async getOrdersByUser(userId: number) {
    const user = await this.usersService.findUserById(userId);
    const userOrders = await this.ordersRepository.findBy({ user: user });

    userOrders.map(
      (order) => (order.order_content = JSON.parse(order.order_content)),
    );

    return userOrders;
  }

  async createOrder(order: OrderDto, userid: number): Promise<Order> {
    order.order_content = await Promise.all(
      order.order_content.map(async (pizza: PizzaDto) => {
        pizza.name = (await this.pizzaService.getOnePizza(pizza.id)).name;
        return pizza;
      }),
    );

    const strOrder = JSON.stringify(order.order_content);
    const user = await this.usersService.findUserById(userid);

    const orderData: CreateOrderDto = {
      order_content: strOrder,
      user: user,
      price: order.price,
    };

    const newOrder = this.ordersRepository.create(orderData);
    return this.ordersRepository.save(newOrder);
  }
}
