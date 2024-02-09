import { IsNotEmpty } from 'class-validator';

export class PizzaDto {
  @IsNotEmpty()
  id: number;
  @IsNotEmpty()
  amount: number;

  name?: string;
}
