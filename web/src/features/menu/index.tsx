import {
  ActionIcon,
  Box,
  Group,
  Stack,
  Tabs,
  Text,
  Tooltip,
  Transition,
  createStyles,
} from "@mantine/core";
import React from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { isEnvBrowser } from "../../utils/misc";
import { fetchNui } from "../../utils/fetchNui";
import ObjectList from "./components/object-list";
import { IconCheck, IconDeviceFloppy, IconPlus, IconX } from "@tabler/icons-react";
import RightEditor from "./components/right-editor";
import { useThreeState } from "../../atoms/threeState";
import CurrentObjects from "./components/current-objects";
import { propsAtom } from "../../atoms/propsState";
import { useRecoilState, useResetRecoilState } from "recoil";

const useStyles = createStyles((theme) => ({
  wrapper: {
    width: "15vw",
    height: "80vh",
    color: theme.colors.dark[0],
    backgroundColor: "rgba(26, 27, 30, 0.85)",
  },
}));

export default function ObjectMenu() {
  const { classes } = useStyles();
  const [propState, setPropState] = useRecoilState(propsAtom);
  const [opened, setOpened] = React.useState(false);
  useNuiEvent("openObjectMenu", (show) => {
    setOpened(show);
  });

  useNuiEvent("setAllProps", (data) => {
    if (propState.allProps.length == 0) {
      setPropState({ ...propState, allProps: data.allProps });
    }
  })

  function handleClose() {
    setOpened(false);
    {
      !isEnvBrowser() && fetchNui("warehouses:closeObjectMenu");
    }
  }

  return (
    <Transition duration={300} transition="fade" mounted={opened}>
      {(style) => (
        <>
          <Group
            spacing="sm"
            sx={{
              position: "absolute",
              top: "50%",
              left: "2rem",
              transform: "translate(0, -50%)",
              zIndex: 3,
            }}
            align="items-start"
          >
            <Box style={style} className={classes.wrapper}>
              <Tabs defaultValue="list">
                <Tabs.List grow position="center">
                  <Tabs.Tab value="list">LIST</Tabs.Tab>
                  <Tabs.Tab value="current">CURRENT</Tabs.Tab>
                </Tabs.List>

                <Tabs.Panel value="list" pt="xs">
                  <ObjectList />
                </Tabs.Panel>

                <Tabs.Panel value="current" pt="xs">
                  <CurrentObjects />
                </Tabs.Panel>
              </Tabs>
            </Box>
            <Stack spacing='sm'>
            <Tooltip label="Add Selected" color="dark">
              <ActionIcon
                size="lg"
                radius="xs"
                variant="default"
                onClick={() => {
                  fetchNui("editCurrentModel");
                }}
                style={{ backgroundColor: "rgba(26, 27, 30, 0.85)" }}
              >
                <IconPlus size={24} />
              </ActionIcon>
            </Tooltip>
            <ActionIcon
                size="lg"
                radius="xs"
                variant="default"
                style={{ backgroundColor: "rgba(26, 27, 30, 0.85)" }}
              >
                <IconDeviceFloppy
                  size={24}
                  onClick={() => {
                    fetchNui("finishEdit");
                  }}
                />
              </ActionIcon>
              <ActionIcon
                size="lg"
                radius="xs"
                variant="default"
                style={{ backgroundColor: "rgba(26, 27, 30, 0.85)" }}
              >
                <IconX
                  size={24}
                  onClick={() => {
                    fetchNui("close");
                  }}
                />
              </ActionIcon>
            </Stack>
          </Group>
          <Box
            sx={{
              position: "absolute",
              top: "50%",
              right: "2rem",
              transform: "translate(0, -50%)",
              zIndex: 3,
            }}
            style={style}
            className={classes.wrapper}
          >
            <RightEditor />
          </Box>
        </>
      )}
    </Transition>
  );
}
