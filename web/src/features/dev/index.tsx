import { ActionIcon, Tooltip } from "@mantine/core";
import { IconCode } from "@tabler/icons-react";
import { debugData } from "../../utils/debugData";

export default function Dev() {
  const openMenu = () => {
    debugData([
      {
        action: "openObjectMenu",
        data: true,
      },
    ]);
  };

  return (
    <>
      <Tooltip label="Open Menu" position="bottom">
        <ActionIcon
          onClick={openMenu}
          variant="filled"
          color="dark"
          size="xl"
          mr={50}
          mb={50}
          sx={{
            position: "absolute",
            bottom: 0,
            right: 0,
            width: 50,
            height: 50,
            zIndex: 1,
          }}
        >
          <IconCode />
        </ActionIcon>
      </Tooltip>
    </>
  );
}