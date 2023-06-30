import { Canvas } from '@react-three/fiber'
import { TransformComponent } from './components/Transform'
import { CameraComponent } from './components/Camera'

export const ThreeComponent = () => {
    return (
        <Canvas style={{zIndex:1}}>
            <CameraComponent />
            <TransformComponent />
        </Canvas>
    )
}