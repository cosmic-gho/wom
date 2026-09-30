'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import {
    Package,
    Search,
    Plus,
    Edit3,
    Trash2,
    ExternalLink,
    Filter,
    ChevronLeft,
    ChevronRight,
    Loader2,
    AlertTriangle,
    Image as ImageIcon
} from 'lucide-react';

export default function AdminProductsPage() {
    const [products, setProducts] = useState<any[]>([]);
    const [categories, setCategories] = useState<any[]>([]);
    const [search, setSearch] = useState('');
    const [selectedCategory, setSelectedCategory] = useState('');
    const [loading, setLoading] = useState(true);
    const [currentPage, setCurrentPage] = useState(1);
    const pageSize = 15;

    const [deleteModalItem, setDeleteModalItem] = useState<any | null>(null);
    const [isDeleting, setIsDeleting] = useState(false);

    const fetchData = async () => {
        setLoading(true);
        try {
            const [prodRes, catRes] = await Promise.all([
                fetch('/api/admin/content?type=products'),
                fetch('/api/admin/content?type=categories'),
            ]);
            const prodJson = await prodRes.json();
            const catJson = await catRes.json();

            if (prodJson.success) setProducts(prodJson.data || []);
            if (catJson.success) setCategories(catJson.data || []);
        } catch (err) {
            console.error('Error fetching products:', err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchData();
    }, []);

    // Filter products by search and category
    const filteredProducts = products.filter((p) => {
        const matchesSearch =
            !search.trim() ||
            p.title?.toLowerCase().includes(search.toLowerCase()) ||
            p.slug?.toLowerCase().includes(search.toLowerCase());

        const matchesCategory =
            !selectedCategory ||
            p.categories?.some((c: any) => c.slug === selectedCategory || c.id === Number(selectedCategory));

        return matchesSearch && matchesCategory;
    });

    // Pagination calculation
    const totalPages = Math.ceil(filteredProducts.length / pageSize) || 1;
    const paginatedProducts = filteredProducts.slice(
        (currentPage - 1) * pageSize,
        currentPage * pageSize
    );

    const handleDelete = async () => {
        if (!deleteModalItem) return;
        setIsDeleting(true);
        try {
            const res = await fetch(`/api/admin/content?type=products&id=${deleteModalItem.id}`, {
                method: 'DELETE',
            });
            const data = await res.json();
            if (data.success) {
                setProducts(products.filter((p) => p.id !== deleteModalItem.id));
                setDeleteModalItem(null);
            } else {
                alert(data.error || 'Failed to delete product');
            }
        } catch (err) {
            console.error('Delete error:', err);
        } finally {
            setIsDeleting(false);
        }
    };

    return (
        <div className="space-y-6">
            {/* Header Bar */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h1 className="text-xl font-bold text-white flex items-center gap-2">
                        <Package className="h-5 w-5 text-blue-400" />
                        <span>Products Catalog Manager</span>
                    </h1>
                    <p className="text-xs text-slate-400">
                        {filteredProducts.length} total equipment items found in database
                    </p>
                </div>

                <Link
                    href="/admin/products/new"
                    className="inline-flex items-center gap-2 px-4 py-2.5 bg-blue-600 hover:bg-blue-500 text-white rounded-xl text-xs font-semibold shadow-lg shadow-blue-600/30 transition-all cursor-pointer self-start sm:self-auto"
                >
                    <Plus className="h-4 w-4" />
                    <span>Add New Product</span>
                </Link>
            </div>

            {/* Filter & Search Bar */}
            <div className="bg-slate-900 border border-slate-800 rounded-2xl p-4 shadow-lg flex flex-col sm:flex-row items-center justify-between gap-4">
                {/* Search Input */}
                <div className="relative w-full sm:w-80">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-500" />
                    <input
                        type="text"
                        placeholder="Filter products by title or slug..."
                        value={search}
                        onChange={(e) => {
                            setSearch(e.target.value);
                            setCurrentPage(1);
                        }}
                        className="w-full pl-9 pr-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 placeholder-slate-500 focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all"
                    />
                </div>

                {/* Category Dropdown Filter */}
                <div className="flex items-center gap-2 w-full sm:w-auto">
                    <Filter className="h-4 w-4 text-slate-400 shrink-0" />
                    <select
                        value={selectedCategory}
                        onChange={(e) => {
                            setSelectedCategory(e.target.value);
                            setCurrentPage(1);
                        }}
                        className="w-full sm:w-64 py-2 px-3 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-blue-500 transition-all cursor-pointer"
                    >
                        <option value="">All Categories ({categories.length})</option>
                        {categories.map((cat) => (
                            <option key={cat.id} value={cat.slug || cat.id}>
                                {cat.name} ({cat.count || 0})
                            </option>
                        ))}
                    </select>
                </div>
            </div>

            {/* Table Card */}
            <div className="bg-slate-900 border border-slate-800 rounded-2xl shadow-xl overflow-hidden">
                <div className="overflow-x-auto">
                    <table className="w-full text-left border-collapse text-xs">
                        <thead>
                            <tr className="border-b border-slate-800 text-slate-400 font-semibold uppercase text-[10px] tracking-wider bg-slate-950/60">
                                <th className="py-3.5 px-4">Image</th>
                                <th className="py-3.5 px-4">Product Name &amp; Slug</th>
                                <th className="py-3.5 px-4">Categories</th>
                                <th className="py-3.5 px-4">Price</th>
                                <th className="py-3.5 px-4">SEO Status</th>
                                <th className="py-3.5 px-4 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-slate-800/60">
                            {loading ? (
                                <tr>
                                    <td colSpan={6} className="py-12 text-center text-slate-400">
                                        <Loader2 className="h-7 w-7 animate-spin text-blue-500 mx-auto mb-2" />
                                        <span>Loading products database...</span>
                                    </td>
                                </tr>
                            ) : paginatedProducts.length > 0 ? (
                                paginatedProducts.map((product) => (
                                    <tr key={product.id} className="hover:bg-slate-800/40 transition-colors group">
                                        {/* Thumbnail */}
                                        <td className="py-3 px-4">
                                            <div className="h-11 w-11 rounded-lg bg-slate-950 border border-slate-800 flex items-center justify-center overflow-hidden shrink-0">
                                                {product.featuredImage?.url ? (
                                                    <img
                                                        src={product.featuredImage.url}
                                                        alt={product.title}
                                                        className="h-full w-full object-cover"
                                                        onError={(e) => {
                                                            (e.target as HTMLElement).style.display = 'none';
                                                        }}
                                                    />
                                                ) : (
                                                    <ImageIcon className="h-5 w-5 text-slate-600" />
                                                )}
                                            </div>
                                        </td>

                                        {/* Title & Slug */}
                                        <td className="py-3 px-4 max-w-sm">
                                            <p className="font-bold text-slate-100 group-hover:text-blue-400 transition-colors truncate">
                                                {product.title}
                                            </p>
                                            <p className="text-[11px] text-slate-500 font-mono truncate">
                                                /products/{product.slug}
                                            </p>
                                        </td>

                                        {/* Categories Badges */}
                                        <td className="py-3 px-4">
                                            <div className="flex flex-wrap gap-1 max-w-xs">
                                                {product.categories && product.categories.length > 0 ? (
                                                    product.categories.slice(0, 2).map((c: any, i: number) => (
                                                        <span
                                                            key={i}
                                                            className="px-2 py-0.5 rounded-md text-[10px] font-medium bg-blue-950 text-blue-300 border border-blue-800/30 truncate max-w-[130px]"
                                                        >
                                                            {c.name || c.slug || `Cat #${c.id}`}
                                                        </span>
                                                    ))
                                                ) : (
                                                    <span className="text-slate-600 italic">Uncategorized</span>
                                                )}
                                                {product.categories?.length > 2 && (
                                                    <span className="text-[10px] text-slate-500 self-center">
                                                        +{product.categories.length - 2} more
                                                    </span>
                                                )}
                                            </div>
                                        </td>

                                        {/* Price Column */}
                                        <td className="py-3 px-4 font-mono font-semibold">
                                            {product.priceOnRequest || !product.price ? (
                                                <span className="text-amber-400 text-[11px] font-sans font-medium">Price on Request</span>
                                            ) : (
                                                <span className="text-emerald-400">
                                                    {product.currency === 'EUR' ? '€' : product.currency === 'GBP' ? '£' : '$'}
                                                    {Number(product.price).toLocaleString(undefined, { minimumFractionDigits: 2 })}
                                                </span>
                                            )}
                                        </td>

                                        {/* SEO Status */}
                                        <td className="py-3 px-4">
                                            {product.seo?.title && product.seo?.description ? (
                                                <span className="px-2 py-0.5 rounded-full text-[10px] font-semibold bg-emerald-950 text-emerald-400 border border-emerald-800/40">
                                                    Optimized
                                                </span>
                                            ) : (
                                                <span className="px-2 py-0.5 rounded-full text-[10px] font-semibold bg-slate-800 text-slate-400">
                                                    Basic
                                                </span>
                                            )}
                                        </td>

                                        {/* Actions */}
                                        <td className="py-3 px-4 text-right space-x-2">
                                            <a
                                                href={`/products/${product.slug}`}
                                                target="_blank"
                                                rel="noopener noreferrer"
                                                className="inline-flex items-center justify-center h-8 w-8 rounded-lg bg-slate-950 hover:bg-slate-800 text-slate-400 hover:text-white border border-slate-800 transition-colors"
                                                title="Preview Public Page"
                                            >
                                                <ExternalLink className="h-3.5 w-3.5" />
                                            </a>
                                            <Link
                                                href={`/admin/products/${product.id}`}
                                                className="inline-flex items-center justify-center h-8 w-8 rounded-lg bg-blue-600/10 hover:bg-blue-600/20 text-blue-400 border border-blue-500/20 transition-colors"
                                                title="Edit Product"
                                            >
                                                <Edit3 className="h-3.5 w-3.5" />
                                            </Link>
                                            <button
                                                onClick={() => setDeleteModalItem(product)}
                                                className="inline-flex items-center justify-center h-8 w-8 rounded-lg bg-red-600/10 hover:bg-red-600/20 text-red-400 border border-red-500/20 transition-colors cursor-pointer"
                                                title="Delete Product"
                                            >
                                                <Trash2 className="h-3.5 w-3.5" />
                                            </button>
                                        </td>
                                    </tr>
                                ))
                            ) : (
                                <tr>
                                    <td colSpan={5} className="py-12 text-center text-slate-500">
                                        No products match your search or filter criteria.
                                    </td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>

                {/* Pagination Bar */}
                {totalPages > 1 && (
                    <div className="p-4 border-t border-slate-800 flex items-center justify-between text-xs text-slate-400 bg-slate-950/40">
                        <div>
                            Showing page <span className="font-semibold text-white">{currentPage}</span> of{' '}
                            <span className="font-semibold text-white">{totalPages}</span>
                        </div>
                        <div className="flex items-center gap-2">
                            <button
                                disabled={currentPage === 1}
                                onClick={() => setCurrentPage((p) => Math.max(1, p - 1))}
                                className="flex items-center gap-1 px-3 py-1.5 bg-slate-900 border border-slate-800 rounded-lg text-slate-300 disabled:opacity-40 hover:bg-slate-800 transition-all cursor-pointer"
                            >
                                <ChevronLeft className="h-4 w-4" />
                                <span>Prev</span>
                            </button>
                            <button
                                disabled={currentPage === totalPages}
                                onClick={() => setCurrentPage((p) => Math.min(totalPages, p + 1))}
                                className="flex items-center gap-1 px-3 py-1.5 bg-slate-900 border border-slate-800 rounded-lg text-slate-300 disabled:opacity-40 hover:bg-slate-800 transition-all cursor-pointer"
                            >
                                <span>Next</span>
                                <ChevronRight className="h-4 w-4" />
                            </button>
                        </div>
                    </div>
                )}
            </div>

            {/* Delete Confirmation Modal */}
            {deleteModalItem && (
                <div className="fixed inset-0 bg-slate-950/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
                    <div className="bg-slate-900 border border-slate-800 rounded-2xl max-w-md w-full p-6 space-y-4 shadow-2xl animate-in fade-in zoom-in-95">
                        <div className="flex items-center gap-3 text-red-400">
                            <div className="h-10 w-10 rounded-full bg-red-950 border border-red-800 flex items-center justify-center">
                                <AlertTriangle className="h-5 w-5" />
                            </div>
                            <div>
                                <h3 className="text-base font-bold text-white">Delete Product</h3>
                                <p className="text-xs text-slate-400">This action cannot be undone.</p>
                            </div>
                        </div>

                        <p className="text-xs text-slate-300">
                            Are you sure you want to permanently delete{' '}
                            <span className="font-bold text-white">"{deleteModalItem.title}"</span>?
                        </p>

                        <div className="flex items-center justify-end gap-3 pt-2">
                            <button
                                onClick={() => setDeleteModalItem(null)}
                                className="px-4 py-2 rounded-xl text-xs font-semibold bg-slate-800 hover:bg-slate-700 text-slate-300 transition-colors"
                            >
                                Cancel
                            </button>
                            <button
                                onClick={handleDelete}
                                disabled={isDeleting}
                                className="px-4 py-2 rounded-xl text-xs font-semibold bg-red-600 hover:bg-red-500 text-white shadow-lg shadow-red-600/30 transition-colors flex items-center gap-2"
                            >
                                {isDeleting && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
                                <span>Delete Permanently</span>
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
