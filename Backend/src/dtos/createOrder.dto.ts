import { User } from '../entities/user.entity';

export class CreateOrderDto {
  order_content: string;
  user: User;
  date: string;
  price: string;
}
