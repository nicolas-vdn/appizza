import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { UserService } from '../user/user.service';

@Injectable()
export class RegisterGuard implements CanActivate {
  constructor(private userService: UserService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const body = context.switchToHttp().getRequest().body;
    const user = await this.userService.findUser(body.username);

    if (user) {
      throw new UnauthorizedException('user already exists');
    } else {
      return true;
    }
  }
}
