'use client';

import React, { useState, useEffect } from 'react';
import {
    MapPin,
    Plus,
    Search,
    Edit3,
    Trash2,
    Loader2,
    CheckCircle2,
    AlertCircle,
    X,
    Globe,
    Phone,
    Mail,
    Building2
} from 'lucide-react';

export default function LocationsManagerPage() {
    const [locations, setLocations] = useState<any[]>([]);
    const [search, setSearch] = useState('');
    const [loading, setLoading] = useState(true);

    // Modal state
    const [showModal, setShowModal] = useState(false);
    const [editingLoc, setEditingLoc] = useState<any | null>(null);

    const [name, setName] = useState('');
    const [slug, setSlug] = useState('');
    const [type, setType] = useState('Manufacturing Facility');
    const [country, setCountry] = useState('USA');
    const [address, setAddress] = useState('');
    const [phone, setPhone] = useState('');
    const [email, setEmail] = useState('');
    const [saving, setSaving] = useState(false);
    const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

    const fetchLocations = async () => {
        setLoading(true);
        try {
            const res = await fetch('/api/admin/content?type=locations');
            const json = await res.json();
            if (json.success) setLocations(json.data || []);
        } catch (err) {
            console.error('Error loading locations:', err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchLocations();
    }, []);

    const handleOpenModal = (loc?: any) => {
        setMessage(null);
        if (loc) {
            setEditingLoc(loc);
            setName(loc.name || '');
            setSlug(loc.slug || '');
            setType(loc.type || 'Manufacturing Facility');
            setCountry(loc.country || 'USA');
            setAddress(loc.address || '');
            setPhone(loc.phone || '');
            setEmail(loc.email || '');
        } else {
            setEditingLoc(null);
            setName('');
            setSlug('');
            setType('Manufacturing Facility');
            setCountry('USA');
            setAddress('');
            setPhone('');
            setEmail('');
        }
        setShowModal(true);
    };

    const handleSave = async (e: React.FormEvent) => {
        e.preventDefault();
        setSaving(true);
        setMessage(null);

        const payload = {
            id: editingLoc ? editingLoc.id : undefined,
            name,
            slug: slug || name.toLowerCase().replace(/\s+/g, '-'),
            type,
            country,
            address,
            phone,
            email,
        };

        try {
            const res = await fetch('/api/admin/content', {
                method: editingLoc ? 'PUT' : 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    type: 'locations',
                    item: payload,
                }),
            });

            const data = await res.json();
            if (data.success) {
                setMessage({ type: 'success', text: editingLoc ? 'Location updated!' : 'Location added!' });
                setTimeout(() => {
                    setShowModal(false);
                    fetchLocations();
                }, 800);
            } else {
                setMessage({ type: 'error', text: data.error || 'Failed to save location' });
            }
        } catch (err) {
            setMessage({ type: 'error', text: 'Error saving location' });
        } finally {
            setSaving(false);
        }
    };

    const handleDelete = async (loc: any) => {
        if (!confirm(`Are you sure you want to delete "${loc.name}"?`)) return;
        try {
            const res = await fetch(`/api/admin/content?type=locations&id=${loc.id}`, { method: 'DELETE' });
            const data = await res.json();
            if (data.success) {
                setLocations(locations.filter((l) => l.id !== loc.id));
            } else {
                alert(data.error || 'Delete failed');
            }
        } catch (err) {
            console.error('Delete error:', err);
        }
    };

    const filtered = locations.filter(
        (l) =>
            l.name?.toLowerCase().includes(search.toLowerCase()) ||
            l.country?.toLowerCase().includes(search.toLowerCase()) ||
            l.address?.toLowerCase().includes(search.toLowerCase())
    );

    return (
        <div className="space-y-6">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h1 className="text-xl font-bold text-white flex items-center gap-2">
                        <MapPin className="h-5 w-5 text-emerald-400" />
                        <span>Global Facility Locations Manager</span>
                    </h1>
                    <p className="text-xs text-slate-400">
                        {filtered.length} manufacturing hubs, sales offices, and service centers
                    </p>
                </div>

                <button
                    onClick={() => handleOpenModal()}
                    className="inline-flex items-center gap-2 px-4 py-2.5 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-semibold shadow-lg shadow-emerald-600/30 transition-all cursor-pointer self-start sm:self-auto"
                >
                    <Plus className="h-4 w-4" />
                    <span>Add New Location</span>
                </button>
            </div>

            {/* Search Bar */}
            <div className="bg-slate-900 border border-slate-800 rounded-2xl p-4 shadow-lg">
                <div className="relative max-w-md">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-500" />
                    <input
                        type="text"
                        placeholder="Search locations by facility name, country, address..."
                        value={search}
                        onChange={(e) => setSearch(e.target.value)}
                        className="w-full pl-9 pr-4 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 placeholder-slate-500 focus:outline-none focus:border-emerald-500"
                    />
                </div>
            </div>

            {/* Locations Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                {loading ? (
                    <div className="col-span-full py-12 text-center text-slate-400">
                        <Loader2 className="h-7 w-7 animate-spin text-emerald-500 mx-auto mb-2" />
                        <span>Loading global locations...</span>
                    </div>
                ) : filtered.length > 0 ? (
                    filtered.map((loc) => (
                        <div
                            key={loc.id}
                            className="bg-slate-900 border border-slate-800 hover:border-slate-700 rounded-2xl p-5 shadow-lg flex flex-col justify-between transition-all group"
                        >
                            <div className="space-y-3">
                                <div className="flex items-center justify-between">
                                    <span className="px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-emerald-950 text-emerald-300 border border-emerald-800/40">
                                        {loc.country || 'Global'}
                                    </span>
                                    <span className="text-[11px] text-slate-500 font-medium">{loc.type}</span>
                                </div>

                                <h3 className="text-base font-bold text-white group-hover:text-emerald-400 transition-colors">
                                    {loc.name}
                                </h3>

                                <div className="space-y-1.5 text-xs text-slate-400 pt-1">
                                    {loc.address && (
                                        <div className="flex items-start gap-2">
                                            <Building2 className="h-3.5 w-3.5 text-slate-500 shrink-0 mt-0.5" />
                                            <span className="line-clamp-2">{loc.address}</span>
                                        </div>
                                    )}
                                    {loc.phone && (
                                        <div className="flex items-center gap-2">
                                            <Phone className="h-3.5 w-3.5 text-slate-500 shrink-0" />
                                            <span>{loc.phone}</span>
                                        </div>
                                    )}
                                    {loc.email && (
                                        <div className="flex items-center gap-2">
                                            <Mail className="h-3.5 w-3.5 text-slate-500 shrink-0" />
                                            <span className="truncate">{loc.email}</span>
                                        </div>
                                    )}
                                </div>
                            </div>

                            <div className="flex items-center justify-end gap-2 pt-4 mt-4 border-t border-slate-800/80">
                                <button
                                    onClick={() => handleOpenModal(loc)}
                                    className="px-3 py-1.5 rounded-lg bg-blue-600/10 hover:bg-blue-600/20 text-blue-400 border border-blue-500/20 text-xs font-medium transition-colors flex items-center gap-1 cursor-pointer"
                                >
                                    <Edit3 className="h-3.5 w-3.5" />
                                    <span>Edit</span>
                                </button>
                                <button
                                    onClick={() => handleDelete(loc)}
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
                        No facility locations match your search.
                    </div>
                )}
            </div>

            {/* Modal */}
            {showModal && (
                <div className="fixed inset-0 bg-slate-950/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
                    <form
                        onSubmit={handleSave}
                        className="bg-slate-900 border border-slate-800 rounded-2xl max-w-lg w-full p-6 space-y-4 shadow-2xl animate-in fade-in zoom-in-95"
                    >
                        <div className="flex items-center justify-between border-b border-slate-800 pb-3">
                            <h3 className="text-base font-bold text-white flex items-center gap-2">
                                <MapPin className="h-5 w-5 text-emerald-400" />
                                <span>{editingLoc ? `Edit Facility #${editingLoc.id}` : 'Add Facility Location'}</span>
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
                            <label className="block text-xs font-semibold text-slate-300 mb-1">Facility Name *</label>
                            <input
                                type="text"
                                required
                                value={name}
                                onChange={(e) => setName(e.target.value)}
                                placeholder="e.g. WOM USA Headquarters & Manufacturing Plant"
                                className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-100 placeholder-slate-500 focus:outline-none focus:border-emerald-500"
                            />
                        </div>

                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div>
                                <label className="block text-xs font-semibold text-slate-300 mb-1">Facility Type</label>
                                <select
                                    value={type}
                                    onChange={(e) => setType(e.target.value)}
                                    className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-emerald-500"
                                >
                                    <option value="Manufacturing Facility">Manufacturing Facility</option>
                                    <option value="Sales & Service Office">Sales &amp; Service Office</option>
                                    <option value="Technology & Testing Hub">Technology &amp; Testing Hub</option>
                                    <option value="Distribution Center">Distribution Center</option>
                                </select>
                            </div>

                            <div>
                                <label className="block text-xs font-semibold text-slate-300 mb-1">Country / Region</label>
                                <input
                                    type="text"
                                    required
                                    value={country}
                                    onChange={(e) => setCountry(e.target.value)}
                                    placeholder="e.g. USA, Scotland, UAE, India"
                                    className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-emerald-500"
                                />
                            </div>
                        </div>

                        <div>
                            <label className="block text-xs font-semibold text-slate-300 mb-1">Full Physical Address</label>
                            <textarea
                                rows={2}
                                value={address}
                                onChange={(e) => setAddress(e.target.value)}
                                placeholder="Street address, city, state/zip code..."
                                className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-emerald-500"
                            />
                        </div>

                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div>
                                <label className="block text-xs font-semibold text-slate-300 mb-1">Phone Contact</label>
                                <input
                                    type="text"
                                    value={phone}
                                    onChange={(e) => setPhone(e.target.value)}
                                    placeholder="+1 (713) 937-0777"
                                    className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-emerald-500"
                                />
                            </div>
                            <div>
                                <label className="block text-xs font-semibold text-slate-300 mb-1">Email Contact</label>
                                <input
                                    type="email"
                                    value={email}
                                    onChange={(e) => setEmail(e.target.value)}
                                    placeholder="info@womgroup.com"
                                    className="w-full px-3 py-2 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-200 focus:outline-none focus:border-emerald-500"
                                />
                            </div>
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
                                className="px-4 py-2 rounded-xl text-xs font-semibold bg-emerald-600 hover:bg-emerald-500 text-white shadow-lg shadow-emerald-600/30 transition-colors flex items-center gap-2 cursor-pointer"
                            >
                                {saving && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
                                <span>{editingLoc ? 'Save Location' : 'Add Location'}</span>
                            </button>
                        </div>
                    </form>
                </div>
            )}
        </div>
    );
}
