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
import Panzoom from "@panzoom/panzoom";

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

Alpine.data("workflowPlayground", (initialNodes) => ({
  nodes: initialNodes,
  connections: [],
  dragging: false,
  activeNode: null,
  offset: { x: 0, y: 0 },
  tempConnection: null,

  init() {
    console.log("Playground initialized with nodes:", this.nodes);
    this.$watch("connections", (value) => {
      this.renderConnections();
    });
  },

  // Create curved path for connections
  createCurvedPath(from, to) {
    const dx = to.x - from.x;
    const dy = to.y - from.y;

    // Control points for the curve - adjust these for different curve styles
    const curvature = Math.min(Math.abs(dx) * 0.5, 150);

    // Horizontal curves (Bezier)
    const cp1x = from.x + curvature;
    const cp1y = from.y;
    const cp2x = to.x - curvature;
    const cp2y = to.y;

    return `M ${from.x} ${from.y} C ${cp1x} ${cp1y}, ${cp2x} ${cp2y}, ${to.x} ${to.y}`;
  },

  // Alternative: Create step-like path
  createStepPath(from, to) {
    const midX = from.x + (to.x - from.x) * 0.5;
    return `M ${from.x} ${from.y} L ${midX} ${from.y} L ${midX} ${to.y} L ${to.x} ${to.y}`;
  },

  // Get connection color based on connection type or state
  getConnectionColor(conn) {
    if (conn.temp) return "#94a3b8";
    if (conn.type === "error") return "#ef4444";
    if (conn.type === "success") return "#22c55e";
    if (conn.type === "data") return "#8b5cf6";
    return "#2563eb";
  },

  // Get stroke width based on connection importance
  getStrokeWidth(conn) {
    if (conn.temp) return "2";
    if (conn.important) return "3";
    return "2";
  },

  // Add animation class for new connections
  getAnimationClass(conn) {
    return conn.isNew ? "animate-pulse-connection" : "";
  },

  renderConnections() {
    const svg = this.$refs.svg;
    if (!svg) return;

    const existingPaths = svg.querySelectorAll(
      "path.connection, line.connection"
    );
    existingPaths.forEach((path) => path.remove());

    this.connections.forEach((conn, index) => {
      const color = this.getConnectionColor(conn);
      const strokeWidth = this.getStrokeWidth(conn);

      // Create curved path instead of straight line
      const path = document.createElementNS(
        "http://www.w3.org/2000/svg",
        "path"
      );
      const pathData = this.createCurvedPath(conn.from, conn.to);

      path.setAttribute("d", pathData);
      path.setAttribute("stroke", color);
      path.setAttribute("stroke-width", strokeWidth);
      path.setAttribute("fill", "none");
      // path.setAttribute("marker-end", "url(#arrow)");
      path.setAttribute("class", "connection");

      // Add smooth transitions
      path.style.transition = "all 0.3s ease";

      // Add hover effects
      path.style.cursor = "pointer";
      path.addEventListener("mouseenter", () => {
        console.log("Hovered connection:", conn);
        path.setAttribute(
          "stroke-width",
          (parseInt(strokeWidth) + 1).toString()
        );
        path.style.filter = "drop-shadow(0 0 4px rgba(37, 99, 235, 0.4))";
      });

      path.addEventListener("mouseleave", () => {
        path.setAttribute("stroke-width", strokeWidth);
        path.style.filter = "none";
      });

      // Add click handler for connection selection/deletion
      path.addEventListener("click", (e) => {
        e.stopPropagation();
        this.selectConnection(conn);
      });

      svg.appendChild(path);

      // Add flow animation for active connections
      if (!conn.temp && conn.active) {
        this.addFlowAnimation(path);
      }
    });
  },

  addFlowAnimation(path) {
    const circle = document.createElementNS(
      "http://www.w3.org/2000/svg",
      "circle"
    );
    circle.setAttribute("r", "3");
    circle.setAttribute("fill", "#60a5fa");
    circle.setAttribute("class", "flow-dot");

    const animateMotion = document.createElementNS(
      "http://www.w3.org/2000/svg",
      "animateMotion"
    );
    animateMotion.setAttribute("dur", "2s");
    animateMotion.setAttribute("repeatCount", "indefinite");

    const mpath = document.createElementNS(
      "http://www.w3.org/2000/svg",
      "mpath"
    );
    mpath.setAttributeNS("http://www.w3.org/1999/xlink", "href", "#" + path.id);

    // Set unique ID for the path
    path.id = `path-${Date.now()}-${Math.random()}`;

    animateMotion.appendChild(mpath);
    circle.appendChild(animateMotion);

    this.$refs.svg.appendChild(circle);
  },

  selectConnection(conn) {
    console.log("Connection selected:", conn);
  },

  getNodePosition(nodeId) {
    const node = this.nodes.find((n) => n.id === nodeId);
    return node?.position || { x: 0, y: 0 };
  },

  startDrag(nodeId, event) {
    const node = this.nodes.find((n) => n.id === nodeId);
    this.activeNode = node;
    this.dragging = true;
    this.offset = {
      x: event.clientX - node.position.x,
      y: event.clientY - node.position.y,
    };
  },

  onDrag(event) {
    if (!this.dragging) return;
    const node = this.nodes.find((n) => n.id === this.activeNode.id);
    if (!node) return;

    node.position.x = event.clientX - this.offset.x;
    node.position.y = event.clientY - this.offset.y;

    this.updateConnections();
  },

  stopDrag() {
    this.dragging = false;
    this.activeNode = null;
  },

  getPortCenter(nodeId, type) {
    const el = document.querySelector(
      `[data-node-id="${nodeId}"][data-port-type="${type}"]`
    );

    if (!el) return { x: 0, y: 0 };

    const rect = el.getBoundingClientRect();
    const container = document.querySelector(
      ".relative.w-full.h-full.overflow-hidden"
    );
    const containerRect = container
      ? container.getBoundingClientRect()
      : { left: 0, top: 0 };

    return {
      x: rect.left + rect.width / 2 - containerRect.left,
      y: rect.top + rect.height / 2 - containerRect.top,
    };
  },

  startConnection(fromNodeId, portType) {
    if (portType !== "output") return;

    const from = this.getPortCenter(fromNodeId, "output");

    this.tempConnection = {
      fromNodeId: fromNodeId,
      from,
      to: { x: from.x, y: from.y },
      temp: true,
    };

    const moveHandler = (e) => {
      if (!this.tempConnection) return;
      const container = document.querySelector(
        ".relative.w-full.h-full.overflow-hidden"
      );
      const containerRect = container
        ? container.getBoundingClientRect()
        : { left: 0, top: 0 };

      this.tempConnection.to = {
        x: e.clientX - containerRect.left,
        y: e.clientY - containerRect.top,
      };
      this.renderTemp();
    };

    const upHandler = (e) => {
      document.removeEventListener("mousemove", moveHandler);
      document.removeEventListener("mouseup", upHandler);
      this.tempConnection = null;
      this.connections = this.connections.filter((c) => !c.temp);
    };

    document.addEventListener("mousemove", moveHandler);
    document.addEventListener("mouseup", upHandler);
  },

  completeConnection(toNodeId, portType) {
    if (portType !== "input" || !this.tempConnection) return;

    const fromNodeId = this.tempConnection.fromNodeId;
    const from = this.getPortCenter(fromNodeId, "output");
    const to = this.getPortCenter(toNodeId, "input");

    const newConnection = {
      id: `conn-${Date.now()}`,
      fromNodeId: fromNodeId,
      toNodeId: toNodeId,
      from,
      to,
      type: "success",
      active: true,
      isNew: true,
    };

    // Remove temp connection and add permanent one
    this.connections = this.connections.filter((c) => !c.temp);
    this.connections.push(newConnection);

    // Remove the "new" flag after animation
    setTimeout(() => {
      newConnection.isNew = false;
    }, 1000);

    this.tempConnection = null;
  },

  updateConnections() {
    this.connections = this.connections.map((conn) => {
      if (conn.temp) return conn;

      if (conn.fromNodeId && conn.toNodeId) {
        return {
          ...conn,
          from: this.getPortCenter(conn.fromNodeId, "output"),
          to: this.getPortCenter(conn.toNodeId, "input"),
        };
      }
      return conn;
    });
  },

  renderTemp() {
    this.connections = this.connections.filter((c) => !c.temp);

    if (this.tempConnection) {
      this.connections.push({
        ...this.tempConnection,
        id: "temp",
        temp: true,
      });
    }
  },
}));

let Hooks = {};

Hooks.SearchLoader = {
  mounted() {
    this.el.addEventListener("input", () => {
      window.dispatchEvent(new CustomEvent("loading:start"));
    });

    this.handleEvent("search_done", () => {
      window.dispatchEvent(new CustomEvent("loading:stop"));
    });
  },
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
