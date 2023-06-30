import { MantineThemeOverride } from "@mantine/core";

const mainBackgroundColor = "rgba(28, 28, 28, 1)";

export const theme: MantineThemeOverride = {
  colorScheme: "dark",
  fontFamily: "Roboto",
  shadows: { sm: "1px 1px 3px rgba(0, 0, 0, 0.5)" },
  components: {
    Header: {
      styles: {
        root: {
          height: "100%",
          backgroundColor: mainBackgroundColor,
          borderRadius: "5px",
        },
      },
    },
    AppShell: {
      styles: {
        main: {
          backgroundColor: mainBackgroundColor,
          borderTopRightRadius: "5px",
          borderBottomRightRadius: "5px",
        },
      },
    },
    Navbar: {
      styles: {
        root: {
          backgroundColor: mainBackgroundColor,
          borderBottomLeftRadius: "5px",
          borderTopLeftRadius: "5px",
        },
      },
    },
    Paper: {
      styles: {
        root: {
          backgroundColor: "rgba(35, 35, 35, 1)",
        },
      },
    },
  },
};