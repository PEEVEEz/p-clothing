export type Item = {
  image: string;
  name: string;
};

export type NuiMessageData<T = unknown> = {
  action: string;
  data: T;
};

export type NuiHandlerSignature<T> = (data: T) => void;

export type Response = {
  success: boolean;
  state?: boolean;
};

export type Position = {
  x: number;
  y: number;
};
