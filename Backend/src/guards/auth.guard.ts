import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private jwtService: JwtService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const token = request.headers.authorization;

    if (!token || token.split(' ')[0] !== 'Bearer') {
      throw new ForbiddenException('missing auth token');
    }

    try {
      const payload = await this.jwtService.verifyAsync(token.split(' ')[1], {
        secret: process.env.JWT_SECRET,
      });
      request.body['user'] = payload;
    } catch {
      throw new ForbiddenException();
    }
    return true;
  }
}
