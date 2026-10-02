import React from "react";
import { notFound } from "next/navigation";
import { getNews, getNewsBySlug } from "@/lib/data";
import Link from "next/link";
import { Metadata } from "next";
import { ArrowLeft, Calendar, Tag } from "lucide-react";

interface NewsPageProps {
  params: Promise<{ slug: string }>;
}

export const revalidate = 0;
export const dynamicParams = true;

export async function generateStaticParams() {
  const news = await getNews();
  return news.map((item) => ({
    slug: item.slug,
  }));
}

export async function generateMetadata({ params }: NewsPageProps): Promise<Metadata> {
  const { slug } = await params;
  const item = await getNewsBySlug(slug);
  if (!item) return {};

  return {
    title: `${item.title} - Worldwide Oilfield Machine`,
    description: item.seo.description || item.excerpt || item.title,
  };
}

export default async function NewsDetailPage({ params }: NewsPageProps) {
  const { slug } = await params;
  const item = await getNewsBySlug(slug);

  if (!item) {
    notFound();
  }

  return (
    <article className="py-12 bg-white min-h-screen">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <Link
          href="/news"
          className="inline-flex items-center gap-1.5 text-xs font-semibold text-gray-500 hover:text-wom-orange mb-8 transition"
        >
          <ArrowLeft className="w-4 h-4" />
          Back to News
        </Link>

        <header className="space-y-4 mb-8">
          <div className="flex items-center gap-4 text-xs text-gray-500">
            <span className="flex items-center gap-1">
              <Calendar className="w-3.5 h-3.5 text-wom-orange" />
              {new Date(item.date).toLocaleDateString("en-US", {
                year: "numeric",
                month: "long",
                day: "numeric",
              })}
            </span>
            {item.categories[0] && (
              <span className="flex items-center gap-1 bg-orange-50 text-wom-orange px-2 py-0.5 rounded font-semibold">
                <Tag className="w-3 h-3" />
                {item.categories[0]}
              </span>
            )}
          </div>

          <h1 className="text-3xl sm:text-4xl font-black text-gray-900 leading-tight">
            {item.title}
          </h1>
        </header>

        {item.featuredImage && (
          <div className="mb-10 rounded-2xl overflow-hidden shadow-sm">
            <img
              src={item.featuredImage.url}
              alt={item.title}
              className="w-full max-h-[460px] object-cover"
            />
          </div>
        )}

        <div
          className="wp-content-render prose prose-orange max-w-none pt-4 border-t border-gray-100"
          dangerouslySetInnerHTML={{ __html: item.contentHtml }}
        />
      </div>
    </article>
  );
}
