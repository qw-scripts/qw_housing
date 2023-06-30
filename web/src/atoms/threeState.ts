import { atom, useRecoilValue } from "recoil";

export interface IThreeState {
    space: 'world' | 'local';
    mode: 'translate' | 'rotate';
    translateSnap: number;
    rotateSnap: number;
    model: number;
    entityX: number;
    entityY: number;
    entityZ: number;
    entityPitch: number;
    entityRoll: number;
    entityYaw: number;
}

export const threeAtom = atom<IThreeState>({
  key: "threeState",
  default: {
    space: 'world',
    mode: 'translate',
    translateSnap: 0.01,
    rotateSnap: 0.01,
    model: 0,
    entityX: 0,
    entityY: 0,
    entityZ: 0,
    entityPitch: 0,
    entityRoll: 0,
    entityYaw: 0,
  }
});

export const useThreeState = () => useRecoilValue(threeAtom);