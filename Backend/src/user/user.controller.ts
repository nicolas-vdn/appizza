import {
  Body,
  Controller,
  Post,
  UseGuards,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto } from 'src/dtos/createUser.dto';
import { JwtService } from '@nestjs/jwt';
import { RegisterGuard } from 'src/guards/register.guard';

@Controller('user')
export class UserController {
  constructor(
    private jwtService: JwtService,
    private userService: UserService,
  ) {}

  @Post('register')
  @UseGuards(RegisterGuard)
  @UsePipes(ValidationPipe)
  async createUser(@Body() createUserDto: CreateUserDto) {
    const newUser = await this.userService.createUser(createUserDto);
    if (newUser) {
      const payload = { id: newUser.id, username: newUser.username };
      const jwt = await this.jwtService.signAsync(payload);
      await this.userService.addAuthToken(newUser, jwt);
      return jwt;
    }
  }
}
