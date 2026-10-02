import React from "react";
import Link from "next/link";
import { getProducts, getLocations, getNews, getProductCategories } from "@/lib/data";
import { ProductCard } from "@/components/ProductCard";
import { HeroSlider } from "@/components/HeroSlider";
import {
  ShieldCheck,
  Award,
  Globe,
  Settings,
  ArrowRight,
  CheckCircle2,
  Cpu,
  Layers,
  Factory
} from "lucide-react";

export const revalidate = 0;

export default async function HomePage() {
  const products = (await getProducts()).slice(0, 6);
  const categories = (await getProductCategories()).filter(c => c.count > 0).slice(0, 8);
  const locations = (await getLocations()).slice(0, 4);
  const news = (await getNews()).slice(0, 3);

  return (
    <div>
      {/* Hero Section with Background Image Slider */}
      <HeroSlider />

      {/* Value Pillars Section */}
      <section className="py-20 bg-gray-50 border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-2xl mx-auto mb-14">
            <h2 className="text-xs font-bold uppercase tracking-widest text-wom-orange mb-2">
              Why Worldwide Oilfield Machine
            </h2>
            <p className="text-3xl font-black text-gray-900">
              Complete Vertical Integration from Forging to Testing
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="bg-white p-8 rounded-2xl border border-gray-200 shadow-sm hover:shadow-md transition">
              <div className="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center text-wom-orange mb-6">
                <Factory className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-3">Internal Forging & Casting</h3>
              <p className="text-sm text-gray-600 leading-relaxed">
                With our dedicated facilities like Magnum Forge & Machine Works and Magna Casting, we control metallurgies and raw components from ingot to finished machining.
              </p>
            </div>

            <div className="bg-white p-8 rounded-2xl border border-gray-200 shadow-sm hover:shadow-md transition">
              <div className="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center text-wom-orange mb-6">
                <ShieldCheck className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-3">Patented Dual Seal Technology</h3>
              <p className="text-sm text-gray-600 leading-relaxed">
                WOM&apos;s proprietary bi-directional metal-to-metal sealing technology delivers extreme reliability across HPHT (high pressure, high temperature) applications.
              </p>
            </div>

            <div className="bg-white p-8 rounded-2xl border border-gray-200 shadow-sm hover:shadow-md transition">
              <div className="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center text-wom-orange mb-6">
                <Globe className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-3">Worldwide Service & Support</h3>
              <p className="text-sm text-gray-600 leading-relaxed">
                Strategically positioned engineering, repair, testing, and distribution centers across North America, Europe, the Middle East, India, and Southeast Asia.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Featured Products Section */}
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col md:flex-row md:items-end justify-between mb-12">
            <div>
              <h2 className="text-xs font-bold uppercase tracking-widest text-wom-orange mb-2">
                Engineered Excellence
              </h2>
              <p className="text-3xl font-black text-gray-900">
                Featured Pressure Control Equipment
              </p>
            </div>
            <Link
              href="/products"
              className="mt-4 md:mt-0 font-bold text-wom-orange hover:underline inline-flex items-center gap-1 text-sm"
            >
              Browse Full Catalog (96 Products) &rarr;
            </Link>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
            {products.map((product) => (
              <ProductCard key={product.id} product={product} />
            ))}
          </div>
        </div>
      </section>

      {/* Product Categories Quick Select */}
      <section className="py-16 bg-gray-50 border-t border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h3 className="text-xl font-bold text-gray-900 mb-8 text-center">
            Explore by Product Category
          </h3>
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
            {categories.map((cat) => (
              <Link
                key={cat.id}
                href={`/products/category/${cat.slug}`}
                className="bg-white hover:bg-orange-50 border border-gray-200 hover:border-wom-orange p-4 rounded-xl text-center transition group shadow-sm"
              >
                <div className="font-bold text-gray-800 group-hover:text-wom-orange text-sm mb-1">
                  {cat.name}
                </div>
                <div className="text-xs text-gray-500">
                  {cat.count} {cat.count === 1 ? "Product" : "Products"}
                </div>
              </Link>
            ))}
          </div>
        </div>
      </section>

      {/* Global Facilities Section */}
      <section className="py-20 bg-wom-dark text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col md:flex-row md:items-end justify-between mb-12">
            <div>
              <h2 className="text-xs font-bold uppercase tracking-widest text-wom-orange mb-2">
                Worldwide Network
              </h2>
              <p className="text-3xl font-black text-white">
                Global Manufacturing & Service Hubs
              </p>
            </div>
            <Link
              href="/locations"
              className="mt-4 md:mt-0 font-bold text-wom-orange hover:underline inline-flex items-center gap-1 text-sm"
            >
              View All 17 Facilities &rarr;
            </Link>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {locations.map((loc) => (
              <div
                key={loc.id}
                className="bg-white/5 border border-white/10 rounded-xl p-6 hover:bg-white/10 transition"
              >
                {loc.regions[0] && (
                  <span className="text-[11px] font-bold uppercase tracking-wider text-wom-orange bg-wom-orange/10 px-2 py-0.5 rounded">
                    {loc.regions[0]}
                  </span>
                )}
                <h4 className="font-bold text-lg text-white mt-3 mb-2">{loc.title}</h4>
                {loc.excerpt && (
                  <p className="text-xs text-gray-400 line-clamp-3 mb-4 leading-relaxed">
                    {loc.excerpt}
                  </p>
                )}
                <Link
                  href={`/locations/${loc.slug}`}
                  className="text-xs font-bold text-wom-orange hover:underline inline-flex items-center gap-1"
                >
                  Facility Details &rarr;
                </Link>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Latest News & Articles */}
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col md:flex-row md:items-end justify-between mb-12">
            <div>
              <h2 className="text-xs font-bold uppercase tracking-widest text-wom-orange mb-2">
                Updates & Milestones
              </h2>
              <p className="text-3xl font-black text-gray-900">
                Latest News & Technical Articles
              </p>
            </div>
            <Link
              href="/news"
              className="mt-4 md:mt-0 font-bold text-wom-orange hover:underline inline-flex items-center gap-1 text-sm"
            >
              Browse All News &rarr;
            </Link>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {news.map((item) => (
              <div
                key={item.id}
                className="bg-white border border-gray-200 rounded-xl overflow-hidden hover:shadow-lg transition flex flex-col justify-between"
              >
                {item.featuredImage && (
                  <div className="h-48 bg-gray-100 overflow-hidden">
                    <img
                      src={item.featuredImage.url}
                      alt={item.title}
                      className="w-full h-full object-cover hover:scale-105 transition duration-300"
                    />
                  </div>
                )}
                <div className="p-6 flex flex-col flex-1 justify-between">
                  <div>
                    <span className="text-xs text-gray-400 font-medium">
                      {new Date(item.date).toLocaleDateString("en-US", {
                        year: "numeric",
                        month: "long",
                        day: "numeric",
                      })}
                    </span>
                    <h4 className="font-bold text-gray-900 text-lg mt-2 mb-2 line-clamp-2">
                      {item.title}
                    </h4>
                    {item.excerpt && (
                      <p className="text-xs text-gray-500 line-clamp-3 leading-relaxed mb-4">
                        {item.excerpt}
                      </p>
                    )}
                  </div>
                  <Link
                    href={`/news/${item.slug}`}
                    className="text-xs font-bold text-wom-orange hover:underline inline-flex items-center gap-1"
                  >
                    Read Story &rarr;
                  </Link>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Call to Action Banner */}
      <section className="bg-wom-orange text-white py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center space-y-6">
          <h2 className="text-3xl sm:text-4xl font-black">
            Looking for Custom Engineered Pressure Control Solutions?
          </h2>
          <p className="max-w-2xl mx-auto text-orange-100 text-base sm:text-lg">
            Our global engineering teams collaborate closely with operators and drilling contractors to design, fabricate, and test equipment suited for extreme field conditions.
          </p>
          <div className="pt-2">
            <Link
              href="/contact-us"
              className="bg-wom-dark hover:bg-black text-white px-8 py-3.5 rounded-full font-bold transition shadow-lg"
            >
              Speak with a WOM Engineer
            </Link>
          </div>
        </div>
      </section>
    </div>
  );
}
