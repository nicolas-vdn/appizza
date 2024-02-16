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
    const userOrders = await this.ordersRepository.findBy({
      user: user,
    });

    if (userOrders.length > 0) {
      const orders = [];

      for (const order of userOrders) {
        const tempOrder = {
          id: order.id,
          order_content: [],
          price: order.price,
        };

        const orderContent: PizzaDto[] = JSON.parse(order.order_content);

        for (const pizza of orderContent) {
          tempOrder.order_content.push({
            ...(await this.pizzaService.getOnePizza(pizza.id)),
            amount: pizza.amount,
          });
        }

        orders.push(tempOrder);
      }

      return orders;
    }

    return userOrders;
  }

  async createOrder(order: OrderDto, userid: number): Promise<Order> {
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
