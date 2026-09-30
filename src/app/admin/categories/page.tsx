'use client';

import React, { useState, useEffect } from 'react';
import {
    FolderTree,
    Plus,
    Search,
    Edit3,
    Trash2,
    Loader2,
    CheckCircle2,
    AlertCircle,
    X,
    Package
} from 'lucide-react';

export default function CategoriesManagerPage() {
    const [categories, setCategories] = useState<any[]>([]);
    const [search, setSearch] = useState('');
    const [loading, setLoading] = useState(true);

    // Modal State
    const [showModal, setShowModal] = useState(false);
    const [editingCategory, setEditingCategory] = useState<any | null>(null);
    const [name, setName] = useState('');
    const [slug, setSlug] = useState('');
    const [description, setDescription] = useState('');
    const [saving, setSaving] = useState(false);
    const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

    const fetchCategories = async () => {
        setLoading(true);
        try {
            const res = await fetch('/api/admin/content?type=categories');
            const json = await res.json();
            if (json.success) setCategories(json.data || []);
        } catch (err) {
            console.error('Failed to load categories:', err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchCategories();
    }, []);

    const handleOpenModal = (cat?: any) => {
        setMessage(null);
        if (cat) {
            setEditingCategory(cat);
            setName(cat.name || '');
            setSlug(cat.slug || '');
            setDescription(cat.description || '');
        } else {
            setEditingCategory(null);
            setName('');
            setSlug('');
            setDescription('');
        }
        setShowModal(true);
    };

    const handleNameChange = (val: string) => {
        setName(val);
        if (!editingCategory || !slug) {
            setSlug(
                val
                    .toLowerCase()
                    .trim()
                    .replace(/\s+/g, '-')
                    .replace(/[^\w\-]+/g, '')
            );
        }
    };

    const handleSave = async (e: React.FormEvent) => {
        e.preventDefault();
        setSaving(true);
        setMessage(null);

        const payload = {
            id: editingCategory ? editingCategory.id : undefined,
            name,
            slug,
            description,
            count: editingCategory ? editingCategory.count || 0 : 0,
            parent: editingCategory ? editingCategory.parent || 0 : 0,
        };

        try {
            const res = await fetch('/api/admin/content', {
                method: editingCategory ? 'PUT' : 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    type: 'categories',
                    item: payload,
                }),
            });

            const data = await res.json();
            if (data.success) {
                setMessage({ type: 'success', text: editingCategory ? 'Category updated!' : 'Category created!' });
                setTimeout(() => {
                    setShowModal(false);
                    fetchCategories();
                }, 800);
            } else {
                setMessage({ type: 'error', text: data.error || 'Failed to save category' });
            }
        } catch (err) {
            setMessage({ type: 'error', text: 'Error saving category' });
        } finally {
            setSaving(false);
        }
    };

    const handleDelete = async (cat: any) => {
        if (!confirm(`Are you sure you want to delete category "${cat.name}"?`)) return;
        try {
            const res = await fetch(`/api/admin/content?type=categories&id=${cat.id}`, { method: 'DELETE' });
            const data = await res.json();
            if (data.success) {
                setCategories(categories.filter((c) => c.id !== cat.id));
            } else {
                alert(data.error || 'Delete failed');
            }
        } catch (err) {
            console.error('Delete error:', err);
        }
    };

    const filteredCategories = categories.filter((c) =>
        c.name?.toLowerCase().includes(search.toLowerCase()) ||
        c.slug?.toLowerCase().includes(search.toLowerCase())
    );

    return (
        <div className="space-y-6">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h1 className="text-xl font-bold text-white flex items-center gap-2">
                        <FolderTree className="h-5 w-5 text-cyan-400" />
                        <span>Product Categories Manager</span>
                    </h1>
                    <p className="text-xs text-slate-400">
                        Organize products into hierarchical operational categories
                    </p>
                </div>

                <button
                    onClick={() => handleOpenModal()}
                    className="inline-flex items-center gap-2 px-4 py-2.5 bg-blue-600 hover:bg-blue-500 text-white rounded-xl text-xs font-semibold shadow-lg shadow-blue-600/30 transition-all cursor-pointer self-start sm:self-auto"
                >
                    <Plus className="h-4 w-4" />
                    <span>Add New Category</span>
                </button>
            </div>

            {/* Search Input */}
            <div className="bg-slate-900 border border-slate-800 rounded-2xl p-4 shadow-lg">
                <div className="relative max-w-md">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-500" />
                    <input
                        type="text"
                        placeholder="Search categories..."
                        value={search}
                        onChange={(e) => setSearch(e.target.value)}
                        className="w-full pl-9 pr-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 placeholder-slate-500 focus:outline-none focus:border-blue-500"
                    />
                </div>
            </div>

            {/* Categories Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {loading ? (
                    <div className="col-span-full py-12 text-center text-slate-400">
                        <Loader2 className="h-7 w-7 animate-spin text-cyan-500 mx-auto mb-2" />
                        <span>Loading categories...</span>
                    </div>
                ) : filteredCategories.length > 0 ? (
                    filteredCategories.map((cat) => (
                        <div
                            key={cat.id}
                            className="bg-slate-900 border border-slate-800 hover:border-slate-700 rounded-2xl p-5 shadow-lg flex flex-col justify-between transition-all group"
                        >
                            <div>
                                <div className="flex items-center justify-between mb-2">
                                    <span className="px-2.5 py-1 rounded-md text-[10px] font-bold bg-cyan-950 text-cyan-400 border border-cyan-800/40">
                                        ID #{cat.id}
                                    </span>
                                    <div className="flex items-center gap-1.5 text-xs text-slate-400">
                                        <Package className="h-3.5 w-3.5 text-slate-500" />
                                        <span>{cat.count || 0} products</span>
                                    </div>
                                </div>

                                <h3 className="text-base font-bold text-white group-hover:text-cyan-400 transition-colors">
                                    {cat.name}
                                </h3>
                                <p className="text-xs text-slate-500 font-mono mt-0.5">/category/{cat.slug}</p>

                                {cat.description && (
                                    <p className="text-xs text-slate-400 mt-2 line-clamp-2 leading-relaxed">
                                        {cat.description}
                                    </p>
                                )}
                            </div>

                            <div className="flex items-center justify-end gap-2 pt-4 mt-4 border-t border-slate-800/80">
                                <button
                                    onClick={() => handleOpenModal(cat)}
                                    className="px-3 py-1.5 rounded-lg bg-blue-600/10 hover:bg-blue-600/20 text-blue-400 border border-blue-500/20 text-xs font-medium transition-colors flex items-center gap-1 cursor-pointer"
                                >
                                    <Edit3 className="h-3.5 w-3.5" />
                                    <span>Edit</span>
                                </button>
                                <button
                                    onClick={() => handleDelete(cat)}
                                    className="px-3 py-1.5 rounded-lg bg-red-600/10 hover:bg-red-600/20 text-red-400 border border-red-500/20 text-xs font-medium transition-colors flex items-center gap-1 cursor-pointer"
                                >
                                    <Trash2 className="h-3.5 w-3.5" />
                                    <span>Delete</span>
                                </button>
                            </div>
                        </div>
                    ))
                ) : (
                    <div className="col-span-full py-12 text-center text-slate-500">
                        No categories found matching your query.
                    </div>
                )}
            </div>

            {/* Add / Edit Category Modal */}
            {showModal && (
                <div className="fixed inset-0 bg-slate-950/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
                    <form
                        onSubmit={handleSave}
                        className="bg-slate-900 border border-slate-800 rounded-2xl max-w-md w-full p-6 space-y-4 shadow-2xl animate-in fade-in zoom-in-95"
                    >
                        <div className="flex items-center justify-between border-b border-slate-800 pb-3">
                            <h3 className="text-base font-bold text-white flex items-center gap-2">
                                <FolderTree className="h-5 w-5 text-cyan-400" />
                                <span>{editingCategory ? `Edit Category #${editingCategory.id}` : 'Create Category'}</span>
                            </h3>
                            <button
                                type="button"
                                onClick={() => setShowModal(false)}
                                className="text-slate-500 hover:text-slate-300"
                            >
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
                            <label className="block text-xs font-semibold text-slate-300 mb-1">Category Name *</label>
                            <input
                                type="text"
                                required
                                value={name}
                                onChange={(e) => handleNameChange(e.target.value)}
                                placeholder="e.g. Xmas Trees and Wellheads"
                                className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-100 placeholder-slate-500 focus:outline-none focus:border-cyan-500"
                            />
                        </div>

                        <div>
                            <label className="block text-xs font-semibold text-slate-300 mb-1">URL Slug</label>
                            <input
                                type="text"
                                required
                                value={slug}
                                onChange={(e) => setSlug(e.target.value)}
                                placeholder="xmas-trees-and-wellheads"
                                className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-300 font-mono focus:outline-none focus:border-cyan-500"
                            />
                        </div>

                        <div>
                            <label className="block text-xs font-semibold text-slate-300 mb-1">Description</label>
                            <textarea
                                rows={3}
                                value={description}
                                onChange={(e) => setDescription(e.target.value)}
                                placeholder="Optional description of this product line..."
                                className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-300 focus:outline-none focus:border-cyan-500"
                            />
                        </div>

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
                                className="px-4 py-2 rounded-xl text-xs font-semibold bg-cyan-600 hover:bg-cyan-500 text-white shadow-lg shadow-cyan-600/30 transition-colors flex items-center gap-2 cursor-pointer"
                            >
                                {saving && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
                                <span>{editingCategory ? 'Save Changes' : 'Create Category'}</span>
                            </button>
                        </div>
                    </form>
                </div>
            )}
        </div>
    );
}
