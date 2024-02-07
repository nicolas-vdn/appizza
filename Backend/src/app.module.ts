import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserModule } from './user/user.module';
import { User } from './entities/user.entity';
import { ConfigModule } from '@nestjs/config';
import { Cart } from './entities/cart.entity';
import { CartModule } from './cart/cart.module';
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
      entities: [User, Cart, Pizza],
      synchronize: true,
    }),
    UserModule,
    CartModule,
    PizzaModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
