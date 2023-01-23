import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import Alpine from "alpinejs";
import QRCode from "qrcode";

import { setKeyboard } from "./room/keyboard";
import { setHooks } from "./room/hooks";
import { uiSetActiveColor } from "./room/utils";
import "./room/store"

window.Alpine = Alpine;

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

// Attach keyboard handler to window object
// so Alpine can use it to dispatch events
window.keyboard = setKeyboard(Alpine.store("state"));
let Hooks = setHooks(Alpine.store('state'))

// Raduga Viewer 
let viewer = document.getElementById("color-viewer");

function setUserSocket() {
  let userSocket = new Socket("/socket", { params: { token: window.userToken } });

  let channel = userSocket.channel(`random_room:${viewer.dataset.room}`, {
    user_id: viewer.dataset.user,
  });
  channel
    .join()
    .receive("ok", (resp) => {
      console.log("Joined successfully", resp);
    })
    .receive("error", (resp) => {
      console.log("Unable to join", resp);
    });

  channel.on("set-color", ({ color: c }) => {
    viewer.style.cssText = `background: #${c.hex}; transition: background ${(1 - c.speed) * 4500}ms linear`;
    uiSetActiveColor(c.id);
  });

  userSocket.connect();
}

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        window.Alpine.clone(from, to);
      }
    },
  },
});


// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (info) => topbar.show());
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();
setUserSocket();

// expose liveSocket on window for web console debug logs and latency simulation:
// liveSocket.enableDebug();
// liveSocket.enableLatencySim(5500)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
// window.liveSocket = liveSocket;

let canvasEl = document.getElementById("qr-canvas");
QRCode.toCanvas(canvasEl, location.href);

Alpine.start();