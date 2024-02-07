import { Column, Entity, JoinColumn, ManyToOne, OneToOne, PrimaryGeneratedColumn } from 'typeorm';
import { User } from './user.entity';

@Entity()
export class Order {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  order_content: string;

  @ManyToOne(type => User, user => user.id)
  user: User;
}
