import React from "react";
import Link from "next/link";
import Image from "next/image";
import { Product } from "@/types/content";
import { ArrowRight, ShieldCheck } from "lucide-react";

interface ProductCardProps {
  product: Product;
}

export function ProductCard({ product }: ProductCardProps) {
  const imageUrl = product.featuredImage?.url || "/uploads/placeholder.jpg";
  const primaryCategory = product.categories[0]?.name;
  const productUrl = `/products/${product.slug}`;

  return (
    <div className="relative group flex flex-col bg-white border border-gray-200 rounded-xl overflow-hidden hover:shadow-xl hover:border-wom-orange/40 transition-all duration-300">
      {/* Image container */}
      <div className="relative h-52 bg-gray-50 flex items-center justify-center p-4 border-b border-gray-100 overflow-hidden">
        {product.featuredImage ? (
          <img
            src={imageUrl}
            alt={product.title}
            className="max-h-full max-w-full object-contain group-hover:scale-105 transition-transform duration-300"
            loading="lazy"
          />
        ) : (
          <div className="flex flex-col items-center justify-center text-gray-400">
            <ShieldCheck className="w-12 h-12 text-wom-orange/40 mb-1" />
            <span className="text-xs uppercase tracking-wider font-semibold">WOM Engineered</span>
          </div>
        )}

        {primaryCategory && (
          <span className="absolute top-3 left-3 bg-white/90 backdrop-blur-sm text-xs font-semibold px-2.5 py-1 rounded-full text-gray-700 shadow-sm border border-gray-100 z-20">
            {primaryCategory}
          </span>
        )}
      </div>

      {/* Card Body */}
      <div className="p-5 flex flex-col flex-1 justify-between">
        <div>
          <div className="flex items-center justify-between gap-2 mb-2">
            <h3 className="font-bold text-gray-900 group-hover:text-wom-orange transition text-lg line-clamp-2">
              {product.title}
            </h3>
          </div>

          <div className="mb-3">
            {product.price !== undefined && product.price !== null && !isNaN(Number(product.price)) && Number(product.price) > 0 ? (
              <span className="inline-block text-sm font-extrabold text-emerald-700 bg-emerald-50 border border-emerald-200 px-2.5 py-0.5 rounded">
                {product.currency === 'EUR' ? '€' : product.currency === 'GBP' ? '£' : product.currency === 'AED' ? 'AED ' : '$'}
                {Number(product.price).toLocaleString(undefined, { minimumFractionDigits: 2 })}
              </span>
            ) : (
              <span className="inline-block text-[11px] font-bold text-amber-700 bg-amber-50 border border-amber-200 px-2 py-0.5 rounded">
                Price on Request
              </span>
            )}
          </div>

          {product.excerpt && (
            <p className="text-xs text-gray-500 line-clamp-3 mb-4 leading-relaxed">
              {product.excerpt}
            </p>
          )}
        </div>

        {/* View Specifications button with direct z-20 link for touch devices */}
        <Link
          href={productUrl}
          className="relative z-20 pt-3 border-t border-gray-100 flex items-center justify-between text-xs font-bold text-wom-orange group-hover:translate-x-1 transition-transform cursor-pointer"
        >
          <span>View Specifications</span>
          <ArrowRight className="w-4 h-4" />
        </Link>
      </div>

      {/* Full card clickable overlay link */}
      <Link href={productUrl} className="absolute inset-0 z-10" aria-label={product.title} />
    </div>
  );
}
