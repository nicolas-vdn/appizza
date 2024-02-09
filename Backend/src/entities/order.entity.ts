import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { User } from './user.entity';

@Entity()
export class Order {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  order_content: string;

  @Column()
  price: string;

  @ManyToOne(() => User, (user) => user.id)
  user: User;
}
