'use client';

import React from 'react';
import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import {
    LayoutDashboard,
    Package,
    FolderTree,
    Newspaper,
    MapPin,
    FileText,
    FileCode,
    ExternalLink,
    LogOut,
    ShieldCheck,
    Inbox,
    Settings,
    ChevronRight
} from 'lucide-react';

interface SidebarProps {
    user?: {
        name: string;
        email: string;
        role: string;
    } | null;
}

export default function AdminSidebar({ user }: SidebarProps) {
    const pathname = usePathname();
    const router = useRouter();

    const handleLogout = async () => {
        try {
            await fetch('/api/admin/auth', { method: 'DELETE' });
            router.push('/admin/login');
            router.refresh();
        } catch (err) {
            console.error('Logout error:', err);
        }
    };

    const navItems = [
        { href: '/admin', label: 'Dashboard', icon: LayoutDashboard },
        { href: '/admin/inquiries', label: 'Inquiries Inbox', icon: Inbox },
        { href: '/admin/products', label: 'Products Catalog', icon: Package },
        { href: '/admin/categories', label: 'Categories', icon: FolderTree },
        { href: '/admin/news', label: 'News & Media', icon: Newspaper },
        { href: '/admin/locations', label: 'Global Locations', icon: MapPin },
        { href: '/admin/resources', label: 'Resources & Downloads', icon: FileText },
        { href: '/admin/pages', label: 'Site Pages', icon: FileCode },
        { href: '/admin/settings', label: 'System Settings', icon: Settings },
    ];

    return (
        <aside className="w-64 bg-slate-900 border-r border-slate-800 text-slate-300 flex flex-col h-screen sticky top-0 z-40 select-none shadow-2xl">
            {/* Brand Header */}
            <div className="p-5 border-b border-slate-800 flex items-center gap-3">
                <div className="h-10 w-10 rounded-xl bg-gradient-to-tr from-blue-600 via-indigo-600 to-cyan-500 flex items-center justify-center text-white font-bold text-xl shadow-lg shadow-blue-500/20">
                    W
                </div>
                <div>
                    <div className="font-extrabold text-white tracking-wide text-base flex items-center gap-1.5">
                        WOM <span className="text-blue-400 font-normal">ADMIN</span>
                    </div>
                    <p className="text-xs text-slate-500 font-medium">Enterprise Portal</p>
                </div>
            </div>

            {/* Navigation */}
            <nav className="flex-1 overflow-y-auto px-3 py-4 space-y-1">
                <div className="px-3 pb-2 text-[11px] font-semibold uppercase tracking-wider text-slate-500">
                    Content Management
                </div>
                {navItems.map((item) => {
                    const Icon = item.icon;
                    const isActive = pathname === item.href || (item.href !== '/admin' && pathname.startsWith(item.href));

                    return (
                        <Link
                            key={item.href}
                            href={item.href}
                            className={`flex items-center justify-between px-3 py-2.5 rounded-lg text-sm font-medium transition-all duration-200 group ${isActive
                                    ? 'bg-blue-600/10 text-blue-400 border border-blue-500/20 shadow-sm'
                                    : 'text-slate-400 hover:text-slate-100 hover:bg-slate-800/60'
                                }`}
                        >
                            <div className="flex items-center gap-3">
                                <Icon className={`h-4 w-4 transition-colors ${isActive ? 'text-blue-400' : 'text-slate-500 group-hover:text-slate-300'}`} />
                                <span>{item.label}</span>
                            </div>
                            {isActive && <ChevronRight className="h-3.5 w-3.5 text-blue-400" />}
                        </Link>
                    );
                })}

                <div className="pt-6 px-3 pb-2 text-[11px] font-semibold uppercase tracking-wider text-slate-500">
                    Quick Links
                </div>
                <a
                    href="/"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="flex items-center justify-between px-3 py-2 rounded-lg text-sm text-slate-400 hover:text-white hover:bg-slate-800/60 transition-colors"
                >
                    <div className="flex items-center gap-3">
                        <ExternalLink className="h-4 w-4 text-slate-500" />
                        <span>View Public Site</span>
                    </div>
                </a>
            </nav>

            {/* Footer User Card */}
            <div className="p-4 border-t border-slate-800 bg-slate-950/40">
                <div className="flex items-center justify-between gap-2 mb-3">
                    <div className="flex items-center gap-2.5 overflow-hidden">
                        <div className="h-8 w-8 rounded-full bg-blue-600/20 border border-blue-500/30 flex items-center justify-center text-blue-400 font-semibold text-xs shrink-0">
                            {user?.name?.[0] || 'A'}
                        </div>
                        <div className="truncate">
                            <p className="text-xs font-semibold text-white truncate">{user?.name || 'Admin User'}</p>
                            <div className="flex items-center gap-1 text-[10px] text-slate-400">
                                <ShieldCheck className="h-3 w-3 text-emerald-400" />
                                <span>{user?.role || 'Administrator'}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <button
                    onClick={handleLogout}
                    className="w-full flex items-center justify-center gap-2 px-3 py-2 rounded-lg text-xs font-medium text-red-400 hover:text-white hover:bg-red-500/10 border border-red-500/20 transition-all duration-150"
                >
                    <LogOut className="h-3.5 w-3.5" />
                    <span>Log Out</span>
                </button>
            </div>
        </aside>
    );
}
