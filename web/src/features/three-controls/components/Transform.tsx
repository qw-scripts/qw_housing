import { Suspense, useRef } from "react";
import { TransformControls } from "@react-three/drei";
import { Mesh, MathUtils } from "three";
import { fetchNui } from "../../../utils/fetchNui";
import { useNuiEvent } from "../../../hooks/useNuiEvent";
import { threeAtom } from "../../../atoms/threeState";
import { useRecoilState } from "recoil";
import React from "react";

export const TransformComponent = () => {
  const mesh = useRef<Mesh>(null!);
  const [currentEntity, setCurrentEntity] = React.useState<number>();
  const [data, setThreeState] = useRecoilState(threeAtom);

  const handleObjectDataUpdate = () => {
    const entity = {
      handle: currentEntity,
      position: {
        x: mesh.current.position.x,
        y: -mesh.current.position.z,
        z: mesh.current.position.y - 0.5,
      },
      rotation: {
        x: MathUtils.radToDeg(mesh.current.rotation.x),
        y: MathUtils.radToDeg(-mesh.current.rotation.z),
        z: MathUtils.radToDeg(mesh.current.rotation.y),
      },
      snap: false,
    };

    
    setThreeState({
      ...data,
      entityX: entity.position.x,
      entityY: entity.position.z,
      entityZ: entity.position.y,
      entityRoll: entity.rotation.x,
      entityYaw: entity.rotation.z,
      entityPitch: entity.rotation.y,
    })

    fetchNui("moveEntity", entity);
  };

  useNuiEvent("setGizmoEntity", (entity: any) => {
    setCurrentEntity(entity.handle);
    if (!entity.handle) {
      return;
    }

    setThreeState({
      ...data,
      entityX: entity.position.x,
      entityY: entity.position.z,
      entityZ: entity.position.y,
      entityRoll: entity.rotation.x,
      entityYaw: entity.rotation.z,
      entityPitch: entity.rotation.y,
      model: entity.model,
    })

    mesh.current.position.set(
      entity.position.x, 
      entity.position.z + 0.5,
      -entity.position.y
    );
    mesh.current.rotation.order = "YZX";
    mesh.current.rotation.set(
      MathUtils.degToRad(entity.rotation.x),
      MathUtils.degToRad(entity.rotation.z),
      MathUtils.degToRad(entity.rotation.y)
    );
  });

  React.useEffect(() => {
    const keyHandler = (e: KeyboardEvent) => {
      switch (e.code) {
        case "KeyS":
          const entity = {
            handle: currentEntity,
            position: {
              x: mesh.current.position.x,
              y: -mesh.current.position.z,
              z: mesh.current.position.y - 0.5,
            },
            rotation: {
              x: MathUtils.radToDeg(mesh.current.rotation.x),
              y: MathUtils.radToDeg(-mesh.current.rotation.z),
              z: MathUtils.radToDeg(mesh.current.rotation.y),
            },
            snap: true,
          };
      
          
          setThreeState({
            ...data,
            entityX: entity.position.x,
            entityY: entity.position.z,
            entityZ: entity.position.y,
            entityRoll: entity.rotation.x,
            entityYaw: entity.rotation.z,
            entityPitch: entity.rotation.y,
          })
      
          fetchNui("moveEntity", entity);
          break;
        default:
          break;
      }
    };
    window.addEventListener("keyup", keyHandler);
    return () => window.removeEventListener("keyup", keyHandler);
  });

  return (
    <>
      <Suspense fallback={<p>Loading Gizmo</p>}>
        {currentEntity != null && (
          <TransformControls
            size={0.5}
            object={mesh}
            mode={data.mode}
            space={data.space}
            rotationSnap={data.rotateSnap}
            translationSnap={data.translateSnap}
            onObjectChange={handleObjectDataUpdate}
          />
        )}
        <mesh ref={mesh} />
      </Suspense>
    </>
  );
};