import { UserBasic } from 'src/user/user.model';

export class UserBasicWithCurrentLine extends UserBasic {
  currentLine?: number;

  constructor(userBasic: UserBasic, currentLine?: number) {
    super();
    this.currentLine = currentLine ?? 0;
  }
}
