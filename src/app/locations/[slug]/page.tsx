import React from "react";
import { notFound } from "next/navigation";
import { getLocations, getLocationBySlug } from "@/lib/data";
import Link from "next/link";
import { Metadata } from "next";
import { ArrowLeft, MapPin, Phone, Mail, Building2 } from "lucide-react";

interface LocationPageProps {
  params: Promise<{ slug: string }>;
}

export async function generateStaticParams() {
  const locations = getLocations();
  return locations.map((loc) => ({
    slug: loc.slug,
  }));
}

export async function generateMetadata({ params }: LocationPageProps): Promise<Metadata> {
  const { slug } = await params;
  const location = getLocationBySlug(slug);
  if (!location) return {};

  return {
    title: `${location.title} - Worldwide Oilfield Machine`,
    description: location.seo.description || location.excerpt || `Information about WOM facility: ${location.title}`,
  };
}

export default async function LocationDetailPage({ params }: LocationPageProps) {
  const { slug } = await params;
  const location = getLocationBySlug(slug);

  if (!location) {
    notFound();
  }

  return (
    <div className="py-12 bg-white min-h-screen">
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <Link
          href="/locations"
          className="inline-flex items-center gap-1.5 text-xs font-semibold text-gray-500 hover:text-wom-orange mb-8 transition"
        >
          <ArrowLeft className="w-4 h-4" />
          Back to All Locations
        </Link>

        <div className="space-y-4 mb-8">
          {location.regions[0] && (
            <span className="inline-block bg-orange-100 text-wom-orange text-xs font-bold uppercase tracking-wider px-3 py-1 rounded-full">
              {location.regions[0]}
            </span>
          )}
          <h1 className="text-4xl font-black text-gray-900">{location.title}</h1>
        </div>

        {location.featuredImage && (
          <div className="mb-10 rounded-2xl overflow-hidden shadow-sm max-h-[480px]">
            <img
              src={location.featuredImage.url}
              alt={location.title}
              className="w-full h-full object-cover"
            />
          </div>
        )}

        <div className="border-t border-gray-100 pt-8">
          <div
            className="wp-content-render prose prose-orange max-w-none"
            dangerouslySetInnerHTML={{ __html: location.contentHtml }}
          />
        </div>

        {/* Contact Facility CTA */}
        <div className="mt-12 bg-gray-50 border border-gray-200 rounded-2xl p-8 flex flex-col sm:flex-row justify-between items-center gap-6">
          <div>
            <h3 className="text-lg font-bold text-gray-900">
              Need to coordinate with this facility?
            </h3>
            <p className="text-xs text-gray-500 mt-1">
              Contact our global operations team to route your inquiry directly.
            </p>
          </div>
          <Link
            href="/contact-us"
            className="bg-wom-orange hover:bg-wom-orangeHover text-white px-6 py-2.5 rounded-full text-xs font-bold transition shadow shrink-0"
          >
            Send Inquiry
          </Link>
        </div>
      </div>
    </div>
  );
}
