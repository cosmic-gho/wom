'use client';

import React, { useState, useEffect } from 'react';
import ImageUploader from '@/components/ImageUploader';
import {
    FileText,
    Plus,
    Search,
    Edit3,
    Trash2,
    Loader2,
    CheckCircle2,
    AlertCircle,
    X,
    Download,
    ExternalLink
} from 'lucide-react';

export default function ResourcesManagerPage() {
    const [resources, setResources] = useState<any[]>([]);
    const [search, setSearch] = useState('');
    const [loading, setLoading] = useState(true);

    // Modal
    const [showModal, setShowModal] = useState(false);
    const [editingRes, setEditingRes] = useState<any | null>(null);

    const [title, setTitle] = useState('');
    const [type, setType] = useState('PDF Brochure');
    const [fileUrl, setFileUrl] = useState('');
    const [category, setCategory] = useState('Technical Specs');
    const [saving, setSaving] = useState(false);
    const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

    const fetchResources = async () => {
        setLoading(true);
        try {
            const res = await fetch('/api/admin/content?type=resources');
            const json = await res.json();
            if (json.success) setResources(json.data || []);
        } catch (err) {
            console.error('Error fetching resources:', err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchResources();
    }, []);

    const handleOpenModal = (res?: any) => {
        setMessage(null);
        if (res) {
            setEditingRes(res);
            setTitle(res.title || '');
            setType(res.type || 'PDF Brochure');
            setFileUrl(res.fileUrl || '');
            setCategory(res.category || 'Technical Specs');
        } else {
            setEditingRes(null);
            setTitle('');
            setType('PDF Brochure');
            setFileUrl('');
            setCategory('Technical Specs');
        }
        setShowModal(true);
    };

    const handleSave = async (e: React.FormEvent) => {
        e.preventDefault();
        setSaving(true);
        setMessage(null);

        const payload = {
            id: editingRes ? editingRes.id : undefined,
            title,
            type,
            fileUrl,
            category,
        };

        try {
            const res = await fetch('/api/admin/content', {
                method: editingRes ? 'PUT' : 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    type: 'resources',
                    item: payload,
                }),
            });

            const data = await res.json();
            if (data.success) {
                setMessage({ type: 'success', text: editingRes ? 'Resource saved!' : 'Resource added!' });
                setTimeout(() => {
                    setShowModal(false);
                    fetchResources();
                }, 800);
            } else {
                setMessage({ type: 'error', text: data.error || 'Failed to save resource' });
            }
        } catch (err) {
            setMessage({ type: 'error', text: 'Error saving resource' });
        } finally {
            setSaving(false);
        }
    };

    const handleDelete = async (item: any) => {
        if (!confirm(`Delete resource "${item.title}"?`)) return;
        try {
            const res = await fetch(`/api/admin/content?type=resources&id=${item.id}`, { method: 'DELETE' });
            const data = await res.json();
            if (data.success) {
                setResources(resources.filter((r) => r.id !== item.id));
            } else {
                alert(data.error || 'Delete failed');
            }
        } catch (err) {
            console.error('Delete error:', err);
        }
    };

    const filtered = resources.filter(
        (r) =>
            r.title?.toLowerCase().includes(search.toLowerCase()) ||
            r.category?.toLowerCase().includes(search.toLowerCase()) ||
            r.type?.toLowerCase().includes(search.toLowerCase())
    );

    return (
        <div className="space-y-6">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h1 className="text-xl font-bold text-white flex items-center gap-2">
                        <FileText className="h-5 w-5 text-amber-400" />
                        <span>Resources &amp; Technical Downloads</span>
                    </h1>
                    <p className="text-xs text-slate-400">
                        {filtered.length} equipment specification sheets, certificates, and brochures
                    </p>
                </div>

                <button
                    onClick={() => handleOpenModal()}
                    className="inline-flex items-center gap-2 px-4 py-2.5 bg-amber-600 hover:bg-amber-500 text-white rounded-xl text-xs font-semibold shadow-lg shadow-amber-600/30 transition-all cursor-pointer self-start sm:self-auto"
                >
                    <Plus className="h-4 w-4" />
                    <span>Upload New Resource</span>
                </button>
            </div>

            <div className="bg-slate-900 border border-slate-800 rounded-2xl p-4 shadow-lg">
                <div className="relative max-w-md">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-500" />
                    <input
                        type="text"
                        placeholder="Search resources by document title, category..."
                        value={search}
                        onChange={(e) => setSearch(e.target.value)}
                        className="w-full pl-9 pr-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 placeholder-slate-500 focus:outline-none focus:border-amber-500"
                    />
                </div>
            </div>

            <div className="bg-slate-900 border border-slate-800 rounded-2xl shadow-xl overflow-hidden">
                <div className="overflow-x-auto">
                    <table className="w-full text-left border-collapse text-xs">
                        <thead>
                            <tr className="border-b border-slate-800 text-slate-400 font-semibold uppercase text-[10px] tracking-wider bg-slate-950/60">
                                <th className="py-3.5 px-4">Document Title</th>
                                <th className="py-3.5 px-4">Type</th>
                                <th className="py-3.5 px-4">Category</th>
                                <th className="py-3.5 px-4">File Path / URL</th>
                                <th className="py-3.5 px-4 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-slate-800/60">
                            {loading ? (
                                <tr>
                                    <td colSpan={5} className="py-12 text-center text-slate-400">
                                        <Loader2 className="h-7 w-7 animate-spin text-amber-500 mx-auto mb-2" />
                                        <span>Loading technical resources...</span>
                                    </td>
                                </tr>
                            ) : filtered.length > 0 ? (
                                filtered.map((item) => (
                                    <tr key={item.id} className="hover:bg-slate-800/40 transition-colors group">
                                        <td className="py-3 px-4 font-bold text-slate-100 group-hover:text-amber-400 transition-colors">
                                            {item.title}
                                        </td>
                                        <td className="py-3 px-4">
                                            <span className="px-2 py-0.5 rounded-md text-[10px] font-semibold bg-amber-950 text-amber-400 border border-amber-800/40">
                                                {item.type || 'PDF'}
                                            </span>
                                        </td>
                                        <td className="py-3 px-4 text-slate-400 font-medium">{item.category || 'General'}</td>
                                        <td className="py-3 px-4 text-slate-500 font-mono text-[11px] truncate max-w-xs">
                                            {item.fileUrl}
                                        </td>
                                        <td className="py-3 px-4 text-right space-x-2">
                                            {item.fileUrl && (
                                                <a
                                                    href={item.fileUrl}
                                                    target="_blank"
                                                    rel="noopener noreferrer"
                                                    className="inline-flex items-center justify-center h-8 w-8 rounded-lg bg-slate-950 hover:bg-slate-800 text-slate-400 hover:text-white border border-slate-800 transition-colors"
                                                    title="Open Document"
                                                >
                                                    <ExternalLink className="h-3.5 w-3.5" />
                                                </a>
                                            )}
                                            <button
                                                onClick={() => handleOpenModal(item)}
                                                className="inline-flex items-center justify-center h-8 w-8 rounded-lg bg-blue-600/10 hover:bg-blue-600/20 text-blue-400 border border-blue-500/20 transition-colors cursor-pointer"
                                                title="Edit Resource"
                                            >
                                                <Edit3 className="h-3.5 w-3.5" />
                                            </button>
                                            <button
                                                onClick={() => handleDelete(item)}
                                                className="inline-flex items-center justify-center h-8 w-8 rounded-lg bg-red-600/10 hover:bg-red-600/20 text-red-400 border border-red-500/20 transition-colors cursor-pointer"
                                                title="Delete Resource"
                                            >
                                                <Trash2 className="h-3.5 w-3.5" />
                                            </button>
                                        </td>
                                    </tr>
                                ))
                            ) : (
                                <tr>
                                    <td colSpan={5} className="py-12 text-center text-slate-500">
                                        No resources match your search.
                                    </td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>
            </div>

            {showModal && (
                <div className="fixed inset-0 bg-slate-950/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
                    <form
                        onSubmit={handleSave}
                        className="bg-slate-900 border border-slate-800 rounded-2xl max-w-md w-full p-6 space-y-4 shadow-2xl animate-in fade-in zoom-in-95"
                    >
                        <div className="flex items-center justify-between border-b border-slate-800 pb-3">
                            <h3 className="text-base font-bold text-white flex items-center gap-2">
                                <FileText className="h-5 w-5 text-amber-400" />
                                <span>{editingRes ? `Edit Resource #${editingRes.id}` : 'Add Technical Resource'}</span>
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
                            <label className="block text-xs font-semibold text-slate-300 mb-1">Document Title *</label>
                            <input
                                type="text"
                                required
                                value={title}
                                onChange={(e) => setTitle(e.target.value)}
                                placeholder="e.g. Subsea Christmas Tree Product Brochure"
                                className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-100 placeholder-slate-500 focus:outline-none focus:border-amber-500"
                            />
                        </div>

                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div>
                                <label className="block text-xs font-semibold text-slate-300 mb-1">Document Type</label>
                                <input
                                    type="text"
                                    value={type}
                                    onChange={(e) => setType(e.target.value)}
                                    placeholder="PDF Brochure, CAD Spec..."
                                    className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-amber-500"
                                />
                            </div>

                            <div>
                                <label className="block text-xs font-semibold text-slate-300 mb-1">Category</label>
                                <input
                                    type="text"
                                    value={category}
                                    onChange={(e) => setCategory(e.target.value)}
                                    placeholder="Technical Specs, Catalog..."
                                    className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-amber-500"
                                />
                            </div>
                        </div>

                        <div>
                            <ImageUploader
                                accept=".pdf,.doc,.docx,image/*"
                                value={fileUrl}
                                onChange={setFileUrl}
                                label="Upload PDF Specification Asset to Cloudinary"
                                folder="wom_resources"
                                placeholder="Click or drop PDF / Specification file to upload"
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
                                className="px-4 py-2 rounded-xl text-xs font-semibold bg-amber-600 hover:bg-amber-500 text-white shadow-lg shadow-amber-600/30 transition-colors flex items-center gap-2 cursor-pointer"
                            >
                                {saving && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
                                <span>{editingRes ? 'Save Resource' : 'Add Resource'}</span>
                            </button>
                        </div>
                    </form>
                </div>
            )}
        </div>
    );
}
