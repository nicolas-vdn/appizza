import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserModule } from './user/user.module';
import { User } from './entities/user.entity';
import { ConfigModule } from '@nestjs/config';
import { Order } from './entities/order.entity';
import { OrderModule } from './order/order.module';
import { PizzaModule } from './pizza/pizza.module';
import { Pizza } from './entities/pizza.entity';

@Module({
  imports: [
    ConfigModule.forRoot(),
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: process.env.DATABASE_HOST,
      port: 3306,
      username: process.env.DATABASE_USER,
      password: process.env.DATABASE_PASS,
      database: process.env.DATABASE_NAME,
      entities: [User, Order, Pizza],
      synchronize: true,
    }),
    UserModule,
    OrderModule,
    PizzaModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
