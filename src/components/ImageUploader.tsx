'use client';

import React, { useState } from 'react';
import { UploadCloud, CheckCircle2, AlertCircle, Loader2, Copy, Check, Image as ImageIcon, Cloud } from 'lucide-react';

interface ImageUploaderProps {
    value?: string;
    onChange: (url: string) => void;
    label?: string;
    folder?: string;
    accept?: string;
    placeholder?: string;
}

export default function ImageUploader({
    value = '',
    onChange,
    label = 'Upload Image / Asset',
    folder = 'womgroup_assets',
    accept = 'image/*',
    placeholder = 'Click or drop image to upload to Cloudinary',
}: ImageUploaderProps) {
    const [uploading, setUploading] = useState(false);
    const [copied, setCopied] = useState(false);
    const [statusMsg, setStatusMsg] = useState<{ type: 'success' | 'error'; text: string } | null>(null);
    const [dragActive, setDragActive] = useState(false);

    const handleFileSelect = async (file: File) => {
        if (!file) return;
        setUploading(true);
        setStatusMsg(null);

        const formData = new FormData();
        formData.append('file', file);
        formData.append('folder', folder);

        try {
            const res = await fetch('/api/admin/upload', {
                method: 'POST',
                body: formData,
            });
            const data = await res.json();

            if (data.success && data.url) {
                onChange(data.url);
                setStatusMsg({
                    type: 'success',
                    text: data.provider === 'cloudinary' ? 'Uploaded to Cloudinary CDN!' : 'Uploaded locally',
                });
            } else {
                setStatusMsg({ type: 'error', text: data.error || 'Upload failed' });
            }
        } catch (err: any) {
            setStatusMsg({ type: 'error', text: 'Network upload error' });
        } finally {
            setUploading(false);
        }
    };

    const handleDrop = (e: React.DragEvent) => {
        e.preventDefault();
        setDragActive(false);
        if (e.dataTransfer.files && e.dataTransfer.files[0]) {
            handleFileSelect(e.dataTransfer.files[0]);
        }
    };

    const handleCopy = () => {
        if (!value) return;
        navigator.clipboard.writeText(value);
        setCopied(true);
        setTimeout(() => setCopied(false), 2000);
    };

    return (
        <div className="space-y-2">
            {label && <label className="block text-xs font-semibold text-slate-300">{label}</label>}

            {/* Main Dropzone & Input Box */}
            <div
                onDragOver={(e) => {
                    e.preventDefault();
                    setDragActive(true);
                }}
                onDragLeave={() => setDragActive(false)}
                onDrop={handleDrop}
                className={`relative border-2 border-dashed rounded-xl p-4 transition-all ${dragActive
                        ? 'border-blue-500 bg-blue-500/10'
                        : value
                            ? 'border-slate-700 bg-slate-900/60'
                            : 'border-slate-800 bg-slate-950 hover:border-slate-700'
                    }`}
            >
                <input
                    type="file"
                    accept={accept}
                    onChange={(e) => e.target.files?.[0] && handleFileSelect(e.target.files[0])}
                    className="absolute inset-0 w-full h-full opacity-0 cursor-pointer z-10"
                    disabled={uploading}
                />

                <div className="flex flex-col items-center justify-center text-center gap-2 pointer-events-none">
                    {uploading ? (
                        <div className="flex items-center gap-2 text-blue-400 py-3">
                            <Loader2 className="h-6 w-6 animate-spin" />
                            <span className="text-xs font-semibold">Uploading asset...</span>
                        </div>
                    ) : value ? (
                        <div className="w-full flex items-center justify-between gap-3 pointer-events-auto">
                            <div className="flex items-center gap-3 overflow-hidden">
                                {value.match(/\.(jpg|jpeg|png|webp|svg|gif)$/i) || value.includes('cloudinary') ? (
                                    <div className="h-12 w-12 rounded-lg bg-slate-950 border border-slate-800 overflow-hidden shrink-0">
                                        <img src={value} alt="Uploaded preview" className="h-full w-full object-cover" />
                                    </div>
                                ) : (
                                    <div className="h-10 w-10 rounded-lg bg-blue-950 text-blue-400 flex items-center justify-center shrink-0">
                                        <ImageIcon className="h-5 w-5" />
                                    </div>
                                )}
                                <div className="text-left truncate">
                                    <p className="text-xs font-semibold text-slate-200 truncate">{value.split('/').pop()}</p>
                                    <p className="text-[10px] text-slate-400 truncate font-mono">{value}</p>
                                </div>
                            </div>

                            <div className="flex items-center gap-2">
                                <button
                                    type="button"
                                    onClick={handleCopy}
                                    className="p-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-300 transition-colors"
                                    title="Copy URL"
                                >
                                    {copied ? <Check className="h-3.5 w-3.5 text-emerald-400" /> : <Copy className="h-3.5 w-3.5" />}
                                </button>
                            </div>
                        </div>
                    ) : (
                        <div className="py-2">
                            <UploadCloud className="h-8 w-8 text-blue-400 mx-auto mb-1" />
                            <p className="text-xs font-semibold text-slate-300">{placeholder}</p>
                            <p className="text-[10px] text-slate-500 mt-0.5">Supports PNG, JPG, WEBP, SVG, PDF up to 20MB</p>
                        </div>
                    )}
                </div>
            </div>

            {/* Manual URL Override Input */}
            <div className="flex items-center gap-2">
                <div className="relative flex-1">
                    <Cloud className="h-3.5 w-3.5 text-slate-500 absolute left-3 top-2.5" />
                    <input
                        type="text"
                        value={value}
                        onChange={(e) => onChange(e.target.value)}
                        placeholder="Or paste direct Cloudinary URL here..."
                        className="w-full pl-8 pr-3 py-1.5 bg-slate-950 border border-slate-800 rounded-lg text-xs text-slate-300 font-mono focus:outline-none focus:border-blue-500"
                    />
                </div>
            </div>

            {/* Notification alert */}
            {statusMsg && (
                <div
                    className={`flex items-center gap-1.5 text-[11px] font-medium ${statusMsg.type === 'success' ? 'text-emerald-400' : 'text-red-400'
                        }`}
                >
                    {statusMsg.type === 'success' ? (
                        <CheckCircle2 className="h-3.5 w-3.5 shrink-0" />
                    ) : (
                        <AlertCircle className="h-3.5 w-3.5 shrink-0" />
                    )}
                    <span>{statusMsg.text}</span>
                </div>
            )}
        </div>
    );
}
