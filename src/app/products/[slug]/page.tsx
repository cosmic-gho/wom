import React from "react";
import { notFound } from "next/navigation";
import { getProducts, getProductBySlug } from "@/lib/data";
import Link from "next/link";
import { Metadata } from "next";
import { ShieldCheck, FileText, Phone, Mail, ArrowLeft, CheckCircle2 } from "lucide-react";

interface ProductPageProps {
  params: Promise<{ slug: string }>;
}

export async function generateStaticParams() {
  const products = getProducts();
  return products.map((product) => ({
    slug: product.slug,
  }));
}

export async function generateMetadata({ params }: ProductPageProps): Promise<Metadata> {
  const { slug } = await params;
  const product = getProductBySlug(slug);
  if (!product) return {};

  return {
    title: product.seo.title || `${product.title} - Worldwide Oilfield Machine`,
    description: product.seo.description || product.excerpt || `Technical specifications for ${product.title}`,
    openGraph: product.seo.ogImage ? { images: [product.seo.ogImage] } : undefined,
  };
}

export default async function ProductDetailPage({ params }: ProductPageProps) {
  const { slug } = await params;
  const product = getProductBySlug(slug);

  if (!product) {
    notFound();
  }

  const primaryCategory = product.categories[0];

  return (
    <div className="py-12 bg-white min-h-screen">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Navigation back and breadcrumbs */}
        <div className="mb-8 flex items-center justify-between">
          <Link
            href="/products"
            className="inline-flex items-center gap-1.5 text-xs font-semibold text-gray-500 hover:text-wom-orange transition"
          >
            <ArrowLeft className="w-4 h-4" />
            Back to Products
          </Link>
          <div className="text-xs text-gray-400">
            {primaryCategory && (
              <Link
                href={`/products/category/${primaryCategory.slug}`}
                className="hover:underline"
              >
                {primaryCategory.name}
              </Link>
            )}
          </div>
        </div>

        {/* Product Hero Layout */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 mb-16">
          {/* Product Image */}
          <div className="lg:col-span-5">
            <div className="bg-gray-50 border border-gray-200 rounded-2xl p-8 flex items-center justify-center min-h-[380px] relative shadow-sm">
              {product.featuredImage ? (
                <img
                  src={product.featuredImage.url}
                  alt={product.title}
                  className="max-h-[320px] max-w-full object-contain"
                />
              ) : (
                <div className="text-center text-gray-400">
                  <ShieldCheck className="w-16 h-16 text-wom-orange mx-auto mb-2" />
                  <span className="text-sm font-semibold uppercase">WOM Engineered</span>
                </div>
              )}
            </div>
          </div>

          {/* Product Info & Inquire Box */}
          <div className="lg:col-span-7 flex flex-col justify-between">
            <div className="space-y-4">
              {primaryCategory && (
                <span className="inline-block bg-orange-100 text-wom-orange text-xs font-bold uppercase tracking-wider px-3 py-1 rounded-full">
                  {primaryCategory.name}
                </span>
              )}
              <h1 className="text-3xl sm:text-4xl font-black text-gray-900 leading-tight">
                {product.title}
              </h1>

              {product.excerpt && (
                <p className="text-base text-gray-600 leading-relaxed font-light">
                  {product.excerpt}
                </p>
              )}

              {/* Standard Highlights */}
              <div className="pt-4 border-t border-gray-100 grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs text-gray-700">
                <div className="flex items-center gap-2">
                  <CheckCircle2 className="w-4 h-4 text-wom-orange shrink-0" />
                  <span>API Specification Compliant</span>
                </div>
                <div className="flex items-center gap-2">
                  <CheckCircle2 className="w-4 h-4 text-wom-orange shrink-0" />
                  <span>100% In-house Quality Tested</span>
                </div>
                <div className="flex items-center gap-2">
                  <CheckCircle2 className="w-4 h-4 text-wom-orange shrink-0" />
                  <span>Available with Bi-Directional Dual Seal</span>
                </div>
                <div className="flex items-center gap-2">
                  <CheckCircle2 className="w-4 h-4 text-wom-orange shrink-0" />
                  <span>Custom Metallurgies Available</span>
                </div>
              </div>
            </div>

            {/* Inquire Card */}
            <div className="mt-8 bg-gray-50 border border-gray-200 rounded-xl p-6">
              <h3 className="font-bold text-gray-900 text-sm mb-2">
                Need Technical Drawings or Pricing for this Product?
              </h3>
              <p className="text-xs text-gray-500 mb-4">
                Speak directly with WOM application engineering specialists in Houston, Dubai, Aberdeen, or Singapore.
              </p>
              <div className="flex flex-wrap gap-3">
                <Link
                  href="/contact-us"
                  className="bg-wom-orange hover:bg-wom-orangeHover text-white px-6 py-2.5 rounded-full text-xs font-bold transition shadow"
                >
                  Request Technical Quotation
                </Link>
                <a
                  href="tel:+13213959915"
                  className="border border-gray-300 hover:border-gray-400 text-gray-700 px-5 py-2.5 rounded-full text-xs font-semibold transition"
                >
                  Call +1 321 395 9915
                </a>
              </div>
            </div>
          </div>
        </div>

        {/* Detailed Technical Content / Specifications */}
        {product.contentHtml && (
          <div className="border-t border-gray-200 pt-12">
            <h2 className="text-2xl font-bold text-gray-900 mb-6">
              Detailed Specifications & Operational Features
            </h2>
            <div
              className="wp-content-render max-w-none prose prose-orange"
              dangerouslySetInnerHTML={{ __html: product.contentHtml }}
            />
          </div>
        )}
      </div>
    </div>
  );
}
