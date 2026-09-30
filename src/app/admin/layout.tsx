'use client';

import React, { useEffect, useState } from 'react';
import { usePathname, useRouter } from 'next/navigation';
import AdminSidebar from '@/components/AdminSidebar';
import AdminHeader from '@/components/AdminHeader';
import { Loader2 } from 'lucide-react';

export default function AdminLayout({ children }: { children: React.ReactNode }) {
    const pathname = usePathname();
    const router = useRouter();
    const [isLoading, setIsLoading] = useState(true);
    const [user, setUser] = useState<{ name: string; email: string; role: string } | null>(null);

    const isLoginPage = pathname === '/admin/login';

    useEffect(() => {
        async function checkAuth() {
            if (isLoginPage) {
                setIsLoading(false);
                return;
            }

            try {
                const res = await fetch('/api/admin/auth');
                const data = await res.json();

                if (data.authenticated && data.user) {
                    setUser(data.user);
                    setIsLoading(false);
                } else {
                    router.push('/admin/login');
                }
            } catch (err) {
                console.error('Auth verification error:', err);
                router.push('/admin/login');
            }
        }

        checkAuth();
    }, [pathname, isLoginPage, router]);

    if (isLoginPage) {
        return <div className="min-h-screen bg-slate-950 text-slate-100">{children}</div>;
    }

    if (isLoading) {
        return (
            <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col items-center justify-center gap-3">
                <Loader2 className="h-10 w-10 text-blue-500 animate-spin" />
                <p className="text-sm text-slate-400 font-medium">Verifying Administrator Access...</p>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-slate-950 text-slate-100 flex">
            <AdminSidebar user={user} />
            <div className="flex-1 flex flex-col min-w-0">
                <AdminHeader />
                <main className="flex-1 p-6 bg-slate-950 overflow-y-auto">{children}</main>
            </div>
        </div>
    );
}
