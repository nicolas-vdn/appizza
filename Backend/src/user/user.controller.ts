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
import { CreateUserDto } from 'src/dtos/createUser.dto';
import { RegisterGuard } from 'src/guards/register.guard';
import { AuthUserDto } from 'src/dtos/authUser.dto';
import * as bcrypt from 'bcrypt';

@Controller('user')
export class UserController {
  constructor(private userService: UserService) {}

  @Post('register')
  @UseGuards(RegisterGuard)
  @UsePipes(ValidationPipe)
  async createUser(
    @Body() createUserDto: CreateUserDto,
  ): Promise<{ authToken: Promise<string> }> {
    const newUser = await this.userService.createUser(createUserDto);
    if (newUser) {
      return { authToken: this.userService.createAuthToken(newUser) };
    }
  }

  @Post('login')
  @UsePipes(ValidationPipe)
  async loginUser(
    @Body() authUserDto: AuthUserDto,
  ): Promise<{ authToken: Promise<string> }> {
    const user = await this.userService.findUser(authUserDto.username);

    if (!user) {
      throw new BadRequestException('invalid credentials');
    }

    if (!(await bcrypt.compare(authUserDto.password, user.password))) {
      throw new BadRequestException('invalid credentials');
    }

    return { authToken: this.userService.createAuthToken(user) };
  }
}
