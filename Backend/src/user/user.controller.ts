import {
  BadRequestException,
  Body,
  Controller,
  Post,
  UseGuards,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { UserService } from './user.service';
<<<<<<< HEAD
import { CreateUserDto } from '../dtos/createUser.dto';
import { RegisterGuard } from '../guards/register.guard';
import { AuthUserDto } from '../dtos/authUser.dto';
=======
import { CreateUserDto } from 'src/dtos/createUser.dto';
import { RegisterGuard } from 'src/guards/register.guard';
import { AuthUserDto } from 'src/dtos/authUser.dto';
>>>>>>> origin/9-backend-feature-creation-du-crud-panier
import * as bcrypt from 'bcrypt';

@Controller('user')
export class UserController {
  constructor(private userService: UserService) {}

  @Post('register')
  @UseGuards(RegisterGuard)
  @UsePipes(ValidationPipe)
  async createUser(
    @Body() createUserDto: CreateUserDto,
  ): Promise<{ authToken: string }> {
    const newUser = await this.userService.createUser(createUserDto);
    if (newUser) {
      return { authToken: await this.userService.createAuthToken(newUser) };
    }
  }

  @Post('login')
  @UsePipes(ValidationPipe)
  async loginUser(
    @Body() authUserDto: AuthUserDto,
  ): Promise<{ authToken: string }> {
    const user = await this.userService.findUser(authUserDto.username);

    if (!user) {
      throw new BadRequestException('invalid credentials');
    }

    if (!(await bcrypt.compare(authUserDto.password, user.password))) {
      throw new BadRequestException('invalid credentials');
    }

    return { authToken: await this.userService.createAuthToken(user) };
  }
}
