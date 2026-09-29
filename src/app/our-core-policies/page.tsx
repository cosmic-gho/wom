import React from "react";
import { getPageBySlug } from "@/lib/data";
import Link from "next/link";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Our Core Policies - Worldwide Oilfield Machine (WOM)",
  description: "Worldwide Oilfield Machine core quality, health, safety, and environmental policies.",
};

export default function CorePoliciesPage() {
  const page = getPageBySlug("our-core-policies");

  return (
    <div className="py-12 bg-white min-h-screen">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-xs text-gray-500 mb-4">
          <Link href="/" className="hover:text-wom-orange">Home</Link> / <span>About Us</span> / <span className="text-gray-900 font-semibold">Our Core Policies</span>
        </div>

        <h1 className="text-4xl font-black text-gray-900 mb-6">
          {page?.title || "Our Core Policies"}
        </h1>

        {page?.contentHtml && (
          <div
            className="wp-content-render prose prose-orange max-w-none pt-4"
            dangerouslySetInnerHTML={{ __html: page.contentHtml }}
          />
        )}
      </div>
    </div>
  );
}
