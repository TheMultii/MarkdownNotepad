export interface DiffPart {
  count: number;
  added?: boolean;
  removed?: boolean;
  value: string | undefined;
}
