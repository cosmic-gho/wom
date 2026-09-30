import { NextResponse } from 'next/server';
import { supabase, isSupabaseConfigured } from '@/lib/supabase';
import fs from 'fs';
import path from 'path';

const INQUIRIES_FILE = path.join(process.cwd(), 'content', 'inquiries.json');

function readLocalInquiries() {
    if (!fs.existsSync(INQUIRIES_FILE)) return [];
    try {
        return JSON.parse(fs.readFileSync(INQUIRIES_FILE, 'utf8'));
    } catch (e) {
        return [];
    }
}

function writeLocalInquiries(data: any[]) {
    try {
        fs.writeFileSync(INQUIRIES_FILE, JSON.stringify(data, null, 2), 'utf8');
        return true;
    } catch (e) {
        return false;
    }
}

// GET /api/admin/inquiries
export async function GET() {
    try {
        let items: any[] = [];

        if (isSupabaseConfigured() && supabase) {
            const { data, error } = await supabase
                .from('inquiries')
                .select('*')
                .order('created_at', { ascending: false });

            if (!error && data) {
                items = data;
            } else {
                items = readLocalInquiries();
            }
        } else {
            items = readLocalInquiries();
        }

        return NextResponse.json({ success: true, count: items.length, data: items });
    } catch (error) {
        return NextResponse.json({ success: false, error: 'Failed to fetch inquiries' }, { status: 500 });
    }
}

// PUT /api/admin/inquiries (Update status)
export async function PUT(request: Request) {
    try {
        const body = await request.json();
        const { id, status } = body;

        if (!id || !status) {
            return NextResponse.json({ success: false, error: 'ID and status required' }, { status: 400 });
        }

        if (isSupabaseConfigured() && supabase) {
            await supabase.from('inquiries').update({ status }).eq('id', id);
        }

        const local = readLocalInquiries();
        const index = local.findIndex((i: any) => String(i.id) === String(id));
        if (index !== -1) {
            local[index].status = status;
            writeLocalInquiries(local);
        }

        return NextResponse.json({ success: true, message: 'Status updated' });
    } catch (error) {
        return NextResponse.json({ success: false, error: 'Failed to update inquiry' }, { status: 500 });
    }
}

// DELETE /api/admin/inquiries?id=123
export async function DELETE(request: Request) {
    try {
        const { searchParams } = new URL(request.url);
        const id = searchParams.get('id');

        if (!id) {
            return NextResponse.json({ success: false, error: 'ID required' }, { status: 400 });
        }

        if (isSupabaseConfigured() && supabase) {
            await supabase.from('inquiries').delete().eq('id', id);
        }

        const local = readLocalInquiries();
        const filtered = local.filter((i: any) => String(i.id) === String(id));
        writeLocalInquiries(filtered);

        return NextResponse.json({ success: true, message: 'Inquiry deleted' });
    } catch (error) {
        return NextResponse.json({ success: false, error: 'Failed to delete inquiry' }, { status: 500 });
    }
}
