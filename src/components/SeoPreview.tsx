'use client';

import React from 'react';
import { Search, Globe, AlertCircle, CheckCircle2 } from 'lucide-react';

interface SeoPreviewProps {
    title: string;
    description: string;
    slug: string;
    baseUrl?: string;
    category?: string;
}

export default function SeoPreview({
    title,
    description,
    slug,
    baseUrl,
    category = 'products',
}: SeoPreviewProps) {
    const defaultDomain = process.env.NEXT_PUBLIC_SITE_URL || (typeof window !== 'undefined' ? window.location.origin : 'https://womgroup.com');
    const effectiveBaseUrl = baseUrl || defaultDomain;

    const displayTitle = title ? `${title} - WOM Group` : 'Page Title - WOM Group';
    const displaySlug = slug || 'page-slug';
    const displayUrl = `${effectiveBaseUrl}/${category}/${displaySlug}`;
    const displayDesc = description || 'Please enter a search engine description for this content...';

    const titleLength = displayTitle.length;
    const descLength = description.length;

    const isTitleOk = titleLength >= 10 && titleLength <= 60;
    const isDescOk = descLength >= 50 && descLength <= 160;

    return (
        <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 space-y-4">
            <div className="flex items-center justify-between border-b border-slate-800 pb-3">
                <div className="flex items-center gap-2 text-xs font-bold text-slate-200">
                    <Search className="h-4 w-4 text-blue-400" />
                    <span>Google Search Result Snippet Preview</span>
                </div>
                <div className="flex items-center gap-2 text-[11px]">
                    <span className={`px-2 py-0.5 rounded-full flex items-center gap-1 font-semibold ${isTitleOk ? 'bg-emerald-950 text-emerald-400 border border-emerald-800/40' : 'bg-amber-950 text-amber-400 border border-amber-800/40'}`}>
                        Title: {titleLength}/60 chars
                    </span>
                    <span className={`px-2 py-0.5 rounded-full flex items-center gap-1 font-semibold ${isDescOk ? 'bg-emerald-950 text-emerald-400 border border-emerald-800/40' : 'bg-amber-950 text-amber-400 border border-amber-800/40'}`}>
                        Desc: {descLength}/160 chars
                    </span>
                </div>
            </div>

            {/* Google Card Simulation */}
            <div className="p-4 rounded-xl bg-slate-950 border border-slate-800/80 font-sans space-y-1.5">
                <div className="flex items-center gap-2 text-xs text-slate-400 truncate">
                    <div className="h-4 w-4 rounded-full bg-blue-600/20 text-blue-400 flex items-center justify-center text-[9px] font-bold shrink-0">
                        W
                    </div>
                    <div className="flex flex-col">
                        <span className="text-[11px] font-medium text-slate-300 leading-tight">WOM Group</span>
                        <span className="text-[10px] text-slate-500 truncate leading-tight">{displayUrl}</span>
                    </div>
                </div>

                <h3 className="text-base font-semibold text-blue-400 hover:underline cursor-pointer truncate tracking-tight">
                    {displayTitle}
                </h3>

                <p className="text-xs text-slate-400 line-clamp-2 leading-relaxed">
                    {displayDesc}
                </p>
            </div>

            {/* Recommendations */}
            <div className="text-[11px] space-y-1 text-slate-400 pt-1">
                {!isTitleOk && (
                    <div className="flex items-center gap-1.5 text-amber-400">
                        <AlertCircle className="h-3.5 w-3.5 shrink-0" />
                        <span>Optimal title length is between 30 to 60 characters for search visibility.</span>
                    </div>
                )}
                {!isDescOk && (
                    <div className="flex items-center gap-1.5 text-amber-400">
                        <AlertCircle className="h-3.5 w-3.5 shrink-0" />
                        <span>Optimal meta description length is between 50 to 160 characters.</span>
                    </div>
                )}
                {isTitleOk && isDescOk && (
                    <div className="flex items-center gap-1.5 text-emerald-400">
                        <CheckCircle2 className="h-3.5 w-3.5 shrink-0" />
                        <span>SEO metadata is well optimized for search engine indexing!</span>
                    </div>
                )}
            </div>
        </div>
    );
}
