import { ArrayMinSize, IsNotEmpty, ValidateNested } from 'class-validator';
import { PizzaDto } from './pizza.dto';
import { Type } from 'class-transformer';

export class OrderDto {
  id?: number;
  @Type(() => PizzaDto)
  @ValidateNested({ each: true })
  @ArrayMinSize(1)
  order_content: PizzaDto[];
  @IsNotEmpty()
  price: string;
}
