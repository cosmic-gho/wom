import React from "react";
import { getPageBySlug } from "@/lib/data";
import Link from "next/link";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Our Story - Worldwide Oilfield Machine (WOM)",
  description: "Learn about the history, evolution, and founding vision of Worldwide Oilfield Machine since 1980.",
};

export const revalidate = 0;

export default async function OurStoryPage() {
  const page = await getPageBySlug("our-story");

  return (
    <div className="py-12 bg-white min-h-screen">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-xs text-gray-500 mb-4">
          <Link href="/" className="hover:text-wom-orange">Home</Link> / <span>About Us</span> / <span className="text-gray-900 font-semibold">Our Story</span>
        </div>

        <h1 className="text-4xl font-black text-gray-900 mb-6">
          {page?.title || "Our Story"}
        </h1>

        {page?.featuredImage && (
          <div className="mb-10 rounded-2xl overflow-hidden shadow-sm">
            <img
              src={page.featuredImage.url}
              alt={page.title}
              className="w-full max-h-[460px] object-cover"
            />
          </div>
        )}

        {page?.contentHtml ? (
          <div
            className="wp-content-render prose prose-orange max-w-none pt-4"
            dangerouslySetInnerHTML={{ __html: page.contentHtml }}
          />
        ) : (
          <p className="text-gray-600">Company history content loaded from database.</p>
        )}
      </div>
    </div>
  );
}
