import React from "react";
import { getLocations } from "@/lib/data";
import Link from "next/link";
import { MapPin, ArrowRight } from "lucide-react";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Global Locations & Facilities - Worldwide Oilfield Machine (WOM)",
  description: "Worldwide Oilfield Machine manufacturing facilities, engineering centers, and sales offices strategically located worldwide in USA, Scotland, UAE, India, and Singapore.",
};

export default function LocationsPage() {
  const locations = getLocations();

  return (
    <div className="py-12 bg-gray-50 min-h-screen">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="mb-12 text-center max-w-3xl mx-auto">
          <span className="text-xs font-bold uppercase tracking-widest text-wom-orange mb-2 block">
            Worldwide Network
          </span>
          <h1 className="text-4xl font-black text-gray-900 mb-4">
            Global Manufacturing & Engineering Facilities
          </h1>
          <p className="text-gray-600 leading-relaxed">
            With vertically integrated manufacturing plants, high-capacity forge and foundry operations, cleanrooms, and testing bays located across the world, WOM delivers local support backed by global scale.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {locations.map((loc) => (
            <div
              key={loc.id}
              className="bg-white border border-gray-200 rounded-2xl overflow-hidden hover:shadow-xl transition-all flex flex-col justify-between"
            >
              {loc.featuredImage ? (
                <div className="h-48 bg-gray-100 overflow-hidden relative">
                  <img
                    src={loc.featuredImage.url}
                    alt={loc.title}
                    className="w-full h-full object-cover"
                  />
                  {loc.regions[0] && (
                    <span className="absolute top-3 left-3 bg-wom-dark/80 backdrop-blur-sm text-white text-[10px] font-bold uppercase tracking-wider px-2.5 py-1 rounded">
                      {loc.regions[0]}
                    </span>
                  )}
                </div>
              ) : (
                <div className="h-48 bg-gradient-to-br from-wom-dark to-wom-charcoal flex items-center justify-center p-6 text-center text-white">
                  <MapPin className="w-10 h-10 text-wom-orange mb-2" />
                </div>
              )}

              <div className="p-6 flex flex-col flex-1 justify-between">
                <div>
                  <h3 className="font-bold text-gray-900 text-xl mb-2">{loc.title}</h3>
                  {loc.excerpt && (
                    <p className="text-xs text-gray-500 line-clamp-3 mb-4 leading-relaxed">
                      {loc.excerpt}
                    </p>
                  )}
                </div>

                <div className="pt-4 border-t border-gray-100 flex items-center justify-between">
                  <Link
                    href={`/locations/${loc.slug}`}
                    className="text-xs font-bold text-wom-orange hover:underline inline-flex items-center gap-1"
                  >
                    View Facility Profile &rarr;
                  </Link>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
