import React from "react";
import { notFound } from "next/navigation";
import { getProductCategories, getCategoryBySlug, getProductsByCategory } from "@/lib/data";
import { ProductCard } from "@/components/ProductCard";
import Link from "next/link";
import { Metadata } from "next";

interface CategoryPageProps {
  params: Promise<{ slug: string }>;
}

export const revalidate = 0;
export const dynamicParams = true;

export async function generateStaticParams() {
  const categories = await getProductCategories();
  return categories.map((cat) => ({
    slug: cat.slug,
  }));
}

export async function generateMetadata({ params }: CategoryPageProps): Promise<Metadata> {
  const { slug } = await params;
  const category = await getCategoryBySlug(slug);
  if (!category) return {};

  return {
    title: `${category.name} - Worldwide Oilfield Machine (WOM)`,
    description: category.description || `Browse WOM's ${category.name} pressure control solutions.`,
  };
}

export default async function CategoryPage({ params }: CategoryPageProps) {
  const { slug } = await params;
  const category = await getCategoryBySlug(slug);

  if (!category) {
    notFound();
  }

  const products = await getProductsByCategory(slug);
  const allCategories = (await getProductCategories()).filter((c) => c.count > 0);

  return (
    <div className="py-12 bg-gray-50 min-h-screen">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Breadcrumb */}
        <div className="text-xs text-gray-500 mb-4">
          <Link href="/" className="hover:text-wom-orange">
            Home
          </Link>{" "}
          /{" "}
          <Link href="/products" className="hover:text-wom-orange">
            Products
          </Link>{" "}
          / <span className="text-gray-900 font-semibold">{category.name}</span>
        </div>

        <div className="mb-10">
          <h1 className="text-4xl font-black text-gray-900 mb-3">{category.name}</h1>
          {category.description ? (
            <p className="text-gray-600 max-w-3xl leading-relaxed">{category.description}</p>
          ) : (
            <p className="text-gray-600 max-w-3xl leading-relaxed">
              Explore our industry-tested {category.name} manufactured for severe oilfield service.
            </p>
          )}
        </div>

        {/* Categories Pills */}
        <div className="mb-10 flex flex-wrap gap-2">
          <Link
            href="/products"
            className="px-4 py-2 rounded-full text-xs font-semibold bg-white hover:bg-orange-50 text-gray-700 hover:text-wom-orange border border-gray-200 transition shadow-sm"
          >
            All Products
          </Link>
          {allCategories.map((cat) => {
            const isActive = cat.slug === slug;
            return (
              <Link
                key={cat.id}
                href={`/products/category/${cat.slug}`}
                className={`px-4 py-2 rounded-full text-xs font-semibold border transition shadow-sm ${
                  isActive
                    ? "bg-wom-orange text-white border-wom-orange font-bold"
                    : "bg-white hover:bg-orange-50 text-gray-700 hover:text-wom-orange border-gray-200"
                }`}
              >
                {cat.name} ({cat.count})
              </Link>
            );
          })}
        </div>

        {/* Product Grid */}
        {products.length > 0 ? (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {products.map((product) => (
              <ProductCard key={product.id} product={product} />
            ))}
          </div>
        ) : (
          <div className="bg-white border border-gray-200 rounded-xl p-12 text-center text-gray-500">
            No products found directly categorized under this category.
          </div>
        )}
      </div>
    </div>
  );
}
