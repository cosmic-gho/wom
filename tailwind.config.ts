import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
    "./content/**/*.{json,js,ts}",
  ],
  theme: {
    extend: {
      colors: {
        wom: {
          orange: "#ea7600",
          orangeHover: "#d46b00",
          orangeLight: "#fff7ed",
          dark: "#111827",
          darkNavy: "#0a1120",
          charcoal: "#1f2937",
          gray: "#4b5563",
          lightGray: "#f3f4f6",
          border: "#e5e7eb",
        }
      },
      fontFamily: {
        sans: ["var(--font-lato)", "sans-serif"],
      },
    },
  },
  plugins: [],
};
export default config;
