'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import {
    Package,
    FolderTree,
    Newspaper,
    MapPin,
    FileText,
    TrendingUp,
    Clock,
    Plus,
    ArrowUpRight,
    Edit3,
    ShieldCheck,
    CheckCircle2,
    RefreshCw,
    Loader2
} from 'lucide-react';

export default function AdminDashboardPage() {
    const [stats, setStats] = useState({
        products: 0,
        categories: 0,
        news: 0,
        locations: 0,
        resources: 0,
        pages: 0,
    });
    const [recentItems, setRecentItems] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);

    const fetchDashboardData = async () => {
        setLoading(true);
        try {
            const [prodRes, catRes, newsRes, locRes, resRes, pageRes] = await Promise.all([
                fetch('/api/admin/content?type=products'),
                fetch('/api/admin/content?type=categories'),
                fetch('/api/admin/content?type=news'),
                fetch('/api/admin/content?type=locations'),
                fetch('/api/admin/content?type=resources'),
                fetch('/api/admin/content?type=pages'),
            ]);

            const [prods, cats, news, locs, res, pages] = await Promise.all([
                prodRes.json(),
                catRes.json(),
                newsRes.json(),
                locRes.json(),
                resRes.json(),
                pageRes.json(),
            ]);

            setStats({
                products: prods.count || 0,
                categories: cats.count || 0,
                news: news.count || 0,
                locations: locs.count || 0,
                resources: res.count || 0,
                pages: pages.count || 0,
            });

            // Combine recent products and news for quick activity feed
            const recentProds = (prods.data || []).slice(0, 5).map((item: any) => ({ ...item, type: 'Product' }));
            const recentNews = (news.data || []).slice(0, 5).map((item: any) => ({ ...item, type: 'News Article' }));

            const combined = [...recentProds, ...recentNews].sort((a, b) => {
                return new Date(b.modified || b.date || 0).getTime() - new Date(a.modified || a.date || 0).getTime();
            }).slice(0, 7);

            setRecentItems(combined);
        } catch (error) {
            console.error('Failed to load dashboard stats:', error);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchDashboardData();
    }, []);

    const statCards = [
        { label: 'Products', count: stats.products, icon: Package, href: '/admin/products', color: 'from-blue-600 to-indigo-600' },
        { label: 'Categories', count: stats.categories, icon: FolderTree, href: '/admin/categories', color: 'from-cyan-600 to-blue-600' },
        { label: 'News Articles', count: stats.news, icon: Newspaper, href: '/admin/news', color: 'from-purple-600 to-indigo-600' },
        { label: 'Global Locations', count: stats.locations, icon: MapPin, href: '/admin/locations', color: 'from-emerald-600 to-teal-600' },
        { label: 'Resources', count: stats.resources, icon: FileText, href: '/admin/resources', color: 'from-amber-600 to-orange-600' },
    ];

    return (
        <div className="space-y-8">
            {/* Welcome Banner */}
            <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-blue-900 via-indigo-900 to-slate-900 p-6 sm:p-8 border border-blue-800/40 shadow-xl">
                <div className="absolute right-0 top-0 translate-x-12 -translate-y-12 w-64 h-64 bg-blue-500/10 rounded-full blur-3xl pointer-events-none" />

                <div className="relative z-10 flex flex-col sm:flex-row sm:items-center justify-between gap-6">
                    <div>
                        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-500/20 border border-blue-400/30 text-blue-300 text-xs font-semibold mb-3">
                            <ShieldCheck className="h-3.5 w-3.5 text-blue-400" />
                            <span>Enterprise Content Control Center</span>
                        </div>
                        <h1 className="text-2xl sm:text-3xl font-black text-white tracking-tight">
                            Welcome back, Super Admin!
                        </h1>
                        <p className="mt-1 text-sm text-slate-300 max-w-xl">
                            Manage equipment products, global news announcements, operational facility locations, and site resources in real-time.
                        </p>
                    </div>

                    <div className="flex items-center gap-3">
                        <button
                            onClick={fetchDashboardData}
                            disabled={loading}
                            className="flex items-center gap-2 px-4 py-2 bg-slate-800/80 hover:bg-slate-800 text-slate-200 border border-slate-700 rounded-xl text-xs font-semibold transition-all cursor-pointer"
                        >
                            <RefreshCw className={`h-3.5 w-3.5 ${loading ? 'animate-spin' : ''}`} />
                            <span>Refresh</span>
                        </button>
                        <Link
                            href="/admin/products/new"
                            className="flex items-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-500 text-white rounded-xl text-xs font-semibold shadow-lg shadow-blue-600/30 transition-all"
                        >
                            <Plus className="h-4 w-4" />
                            <span>Add Product</span>
                        </Link>
                    </div>
                </div>
            </div>

            {/* Metrics Grid */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
                {statCards.map((card) => {
                    const Icon = card.icon;
                    return (
                        <Link
                            key={card.label}
                            href={card.href}
                            className="group bg-slate-900 border border-slate-800 hover:border-slate-700 p-5 rounded-2xl shadow-lg transition-all duration-200 hover:-translate-y-1 relative overflow-hidden"
                        >
                            <div className="flex items-center justify-between mb-4">
                                <div className={`p-2.5 rounded-xl bg-gradient-to-br ${card.color} text-white shadow-md`}>
                                    <Icon className="h-5 w-5" />
                                </div>
                                <ArrowUpRight className="h-4 w-4 text-slate-600 group-hover:text-blue-400 transition-colors" />
                            </div>

                            <div>
                                <p className="text-2xl font-black text-white tracking-tight">
                                    {loading ? <Loader2 className="h-6 w-6 animate-spin text-slate-600" /> : card.count}
                                </p>
                                <p className="text-xs font-medium text-slate-400 mt-1">{card.label}</p>
                            </div>
                        </Link>
                    );
                })}
            </div>

            {/* Main Content & Recent Activity Grid */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                {/* Recent Items Table (2 cols) */}
                <div className="lg:col-span-2 bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-4">
                    <div className="flex items-center justify-between">
                        <div>
                            <h2 className="text-base font-bold text-white flex items-center gap-2">
                                <Clock className="h-4 w-4 text-blue-400" />
                                <span>Recent Content Updates</span>
                            </h2>
                            <p className="text-xs text-slate-400">Latest modified items across products and news</p>
                        </div>
                        <Link
                            href="/admin/products"
                            className="text-xs font-semibold text-blue-400 hover:text-blue-300 transition-colors"
                        >
                            View All Products &rarr;
                        </Link>
                    </div>

                    <div className="overflow-x-auto">
                        <table className="w-full text-left border-collapse text-xs">
                            <thead>
                                <tr className="border-b border-slate-800 text-slate-400 font-semibold uppercase text-[10px] tracking-wider">
                                    <th className="py-3 px-3">Title</th>
                                    <th className="py-3 px-3">Type</th>
                                    <th className="py-3 px-3">Slug</th>
                                    <th className="py-3 px-3 text-right">Action</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-slate-800/60">
                                {recentItems.length > 0 ? (
                                    recentItems.map((item) => (
                                        <tr key={item.id} className="hover:bg-slate-800/40 transition-colors">
                                            <td className="py-3 px-3 font-semibold text-slate-200 max-w-xs truncate">
                                                {item.title}
                                            </td>
                                            <td className="py-3 px-3">
                                                <span className={`px-2 py-0.5 rounded-md text-[10px] font-bold ${item.type === 'Product'
                                                        ? 'bg-blue-950 text-blue-400 border border-blue-800/40'
                                                        : 'bg-purple-950 text-purple-400 border border-purple-800/40'
                                                    }`}>
                                                    {item.type}
                                                </span>
                                            </td>
                                            <td className="py-3 px-3 text-slate-500 font-mono text-[11px] truncate max-w-xs">
                                                {item.slug}
                                            </td>
                                            <td className="py-3 px-3 text-right">
                                                <Link
                                                    href={item.type === 'Product' ? `/admin/products/${item.id}` : `/admin/news/${item.id}`}
                                                    className="inline-flex items-center gap-1 text-xs text-blue-400 hover:text-blue-300 font-medium"
                                                >
                                                    <Edit3 className="h-3 w-3" />
                                                    <span>Edit</span>
                                                </Link>
                                            </td>
                                        </tr>
                                    ))
                                ) : (
                                    <tr>
                                        <td colSpan={4} className="py-8 text-center text-slate-500">
                                            {loading ? 'Loading content...' : 'No recent items found.'}
                                        </td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>

                {/* Side Panel: System Status & Quick Links */}
                <div className="space-y-6">
                    {/* System Health */}
                    <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-4">
                        <h3 className="text-sm font-bold text-white flex items-center gap-2">
                            <CheckCircle2 className="h-4 w-4 text-emerald-400" />
                            <span>System & Data Integrity</span>
                        </h3>

                        <div className="space-y-3 text-xs">
                            <div className="flex items-center justify-between p-3 rounded-xl bg-slate-950 border border-slate-800">
                                <span className="text-slate-300 font-medium">JSON File Storage</span>
                                <span className="text-emerald-400 font-semibold flex items-center gap-1">
                                    <span className="h-2 w-2 rounded-full bg-emerald-400 animate-pulse"></span>
                                    Active
                                </span>
                            </div>
                            <div className="flex items-center justify-between p-3 rounded-xl bg-slate-950 border border-slate-800">
                                <span className="text-slate-300 font-medium">API Route Sync</span>
                                <span className="text-emerald-400 font-semibold">Online</span>
                            </div>
                            <div className="flex items-center justify-between p-3 rounded-xl bg-slate-950 border border-slate-800">
                                <span className="text-slate-300 font-medium">Next.js App Directory</span>
                                <span className="text-blue-400 font-semibold">v15.1 Ready</span>
                            </div>
                        </div>
                    </div>

                    {/* Quick Shortcuts */}
                    <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-3">
                        <h3 className="text-sm font-bold text-white mb-2">Management Shortcuts</h3>
                        <Link
                            href="/admin/products/new"
                            className="w-full flex items-center justify-between p-3 rounded-xl bg-slate-950 border border-slate-800 hover:border-slate-700 text-slate-200 hover:text-white transition-all text-xs font-semibold"
                        >
                            <div className="flex items-center gap-2.5">
                                <Package className="h-4 w-4 text-blue-400" />
                                <span>Create New Product</span>
                            </div>
                            <Plus className="h-4 w-4 text-slate-500" />
                        </Link>
                        <Link
                            href="/admin/categories"
                            className="w-full flex items-center justify-between p-3 rounded-xl bg-slate-950 border border-slate-800 hover:border-slate-700 text-slate-200 hover:text-white transition-all text-xs font-semibold"
                        >
                            <div className="flex items-center gap-2.5">
                                <FolderTree className="h-4 w-4 text-cyan-400" />
                                <span>Manage Product Categories</span>
                            </div>
                            <ArrowUpRight className="h-4 w-4 text-slate-500" />
                        </Link>
                        <Link
                            href="/admin/news/new"
                            className="w-full flex items-center justify-between p-3 rounded-xl bg-slate-950 border border-slate-800 hover:border-slate-700 text-slate-200 hover:text-white transition-all text-xs font-semibold"
                        >
                            <div className="flex items-center gap-2.5">
                                <Newspaper className="h-4 w-4 text-purple-400" />
                                <span>Publish News Release</span>
                            </div>
                            <Plus className="h-4 w-4 text-slate-500" />
                        </Link>
                    </div>
                </div>
            </div>
        </div>
    );
}
