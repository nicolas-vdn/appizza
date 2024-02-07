import { ArrayMinSize, IsNotEmpty, MinLength, ValidateNested, isNotEmpty, minLength } from 'class-validator';
import { User } from '../entities/user.entity';
import { PizzaDto } from './pizza.dto';
import { Type } from 'class-transformer';

export class OrderDto {
  @IsNotEmpty()
  @Type(() => PizzaDto)
  @ValidateNested({ each: true })
  @ArrayMinSize(1)
  pizzas: PizzaDto[];
  @IsNotEmpty()
  price: string;
}
