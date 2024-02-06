import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { CreateUserDto } from '../dtos/createUser.dto';
import { User } from '../entities/user.entity';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
    private jwtService: JwtService,
  ) {}

  async createUser(createUserDto: CreateUserDto): Promise<User> {
    const salt = await bcrypt.genSalt();
    createUserDto.password = await bcrypt.hash(createUserDto.password, salt);

    const newUser = this.usersRepository.create(createUserDto);
    return this.usersRepository.save(newUser);
  }

  async findUser(username: string): Promise<User> | null {
    return this.usersRepository.findOneBy({ username });
  }

  async createAuthToken(user: User): Promise<string> {
    const payload = { id: user.id, username: user.username };
    const jwt = await this.jwtService.signAsync(payload);

    await this.usersRepository.update({ id: user.id }, { authToken: jwt });

    return jwt;
  }
}
