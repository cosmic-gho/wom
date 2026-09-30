'use client';

import React, { useState, useEffect } from 'react';
import { usePathname, useRouter } from 'next/navigation';
import { Search, Plus, Globe, Sparkles, X, ChevronRight, Package, Newspaper, MapPin } from 'lucide-react';
import Link from 'next/link';

export default function AdminHeader() {
    const pathname = usePathname();
    const router = useRouter();
    const [searchQuery, setSearchQuery] = useState('');
    const [searchResults, setSearchResults] = useState<any[]>([]);
    const [isSearching, setIsSearching] = useState(false);
    const [showQuickMenu, setShowQuickMenu] = useState(false);

    // Simple title generator
    const getPageTitle = () => {
        if (pathname === '/admin') return 'Dashboard Overview';
        if (pathname.startsWith('/admin/products')) return 'Products Management';
        if (pathname.startsWith('/admin/categories')) return 'Product Categories';
        if (pathname.startsWith('/admin/news')) return 'News & Media';
        if (pathname.startsWith('/admin/locations')) return 'Global Locations';
        if (pathname.startsWith('/admin/resources')) return 'Resources & Downloads';
        if (pathname.startsWith('/admin/pages')) return 'Site Pages Copy & SEO';
        return 'Admin Control Center';
    };

    useEffect(() => {
        if (!searchQuery.trim()) {
            setSearchResults([]);
            setIsSearching(false);
            return;
        }

        const timer = setTimeout(async () => {
            setIsSearching(true);
            try {
                const res = await fetch(`/api/admin/content?type=products&search=${encodeURIComponent(searchQuery)}&limit=5`);
                const json = await res.json();
                if (json.success) {
                    setSearchResults(json.data);
                }
            } catch (e) {
                console.error('Search error:', e);
            } finally {
                setIsSearching(false);
            }
        }, 300);

        return () => clearTimeout(timer);
    }, [searchQuery]);

    return (
        <header className="h-16 bg-slate-900/90 backdrop-blur-md border-b border-slate-800 px-6 flex items-center justify-between sticky top-0 z-30 shadow-sm">
            {/* Page Title & Breadcrumbs */}
            <div>
                <h1 className="text-lg font-bold text-white tracking-tight flex items-center gap-2">
                    {getPageTitle()}
                </h1>
                <div className="flex items-center gap-1.5 text-xs text-slate-400">
                    <span>Admin</span>
                    <ChevronRight className="h-3 w-3 text-slate-600" />
                    <span className="text-blue-400 font-medium capitalize">
                        {pathname.split('/')[2] || 'Dashboard'}
                    </span>
                </div>
            </div>

            {/* Center Search & Quick Actions */}
            <div className="flex items-center gap-4">
                {/* Search Bar */}
                <div className="relative w-72">
                    <div className="relative">
                        <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-500" />
                        <input
                            type="text"
                            placeholder="Quick search products, news..."
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                            className="w-full pl-9 pr-8 py-1.5 bg-slate-950/60 border border-slate-800 rounded-lg text-xs text-slate-200 placeholder-slate-500 focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all"
                        />
                        {searchQuery && (
                            <button
                                onClick={() => setSearchQuery('')}
                                className="absolute right-2 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-300"
                            >
                                <X className="h-3.5 w-3.5" />
                            </button>
                        )}
                    </div>

                    {/* Search Dropdown Results */}
                    {searchQuery && (
                        <div className="absolute top-full left-0 right-0 mt-2 bg-slate-900 border border-slate-800 rounded-xl shadow-2xl overflow-hidden z-50">
                            <div className="p-2 border-b border-slate-800 text-[11px] font-semibold text-slate-400 flex justify-between items-center">
                                <span>Search Results</span>
                                {isSearching && <span className="text-blue-400 animate-pulse">Searching...</span>}
                            </div>

                            {searchResults.length > 0 ? (
                                <div className="max-h-60 overflow-y-auto divide-y divide-slate-800/50">
                                    {searchResults.map((item) => (
                                        <Link
                                            key={item.id}
                                            href={`/admin/products/${item.id}`}
                                            onClick={() => setSearchQuery('')}
                                            className="p-2.5 hover:bg-slate-800/80 flex items-center justify-between group transition-colors"
                                        >
                                            <div className="truncate pr-2">
                                                <p className="text-xs font-medium text-slate-200 group-hover:text-blue-400 truncate">
                                                    {item.title}
                                                </p>
                                                <p className="text-[10px] text-slate-500 truncate">{item.slug}</p>
                                            </div>
                                            <ChevronRight className="h-3.5 w-3.5 text-slate-600 group-hover:text-blue-400 shrink-0" />
                                        </Link>
                                    ))}
                                </div>
                            ) : (
                                !isSearching && (
                                    <div className="p-4 text-center text-xs text-slate-500">No matching items found</div>
                                )
                            )}
                        </div>
                    )}
                </div>

                {/* Quick Add Dropdown */}
                <div className="relative">
                    <button
                        onClick={() => setShowQuickMenu(!showQuickMenu)}
                        className="flex items-center gap-1.5 px-3 py-1.5 bg-blue-600 hover:bg-blue-500 text-white rounded-lg text-xs font-semibold shadow-lg shadow-blue-600/20 transition-all duration-150"
                    >
                        <Plus className="h-4 w-4" />
                        <span>Create New</span>
                    </button>

                    {showQuickMenu && (
                        <div className="absolute right-0 mt-2 w-48 bg-slate-900 border border-slate-800 rounded-xl shadow-2xl p-1 z-50 animate-in fade-in zoom-in-95 duration-100">
                            <Link
                                href="/admin/products/new"
                                onClick={() => setShowQuickMenu(false)}
                                className="flex items-center gap-2.5 px-3 py-2 text-xs font-medium text-slate-300 hover:text-white hover:bg-slate-800 rounded-lg transition-colors"
                            >
                                <Package className="h-4 w-4 text-blue-400" />
                                <span>New Product</span>
                            </Link>
                            <Link
                                href="/admin/news/new"
                                onClick={() => setShowQuickMenu(false)}
                                className="flex items-center gap-2.5 px-3 py-2 text-xs font-medium text-slate-300 hover:text-white hover:bg-slate-800 rounded-lg transition-colors"
                            >
                                <Newspaper className="h-4 w-4 text-purple-400" />
                                <span>New Article</span>
                            </Link>
                            <Link
                                href="/admin/locations/new"
                                onClick={() => setShowQuickMenu(false)}
                                className="flex items-center gap-2.5 px-3 py-2 text-xs font-medium text-slate-300 hover:text-white hover:bg-slate-800 rounded-lg transition-colors"
                            >
                                <MapPin className="h-4 w-4 text-emerald-400" />
                                <span>New Location</span>
                            </Link>
                        </div>
                    )}
                </div>

                {/* Live Site Badge */}
                <a
                    href="/"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="flex items-center gap-1.5 px-3 py-1.5 bg-slate-950/80 border border-slate-800 hover:border-slate-700 text-slate-300 rounded-lg text-xs font-medium transition-colors"
                >
                    <span className="relative flex h-2 w-2">
                        <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                        <span className="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
                    </span>
                    <Globe className="h-3.5 w-3.5 text-slate-400" />
                    <span className="hidden sm:inline">Live Site</span>
                </a>
            </div>
        </header>
    );
}
