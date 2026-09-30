'use client';

import React, { useState, useEffect } from 'react';
import {
    Inbox,
    Mail,
    Search,
    Filter,
    Clock,
    Trash2,
    CheckCircle2,
    Archive,
    RefreshCw,
    Loader2,
    User,
    Building2,
    Phone,
    ExternalLink
} from 'lucide-react';

export default function AdminInquiriesPage() {
    const [inquiries, setInquiries] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [filterStatus, setFilterStatus] = useState<string>('all');
    const [selectedInquiry, setSelectedInquiry] = useState<any | null>(null);

    const fetchInquiries = async () => {
        setLoading(true);
        try {
            const res = await fetch('/api/admin/inquiries');
            const data = await res.json();
            if (data.success) {
                setInquiries(data.data || []);
            }
        } catch (err) {
            console.error('Error loading inquiries:', err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchInquiries();
    }, []);

    const updateStatus = async (id: any, status: string) => {
        try {
            await fetch('/api/admin/inquiries', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ id, status }),
            });
            fetchInquiries();
            if (selectedInquiry?.id === id) {
                setSelectedInquiry((prev: any) => (prev ? { ...prev, status } : null));
            }
        } catch (err) {
            console.error('Error updating status:', err);
        }
    };

    const deleteInquiry = async (id: any) => {
        if (!confirm('Are you sure you want to delete this inquiry?')) return;
        try {
            await fetch(`/api/admin/inquiries?id=${id}`, { method: 'DELETE' });
            fetchInquiries();
            if (selectedInquiry?.id === id) setSelectedInquiry(null);
        } catch (err) {
            console.error('Error deleting inquiry:', err);
        }
    };

    const filtered = inquiries.filter((item) => {
        const matchesFilter = filterStatus === 'all' || item.status === filterStatus;
        const matchesSearch =
            (item.name || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
            (item.email || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
            (item.company || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
            (item.subject || '').toLowerCase().includes(searchTerm.toLowerCase());
        return matchesFilter && matchesSearch;
    });

    const unreadCount = inquiries.filter((i) => i.status === 'unread').length;

    return (
        <div className="space-y-6 max-w-7xl mx-auto">
            {/* Top Banner */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
                <div>
                    <h1 className="text-2xl font-black text-white tracking-tight flex items-center gap-2.5">
                        <Inbox className="h-6 w-6 text-blue-400" />
                        <span>Customer Contact Inquiries</span>
                        {unreadCount > 0 && (
                            <span className="px-2.5 py-0.5 rounded-full bg-blue-600 text-white text-xs font-bold animate-pulse">
                                {unreadCount} New
                            </span>
                        )}
                    </h1>
                    <p className="text-xs text-slate-400 mt-1">
                        View and respond to leads and inquiries submitted through the website contact forms.
                    </p>
                </div>

                <button
                    onClick={fetchInquiries}
                    disabled={loading}
                    className="self-start sm:self-auto px-4 py-2 bg-slate-900 hover:bg-slate-800 border border-slate-800 rounded-xl text-xs font-semibold text-slate-300 flex items-center gap-2 transition-colors cursor-pointer"
                >
                    <RefreshCw className={`h-3.5 w-3.5 ${loading ? 'animate-spin' : ''}`} />
                    <span>Refresh Inbox</span>
                </button>
            </div>

            {/* Filter Controls & Search */}
            <div className="flex flex-col md:flex-row items-center justify-between gap-4 bg-slate-900 border border-slate-800 p-4 rounded-2xl">
                <div className="relative w-full md:w-80">
                    <Search className="h-4 w-4 text-slate-500 absolute left-3.5 top-3" />
                    <input
                        type="text"
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        placeholder="Search by name, email, company..."
                        className="w-full pl-10 pr-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-100 placeholder-slate-500 focus:outline-none focus:border-blue-500 transition-colors"
                    />
                </div>

                <div className="flex items-center gap-2 w-full md:w-auto overflow-x-auto pb-1 md:pb-0">
                    {['all', 'unread', 'read', 'archived'].map((status) => (
                        <button
                            key={status}
                            onClick={() => setFilterStatus(status)}
                            className={`px-3 py-1.5 rounded-xl text-xs font-bold capitalize transition-all shrink-0 ${filterStatus === status
                                    ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30'
                                    : 'bg-slate-950 text-slate-400 hover:text-slate-200 border border-slate-800'
                                }`}
                        >
                            {status}
                        </button>
                    ))}
                </div>
            </div>

            {/* Main Content Layout */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                {/* List View (1 or 2 cols) */}
                <div className="lg:col-span-1 bg-slate-900 border border-slate-800 rounded-2xl overflow-hidden shadow-xl flex flex-col h-[600px]">
                    <div className="p-4 border-b border-slate-800 bg-slate-950/60 flex items-center justify-between text-xs font-semibold text-slate-400">
                        <span>All Messages ({filtered.length})</span>
                        <Filter className="h-3.5 w-3.5" />
                    </div>

                    <div className="flex-1 overflow-y-auto divide-y divide-slate-800/60">
                        {loading ? (
                            <div className="p-8 text-center text-slate-500 space-y-2">
                                <Loader2 className="h-6 w-6 animate-spin text-blue-500 mx-auto" />
                                <p className="text-xs">Loading inquiries...</p>
                            </div>
                        ) : filtered.length > 0 ? (
                            filtered.map((item) => {
                                const isSelected = selectedInquiry?.id === item.id;
                                const isUnread = item.status === 'unread';

                                return (
                                    <div
                                        key={item.id}
                                        onClick={() => {
                                            setSelectedInquiry(item);
                                            if (isUnread) updateStatus(item.id, 'read');
                                        }}
                                        className={`p-4 cursor-pointer transition-all ${isSelected
                                                ? 'bg-blue-600/10 border-l-4 border-blue-500'
                                                : isUnread
                                                    ? 'bg-slate-950/80 font-bold hover:bg-slate-800/40'
                                                    : 'hover:bg-slate-800/30 text-slate-400'
                                            }`}
                                    >
                                        <div className="flex items-center justify-between mb-1">
                                            <span className={`text-xs ${isUnread ? 'text-white font-bold' : 'text-slate-200'}`}>
                                                {item.name}
                                            </span>
                                            <span className="text-[10px] text-slate-500">
                                                {new Date(item.created_at || Date.now()).toLocaleDateString()}
                                            </span>
                                        </div>

                                        <p className="text-xs text-blue-400 font-medium truncate">{item.subject || 'Website Inquiry'}</p>
                                        <p className="text-[11px] text-slate-500 truncate mt-1">{item.message}</p>
                                    </div>
                                );
                            })
                        ) : (
                            <div className="p-8 text-center text-slate-500 text-xs">No inquiries found matching criteria.</div>
                        )}
                    </div>
                </div>

                {/* Detail View Panel (2 cols) */}
                <div className="lg:col-span-2 bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl h-[600px] flex flex-col">
                    {selectedInquiry ? (
                        <div className="flex-1 flex flex-col justify-between space-y-6 overflow-y-auto">
                            <div className="space-y-6">
                                {/* Header Info */}
                                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
                                    <div>
                                        <span className="px-2.5 py-1 rounded-md bg-blue-950 text-blue-400 border border-blue-800/40 text-[10px] font-bold uppercase tracking-wider">
                                            {selectedInquiry.status || 'Received'}
                                        </span>
                                        <h2 className="text-xl font-bold text-white mt-2">
                                            {selectedInquiry.subject || 'Website Contact Form Inquiry'}
                                        </h2>
                                        <p className="text-xs text-slate-400 flex items-center gap-1.5 mt-1">
                                            <Clock className="h-3.5 w-3.5" />
                                            <span>Received on {new Date(selectedInquiry.created_at || Date.now()).toLocaleString()}</span>
                                        </p>
                                    </div>

                                    {/* Action Buttons */}
                                    <div className="flex items-center gap-2">
                                        <button
                                            onClick={() => updateStatus(selectedInquiry.id, 'archived')}
                                            className="p-2 bg-slate-950 hover:bg-slate-800 text-slate-400 hover:text-amber-400 border border-slate-800 rounded-xl text-xs transition-colors"
                                            title="Archive"
                                        >
                                            <Archive className="h-4 w-4" />
                                        </button>
                                        <button
                                            onClick={() => deleteInquiry(selectedInquiry.id)}
                                            className="p-2 bg-slate-950 hover:bg-slate-800 text-slate-400 hover:text-red-400 border border-slate-800 rounded-xl text-xs transition-colors"
                                            title="Delete"
                                        >
                                            <Trash2 className="h-4 w-4" />
                                        </button>
                                    </div>
                                </div>

                                {/* Contact Details Card */}
                                <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 bg-slate-950 p-4 rounded-xl border border-slate-800 text-xs">
                                    <div className="flex items-center gap-2.5">
                                        <User className="h-4 w-4 text-blue-400" />
                                        <div>
                                            <p className="text-slate-500 text-[10px]">Contact Name</p>
                                            <p className="font-semibold text-slate-200">{selectedInquiry.name}</p>
                                        </div>
                                    </div>

                                    <div className="flex items-center gap-2.5">
                                        <Mail className="h-4 w-4 text-cyan-400" />
                                        <div>
                                            <p className="text-slate-500 text-[10px]">Email Address</p>
                                            <a href={`mailto:${selectedInquiry.email}`} className="font-semibold text-blue-400 hover:underline">
                                                {selectedInquiry.email}
                                            </a>
                                        </div>
                                    </div>

                                    <div className="flex items-center gap-2.5">
                                        <Building2 className="h-4 w-4 text-purple-400" />
                                        <div>
                                            <p className="text-slate-500 text-[10px]">Company / Phone</p>
                                            <p className="font-semibold text-slate-200">
                                                {selectedInquiry.company || 'N/A'} {selectedInquiry.phone ? `(${selectedInquiry.phone})` : ''}
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                {/* Message Body */}
                                <div>
                                    <h4 className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-2">Inquiry Message Body</h4>
                                    <div className="p-5 bg-slate-950 rounded-xl border border-slate-800/80 text-slate-200 text-xs leading-relaxed whitespace-pre-wrap font-sans">
                                        {selectedInquiry.message}
                                    </div>
                                </div>
                            </div>

                            {/* Reply Action */}
                            <div className="pt-4 border-t border-slate-800 flex items-center justify-between">
                                <span className="text-xs text-slate-500">
                                    Status: <strong className="text-slate-300 capitalize">{selectedInquiry.status}</strong>
                                </span>
                                <a
                                    href={`mailto:${selectedInquiry.email}?subject=Re: ${encodeURIComponent(selectedInquiry.subject || 'WOM Group Inquiry')}`}
                                    className="px-4 py-2.5 bg-blue-600 hover:bg-blue-500 text-white rounded-xl text-xs font-semibold flex items-center gap-2 shadow-lg shadow-blue-600/30 transition-all"
                                >
                                    <Mail className="h-4 w-4" />
                                    <span>Reply via Email</span>
                                    <ExternalLink className="h-3 w-3" />
                                </a>
                            </div>
                        </div>
                    ) : (
                        <div className="flex-1 flex flex-col items-center justify-center text-center text-slate-500 p-8 space-y-3">
                            <Inbox className="h-12 w-12 text-slate-700" />
                            <h3 className="text-sm font-bold text-slate-400">No Inquiry Selected</h3>
                            <p className="text-xs max-w-xs text-slate-500">
                                Select an inquiry message from the list on the left to read details and send a response.
                            </p>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
