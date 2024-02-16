import { Module } from '@nestjs/common';
import { OrderController } from './order.controller';
import { OrderService } from './order.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from '../entities/user.entity';
import { ConfigModule } from '@nestjs/config';
import { Order } from '../entities/order.entity';
import { PizzaService } from '../pizza/pizza.service';
import { Pizza } from '../entities/pizza.entity';
import { UserService } from '../user/user.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([User, Order, Pizza]),
    ConfigModule.forRoot(),
  ],
  controllers: [OrderController],
  providers: [UserService, OrderService, PizzaService],
})
export class OrderModule {}
