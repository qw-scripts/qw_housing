import {
  ActionIcon,
  Box,
  Button,
  Group,
  Paper,
  ScrollArea,
  Stack,
  Text,
  TextInput,
  createStyles,
} from "@mantine/core";
import React from "react";
import { useRecoilState } from "recoil";
import { propsAtom } from "../../../../atoms/propsState";
import { IconBuildingCircus, IconEdit, IconTrash } from "@tabler/icons-react";
import { fetchNui } from "../../../../utils/fetchNui";

const useStyles = createStyles((theme) => ({
  wrapper: {
    padding: theme.spacing.md,
  },
}));

export default function CurrentObjects() {
  const { classes } = useStyles();
  const [propState, setPropState] = useRecoilState(propsAtom);
  const [search, setSearch] = React.useState("");
  return (
    <Box className={classes.wrapper}>
      <Stack spacing="sm">
        <Text size="md">Object List:</Text>
        <TextInput
          placeholder="Search title..."
          value={search}
          onChange={(e) => setSearch(e.currentTarget.value)}
        />
        <Paper
          shadow="xs"
          p="md"
          h="full"
          style={{ minHeight: "60vh", maxHeight: "60vh" }}
        >
          <ScrollArea h="55vh" type="never">
            <Stack spacing="sm">
              {propState.currentProps
                .filter((row) =>
                  row.model.toLowerCase().includes(search.toLowerCase())
                )
                .map((prop, index) => (
                  <Paper>
                    <Group position="apart">
                      <Text>{prop.model}</Text>
                      <Group spacing="sm">
                        <ActionIcon
                          onClick={() => {
                            fetchNui("editExisting", {
                              handle: prop.handle,
                              id: prop.id,
                            });
                          }}
                        >
                          <IconEdit size="1.125rem" />
                        </ActionIcon>
                        <ActionIcon
                          color="red"
                          onClick={() => {
                            fetchNui("removeProp", { id: prop.id });
                            setPropState({
                              ...propState,
                              currentProps: propState.currentProps.filter(
                                (p) => p.id !== prop.id
                              ),
                            });
                          }}
                        >
                          <IconTrash size="1.125rem" />
                        </ActionIcon>
                      </Group>
                    </Group>
                  </Paper>
                ))}
            </Stack>
          </ScrollArea>
        </Paper>
      </Stack>
    </Box>
  );
}
