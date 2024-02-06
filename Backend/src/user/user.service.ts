import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { CreateUserDto } from 'src/dtos/createUser.dto';
import { User } from 'src/entities/user.entity';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
  ) {}

  async createUser(createUserDto: CreateUserDto): Promise<User> {
    createUserDto.salt = await bcrypt.genSalt();
    createUserDto.password = await bcrypt.hash(
      createUserDto.password,
      createUserDto.salt,
    );

    const newUser = this.usersRepository.create(createUserDto);
    return this.usersRepository.save(newUser);
  }
}
