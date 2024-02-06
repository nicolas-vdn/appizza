import { IsNotEmpty, MinLength } from 'class-validator';

export class AuthUserDto {
  @IsNotEmpty()
  @MinLength(3)
  username: string;

  @IsNotEmpty()
  @MinLength(10)
  password: string;
}
