import React from "react";
import { getNews } from "@/lib/data";
import Link from "next/link";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Latest News & Technical Articles - Worldwide Oilfield Machine (WOM)",
  description: "Stay updated with company announcements, engineering breakthroughs, industry exhibitions, and field milestones from Worldwide Oilfield Machine.",
};

export const revalidate = 0;

export default async function NewsPage() {
  const news = await getNews();

  return (
    <div className="py-12 bg-gray-50 min-h-screen">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="mb-12">
          <div className="text-xs text-gray-500 mb-2">
            <Link href="/" className="hover:text-wom-orange">Home</Link> / <span className="text-gray-900 font-semibold">News & Events</span>
          </div>
          <h1 className="text-4xl font-black text-gray-900 mb-4">
            News, Articles & Milestone Updates
          </h1>
          <p className="text-gray-600 max-w-3xl leading-relaxed">
            Discover the latest news on product launches, deepwater projects, international exhibitions, and technology milestones from WOM worldwide.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {news.map((item) => (
            <article
              key={item.id}
              className="bg-white border border-gray-200 rounded-2xl overflow-hidden hover:shadow-xl transition-all flex flex-col justify-between"
            >
              {item.featuredImage && (
                <div className="h-52 bg-gray-100 overflow-hidden relative">
                  <img
                    src={item.featuredImage.url}
                    alt={item.title}
                    className="w-full h-full object-cover hover:scale-105 transition-transform duration-300"
                  />
                  {item.categories[0] && (
                    <span className="absolute top-3 left-3 bg-white/90 backdrop-blur-sm text-gray-800 text-[10px] font-bold uppercase tracking-wider px-2.5 py-1 rounded shadow-sm">
                      {item.categories[0]}
                    </span>
                  )}
                </div>
              )}

              <div className="p-6 flex flex-col flex-1 justify-between">
                <div>
                  <div className="text-xs text-gray-400 font-medium mb-2">
                    {new Date(item.date).toLocaleDateString("en-US", {
                      year: "numeric",
                      month: "long",
                      day: "numeric",
                    })}
                  </div>
                  <h3 className="font-bold text-gray-900 text-lg mb-3 line-clamp-2">
                    {item.title}
                  </h3>
                  {item.excerpt && (
                    <p className="text-xs text-gray-500 line-clamp-3 mb-4 leading-relaxed">
                      {item.excerpt}
                    </p>
                  )}
                </div>

                <div className="pt-4 border-t border-gray-100 flex items-center justify-between">
                  <Link
                    href={`/news/${item.slug}`}
                    className="text-xs font-bold text-wom-orange hover:underline inline-flex items-center gap-1"
                  >
                    Read Full Story &rarr;
                  </Link>
                </div>
              </div>
            </article>
          ))}
        </div>
      </div>
    </div>
  );
}
