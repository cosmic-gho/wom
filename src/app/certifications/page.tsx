import React from "react";
import { getPageBySlug, getResources } from "@/lib/data";
import Link from "next/link";
import { Metadata } from "next";
import { Award, CheckCircle, FileText } from "lucide-react";

export const metadata: Metadata = {
  title: "Certifications & Quality Standards - Worldwide Oilfield Machine",
  description: "WOM certifications including API 6A, API 16A, API 17D, ISO 9001, ASME, and CE PED.",
};

export default function CertificationsPage() {
  const page = getPageBySlug("certifications");
  const certResources = getResources();

  return (
    <div className="py-12 bg-white min-h-screen">
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-xs text-gray-500 mb-4">
          <Link href="/" className="hover:text-wom-orange">Home</Link> / <span>About Us</span> / <span className="text-gray-900 font-semibold">Certifications</span>
        </div>

        <div className="mb-10">
          <div className="inline-flex items-center gap-2 bg-orange-100 text-wom-orange text-xs font-bold uppercase tracking-wider px-3 py-1 rounded-full mb-3">
            <Award className="w-4 h-4" />
            Global Quality Assurance
          </div>
          <h1 className="text-4xl font-black text-gray-900 mb-4">
            {page?.title || "Certifications & Quality Standards"}
          </h1>
          <p className="text-gray-600 leading-relaxed max-w-3xl">
            WOM maintains rigorous compliance with international oil and gas manufacturing benchmarks. All equipment undergoes stringent testing under certified quality management systems.
          </p>
        </div>

        {page?.contentHtml && (
          <div
            className="wp-content-render prose prose-orange max-w-none pt-4 mb-16 border-t border-gray-100"
            dangerouslySetInnerHTML={{ __html: page.contentHtml }}
          />
        )}

        {certResources.length > 0 && (
          <div className="border-t border-gray-200 pt-12">
            <h2 className="text-2xl font-bold text-gray-900 mb-6">
              Official Certificates & Regulatory Documents ({certResources.length})
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {certResources.map((res) => (
                <div
                  key={res.id}
                  className="bg-gray-50 border border-gray-200 rounded-xl p-5 hover:shadow-md transition flex flex-col justify-between"
                >
                  <div>
                    <FileText className="w-8 h-8 text-wom-orange mb-3" />
                    <h3 className="font-bold text-gray-900 text-sm mb-2">{res.title}</h3>
                    {res.excerpt && (
                      <p className="text-xs text-gray-500 line-clamp-2 mb-4">
                        {res.excerpt}
                      </p>
                    )}
                  </div>
                  {res.featuredImage && (
                    <a
                      href={res.featuredImage.url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-xs font-bold text-wom-orange hover:underline inline-flex items-center gap-1"
                    >
                      View Certificate Image &rarr;
                    </a>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
