import Alpine from "alpinejs";
import panzoom from "@panzoom/panzoom";

const playground = () => {
  Alpine.data("workflowPlayground", (initialNodes) => ({
    nodes: initialNodes,
    connections: [],
    dragging: false,
    activeNode: null,
    offset: { x: 0, y: 0 },
    tempConnection: null,
    errorPorts: [],
    panzoomInstance: null,

    initPanzoom(container) {
      this.panzoomInstance = panzoom(container, {
        contain: "outside",
        maxScale: 2,
        minScale: 0.5,
        panOnlyWhenZoomed: false,
        smoothScroll: false,
        startScale: 1,
        cursor: "grab",
        disablePan: false,
        disableZoom: false,
        excludeClass: "workflow-node",
        beforeMouseDown: (e) => {
          const isDraggingNode = e.target.closest(".workflow-node");
          console.log(isDraggingNode)
          const ctrlPressed = e.ctrlKey || e.metaKey;

          if (!ctrlPressed || isDraggingNode) return false;
          return true;
        },
      });

      container.parentElement.addEventListener("wheel", (event) => {
        if (event.ctrlKey || event.metaKey) {
          event.preventDefault();
          const delta = event.deltaY < 0 ? 1.1 : 0.9;
          this.panzoomInstance.zoomWithWheel(event, delta);
        }
      });

      console.log(this.panzoomInstance);
    },

    init() {
      console.log("Playground initialized with nodes:", this.nodes);
      this.$watch("connections", (value) => {
        this.renderConnections();
      });
    },

    createCurvedPath(from, to) {
      const dx = to.x - from.x;
      const dy = to.y - from.y;

      const curvature = Math.min(Math.abs(dx) * 0.5, 150);

      // Horizontal curves
      const cp1x = from.x + curvature;
      const cp1y = from.y;
      const cp2x = to.x - curvature;
      const cp2y = to.y;

      return `M ${from.x} ${from.y} C ${cp1x} ${cp1y}, ${cp2x} ${cp2y}, ${to.x} ${to.y}`;
    },

    getConnectionColor(conn) {
      if (conn.temp) return "#94a3b8";
      if (conn.type === "error") return "#ef4444";
      if (conn.type === "success") return "#22c55e";
      if (conn.type === "data") return "#8b5cf6";
      return "#2563eb";
    },

    getMarkerUrl(conn) {
      if (conn.temp) return "url(#arrow-gray)";
      if (conn.type === "error") return "url(#arrow-red)";
      if (conn.type === "success") return "url(#arrow-green)";
      if (conn.type === "data") return "url(#arrow-purple)";
      return "url(#arrow)";
    },

    getStrokeWidth(conn) {
      if (conn.temp) return "2";
      if (conn.important) return "3";
      return "2";
    },

    renderConnections() {
      const svg = this.$refs.svg;
      if (!svg) {
        console.error("SVG ref not found!");
        return;
      }

      const existingElements = svg.querySelectorAll(
        "path.connection, path.connection-hit, circle.flow-dot"
      );
      existingElements.forEach((element) => element.remove());

      this.connections.forEach((conn, index) => {
        const color = this.getConnectionColor(conn);
        const strokeWidth = this.getStrokeWidth(conn);
        const markerUrl = this.getMarkerUrl(conn);

        const path = document.createElementNS(
          "http://www.w3.org/2000/svg",
          "path"
        );
        const pathData = this.createCurvedPath(conn.from, conn.to);

        path.setAttribute("d", pathData);
        path.setAttribute("stroke", color);
        path.setAttribute("stroke-width", strokeWidth);
        path.setAttribute("fill", "none");
        // path.setAttribute("marker-end", markerUrl);
        path.setAttribute("class", "connection");
        path.id = `path-${conn.id || index}`;

        path.style.transition = "all 0.3s ease";

        const hitPath = document.createElementNS(
          "http://www.w3.org/2000/svg",
          "path"
        );
        hitPath.setAttribute("d", pathData);
        hitPath.setAttribute("stroke", "transparent");
        hitPath.setAttribute("stroke-width", "12");
        hitPath.setAttribute("fill", "none");
        hitPath.setAttribute("class", "connection-hit");
        hitPath.style.cursor = "pointer";

        if (conn.active) {
          hitPath.style.pointerEvents = "auto";
          hitPath.addEventListener("mouseenter", () => {
            path.setAttribute(
              "stroke-width",
              (parseInt(strokeWidth) + 1).toString()
            );
            path.style.filter = "drop-shadow(0 0 4px rgba(37, 99, 235, 0.4))";
          });

          hitPath.addEventListener("mouseleave", () => {
            path.setAttribute("stroke-width", strokeWidth);
            path.style.filter = "none";
          });

          hitPath.addEventListener("click", (e) => {
            e.stopPropagation();
            this.selectConnection(conn);
          });
        }

        svg.appendChild(path);
        svg.appendChild(hitPath);

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
      mpath.setAttributeNS(
        "http://www.w3.org/1999/xlink",
        "href",
        "#" + path.id
      );

      animateMotion.appendChild(mpath);
      circle.appendChild(animateMotion);

      this.$refs.svg.appendChild(circle);
    },

    selectConnection(conn) {
      if (confirm("Delete this connection?")) {
        this.connections = this.connections.filter((c) => c.id !== conn.id);
      }
    },

    getNodePosition(nodeId) {
      const node = this.nodes.find((n) => n.id === nodeId);
      return node?.position || { x: 0, y: 0 };
    },

    startDrag(nodeId, event) {
      const node = this.nodes.find((n) => n.id === nodeId);
      if (!node) return;

      this.activeNode = node;
      this.dragging = true;
      this.offset = {
        x: event.clientX - node.position.x,
        y: event.clientY - node.position.y,
      };
    },

    onDrag(event) {
      if (!this.dragging || !this.activeNode) return;

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

      if (!el) {
        console.warn(`Port not found for node ${nodeId}, type ${type}`);
        return { x: 0, y: 0 };
      }

      const rect = el.getBoundingClientRect();
      const container =
        document.querySelector(".relative.w-full.h-full.overflow-hidden") ||
        document.querySelector('[x-data*="workflowPlayground"]');

      if (!container) {
        console.warn("Container not found, using document body");
        return {
          x: rect.left + rect.width / 2,
          y: rect.top + rect.height / 2,
        };
      }

      const containerRect = container.getBoundingClientRect();

      return {
        x: rect.left + rect.width / 2 - containerRect.left,
        y: rect.top + rect.height / 2 - containerRect.top,
      };
    },

    startConnection(fromNodeId, portType) {
      console.log("Starting connection from:", fromNodeId, "port:", portType);
      if (portType !== "output") return;

      const from = this.getPortCenter(fromNodeId, "output");
      console.log("From port center:", from);

      this.tempConnection = {
        fromNodeId: fromNodeId,
        from,
        to: { x: from.x, y: from.y },
        temp: true,
      };

      const moveHandler = (e) => {
        if (!this.tempConnection) return;

        const container =
          document.querySelector(".relative.w-full.h-full.overflow-hidden") ||
          document.querySelector('[x-data*="workflowPlayground"]');
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
      console.log(
        "Completing connection to node:",
        toNodeId,
        "port:",
        portType
      );
      if (portType !== "input" || !this.tempConnection) {
        console.log(
          "Connection not completed - invalid port or no temp connection"
        );
        return;
      }

      const fromNodeId = this.tempConnection.fromNodeId;
      const from = this.getPortCenter(fromNodeId, "output");
      const to = this.getPortCenter(toNodeId, "input");

      const duplicate = this.connections.some(
        (c) => c.toNodeId === toNodeId && c.fromNodeId === fromNodeId
      );

      if (duplicate) {
        console.log("Duplicate: Connection already exists!");

        this.errorPorts.push(
          { nodeId: fromNodeId, portType: "output" },
          { nodeId: toNodeId, portType: "input" }
        );

        setTimeout(() => {
          this.errorPorts = this.errorPorts.filter(
            (p) =>
              !(
                (p.nodeId === fromNodeId && p.portType === "output") ||
                (p.nodeId === toNodeId && p.portType === "input")
              )
          );
        }, 1500);

        return;
      }

      console.log("Connection points:", { from, to });

      const newConnection = {
        id: `conn-${Date.now()}`,
        fromNodeId: fromNodeId,
        toNodeId: toNodeId,
        from,
        to,
        type: "data",
        active: true,
        isNew: true,
      };

      this.connections = this.connections.filter((c) => !c.temp);
      this.connections.push(newConnection);

      console.log("Connection created:", newConnection);
      console.log("Total connections:", this.connections.length);

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
};

export default playground;
