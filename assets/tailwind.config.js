const plugin = require("tailwindcss/plugin");
const defaultTheme = require("tailwindcss/defaultTheme");
const fs = require("fs");
const path = require("path");

module.exports = {
  content: ["./js/**/*.js", "../lib/ottr_web.ex", "../lib/ottr_web/**/*.*ex"],
  darkMode: "class",
  theme: {
    extend: {
      keyframes: {
        float: {
          "0%, 100%": { transform: "translateY(0)" },
          "50%": { transform: "translateY(-10px)" },
        },
        marquee: {
          "0%": { transform: "translateX(0%)" },
          "100%": { transform: "translateX(-50%)" },
        },
        "marquee-reverse": {
          "0%": { transform: "translateX(0%)" },
          "100%": { transform: "translateX(50%)" },
        },
        dash: {
          to: {
            strokeDashoffset: "-10",
          },
        },
        "pulse-connection": {
          "0%, 100%": { opacity: "1" },
          "50%": { opacity: "0.7" },
        },
        "loading-dash": {
          "0%": {
            strokeDasharray: "1,200",
            strokeDashoffset: "0",
          },
          "50%": {
            strokeDasharray: "89,200",
            strokeDashoffset: "-35px",
          },
          "100%": {
            strokeDasharray: "89,200",
            strokeDashoffset: "-124px",
          },
        },
      },
      animation: {
        "float-slow": "float 6s ease-in-out infinite",
        "float-medium": "float 4s ease-in-out infinite",
        "float-fast": "float 3s ease-in-out infinite",
        marquee: "marquee 25s linear infinite",
        "marquee-reverse": "marquee-reverse 30s linear infinite",
        dash: "dash 1s linear infinite",
        "pulse-connection": "pulse-connection 2s infinite",
        "loading-dash": "loading-dash 1.5s ease-in-out infinite",
      },
      colors: {
        brand: "var(--brand)",
        "brand-accent": "var(--brand-accent)",
        background: "var(--background)",
        foreground: "var(--foreground)",
        card: "var(--card)",
        "card-foreground": "var(--card-foreground)",
        popover: "var(--popover)",
        "popover-foreground": "var(--popover-foreground)",
        primary: "var(--primary)",
        "primary-foreground": "var(--primary-foreground)",
        secondary: "var(--secondary)",
        "secondary-foreground": "var(--secondary-foreground)",
        muted: "var(--muted)",
        "muted-foreground": "var(--muted-foreground)",
        accent: "var(--accent)",
        "accent-foreground": "var(--accent-foreground)",
        destructive: "var(--destructive)",
        border: "var(--border)",
        input: "var(--input)",
        ring: "var(--ring)",

        "chart-1": "var(--chart-1)",
        "chart-2": "var(--chart-2)",
        "chart-3": "var(--chart-3)",
        "chart-4": "var(--chart-4)",
        "chart-5": "var(--chart-5)",

        sidebar: "var(--sidebar)",
        "sidebar-foreground": "var(--sidebar-foreground)",
        "sidebar-primary": "var(--sidebar-primary)",
        "sidebar-primary-foreground": "var(--sidebar-primary-foreground)",
        "sidebar-accent": "var(--sidebar-accent)",
        "sidebar-accent-foreground": "var(--sidebar-accent-foreground)",
        "sidebar-border": "var(--sidebar-border)",
        "sidebar-ring": "var(--sidebar-ring)",
      },
      borderRadius: {
        sm: "calc(var(--radius) - 4px)",
        md: "calc(var(--radius) - 2px)",
        lg: "var(--radius)",
        xl: "calc(var(--radius) + 4px)",
      },
      fontFamily: {
        sans: ["var(--font-lexend)", ...defaultTheme.fontFamily.sans],
        lexend: ["var(--font-lexend)", ...defaultTheme.fontFamily.sans],
        inter: ["var(--font-inter)", ...defaultTheme.fontFamily.sans],
      },
      dropShadow: {
        'connection': '0 0 6px rgba(37, 99, 235, 0.4)',
        'connection-hover': '0 0 8px rgba(37, 99, 235, 0.6)',
        'flow': '0 0 3px rgba(96, 165, 250, 0.6)',
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        ".phx-click-loading&",
        ".phx-click-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        ".phx-submit-loading&",
        ".phx-submit-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        ".phx-change-loading&",
        ".phx-change-loading &",
      ])
    ),

    // Custom plugin for connection styles
    plugin(function({ addUtilities, addComponents }) {
      addUtilities({
        '.pointer-events-stroke': {
          'pointer-events': 'stroke',
        },
      });

      addComponents({
        '.connection-source': {
          'box-shadow': '0 0 0 2px #2563eb !important',
          'transform': 'scale(1.02)',
          'transition': 'all 0.2s ease',
        },
        '.connection-target': {
          'box-shadow': '0 0 0 2px #22c55e !important',
          'transform': 'scale(1.02)',
          'transition': 'all 0.2s ease',
        },
        '.connection-selected': {
          'stroke-width': '4 !important',
          'filter': 'drop-shadow(0 0 8px rgba(37, 99, 235, 0.6)) !important',
          'animation': 'pulse-connection 2s infinite',
        },
      });
    }),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    // plugin(function ({ matchComponents, theme }) {
    //   let iconsDir = path.join(__dirname, "../deps/heroicons/optimized");
    //   let values = {};
    //   let icons = [
    //     ["", "/24/outline"],
    //     ["-solid", "/24/solid"],
    //     ["-mini", "/20/solid"],
    //     ["-micro", "/16/solid"],
    //   ];
    //   icons.forEach(([suffix, dir]) => {
    //     fs.readdirSync(path.join(iconsDir, dir)).forEach((file) => {
    //       let name = path.basename(file, ".svg") + suffix;
    //       values[name] = { name, fullPath: path.join(iconsDir, dir, file) };
    //     });
    //   });
    //   matchComponents(
    //     {
    //       hero: ({ name, fullPath }) => {
    //         let content = fs
    //           .readFileSync(fullPath)
    //           .toString()
    //           .replace(/\r?\n|\r/g, "");
    //         let size = theme("spacing.6");
    //         if (name.endsWith("-mini")) {
    //           size = theme("spacing.5");
    //         } else if (name.endsWith("-micro")) {
    //           size = theme("spacing.4");
    //         }
    //         return {
    //           [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
    //           "-webkit-mask": `var(--hero-${name})`,
    //           mask: `var(--hero-${name})`,
    //           "mask-repeat": "no-repeat",
    //           "background-color": "currentColor",
    //           "vertical-align": "middle",
    //           display: "inline-block",
    //           width: size,
    //           height: size,
    //         };
    //       },
    //     },
    //     { values }
    //   )
    // })
  ],
};