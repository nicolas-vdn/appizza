import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from '../entities/user.entity';
import { Repository } from 'typeorm';
import { Order } from '../entities/order.entity';
import { OrderDto } from '../dtos/order.dto';
import { UserService } from '../user/user.service';
import { CreateOrderDto } from '../dtos/createOrder.dto';

@Injectable()
export class OrderService {
  constructor(
    @InjectRepository(Order)
    private ordersRepository: Repository<Order>,
    private usersService: UserService
  ) {}

  async getOrdersByUser(userId: number) {
    const user = await this.usersService.findUserById(userId);
    const userOrders = await this.ordersRepository.findBy({user: user});

    userOrders.map(order => order.order_content = JSON.parse(order.order_content));

    return userOrders;
  }

  async createOrder(order: OrderDto, userid: number): Promise<Order> {
    const strOrder = JSON.stringify(order);
    const user = await this.usersService.findUserById(userid);

    const orderData : CreateOrderDto = {
      order_content: strOrder,
      user: user
    }

    const newOrder = this.ordersRepository.create(orderData);
    return this.ordersRepository.save(newOrder);
  }
}
