import { Box, createStyles } from "@mantine/core";
import { isEnvBrowser } from "./utils/misc";
import Dev from "./features/dev";
import ObjectMenu from "./features/menu";
import { ThreeComponent } from "./features/three-controls";
import { useNuiEvent } from "./hooks/useNuiEvent";
import { useRecoilState, useResetRecoilState } from "recoil";
import { propsAtom } from "./atoms/propsState";
import { fetchNui } from "./utils/fetchNui";
import React from "react";

const useStyles = createStyles(() => ({
    container: {
      width: "100%",
      height: "100%",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
    },
  }));

  const App: React.FC = () => {
    const { classes } = useStyles();
    const [propState, setPropState] = useRecoilState(propsAtom);

    useNuiEvent("setCurrentProps", (data) => {
      setPropState({ ...propState, currentProps: data.currentProps });
    })

    React.useEffect(() => {
      const mouseHandler = (e: MouseEvent) => {
        switch (e.button) {
          case 2:
            fetchNui("changeFocus");
            break;
          default:
            break;
        }
      };
      window.addEventListener('contextmenu', mouseHandler)
      return () => window.removeEventListener("contextmenu", mouseHandler);
    });
  
    return (
      <>
        <Box className={classes.container}>
          <ThreeComponent />
          <ObjectMenu />
          {isEnvBrowser() && <Dev />}
        </Box>
      </>
    );
  };
  
  export default App;