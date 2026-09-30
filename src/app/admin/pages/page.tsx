'use client';

import React, { useState, useEffect } from 'react';
import {
    FileCode,
    Search,
    Edit3,
    Loader2,
    Globe,
    CheckCircle2,
    AlertCircle,
    X,
    ExternalLink,
    Save
} from 'lucide-react';
import SeoPreview from '@/components/SeoPreview';

export default function SitePagesManagerPage() {
    const [pages, setPages] = useState<any[]>([]);
    const [search, setSearch] = useState('');
    const [loading, setLoading] = useState(true);

    // Edit Modal State
    const [showModal, setShowModal] = useState(false);
    const [editingPage, setEditingPage] = useState<any | null>(null);

    const [title, setTitle] = useState('');
    const [slug, setSlug] = useState('');
    const [headline, setHeadline] = useState('');
    const [seoTitle, setSeoTitle] = useState('');
    const [seoDescription, setSeoDescription] = useState('');
    const [saving, setSaving] = useState(false);
    const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

    const fetchPages = async () => {
        setLoading(true);
        try {
            const res = await fetch('/api/admin/content?type=pages');
            const json = await res.json();
            if (json.success) setPages(json.data || []);
        } catch (err) {
            console.error('Error fetching pages:', err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchPages();
    }, []);

    const handleOpenModal = (page: any) => {
        setMessage(null);
        setEditingPage(page);
        setTitle(page.title || '');
        setSlug(page.slug || '');
        setHeadline(page.headline || '');
        setSeoTitle(page.seo?.title || page.title || '');
        setSeoDescription(page.seo?.description || '');
        setShowModal(true);
    };

    const handleSave = async (e: React.FormEvent) => {
        e.preventDefault();
        setSaving(true);
        setMessage(null);

        const payload = {
            ...editingPage,
            title,
            slug,
            headline,
            seo: {
                title: seoTitle,
                description: seoDescription,
            },
        };

        try {
            const res = await fetch('/api/admin/content', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    type: 'pages',
                    item: payload,
                }),
            });

            const data = await res.json();
            if (data.success) {
                setMessage({ type: 'success', text: 'Page updated successfully!' });
                setTimeout(() => {
                    setShowModal(false);
                    fetchPages();
                }, 800);
            } else {
                setMessage({ type: 'error', text: data.error || 'Failed to save page' });
            }
        } catch (err) {
            setMessage({ type: 'error', text: 'Server error' });
        } finally {
            setSaving(false);
        }
    };

    const filtered = pages.filter(
        (p) =>
            p.title?.toLowerCase().includes(search.toLowerCase()) ||
            p.slug?.toLowerCase().includes(search.toLowerCase())
    );

    return (
        <div className="space-y-6">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h1 className="text-xl font-bold text-white flex items-center gap-2">
                        <FileCode className="h-5 w-5 text-blue-400" />
                        <span>Site Pages Copy &amp; SEO Management</span>
                    </h1>
                    <p className="text-xs text-slate-400">
                        Control main site pages, headlines, metadata, and search indexing rules
                    </p>
                </div>
            </div>

            <div className="bg-slate-900 border border-slate-800 rounded-2xl p-4 shadow-lg">
                <div className="relative max-w-md">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-500" />
                    <input
                        type="text"
                        placeholder="Search pages by title or route..."
                        value={search}
                        onChange={(e) => setSearch(e.target.value)}
                        className="w-full pl-9 pr-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 placeholder-slate-500 focus:outline-none focus:border-blue-500"
                    />
                </div>
            </div>

            {/* Pages Cards Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                {loading ? (
                    <div className="col-span-full py-12 text-center text-slate-400">
                        <Loader2 className="h-7 w-7 animate-spin text-blue-500 mx-auto mb-2" />
                        <span>Loading site pages metadata...</span>
                    </div>
                ) : filtered.length > 0 ? (
                    filtered.map((page) => (
                        <div
                            key={page.id}
                            className="bg-slate-900 border border-slate-800 hover:border-slate-700 rounded-2xl p-5 shadow-lg flex flex-col justify-between transition-all group"
                        >
                            <div className="space-y-3">
                                <div className="flex items-center justify-between">
                                    <span className="px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-blue-950 text-blue-300 border border-blue-800/40 font-mono">
                                        /{page.slug === 'home' ? '' : page.slug}
                                    </span>
                                    <span className="text-[10px] text-slate-500 uppercase font-bold">System Page</span>
                                </div>

                                <h3 className="text-base font-bold text-white group-hover:text-blue-400 transition-colors">
                                    {page.title}
                                </h3>

                                {page.headline && (
                                    <p className="text-xs text-slate-400 line-clamp-2 leading-relaxed italic">
                                        "{page.headline}"
                                    </p>
                                )}
                            </div>

                            <div className="flex items-center justify-between pt-4 mt-4 border-t border-slate-800/80">
                                <a
                                    href={`/${page.slug === 'home' ? '' : page.slug}`}
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    className="text-xs text-slate-400 hover:text-white flex items-center gap-1 transition-colors"
                                >
                                    <ExternalLink className="h-3.5 w-3.5" />
                                    <span>View Live</span>
                                </a>
                                <button
                                    onClick={() => handleOpenModal(page)}
                                    className="px-3.5 py-1.5 rounded-lg bg-blue-600/10 hover:bg-blue-600/20 text-blue-400 border border-blue-500/20 text-xs font-medium transition-colors flex items-center gap-1.5 cursor-pointer"
                                >
                                    <Edit3 className="h-3.5 w-3.5" />
                                    <span>Edit Copy &amp; SEO</span>
                                </button>
                            </div>
                        </div>
                    ))
                ) : (
                    <div className="col-span-full py-12 text-center text-slate-500">
                        No site pages match your search.
                    </div>
                )}
            </div>

            {/* Edit Modal */}
            {showModal && editingPage && (
                <div className="fixed inset-0 bg-slate-950/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
                    <form
                        onSubmit={handleSave}
                        className="bg-slate-900 border border-slate-800 rounded-2xl max-w-2xl w-full p-6 space-y-4 shadow-2xl animate-in fade-in zoom-in-95 max-h-[90vh] overflow-y-auto"
                    >
                        <div className="flex items-center justify-between border-b border-slate-800 pb-3">
                            <h3 className="text-base font-bold text-white flex items-center gap-2">
                                <FileCode className="h-5 w-5 text-blue-400" />
                                <span>Edit Page: {editingPage.title}</span>
                            </h3>
                            <button type="button" onClick={() => setShowModal(false)} className="text-slate-500 hover:text-slate-300">
                                <X className="h-5 w-5" />
                            </button>
                        </div>

                        {message && (
                            <div
                                className={`p-3 rounded-xl flex items-center gap-2 text-xs font-semibold ${message.type === 'success'
                                        ? 'bg-emerald-950 border border-emerald-800 text-emerald-400'
                                        : 'bg-red-950 border border-red-800 text-red-400'
                                    }`}
                            >
                                {message.type === 'success' ? <CheckCircle2 className="h-4 w-4" /> : <AlertCircle className="h-4 w-4" />}
                                <span>{message.text}</span>
                            </div>
                        )}

                        <div>
                            <label className="block text-xs font-semibold text-slate-300 mb-1">Page Title *</label>
                            <input
                                type="text"
                                required
                                value={title}
                                onChange={(e) => setTitle(e.target.value)}
                                className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-100 focus:outline-none focus:border-blue-500 font-semibold"
                            />
                        </div>

                        <div>
                            <label className="block text-xs font-semibold text-slate-300 mb-1">Hero Banner Headline</label>
                            <input
                                type="text"
                                value={headline}
                                onChange={(e) => setHeadline(e.target.value)}
                                placeholder="e.g. World-Class Oilfield & Flow Control Engineering"
                                className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-blue-500"
                            />
                        </div>

                        <div className="space-y-3 pt-2 border-t border-slate-800">
                            <h4 className="text-xs font-bold text-white flex items-center gap-2">
                                <Globe className="h-4 w-4 text-blue-400" />
                                <span>Google Search Engine Meta Tags</span>
                            </h4>

                            <div>
                                <label className="block text-[11px] text-slate-400 mb-1">SEO Title Tag</label>
                                <input
                                    type="text"
                                    value={seoTitle}
                                    onChange={(e) => setSeoTitle(e.target.value)}
                                    className="w-full px-3 py-1.5 bg-slate-950 border border-slate-800 rounded-lg text-xs text-slate-200 focus:outline-none focus:border-blue-500"
                                />
                            </div>

                            <div>
                                <label className="block text-[11px] text-slate-400 mb-1">SEO Meta Description</label>
                                <textarea
                                    rows={3}
                                    value={seoDescription}
                                    onChange={(e) => setSeoDescription(e.target.value)}
                                    className="w-full px-3 py-1.5 bg-slate-950 border border-slate-800 rounded-lg text-xs text-slate-200 focus:outline-none focus:border-blue-500"
                                />
                            </div>
                        </div>

                        <SeoPreview title={seoTitle} description={seoDescription} slug={slug} category="page" />

                        <div className="flex items-center justify-end gap-3 pt-3 border-t border-slate-800">
                            <button
                                type="button"
                                onClick={() => setShowModal(false)}
                                className="px-4 py-2 rounded-xl text-xs font-semibold bg-slate-800 hover:bg-slate-700 text-slate-300 transition-colors"
                            >
                                Cancel
                            </button>
                            <button
                                type="submit"
                                disabled={saving}
                                className="px-4 py-2 rounded-xl text-xs font-semibold bg-blue-600 hover:bg-blue-500 text-white shadow-lg shadow-blue-600/30 transition-colors flex items-center gap-2 cursor-pointer"
                            >
                                {saving ? <Loader2 className="h-3.5 w-3.5 animate-spin" /> : <Save className="h-3.5 w-3.5" />}
                                <span>Save Page Settings</span>
                            </button>
                        </div>
                    </form>
                </div>
            )}
        </div>
    );
}
