import React from "react";
import { getProducts, getProductCategories } from "@/lib/data";
import { ProductCard } from "@/components/ProductCard";
import Link from "next/link";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "All Products - Worldwide Oilfield Machine (WOM)",
  description: "Explore the comprehensive range of WOM surface and subsea pressure control equipment, gate valves, ball valves, BOPs, and flow control systems.",
};

export default function ProductsPage() {
  const products = getProducts();
  const categories = getProductCategories().filter(c => c.count > 0);

  return (
    <div className="py-12 bg-gray-50 min-h-screen">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Breadcrumb & Header */}
        <div className="mb-10">
          <div className="text-xs text-gray-500 mb-2">
            <Link href="/" className="hover:text-wom-orange">Home</Link> / <span className="text-gray-900 font-semibold">Products</span>
          </div>
          <h1 className="text-4xl font-black text-gray-900 mb-4">
            WOM Equipment & Product Catalog
          </h1>
          <p className="text-gray-600 max-w-3xl leading-relaxed">
            All WOM products meet or exceed ISO and API performance standards. Complete vertical integration, combined with advanced in-house machining and testing, ensures peak field reliability.
          </p>
        </div>

        {/* Category Filter Pills */}
        <div className="mb-10 flex flex-wrap gap-2">
          <Link
            href="/products"
            className="px-4 py-2 rounded-full text-xs font-bold bg-wom-orange text-white shadow-sm"
          >
            All ({products.length})
          </Link>
          {categories.map(cat => (
            <Link
              key={cat.id}
              href={`/products/category/${cat.slug}`}
              className="px-4 py-2 rounded-full text-xs font-semibold bg-white hover:bg-orange-50 text-gray-700 hover:text-wom-orange border border-gray-200 transition shadow-sm"
            >
              {cat.name} ({cat.count})
            </Link>
          ))}
        </div>

        {/* Products Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {products.map(product => (
            <ProductCard key={product.id} product={product} />
          ))}
        </div>
      </div>
    </div>
  );
}
