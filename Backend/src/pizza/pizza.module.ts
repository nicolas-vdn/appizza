import { Module } from '@nestjs/common';
import { PizzaController } from './pizza.controller';
import { PizzaService } from './pizza.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { Pizza } from '../entities/pizza.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Pizza]),
    ConfigModule.forRoot()
  ],
  controllers: [PizzaController],
  providers: [PizzaService],
})
export class PizzaModule {}
