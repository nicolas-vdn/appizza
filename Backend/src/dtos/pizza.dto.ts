import { IsNotEmpty } from 'class-validator';

export class PizzaDto {
  @IsNotEmpty()
  id: number;
  @IsNotEmpty()
  amount: number;

  price!: string;

  image_url!: string;

  name!: string;
}
