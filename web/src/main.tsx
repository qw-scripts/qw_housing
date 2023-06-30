import React from "react";
import ReactDOM from "react-dom/client";
import "./index.css";
import { isEnvBrowser } from "./utils/misc";
import { MantineProvider } from "@mantine/core";
import { theme } from "./theme";
import App from "./App";
import { RecoilRoot } from "recoil";

if (isEnvBrowser()) {
  const root = document.getElementById("root");

  // https://i.imgur.com/iPTAdYV.png - Night time img
  root!.style.backgroundImage = 'url("https://i.imgur.com/iPTAdYV.png")';
  root!.style.backgroundSize = "cover";
  root!.style.backgroundRepeat = "no-repeat";
  root!.style.backgroundPosition = "center";
}

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <RecoilRoot>
      <MantineProvider withNormalizeCSS withGlobalStyles theme={theme}>
        <App />
      </MantineProvider>
    </RecoilRoot>
  </React.StrictMode>
);
