import {
  BadRequestException,
  Body,
  Controller,
  HttpCode,
  HttpStatus,
  Options,
  Post,
  UseGuards,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { UserService } from './user.service';
import { RegisterGuard } from '../guards/register.guard';
import { UserDto } from '../dtos/user.dto';
import * as bcrypt from 'bcrypt';

@Controller('user')
export class UserController {
  constructor(private userService: UserService) {}

  @Options('*')
  @HttpCode(200)
  launchOk() {
    return HttpStatus.OK;
  }

  @Post('register')
  @UseGuards(RegisterGuard)
  @UsePipes(ValidationPipe)
  async createUser(
    @Body() createUserDto: UserDto,
  ): Promise<{ authToken: string }> {
    const newUser = await this.userService.createUser(createUserDto);
    if (newUser) {
      return { authToken: await this.userService.createAuthToken(newUser) };
    }
  }

  @Post('login')
  @HttpCode(200)
  @UsePipes(ValidationPipe)
  async loginUser(
    @Body() authUserDto: UserDto,
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
