import {
  ActionIcon,
  Box,
  Button,
  Modal,
  Paper,
  ScrollArea,
  Stack,
  Text,
  TextInput,
  createStyles,
} from "@mantine/core";
import { IconBuildingCircus, IconHelpCircle } from "@tabler/icons-react";
import { useDisclosure } from "@mantine/hooks";
import React from "react";
import { useRecoilState } from "recoil";
import { propsAtom } from "../../../../atoms/propsState";
import { fetchNui } from "../../../../utils/fetchNui";

const useStyles = createStyles((theme) => ({
  wrapper: {
    padding: theme.spacing.md,
  },
  helpWrapper: {
    position: "absolute",
    bottom: "1rem",
    left: "1rem",
  },
}));

function previewModel(model: string) {
  fetchNui('previewModel', { model })
}

export default function ObjectList() {
  const { classes } = useStyles();
  const [opened, { open, close }] = useDisclosure(false);
  const [propState, setPropState] = useRecoilState(propsAtom);
  const [search, setSearch] = React.useState("");
  return (
    <Box className={classes.wrapper}>
      <Stack spacing="sm">
        <Text size="md">Object List:</Text>
        <TextInput placeholder="Search title..." value={search}
          onChange={(e) => setSearch(e.currentTarget.value)} />
        <Paper
          shadow="xs"
          p="md"
          h="full"
          style={{ minHeight: "60vh", maxHeight: "60vh" }}
        >
          <ScrollArea h="55vh" type="never">
            <Stack spacing="sm">
              {propState.allProps.filter((row) =>
                  row.model.toLowerCase().includes(search.toLowerCase())
                ).map((prop, index) => (
                <Button
                  key={index}
                  color="gray"
                  radius="xs"
                  compact
                  fullWidth
                  leftIcon={<IconBuildingCircus size={16} />}
                  onClick={() => previewModel(prop.model)}
                  styles={() => ({
                    root: {
                      display: "flex",
                      justifyContent: "flex-start",
                      alignItems: "center",
                      gap: "0.5rem",
                    },
                  })}
                >
                  <Text>{prop.model}</Text>
                </Button>
              ))}
            </Stack>
          </ScrollArea>
        </Paper>
      </Stack>
      <Box className={classes.helpWrapper}>
        <ActionIcon onClick={open} variant="outline" color="gray" size="lg">
          <IconHelpCircle size={24} />
        </ActionIcon>
      </Box>
      <Modal opened={opened} onClose={close} withCloseButton={false} centered>
        <Text>
          Find the object you want to place down, preview it, and click the Plus
          button to place it and begin editing it.
        </Text>
      </Modal>
    </Box>
  );
}
