'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import {
    Newspaper,
    Search,
    Plus,
    Edit3,
    Trash2,
    ExternalLink,
    ChevronLeft,
    ChevronRight,
    Loader2,
    Calendar,
    AlertTriangle
} from 'lucide-react';

export default function AdminNewsPage() {
    const [news, setNews] = useState<any[]>([]);
    const [search, setSearch] = useState('');
    const [loading, setLoading] = useState(true);
    const [currentPage, setCurrentPage] = useState(1);
    const pageSize = 12;

    const [deleteModalItem, setDeleteModalItem] = useState<any | null>(null);
    const [isDeleting, setIsDeleting] = useState(false);

    const fetchNews = async () => {
        setLoading(true);
        try {
            const res = await fetch('/api/admin/content?type=news');
            const json = await res.json();
            if (json.success) setNews(json.data || []);
        } catch (err) {
            console.error('Error fetching news:', err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchNews();
    }, []);

    const filteredNews = news.filter((item) =>
        item.title?.toLowerCase().includes(search.toLowerCase()) ||
        item.slug?.toLowerCase().includes(search.toLowerCase())
    );

    const totalPages = Math.ceil(filteredNews.length / pageSize) || 1;
    const paginatedNews = filteredNews.slice(
        (currentPage - 1) * pageSize,
        currentPage * pageSize
    );

    const handleDelete = async () => {
        if (!deleteModalItem) return;
        setIsDeleting(true);
        try {
            const res = await fetch(`/api/admin/content?type=news&id=${deleteModalItem.id}`, {
                method: 'DELETE',
            });
            const data = await res.json();
            if (data.success) {
                setNews(news.filter((n) => n.id !== deleteModalItem.id));
                setDeleteModalItem(null);
            } else {
                alert(data.error || 'Failed to delete news article');
            }
        } catch (err) {
            console.error('Delete error:', err);
        } finally {
            setIsDeleting(false);
        }
    };

    return (
        <div className="space-y-6">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h1 className="text-xl font-bold text-white flex items-center gap-2">
                        <Newspaper className="h-5 w-5 text-purple-400" />
                        <span>News &amp; Media Announcements</span>
                    </h1>
                    <p className="text-xs text-slate-400">
                        {filteredNews.length} news releases and press articles published
                    </p>
                </div>

                <Link
                    href="/admin/news/new"
                    className="inline-flex items-center gap-2 px-4 py-2.5 bg-purple-600 hover:bg-purple-500 text-white rounded-xl text-xs font-semibold shadow-lg shadow-purple-600/30 transition-all cursor-pointer self-start sm:self-auto"
                >
                    <Plus className="h-4 w-4" />
                    <span>Publish News Article</span>
                </Link>
            </div>

            {/* Search Bar */}
            <div className="bg-slate-900 border border-slate-800 rounded-2xl p-4 shadow-lg">
                <div className="relative max-w-md">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-500" />
                    <input
                        type="text"
                        placeholder="Search news by title or slug..."
                        value={search}
                        onChange={(e) => {
                            setSearch(e.target.value);
                            setCurrentPage(1);
                        }}
                        className="w-full pl-9 pr-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 placeholder-slate-500 focus:outline-none focus:border-purple-500"
                    />
                </div>
            </div>

            {/* News Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                {loading ? (
                    <div className="col-span-full py-12 text-center text-slate-400">
                        <Loader2 className="h-7 w-7 animate-spin text-purple-500 mx-auto mb-2" />
                        <span>Loading news articles...</span>
                    </div>
                ) : paginatedNews.length > 0 ? (
                    paginatedNews.map((item) => (
                        <div
                            key={item.id}
                            className="bg-slate-900 border border-slate-800 hover:border-slate-700 rounded-2xl p-5 shadow-lg flex flex-col justify-between transition-all group"
                        >
                            <div className="space-y-3">
                                <div className="flex items-center justify-between text-xs text-slate-400">
                                    <div className="flex items-center gap-1 text-[11px] text-purple-400 font-semibold">
                                        <Calendar className="h-3 w-3" />
                                        <span>{item.date ? new Date(item.date).toLocaleDateString() : 'N/A'}</span>
                                    </div>
                                    <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-purple-950 text-purple-300 border border-purple-800/40">
                                        #{item.id}
                                    </span>
                                </div>

                                <h3 className="text-base font-bold text-white group-hover:text-purple-400 transition-colors line-clamp-2">
                                    {item.title}
                                </h3>

                                <p className="text-xs text-slate-400 line-clamp-3 leading-relaxed">
                                    {item.excerpt || item.contentHtml?.replace(/<[^>]+>/g, '').slice(0, 120)}
                                </p>
                            </div>

                            <div className="flex items-center justify-between pt-4 mt-4 border-t border-slate-800/80 text-xs">
                                <a
                                    href={`/news/${item.slug}`}
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    className="text-slate-400 hover:text-white flex items-center gap-1 transition-colors"
                                >
                                    <ExternalLink className="h-3.5 w-3.5" />
                                    <span>Preview</span>
                                </a>

                                <div className="flex items-center gap-2">
                                    <Link
                                        href={`/admin/news/${item.id}`}
                                        className="px-3 py-1.5 rounded-lg bg-blue-600/10 hover:bg-blue-600/20 text-blue-400 border border-blue-500/20 font-medium transition-colors flex items-center gap-1"
                                    >
                                        <Edit3 className="h-3.5 w-3.5" />
                                        <span>Edit</span>
                                    </Link>
                                    <button
                                        onClick={() => setDeleteModalItem(item)}
                                        className="px-3 py-1.5 rounded-lg bg-red-600/10 hover:bg-red-600/20 text-red-400 border border-red-500/20 font-medium transition-colors flex items-center gap-1 cursor-pointer"
                                    >
                                        <Trash2 className="h-3.5 w-3.5" />
                                        <span>Delete</span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    ))
                ) : (
                    <div className="col-span-full py-12 text-center text-slate-500">
                        No news articles match your query.
                    </div>
                )}
            </div>

            {/* Pagination Bar */}
            {totalPages > 1 && (
                <div className="p-4 bg-slate-900 border border-slate-800 rounded-2xl flex items-center justify-between text-xs text-slate-400">
                    <div>
                        Showing page <span className="font-semibold text-white">{currentPage}</span> of{' '}
                        <span className="font-semibold text-white">{totalPages}</span>
                    </div>
                    <div className="flex items-center gap-2">
                        <button
                            disabled={currentPage === 1}
                            onClick={() => setCurrentPage((p) => Math.max(1, p - 1))}
                            className="flex items-center gap-1 px-3 py-1.5 bg-slate-950 border border-slate-800 rounded-lg text-slate-300 disabled:opacity-40 hover:bg-slate-800 transition-all cursor-pointer"
                        >
                            <ChevronLeft className="h-4 w-4" />
                            <span>Prev</span>
                        </button>
                        <button
                            disabled={currentPage === totalPages}
                            onClick={() => setCurrentPage((p) => Math.min(totalPages, p + 1))}
                            className="flex items-center gap-1 px-3 py-1.5 bg-slate-950 border border-slate-800 rounded-lg text-slate-300 disabled:opacity-40 hover:bg-slate-800 transition-all cursor-pointer"
                        >
                            <span>Next</span>
                            <ChevronRight className="h-4 w-4" />
                        </button>
                    </div>
                </div>
            )}

            {/* Delete Confirmation Modal */}
            {deleteModalItem && (
                <div className="fixed inset-0 bg-slate-950/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
                    <div className="bg-slate-900 border border-slate-800 rounded-2xl max-w-md w-full p-6 space-y-4 shadow-2xl animate-in fade-in zoom-in-95">
                        <div className="flex items-center gap-3 text-red-400">
                            <div className="h-10 w-10 rounded-full bg-red-950 border border-red-800 flex items-center justify-center">
                                <AlertTriangle className="h-5 w-5" />
                            </div>
                            <div>
                                <h3 className="text-base font-bold text-white">Delete News Article</h3>
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
                                <span>Delete Article</span>
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
