'use client';

import React, { useState, useEffect, use } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import SeoPreview from '@/components/SeoPreview';
import ImageUploader from '@/components/ImageUploader';
import {
    ArrowLeft,
    Save,
    Package,
    Globe,
    Image as ImageIcon,
    Eye,
    Code,
    CheckCircle2,
    AlertCircle,
    Loader2,
    FolderTree,
    Sparkles
} from 'lucide-react';

export default function ProductEditPage({ params }: { params: Promise<{ id: string }> }) {
    const resolvedParams = use(params);
    const productId = resolvedParams.id;
    const isNew = productId === 'new';

    const router = useRouter();
    const [categories, setCategories] = useState<any[]>([]);
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
    const [selectedCategoryIds, setSelectedCategoryIds] = useState<number[]>([]);

    // Image State
    const [imageUrl, setImageUrl] = useState('');
    const [imageAlt, setImageAlt] = useState('');

    // Price State
    const [price, setPrice] = useState<string>('');
    const [currency, setCurrency] = useState('USD');
    const [priceOnRequest, setPriceOnRequest] = useState(false);

    // SEO State
    const [seoTitle, setSeoTitle] = useState('');
    const [seoDescription, setSeoDescription] = useState('');

    useEffect(() => {
        async function loadInitialData() {
            try {
                // Fetch categories list
                const catRes = await fetch('/api/admin/content?type=categories');
                const catJson = await catRes.json();
                if (catJson.success) setCategories(catJson.data || []);

                if (!isNew) {
                    // Fetch existing product
                    const prodRes = await fetch(`/api/admin/content?type=products&id=${productId}`);
                    const prodJson = await prodRes.json();

                    if (prodJson.success && prodJson.data) {
                        const p = prodJson.data;
                        setTitle(p.title || '');
                        setSlug(p.slug || '');
                        setExcerpt(p.excerpt || '');
                        setContentHtml(p.contentHtml || '');
                        if (p.date) setDate(p.date.slice(0, 10));

                        if (p.price !== undefined && p.price !== null) setPrice(String(p.price));
                        if (p.currency) setCurrency(p.currency);
                        if (p.priceOnRequest !== undefined) setPriceOnRequest(Boolean(p.priceOnRequest));

                        if (p.categories && Array.isArray(p.categories)) {
                            setSelectedCategoryIds(p.categories.map((c: any) => c.id).filter(Boolean));
                        }

                        if (p.featuredImage) {
                            setImageUrl(p.featuredImage.url || '');
                            setImageAlt(p.featuredImage.alt || '');
                        }

                        if (p.seo) {
                            setSeoTitle(p.seo.title || '');
                            setSeoDescription(p.seo.description || '');
                        }
                    } else {
                        setMessage({ type: 'error', text: 'Product not found' });
                    }
                }
            } catch (err) {
                console.error('Error loading product details:', err);
            } finally {
                setLoading(false);
            }
        }

        loadInitialData();
    }, [productId, isNew]);

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

    const handleCategoryToggle = (id: number) => {
        setSelectedCategoryIds((prev) =>
            prev.includes(id) ? prev.filter((catId) => catId !== id) : [...prev, id]
        );
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setSaving(true);
        setMessage(null);

        // Build payload
        const selectedCats = categories
            .filter((c) => selectedCategoryIds.includes(c.id))
            .map((c) => ({ id: c.id, name: c.name, slug: c.slug }));

        const payloadItem = {
            id: isNew ? undefined : Number(productId),
            title,
            slug,
            excerpt,
            contentHtml,
            date,
            price: price ? parseFloat(price) : null,
            currency,
            priceOnRequest,
            categories: selectedCats,
            featuredImage: imageUrl ? { url: imageUrl, alt: imageAlt || title } : null,
            seo: {
                title: seoTitle || `${title} - WOM Group`,
                description: seoDescription || excerpt || '',
                ogImage: imageUrl || null,
            },
        };

        try {
            const res = await fetch('/api/admin/content', {
                method: isNew ? 'POST' : 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    type: 'products',
                    item: payloadItem,
                }),
            });

            const data = await res.json();

            if (data.success) {
                setMessage({ type: 'success', text: isNew ? 'Product created successfully!' : 'Product saved successfully!' });
                if (isNew && data.data?.id) {
                    setTimeout(() => {
                        router.push(`/admin/products/${data.data.id}`);
                    }, 1000);
                }
            } else {
                setMessage({ type: 'error', text: data.error || 'Failed to save product' });
            }
        } catch (err) {
            setMessage({ type: 'error', text: 'An unexpected server error occurred' });
        } finally {
            setSaving(false);
        }
    };

    if (loading) {
        return (
            <div className="py-20 text-center text-slate-400 space-y-3">
                <Loader2 className="h-8 w-8 animate-spin text-blue-500 mx-auto" />
                <p className="text-sm font-medium">Loading product editor...</p>
            </div>
        );
    }

    return (
        <form onSubmit={handleSubmit} className="space-y-6 max-w-5xl mx-auto pb-12">
            {/* Top Action Header */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
                <div className="flex items-center gap-3">
                    <Link
                        href="/admin/products"
                        className="h-9 w-9 rounded-xl bg-slate-900 border border-slate-800 hover:border-slate-700 flex items-center justify-center text-slate-400 hover:text-white transition-colors"
                    >
                        <ArrowLeft className="h-4 w-4" />
                    </Link>
                    <div>
                        <h1 className="text-xl font-bold text-white tracking-tight flex items-center gap-2">
                            <Package className="h-5 w-5 text-blue-400" />
                            <span>{isNew ? 'Create New Product' : `Edit Product #${productId}`}</span>
                        </h1>
                        <p className="text-xs text-slate-400 truncate max-w-md">
                            {title ? title : 'Untitled Product'}
                        </p>
                    </div>
                </div>

                <div className="flex items-center gap-3">
                    {!isNew && (
                        <a
                            href={`/products/${slug}`}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="px-3.5 py-2 bg-slate-900 hover:bg-slate-800 text-slate-300 border border-slate-800 rounded-xl text-xs font-semibold flex items-center gap-1.5 transition-colors"
                        >
                            <Globe className="h-3.5 w-3.5 text-slate-400" />
                            <span>View Public Page</span>
                        </a>
                    )}
                    <button
                        type="submit"
                        disabled={saving}
                        className="px-5 py-2 bg-blue-600 hover:bg-blue-500 text-white rounded-xl text-xs font-semibold shadow-lg shadow-blue-600/30 flex items-center gap-2 transition-all cursor-pointer disabled:opacity-50"
                    >
                        {saving ? <Loader2 className="h-4 w-4 animate-spin" /> : <Save className="h-4 w-4" />}
                        <span>{isNew ? 'Publish Product' : 'Save Changes'}</span>
                    </button>
                </div>
            </div>

            {/* Toast Notification Alert */}
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

            {/* Editor Tabs Navigation */}
            <div className="flex border-b border-slate-800 gap-2">
                <button
                    type="button"
                    onClick={() => setActiveTab('content')}
                    className={`pb-3 px-4 text-xs font-bold border-b-2 transition-all flex items-center gap-2 ${activeTab === 'content'
                            ? 'border-blue-500 text-blue-400'
                            : 'border-transparent text-slate-400 hover:text-slate-200'
                        }`}
                >
                    <Code className="h-4 w-4" />
                    <span>Product Specs &amp; Details</span>
                </button>
                <button
                    type="button"
                    onClick={() => setActiveTab('seo')}
                    className={`pb-3 px-4 text-xs font-bold border-b-2 transition-all flex items-center gap-2 ${activeTab === 'seo'
                            ? 'border-blue-500 text-blue-400'
                            : 'border-transparent text-slate-400 hover:text-slate-200'
                        }`}
                >
                    <Globe className="h-4 w-4" />
                    <span>SEO &amp; Meta Info</span>
                </button>
                <button
                    type="button"
                    onClick={() => setActiveTab('preview')}
                    className={`pb-3 px-4 text-xs font-bold border-b-2 transition-all flex items-center gap-2 ${activeTab === 'preview'
                            ? 'border-blue-500 text-blue-400'
                            : 'border-transparent text-slate-400 hover:text-slate-200'
                        }`}
                >
                    <Eye className="h-4 w-4" />
                    <span>Live HTML Preview</span>
                </button>
            </div>

            {/* TAB 1: Main Content Editor */}
            {activeTab === 'content' && (
                <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    {/* Main Details (2 cols) */}
                    <div className="lg:col-span-2 space-y-6">
                        <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6 space-y-4 shadow-xl">
                            <div>
                                <label className="block text-xs font-semibold text-slate-300 mb-1">
                                    Product Title *
                                </label>
                                <input
                                    type="text"
                                    required
                                    value={title}
                                    onChange={handleTitleChange}
                                    placeholder="e.g. 13 5/8-10K Wellhead / XT (H4 Connector)"
                                    className="w-full px-4 py-2.5 bg-slate-950 border border-slate-800 rounded-xl text-sm text-slate-100 placeholder-slate-500 focus:outline-none focus:border-blue-500 transition-all font-semibold"
                                />
                            </div>

                            <div>
                                <label className="block text-xs font-semibold text-slate-300 mb-1">
                                    URL Slug
                                </label>
                                <input
                                    type="text"
                                    required
                                    value={slug}
                                    onChange={(e) => setSlug(e.target.value)}
                                    placeholder="13-5-8-10k-wellhead-xt-h4-connector"
                                    className="w-full px-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-300 font-mono focus:outline-none focus:border-blue-500 transition-all"
                                />
                            </div>

                            {/* Prominent Pricing Card */}
                            <div className="p-4 bg-slate-950 rounded-xl border border-blue-500/30 space-y-3 shadow-md">
                                <div className="flex items-center justify-between">
                                    <label className="text-xs font-bold text-blue-400 uppercase tracking-wider flex items-center gap-1.5">
                                        <span>Product Price &amp; Commercial Terms</span>
                                    </label>
                                </div>

                                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-1">
                                    <div>
                                        <label className="block text-xs font-semibold text-slate-300 mb-1">
                                            Product Price *
                                        </label>
                                        <div className="relative">
                                            <span className="absolute left-3 top-2.5 text-slate-400 text-xs font-mono font-bold">
                                                {currency === 'EUR' ? '€' : currency === 'GBP' ? '£' : '$'}
                                            </span>
                                            <input
                                                type="number"
                                                step="0.01"
                                                value={price}
                                                onChange={(e) => {
                                                    setPrice(e.target.value);
                                                    if (e.target.value) setPriceOnRequest(false);
                                                }}
                                                placeholder="e.g. 24500.00"
                                                className="w-full pl-8 pr-3 py-2 bg-slate-900 border border-slate-700 rounded-xl text-xs text-white placeholder-slate-500 focus:outline-none focus:border-blue-500 font-mono font-semibold"
                                            />
                                        </div>
                                    </div>

                                    <div>
                                        <label className="block text-xs font-semibold text-slate-300 mb-1">Currency</label>
                                        <select
                                            value={currency}
                                            onChange={(e) => setCurrency(e.target.value)}
                                            className="w-full px-3 py-2 bg-slate-900 border border-slate-700 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-blue-500 font-semibold"
                                        >
                                            <option value="USD">USD ($ - US Dollar)</option>
                                            <option value="EUR">EUR (€ - Euro)</option>
                                            <option value="GBP">GBP (£ - British Pound)</option>
                                            <option value="AED">AED (د.إ - UAE Dirham)</option>
                                            <option value="SAR">SAR (﷼ - Saudi Riyal)</option>
                                        </select>
                                    </div>
                                </div>

                                <div className="pt-2 border-t border-slate-800/80">
                                    <label className="flex items-center gap-2 text-xs text-slate-300 cursor-pointer select-none">
                                        <input
                                            type="checkbox"
                                            checked={priceOnRequest}
                                            onChange={(e) => setPriceOnRequest(e.target.checked)}
                                            className="rounded border-slate-700 text-blue-600 focus:ring-blue-500 h-4 w-4"
                                        />
                                        <span>Display as "Price on Request" (Contact for Quote)</span>
                                    </label>
                                </div>
                            </div>

                            <div>
                                <label className="block text-xs font-semibold text-slate-300 mb-1">
                                    Short Excerpt / Summary
                                </label>
                                <textarea
                                    rows={2}
                                    value={excerpt}
                                    onChange={(e) => setExcerpt(e.target.value)}
                                    placeholder="Brief summary of product features or applications..."
                                    className="w-full px-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-300 focus:outline-none focus:border-blue-500 transition-all"
                                />
                            </div>

                            <div>
                                <div className="flex items-center justify-between mb-1">
                                    <label className="block text-xs font-semibold text-slate-300">
                                        Product Description HTML &amp; Technical Specifications
                                    </label>
                                    <span className="text-[10px] text-slate-500">Supports standard HTML tables, lists, headings</span>
                                </div>
                                <textarea
                                    rows={14}
                                    value={contentHtml}
                                    onChange={(e) => setContentHtml(e.target.value)}
                                    placeholder="<p>Enter HTML description, features list, specifications table...</p>"
                                    className="w-full p-4 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 font-mono focus:outline-none focus:border-blue-500 transition-all leading-relaxed"
                                />
                            </div>
                        </div>
                    </div>

                    {/* Sidebar Settings (1 col) */}
                    <div className="space-y-6">
                        {/* Categories Selector */}
                        <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 space-y-3 shadow-xl">
                            <h3 className="text-xs font-bold text-white flex items-center gap-2">
                                <FolderTree className="h-4 w-4 text-cyan-400" />
                                <span>Categories</span>
                            </h3>
                            <div className="max-h-52 overflow-y-auto space-y-1.5 pr-1 border border-slate-800/80 rounded-xl p-2.5 bg-slate-950">
                                {categories.map((cat) => (
                                    <label
                                        key={cat.id}
                                        className="flex items-center gap-2.5 p-1.5 rounded-lg hover:bg-slate-900/80 text-xs text-slate-300 cursor-pointer select-none"
                                    >
                                        <input
                                            type="checkbox"
                                            checked={selectedCategoryIds.includes(cat.id)}
                                            onChange={() => handleCategoryToggle(cat.id)}
                                            className="rounded border-slate-700 text-blue-600 focus:ring-blue-500 h-4 w-4"
                                        />
                                        <span>{cat.name}</span>
                                    </label>
                                ))}
                            </div>
                        </div>

                        {/* Featured Image URL & Preview */}
                        <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 space-y-3 shadow-xl">
                            <h3 className="text-xs font-bold text-white flex items-center gap-2">
                                <ImageIcon className="h-4 w-4 text-purple-400" />
                                <span>Featured Product Image</span>
                            </h3>

                            <ImageUploader
                                value={imageUrl}
                                onChange={setImageUrl}
                                label="Upload to Cloudinary Asset CDN"
                                folder="wom_products"
                            />

                            <div>
                                <label className="block text-[11px] text-slate-400 mb-1">Alt Text</label>
                                <input
                                    type="text"
                                    value={imageAlt}
                                    onChange={(e) => setImageAlt(e.target.value)}
                                    placeholder="Alt text for image accessibility"
                                    className="w-full px-3 py-1.5 bg-slate-950 border border-slate-800 rounded-lg text-xs text-slate-200 focus:outline-none focus:border-blue-500"
                                />
                            </div>
                        </div>
                    </div>
                </div>
            )}

            {/* TAB 2: SEO Settings & Live Snippet */}
            {activeTab === 'seo' && (
                <div className="space-y-6">
                    <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6 space-y-4 shadow-xl">
                        <h2 className="text-sm font-bold text-white flex items-center gap-2">
                            <Globe className="h-4 w-4 text-blue-400" />
                            <span>Search Engine Optimization (SEO) Settings</span>
                        </h2>

                        <div>
                            <label className="block text-xs font-semibold text-slate-300 mb-1">
                                SEO Title Tag
                            </label>
                            <input
                                type="text"
                                value={seoTitle}
                                onChange={(e) => setSeoTitle(e.target.value)}
                                placeholder={`${title} - WOM Group`}
                                className="w-full px-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-blue-500"
                            />
                        </div>

                        <div>
                            <label className="block text-xs font-semibold text-slate-300 mb-1">
                                SEO Meta Description
                            </label>
                            <textarea
                                rows={4}
                                value={seoDescription}
                                onChange={(e) => setSeoDescription(e.target.value)}
                                placeholder="Comprehensive description of equipment specifications for Google search indexing..."
                                className="w-full px-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-blue-500"
                            />
                        </div>
                    </div>

                    <SeoPreview
                        title={seoTitle || title}
                        description={seoDescription || excerpt}
                        slug={slug}
                        category="products"
                    />
                </div>
            )}

            {/* TAB 3: Live HTML Preview */}
            {activeTab === 'preview' && (
                <div className="bg-white text-slate-900 border border-slate-300 rounded-2xl p-8 shadow-2xl space-y-6">
                    <div className="border-b border-slate-200 pb-4">
                        <span className="text-xs font-bold uppercase tracking-wider text-blue-600">
                            WOM Group Product Preview
                        </span>
                        <h1 className="text-2xl font-black text-slate-900 mt-1">{title || 'Untitled Product'}</h1>
                    </div>

                    {imageUrl && (
                        <div className="max-w-md mx-auto my-4">
                            <img src={imageUrl} alt={imageAlt} className="w-full rounded-xl shadow-md border" />
                        </div>
                    )}

                    <div
                        className="prose max-w-none text-slate-800 text-sm leading-relaxed"
                        dangerouslySetInnerHTML={{ __html: contentHtml || '<p>No content entered yet.</p>' }}
                    />
                </div>
            )}
        </form>
    );
}
