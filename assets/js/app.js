// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import Alpine from "alpinejs";
import topbar from "../vendor/topbar";
import Panzoom from '@panzoom/panzoom';


Alpine.data("sidebarToggle", () => ({
  currentMode: localStorage.getItem("sidebarMode") || "expanded",
  panelOpen: false,
  panelX: 0,
  panelY: 0,
  hover: false,
  togglePanel() {
    this.panelOpen = !this.panelOpen;
    if (this.panelOpen) {
      this.$nextTick(() => {
        const rect = this.$refs.triggerBtn.getBoundingClientRect();
        const panel = this.$refs.panel;
        const panelRect = panel.getBoundingClientRect();
        this.panelY = rect.top + window.scrollY - panelRect.height - 8;
        this.panelX = rect.right - rect.width;
      });
    }
  },
  setMode(mode) {
    this.currentMode = mode;
    localStorage.setItem("sidebarMode", mode);
  },
  setHover(val) {
    this.hover = val;
  },
}));

Alpine.data("topbarToggle", () => ({
  workflowPanelOpen: false,
  workflowPanelX: 0,
  workflowPanelY: 0,
  selectWorkflow(id) {
    console.log("Selected Workflow: ", id);
  },
  toggleWorkflowOption() {
    this.workflowPanelOpen = !this.workflowPanelOpen;
    if (this.workflowPanelOpen) {
      this.$nextTick(() => {
        const rect = this.$refs.workflowOptionsTrigger.getBoundingClientRect();
        this.workflowPanelY = rect.bottom + window.scrollY + 8;
        this.workflowPanelX = rect.right - rect.width;
      });
    }
  },
  accountPanelOpen: false,
  accountPanelX: 0,
  accountPanelY: 0,
  toggleAccount() {
    this.accountPanelOpen = !this.accountPanelOpen;
    if (this.accountPanelOpen) {
      this.$nextTick(() => {
        const rect = this.$refs.accountTrigger.getBoundingClientRect();
        this.accountPanelY = rect.bottom + window.scrollY + 8;
        this.accountPanelX = 0;
      });
    }
  },
}));

let Hooks = {}

Hooks.SearchLoader = {
  mounted() {
    this.el.addEventListener("input", () => {
      window.dispatchEvent(new CustomEvent("loading:start"));
    });

    this.handleEvent("search_done", () => {
      window.dispatchEvent(new CustomEvent("loading:stop"));
    });
  }
};




let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
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
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
window.Alpine = Alpine;
window.Panzoom = Panzoom;
Alpine.start();
