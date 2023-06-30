import {
  Box,
  Divider,
  Group,
  NumberInput,
  SegmentedControl,
  Slider,
  Stack,
  Text,
  TextInput,
  createStyles,
} from "@mantine/core";
import React from "react";
import { useRecoilState } from "recoil";
import { threeAtom } from "../../../../atoms/threeState";

const useStyles = createStyles((theme) => ({
  wrapper: {
    padding: theme.spacing.md,
  },
}));

export default function RightEditor() {
  const { classes } = useStyles();
  const [threeState, setThreeState] = useRecoilState(threeAtom);
  return (
    <Box className={classes.wrapper}>
      <Stack spacing="xl">
        <Text size="lg">Space:</Text>
        <SegmentedControl
          size="sm"
          onChange={(value: 'world' | 'local') => {
            setThreeState({ ...threeState, space: value });
          }}
          data={[
            { label: "World", value: "world" },
            { label: "Local", value: "local" },
          ]}
        />
        <Text size="lg">Mode:</Text>
        <SegmentedControl
          size="sm"
          onChange={(value: 'translate' | 'rotate') => {
            setThreeState({ ...threeState, mode: value });
          }}
          data={[
            { label: "Translate", value: "translate" },
            { label: "Rotate", value: "rotate" },
          ]}
        />
        <Divider my="sm" />
        <Text size="lg">Model Movement Settings:</Text>
        <Text size="md">Translate Snap:</Text>
        <Slider
          labelTransition="skew-down"
          min={0.01}
          max={0.10}
          precision={2}
          step={0.01}
          onChangeEnd={(value) => {
            setThreeState({ ...threeState, translateSnap: value });
          }}
          labelTransitionDuration={150}
          labelTransitionTimingFunction="ease"
        />
        <Text size="md">Rotate Snap:</Text>
        <Slider
          labelTransition="skew-down"
          min={0.01}
          max={0.10}
          precision={2}
          step={0.01}
          onChangeEnd={(value) => {
            setThreeState({ ...threeState, rotateSnap: value });
          }}
          labelTransitionDuration={150}
          labelTransitionTimingFunction="ease"
        />
        <Divider my="sm" />
        <Text size="lg">Entity:</Text>
        <TextInput label="Model" value={threeState.model} disabled />
        <Group spacing="sm" grow>
          <NumberInput label="X" value={threeState.entityX} precision={2} />
          <NumberInput label="Y" value={threeState.entityY} precision={2} />
          <NumberInput label="Z" value={threeState.entityZ} precision={2} />
        </Group>
        <Group spacing="sm" grow>
          <NumberInput label="Pitch" value={threeState.entityPitch} precision={2} />
          <NumberInput label="Roll" value={threeState.entityRoll} precision={2} />
          <NumberInput label="Yaw" value={threeState.entityYaw} precision={2} />
        </Group>
      </Stack>
    </Box>
  );
}
