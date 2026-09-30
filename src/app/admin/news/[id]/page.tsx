'use client';

import React, { useState, useEffect, use } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import SeoPreview from '@/components/SeoPreview';
import ImageUploader from '@/components/ImageUploader';
import {
    ArrowLeft,
    Save,
    Newspaper,
    Globe,
    Image as ImageIcon,
    Eye,
    Code,
    CheckCircle2,
    AlertCircle,
    Loader2,
    Calendar
} from 'lucide-react';

export default function NewsEditPage({ params }: { params: Promise<{ id: string }> }) {
    const resolvedParams = use(params);
    const newsId = resolvedParams.id;
    const isNew = newsId === 'new';

    const router = useRouter();
    const [loading, setLoading] = useState(!isNew);
    const [saving, setSaving] = useState(false);
    const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

    const [activeTab, setActiveTab] = useState<'content' | 'seo' | 'preview'>('content');

    // Form State
    const [title, setTitle] = useState('');
    const [slug, setSlug] = useState('');
    const [excerpt, setExcerpt] = useState('');
    const [contentHtml, setContentHtml] = useState('');
    const [date, setDate] = useState(new Date().toISOString().slice(0, 10));

    // Image State
    const [imageUrl, setImageUrl] = useState('');
    const [imageAlt, setImageAlt] = useState('');

    // SEO State
    const [seoTitle, setSeoTitle] = useState('');
    const [seoDescription, setSeoDescription] = useState('');

    useEffect(() => {
        async function loadNews() {
            if (isNew) return;
            try {
                const res = await fetch(`/api/admin/content?type=news&id=${newsId}`);
                const json = await res.json();
                if (json.success && json.data) {
                    const n = json.data;
                    setTitle(n.title || '');
                    setSlug(n.slug || '');
                    setExcerpt(n.excerpt || '');
                    setContentHtml(n.contentHtml || '');
                    if (n.date) setDate(n.date.slice(0, 10));

                    if (n.featuredImage) {
                        setImageUrl(n.featuredImage.url || '');
                        setImageAlt(n.featuredImage.alt || '');
                    }

                    if (n.seo) {
                        setSeoTitle(n.seo.title || '');
                        setSeoDescription(n.seo.description || '');
                    }
                }
            } catch (err) {
                console.error('Error loading news:', err);
            } finally {
                setLoading(false);
            }
        }

        loadNews();
    }, [newsId, isNew]);

    const handleTitleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const val = e.target.value;
        setTitle(val);
        if (isNew || !slug) {
            setSlug(
                val
                    .toLowerCase()
                    .trim()
                    .replace(/\s+/g, '-')
                    .replace(/[^\w\-]+/g, '')
            );
        }
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setSaving(true);
        setMessage(null);

        const payloadItem = {
            id: isNew ? undefined : Number(newsId),
            title,
            slug,
            excerpt,
            contentHtml,
            date,
            featuredImage: imageUrl ? { url: imageUrl, alt: imageAlt || title } : null,
            seo: {
                title: seoTitle || `${title} - WOM Group News`,
                description: seoDescription || excerpt || '',
                ogImage: imageUrl || null,
            },
        };

        try {
            const res = await fetch('/api/admin/content', {
                method: isNew ? 'POST' : 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    type: 'news',
                    item: payloadItem,
                }),
            });

            const data = await res.json();
            if (data.success) {
                setMessage({ type: 'success', text: isNew ? 'News article published!' : 'Article saved!' });
                if (isNew && data.data?.id) {
                    setTimeout(() => {
                        router.push(`/admin/news/${data.data.id}`);
                    }, 1000);
                }
            } else {
                setMessage({ type: 'error', text: data.error || 'Failed to save news article' });
            }
        } catch (err) {
            setMessage({ type: 'error', text: 'Server error' });
        } finally {
            setSaving(false);
        }
    };

    if (loading) {
        return (
            <div className="py-20 text-center text-slate-400 space-y-3">
                <Loader2 className="h-8 w-8 animate-spin text-purple-500 mx-auto" />
                <p className="text-sm font-medium">Loading news article editor...</p>
            </div>
        );
    }

    return (
        <form onSubmit={handleSubmit} className="space-y-6 max-w-5xl mx-auto pb-12">
            {/* Top Bar */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
                <div className="flex items-center gap-3">
                    <Link
                        href="/admin/news"
                        className="h-9 w-9 rounded-xl bg-slate-900 border border-slate-800 hover:border-slate-700 flex items-center justify-center text-slate-400 hover:text-white transition-colors"
                    >
                        <ArrowLeft className="h-4 w-4" />
                    </Link>
                    <div>
                        <h1 className="text-xl font-bold text-white tracking-tight flex items-center gap-2">
                            <Newspaper className="h-5 w-5 text-purple-400" />
                            <span>{isNew ? 'Publish New Article' : `Edit Article #${newsId}`}</span>
                        </h1>
                        <p className="text-xs text-slate-400 truncate max-w-md">
                            {title ? title : 'Untitled Article'}
                        </p>
                    </div>
                </div>

                <button
                    type="submit"
                    disabled={saving}
                    className="px-5 py-2 bg-purple-600 hover:bg-purple-500 text-white rounded-xl text-xs font-semibold shadow-lg shadow-purple-600/30 flex items-center gap-2 transition-all cursor-pointer disabled:opacity-50"
                >
                    {saving ? <Loader2 className="h-4 w-4 animate-spin" /> : <Save className="h-4 w-4" />}
                    <span>{isNew ? 'Publish Article' : 'Save Changes'}</span>
                </button>
            </div>

            {message && (
                <div
                    className={`p-4 rounded-2xl flex items-center gap-3 text-xs font-semibold ${message.type === 'success'
                            ? 'bg-emerald-950/80 border border-emerald-800/60 text-emerald-300'
                            : 'bg-red-950/80 border border-red-800/60 text-red-300'
                        }`}
                >
                    {message.type === 'success' ? (
                        <CheckCircle2 className="h-5 w-5 text-emerald-400 shrink-0" />
                    ) : (
                        <AlertCircle className="h-5 w-5 text-red-400 shrink-0" />
                    )}
                    <span>{message.text}</span>
                </div>
            )}

            {/* Tabs */}
            <div className="flex border-b border-slate-800 gap-2">
                <button
                    type="button"
                    onClick={() => setActiveTab('content')}
                    className={`pb-3 px-4 text-xs font-bold border-b-2 transition-all flex items-center gap-2 ${activeTab === 'content'
                            ? 'border-purple-500 text-purple-400'
                            : 'border-transparent text-slate-400 hover:text-slate-200'
                        }`}
                >
                    <Code className="h-4 w-4" />
                    <span>Article Content</span>
                </button>
                <button
                    type="button"
                    onClick={() => setActiveTab('seo')}
                    className={`pb-3 px-4 text-xs font-bold border-b-2 transition-all flex items-center gap-2 ${activeTab === 'seo'
                            ? 'border-purple-500 text-purple-400'
                            : 'border-transparent text-slate-400 hover:text-slate-200'
                        }`}
                >
                    <Globe className="h-4 w-4" />
                    <span>SEO &amp; Social</span>
                </button>
                <button
                    type="button"
                    onClick={() => setActiveTab('preview')}
                    className={`pb-3 px-4 text-xs font-bold border-b-2 transition-all flex items-center gap-2 ${activeTab === 'preview'
                            ? 'border-purple-500 text-purple-400'
                            : 'border-transparent text-slate-400 hover:text-slate-200'
                        }`}
                >
                    <Eye className="h-4 w-4" />
                    <span>Live Preview</span>
                </button>
            </div>

            {activeTab === 'content' && (
                <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <div className="lg:col-span-2 space-y-6">
                        <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6 space-y-4 shadow-xl">
                            <div>
                                <label className="block text-xs font-semibold text-slate-300 mb-1">Article Title *</label>
                                <input
                                    type="text"
                                    required
                                    value={title}
                                    onChange={handleTitleChange}
                                    placeholder="e.g. WOM Group Announces Expansion into Deepwater Riser Systems"
                                    className="w-full px-4 py-2.5 bg-slate-950 border border-slate-800 rounded-xl text-sm text-slate-100 placeholder-slate-500 focus:outline-none focus:border-purple-500 font-semibold"
                                />
                            </div>

                            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                <div>
                                    <label className="block text-xs font-semibold text-slate-300 mb-1">URL Slug</label>
                                    <input
                                        type="text"
                                        required
                                        value={slug}
                                        onChange={(e) => setSlug(e.target.value)}
                                        className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-300 font-mono focus:outline-none focus:border-purple-500"
                                    />
                                </div>
                                <div>
                                    <label className="block text-xs font-semibold text-slate-300 mb-1">Publication Date</label>
                                    <input
                                        type="date"
                                        value={date}
                                        onChange={(e) => setDate(e.target.value)}
                                        className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-300 focus:outline-none focus:border-purple-500"
                                    />
                                </div>
                            </div>

                            <div>
                                <label className="block text-xs font-semibold text-slate-300 mb-1">Excerpt Summary</label>
                                <textarea
                                    rows={2}
                                    value={excerpt}
                                    onChange={(e) => setExcerpt(e.target.value)}
                                    placeholder="Summary paragraph for news listing..."
                                    className="w-full px-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-300 focus:outline-none focus:border-purple-500"
                                />
                            </div>

                            <div>
                                <label className="block text-xs font-semibold text-slate-300 mb-1">Full Article HTML Content</label>
                                <textarea
                                    rows={14}
                                    value={contentHtml}
                                    onChange={(e) => setContentHtml(e.target.value)}
                                    placeholder="<p>Full article body HTML content...</p>"
                                    className="w-full p-4 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 font-mono focus:outline-none focus:border-purple-500 leading-relaxed"
                                />
                            </div>
                        </div>
                    </div>

                    <div className="space-y-6">
                        <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 space-y-3 shadow-xl">
                            <h3 className="text-xs font-bold text-white flex items-center gap-2">
                                <ImageIcon className="h-4 w-4 text-purple-400" />
                                <span>Featured Cover Image</span>
                            </h3>

                            <ImageUploader
                                value={imageUrl}
                                onChange={setImageUrl}
                                label="Upload Cover Asset to Cloudinary"
                                folder="wom_news"
                            />
                        </div>
                    </div>
                </div>
            )}

            {activeTab === 'seo' && (
                <div className="space-y-6">
                    <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6 space-y-4 shadow-xl">
                        <h2 className="text-sm font-bold text-white flex items-center gap-2">
                            <Globe className="h-4 w-4 text-purple-400" />
                            <span>SEO Settings</span>
                        </h2>

                        <div>
                            <label className="block text-xs font-semibold text-slate-300 mb-1">SEO Title</label>
                            <input
                                type="text"
                                value={seoTitle}
                                onChange={(e) => setSeoTitle(e.target.value)}
                                className="w-full px-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200"
                            />
                        </div>

                        <div>
                            <label className="block text-xs font-semibold text-slate-300 mb-1">Meta Description</label>
                            <textarea
                                rows={3}
                                value={seoDescription}
                                onChange={(e) => setSeoDescription(e.target.value)}
                                className="w-full px-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200"
                            />
                        </div>
                    </div>

                    <SeoPreview title={seoTitle || title} description={seoDescription || excerpt} slug={slug} category="news" />
                </div>
            )}

            {activeTab === 'preview' && (
                <div className="bg-white text-slate-900 border border-slate-300 rounded-2xl p-8 shadow-2xl space-y-4">
                    <div className="border-b pb-4">
                        <span className="text-xs font-bold text-purple-600 uppercase">WOM News Announcement</span>
                        <h1 className="text-2xl font-bold mt-1">{title || 'Untitled Article'}</h1>
                        <p className="text-xs text-slate-500 mt-1">Published on {date}</p>
                    </div>
                    <div
                        className="prose max-w-none text-sm text-slate-800 leading-relaxed"
                        dangerouslySetInnerHTML={{ __html: contentHtml || '<p>No content provided.</p>' }}
                    />
                </div>
            )}
        </form>
    );
}
