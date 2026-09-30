'use client';

import React, { useState, useEffect } from 'react';
import {
    Settings,
    Database,
    Cloud,
    Mail,
    Save,
    CheckCircle2,
    AlertTriangle,
    Loader2,
    FileText,
    Copy,
    Check,
    Globe,
    Shield
} from 'lucide-react';

export default function AdminSettingsPage() {
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [status, setStatus] = useState<any>({});
    const [manifest, setManifest] = useState<any>({});
    const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null);
    const [copiedSql, setCopiedSql] = useState(false);

    useEffect(() => {
        async function fetchSettings() {
            try {
                const res = await fetch('/api/admin/settings');
                const data = await res.json();
                if (data.success) {
                    setManifest(data.manifest || {});
                    setStatus(data.status || {});
                }
            } catch (err) {
                console.error('Failed to load settings:', err);
            } finally {
                setLoading(false);
            }
        }
        fetchSettings();
    }, []);

    const handleSave = async (e: React.FormEvent) => {
        e.preventDefault();
        setSaving(true);
        setMessage(null);

        try {
            const res = await fetch('/api/admin/settings', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ manifest }),
            });
            const data = await res.json();

            if (data.success) {
                setMessage({ type: 'success', text: 'Site settings updated successfully!' });
            } else {
                setMessage({ type: 'error', text: data.error || 'Failed to save settings' });
            }
        } catch (err) {
            setMessage({ type: 'error', text: 'Network server error' });
        } finally {
            setSaving(false);
        }
    };

    if (loading) {
        return (
            <div className="py-20 text-center text-slate-400 space-y-3">
                <Loader2 className="h-8 w-8 animate-spin text-blue-500 mx-auto" />
                <p className="text-sm font-medium">Loading system settings...</p>
            </div>
        );
    }

    return (
        <form onSubmit={handleSave} className="space-y-8 max-w-5xl mx-auto pb-12">
            {/* Header */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
                <div>
                    <h1 className="text-2xl font-black text-white tracking-tight flex items-center gap-2.5">
                        <Settings className="h-6 w-6 text-blue-400" />
                        <span>System Settings &amp; Integrations</span>
                    </h1>
                    <p className="text-xs text-slate-400 mt-1">
                        Configure global brand metadata, manage backend integrations, and export Supabase SQL schemas.
                    </p>
                </div>

                <button
                    type="submit"
                    disabled={saving}
                    className="px-5 py-2.5 bg-blue-600 hover:bg-blue-500 text-white rounded-xl text-xs font-semibold flex items-center gap-2 shadow-lg shadow-blue-600/30 transition-all cursor-pointer disabled:opacity-50"
                >
                    {saving ? <Loader2 className="h-4 w-4 animate-spin" /> : <Save className="h-4 w-4" />}
                    <span>Save Settings</span>
                </button>
            </div>

            {message && (
                <div
                    className={`p-4 rounded-2xl flex items-center gap-3 text-xs font-semibold ${message.type === 'success'
                            ? 'bg-emerald-950/80 border border-emerald-800/60 text-emerald-300'
                            : 'bg-red-950/80 border border-red-800/60 text-red-300'
                        }`}
                >
                    <CheckCircle2 className="h-5 w-5 shrink-0" />
                    <span>{message.text}</span>
                </div>
            )}

            {/* Integration Status Overview */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                {/* Supabase Status */}
                <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-xl space-y-3 relative overflow-hidden">
                    <div className="flex items-center justify-between">
                        <div className="p-2.5 rounded-xl bg-gradient-to-br from-emerald-600 to-teal-600 text-white shadow-md">
                            <Database className="h-5 w-5" />
                        </div>
                        <span
                            className={`px-2.5 py-0.5 rounded-full text-[10px] font-bold ${status.supabase
                                    ? 'bg-emerald-950 text-emerald-400 border border-emerald-800/60'
                                    : 'bg-amber-950 text-amber-400 border border-amber-800/60'
                                }`}
                        >
                            {status.supabase ? 'Supabase Active' : 'Ready (JSON Fallback)'}
                        </span>
                    </div>
                    <div>
                        <h3 className="text-sm font-bold text-white">Supabase Backend</h3>
                        <p className="text-[11px] text-slate-400 mt-1">
                            PostgreSQL database &amp; Auth. Set <code className="text-blue-400 font-mono">NEXT_PUBLIC_SUPABASE_URL</code> in <code className="text-slate-300 font-mono">.env.local</code> to activate.
                        </p>
                    </div>
                </div>

                {/* Cloudinary Status */}
                <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-xl space-y-3 relative overflow-hidden">
                    <div className="flex items-center justify-between">
                        <div className="p-2.5 rounded-xl bg-gradient-to-br from-blue-600 to-cyan-600 text-white shadow-md">
                            <Cloud className="h-5 w-5" />
                        </div>
                        <span
                            className={`px-2.5 py-0.5 rounded-full text-[10px] font-bold ${status.cloudinary
                                    ? 'bg-blue-950 text-blue-400 border border-blue-800/60'
                                    : 'bg-slate-800 text-slate-400'
                                }`}
                        >
                            {status.cloudinary ? 'Cloudinary CDN Active' : 'Local Storage Fallback'}
                        </span>
                    </div>
                    <div>
                        <h3 className="text-sm font-bold text-white">Cloudinary Asset Host</h3>
                        <p className="text-[11px] text-slate-400 mt-1">
                            High-performance media CDN. Set <code className="text-blue-400 font-mono">CLOUDINARY_CLOUD_NAME</code> to activate CDN uploads.
                        </p>
                    </div>
                </div>

                {/* SMTP Email Notifications Status */}
                <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-xl space-y-3 relative overflow-hidden">
                    <div className="flex items-center justify-between">
                        <div className="p-2.5 rounded-xl bg-gradient-to-br from-purple-600 to-indigo-600 text-white shadow-md">
                            <Mail className="h-5 w-5" />
                        </div>
                        <span
                            className={`px-2.5 py-0.5 rounded-full text-[10px] font-bold ${status.smtp
                                    ? 'bg-purple-950 text-purple-400 border border-purple-800/60'
                                    : 'bg-slate-800 text-slate-400'
                                }`}
                        >
                            {status.smtp ? 'SMTP Email Ready' : 'Inbox Only Mode'}
                        </span>
                    </div>
                    <div>
                        <h3 className="text-sm font-bold text-white">SMTP Email Alerts</h3>
                        <p className="text-[11px] text-slate-400 mt-1">
                            Sends email alerts on contact inquiry. Set <code className="text-blue-400 font-mono">SMTP_HOST</code> &amp; <code className="text-blue-400 font-mono">SMTP_USER</code> in <code className="text-slate-300 font-mono">.env</code>.
                        </p>
                    </div>
                </div>
            </div>

            {/* SQL Export Box */}
            <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-4">
                <div className="flex items-center justify-between">
                    <div>
                        <h3 className="text-sm font-bold text-white flex items-center gap-2">
                            <FileText className="h-4 w-4 text-emerald-400" />
                            <span>Supabase SQL Database Export</span>
                        </h3>
                        <p className="text-xs text-slate-400 mt-0.5">
                            Use this generated SQL file to manually import all tables and content into your Supabase Dashboard.
                        </p>
                    </div>
                    <a
                        href="/supabase/schema.sql"
                        download="schema.sql"
                        className="px-3.5 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-semibold flex items-center gap-1.5 transition-colors shadow-md shadow-emerald-600/20"
                    >
                        <FileText className="h-3.5 w-3.5" />
                        <span>Download schema.sql</span>
                    </a>
                </div>

                <div className="p-3 bg-slate-950 rounded-xl border border-slate-800 text-xs font-mono text-slate-400 flex items-center justify-between">
                    <span>File location: <code className="text-emerald-400">/supabase/schema.sql</code></span>
                    <span className="text-[11px] text-slate-500">Includes 7 tables + RLS Policies + Seed Data</span>
                </div>
            </div>

            {/* Brand Settings Form */}
            <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-6">
                <h3 className="text-sm font-bold text-white flex items-center gap-2">
                    <Globe className="h-4 w-4 text-blue-400" />
                    <span>Global Website &amp; Brand Settings</span>
                </h3>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label className="block text-xs font-semibold text-slate-300 mb-1">Website Title</label>
                        <input
                            type="text"
                            value={manifest.name || 'Worldwide Oilfield Machine (WOM Group)'}
                            onChange={(e) => setManifest({ ...manifest, name: e.target.value })}
                            className="w-full px-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-blue-500"
                        />
                    </div>

                    <div>
                        <label className="block text-xs font-semibold text-slate-300 mb-1">Support / Contact Email</label>
                        <input
                            type="email"
                            value={manifest.email || 'info@womgroup.com'}
                            onChange={(e) => setManifest({ ...manifest, email: e.target.value })}
                            className="w-full px-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-blue-500"
                        />
                    </div>
                </div>

                <div>
                    <label className="block text-xs font-semibold text-slate-300 mb-1">Company Description</label>
                    <textarea
                        rows={3}
                        value={manifest.description || ''}
                        onChange={(e) => setManifest({ ...manifest, description: e.target.value })}
                        className="w-full px-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-blue-500"
                    />
                </div>
            </div>
        </form>
    );
}
