import React from "react";
import { getPageBySlug } from "@/lib/data";
import Link from "next/link";
import { Metadata } from "next";
import { ShieldCheck } from "lucide-react";

export const metadata: Metadata = {
  title: "Patents & Intellectual Property - Worldwide Oilfield Machine (WOM)",
  description: "Comprehensive listing of WOM granted and pending patents in valve systems, compact cutting devices, dual seals, and deepwater riser intervention.",
};

export const revalidate = 0;

export default async function PatentsPage() {
  const page = await getPageBySlug("patents");

  return (
    <div className="py-12 bg-white min-h-screen">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-xs text-gray-500 mb-4">
          <Link href="/" className="hover:text-wom-orange">Home</Link> / <span>About Us</span> / <span className="text-gray-900 font-semibold">Patents</span>
        </div>

        <div className="mb-8">
          <div className="inline-flex items-center gap-2 bg-orange-100 text-wom-orange text-xs font-bold uppercase tracking-wider px-3 py-1 rounded-full mb-3">
            <ShieldCheck className="w-4 h-4" />
            Proprietary Technology
          </div>
          <h1 className="text-4xl font-black text-gray-900 mb-3">
            {page?.title || "Patents & Trademarks"}
          </h1>
          <p className="text-gray-600 leading-relaxed">
            WOM has continuously pushed the frontiers of high-pressure sealing and intervention engineering, earning dozens of registered international patents.
          </p>
        </div>

        {page?.contentHtml && (
          <div
            className="wp-content-render prose prose-orange max-w-none pt-4 border-t border-gray-100"
            dangerouslySetInnerHTML={{ __html: page.contentHtml }}
          />
        )}
      </div>
    </div>
  );
}
