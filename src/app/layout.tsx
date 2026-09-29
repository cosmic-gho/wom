import type { Metadata } from "next";
import "./globals.css";
import { Header } from "@/components/Header";
import { Footer } from "@/components/Footer";

export const metadata: Metadata = {
  title: "Worldwide Oilfield Machine (WOM) - Oilfield Equipment Supplier",
  description:
    "Worldwide Oilfield Machine (WOM) is a globally recognized manufacturer of pressure control and oilfield equipment for surface and subsea applications worldwide.",
  metadataBase: new URL("https://womgroup.com"),
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="min-h-screen flex flex-col antialiased">
        <Header />
        <main className="flex-1">{children}</main>
        <Footer />
      </body>
    </html>
  );
}
