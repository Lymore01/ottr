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
    debugMode: true,

    debug(message, data = null) {
      if (this.debugMode) {
        console.log(`[WORKFLOW DEBUG] ${message}`, data || '');
      }
    },

    initPanzoom(container) {
      this.debug("Initializing panzoom", { container });
      
      try {
        this.panzoomInstance = panzoom(container, {
          contain: "outside",
          maxScale: 2,
          minScale: 0.5,
          panOnlyWhenZoomed: false,
          smoothScroll: false,
          startScale: 1,
          cursor: 'grab',
          disablePan: false,
          disableZoom: false,
          excludeClass: 'workflow-node'
        });

        this.debug("Panzoom instance created", this.panzoomInstance);

        // Test panzoom methods
        this.debug("Testing panzoom methods", {
          getTransform: typeof this.panzoomInstance.getTransform,
          pan: typeof this.panzoomInstance.pan,
          zoom: typeof this.panzoomInstance.zoom,
          pause: typeof this.panzoomInstance.pause,
          resume: typeof this.panzoomInstance.resume
        });

        // Wheel event for zoom and pan
        container.addEventListener("wheel", (event) => {
          this.debug("Wheel event", {
            deltaX: event.deltaX,
            deltaY: event.deltaY,
            ctrlKey: event.ctrlKey,
            metaKey: event.metaKey
          });

          if (event.ctrlKey || event.metaKey) {
            this.debug("Zooming with wheel");
            event.preventDefault();
            this.panzoomInstance.zoomWithWheel(event);
          } else {
            this.debug("Panning with wheel");
            event.preventDefault();
            try {
              this.panzoomInstance.pan(
                -event.deltaX * 0.5, 
                -event.deltaY * 0.5, 
                { relative: true }
              );
            } catch (error) {
              this.debug("Pan error", error);
            }
          }
        }, { passive: false });

        // Test manual pan
        setTimeout(() => {
          this.debug("Testing manual pan");
          try {
            this.panzoomInstance.pan(10, 10, { relative: true });
            this.debug("Manual pan successful");
          } catch (error) {
            this.debug("Manual pan failed", error);
          }
        }, 1000);

      } catch (error) {
        this.debug("Panzoom initialization error", error);
      }
    },

    init() {
      this.debug("Playground initialized with nodes", this.nodes);
      this.$watch("connections", (value) => {
        this.debug("Connections changed", value);
        this.renderConnections();
      });

      // Add global event listeners for debugging
      document.addEventListener('mousedown', (e) => {
        this.debug("Global mousedown", {
          target: e.target.className,
          clientX: e.clientX,
          clientY: e.clientY
        });
      });

      document.addEventListener('mousemove', (e) => {
        if (this.dragging) {
          this.debug("Global mousemove during drag", {
            clientX: e.clientX,
            clientY: e.clientY,
            activeNode: this.activeNode?.id
          });
        }
      });
    },

    createCurvedPath(from, to) {
      const dx = to.x - from.x;
      const dy = to.y - from.y;
      const curvature = Math.min(Math.abs(dx) * 0.5, 150);
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
        this.debug("SVG ref not found!");
        return;
      }

      this.debug("Rendering connections", this.connections.length);

      const existingElements = svg.querySelectorAll(
        "path.connection, path.connection-hit, circle.flow-dot"
      );
      existingElements.forEach((element) => element.remove());

      this.connections.forEach((conn, index) => {
        const color = this.getConnectionColor(conn);
        const strokeWidth = this.getStrokeWidth(conn);
        const markerUrl = this.getMarkerUrl(conn);

        const path = document.createElementNS("http://www.w3.org/2000/svg", "path");
        const pathData = this.createCurvedPath(conn.from, conn.to);

        path.setAttribute("d", pathData);
        path.setAttribute("stroke", color);
        path.setAttribute("stroke-width", strokeWidth);
        path.setAttribute("fill", "none");
        path.setAttribute("marker-end", markerUrl);
        path.setAttribute("class", "connection");
        path.id = `path-${conn.id || index}`;
        path.style.transition = "all 0.3s ease";

        svg.appendChild(path);

        if (!conn.temp && conn.active) {
          this.addFlowAnimation(path);
        }
      });
    },

    addFlowAnimation(path) {
      // Flow animation code remains the same
      const circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
      circle.setAttribute("r", "3");
      circle.setAttribute("fill", "#60a5fa");
      circle.setAttribute("class", "flow-dot");

      const animateMotion = document.createElementNS("http://www.w3.org/2000/svg", "animateMotion");
      animateMotion.setAttribute("dur", "2s");
      animateMotion.setAttribute("repeatCount", "indefinite");

      const mpath = document.createElementNS("http://www.w3.org/2000/svg", "mpath");
      mpath.setAttributeNS("http://www.w3.org/1999/xlink", "href", "#" + path.id);

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
      const position = node?.position || { x: 0, y: 0 };
      this.debug(`Node ${nodeId} position`, position);
      return position;
    },

    startDrag(nodeId, event) {
      this.debug("startDrag called", { nodeId, event: event.type });
      
      const node = this.nodes.find((n) => n.id === nodeId);
      if (!node) {
        this.debug("Node not found", nodeId);
        return;
      }

      this.debug("Starting drag", {
        node: node.id,
        currentPosition: node.position,
        mouseX: event.clientX,
        mouseY: event.clientY
      });

      // Stop event propagation
      event.stopPropagation();
      event.preventDefault();

      this.activeNode = node;
      this.dragging = true;

      if (!this.panzoomInstance) {
        this.debug("Panzoom instance not found!");
        return;
      }

      try {
        const transform = this.panzoomInstance.getTransform();
        this.debug("Current transform", transform);

        const rect = event.currentTarget.getBoundingClientRect();
        const container = this.panzoomInstance.getContainer().getBoundingClientRect();
        
        this.debug("Rectangles", { rect, container });

        this.offset = {
          x: (event.clientX - container.left - transform.x) / transform.scale - node.position.x,
          y: (event.clientY - container.top - transform.y) / transform.scale - node.position.y
        };

        this.debug("Calculated offset", this.offset);

        this.panzoomInstance.pause();
        document.body.style.cursor = 'grabbing';
        
        this.debug("Drag started successfully");
      } catch (error) {
        this.debug("Error in startDrag", error);
      }
    },

    onDrag(event) {
      if (!this.dragging || !this.activeNode) {
        return;
      }

      this.debug("onDrag", {
        dragging: this.dragging,
        activeNode: this.activeNode?.id,
        mouseX: event.clientX,
        mouseY: event.clientY
      });

      event.preventDefault();
      const node = this.nodes.find((n) => n.id === this.activeNode.id);
      if (!node) {
        this.debug("Active node not found during drag");
        return;
      }

      try {
        const transform = this.panzoomInstance.getTransform();
        const container = this.panzoomInstance.getContainer().getBoundingClientRect();
        
        const newX = (event.clientX - container.left - transform.x) / transform.scale - this.offset.x;
        const newY = (event.clientY - container.top - transform.y) / transform.scale - this.offset.y;
        
        this.debug("New position calculated", { newX, newY });
        
        node.position.x = newX;
        node.position.y = newY;

        this.debug("Node position updated", node.position);
        this.updateConnections();
      } catch (error) {
        this.debug("Error in onDrag", error);
      }
    },

    stopDrag() {
      this.debug("stopDrag called", {
        wasDragging: this.dragging,
        activeNode: this.activeNode?.id
      });

      if (this.dragging) {
        this.dragging = false;
        this.activeNode = null;
        
        if (this.panzoomInstance) {
          try {
            this.panzoomInstance.resume();
            this.debug("Panzoom resumed");
          } catch (error) {
            this.debug("Error resuming panzoom", error);
          }
        }
        
        document.body.style.cursor = 'default';
        this.debug("Drag stopped successfully");
      }
    },

    getPortCenter(nodeId, type) {
      const el = document.querySelector(`[data-node-id="${nodeId}"][data-port-type="${type}"]`);

      if (!el) {
        this.debug(`Port not found for node ${nodeId}, type ${type}`);
        return { x: 0, y: 0 };
      }

      const rect = el.getBoundingClientRect();
      
      if (!this.panzoomInstance) {
        this.debug("Panzoom instance not available for port calculation");
        return {
          x: rect.left + rect.width / 2,
          y: rect.top + rect.height / 2
        };
      }

      try {
        const container = this.panzoomInstance.getContainer();
        const containerRect = container.getBoundingClientRect();
        const transform = this.panzoomInstance.getTransform();

        const result = {
          x: (rect.left + rect.width / 2 - containerRect.left - transform.x) / transform.scale,
          y: (rect.top + rect.height / 2 - containerRect.top - transform.y) / transform.scale
        };

        this.debug(`Port center for ${nodeId}:${type}`, result);
        return result;
      } catch (error) {
        this.debug("Error calculating port center", error);
        return { x: 0, y: 0 };
      }
    },

    startConnection(fromNodeId, portType) {
      this.debug("Starting connection", { fromNodeId, portType });
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

        try {
          const container = this.panzoomInstance.getContainer();
          const containerRect = container.getBoundingClientRect();
          const transform = this.panzoomInstance.getTransform();

          this.tempConnection.to = {
            x: (e.clientX - containerRect.left - transform.x) / transform.scale,
            y: (e.clientY - containerRect.top - transform.y) / transform.scale
          };
          this.renderTemp();
        } catch (error) {
          this.debug("Error in connection move handler", error);
        }
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
      this.debug("Completing connection", { toNodeId, portType });
      if (portType !== "input" || !this.tempConnection) {
        this.debug("Connection not completed - invalid port or no temp connection");
        return;
      }

      const fromNodeId = this.tempConnection.fromNodeId;
      const from = this.getPortCenter(fromNodeId, "output");
      const to = this.getPortCenter(toNodeId, "input");

      const duplicate = this.connections.some(
        (c) => c.toNodeId === toNodeId && c.fromNodeId === fromNodeId
      );

      if (duplicate) {
        this.debug("Duplicate connection detected");
        return;
      }

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
      this.debug("Connection created", newConnection);

      this.tempConnection = null;
    },

    updateConnections() {
      this.debug("Updating connections");
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