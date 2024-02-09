import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Pizza } from '../entities/pizza.entity';
import { Repository } from 'typeorm';

@Injectable()
export class PizzaService {
  constructor(
    @InjectRepository(Pizza) private pizzasRepository: Repository<Pizza>,
  ) {}

  getAllPizzas() {
    return this.pizzasRepository.find();
  }

  getOnePizza(id: number): Promise<Pizza> {
    return this.pizzasRepository.findOneBy({ id: id });
  }
}
