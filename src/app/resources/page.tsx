import React from "react";
import { getResources } from "@/lib/data";
import Link from "next/link";
import { Metadata } from "next";
import { FileText, Download, ShieldCheck } from "lucide-react";

export const metadata: Metadata = {
  title: "Resource Library & Technical Documentation - Worldwide Oilfield Machine",
  description: "Download official technical certifications, product brochures, API licenses, and spec sheets.",
};

export default function ResourcesPage() {
  const resources = getResources();

  return (
    <div className="py-12 bg-gray-50 min-h-screen">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="mb-12">
          <div className="text-xs text-gray-500 mb-2">
            <Link href="/" className="hover:text-wom-orange">Home</Link> / <span className="text-gray-900 font-semibold">Resources</span>
          </div>
          <h1 className="text-4xl font-black text-gray-900 mb-4">
            Technical Resource Library
          </h1>
          <p className="text-gray-600 max-w-3xl leading-relaxed">
            Access official API Q1, 6A, 16A, 17D licenses, quality certificates, ISO accreditations, and technical product literature.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {resources.map((item) => (
            <div
              key={item.id}
              className="bg-white border border-gray-200 rounded-2xl p-6 shadow-sm hover:shadow-md transition flex flex-col justify-between"
            >
              <div>
                <div className="w-12 h-12 bg-orange-50 rounded-xl flex items-center justify-center text-wom-orange mb-4">
                  <FileText className="w-6 h-6" />
                </div>
                <h3 className="font-bold text-gray-900 text-lg mb-2">{item.title}</h3>
                {item.excerpt && (
                  <p className="text-xs text-gray-500 line-clamp-3 mb-4 leading-relaxed">
                    {item.excerpt}
                  </p>
                )}
              </div>

              {item.featuredImage && (
                <div className="pt-4 border-t border-gray-100 flex items-center justify-between">
                  <a
                    href={item.featuredImage.url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-xs font-bold text-wom-orange hover:underline inline-flex items-center gap-1.5"
                  >
                    <Download className="w-4 h-4" />
                    Download / View Document
                  </a>
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
