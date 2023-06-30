import { atom, useRecoilValue } from "recoil";

export interface IConfigProp {
  model: string;
  settings: Object;
}

export interface IProp {
  id: number;
  handle: number;
  model: string;
}

export interface IPropsState {
  allProps: IConfigProp[];
  currentProps: IProp[];
}

export const propsAtom = atom<IPropsState>({
  key: "propsState",
  default: {
    allProps: [],
    currentProps: [],
  },
});


export const usePropsState = () => useRecoilValue(propsAtom);
