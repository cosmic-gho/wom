import { NextResponse } from 'next/server';
import { isSupabaseConfigured } from '@/lib/supabase';
import fs from 'fs';
import path from 'path';

const MANIFEST_PATH = path.join(process.cwd(), 'content', 'site-manifest.json');
const SQL_PATH = path.join(process.cwd(), 'supabase', 'schema.sql');

function readManifest() {
    if (!fs.existsSync(MANIFEST_PATH)) return {};
    try {
        return JSON.parse(fs.readFileSync(MANIFEST_PATH, 'utf8'));
    } catch (e) {
        return {};
    }
}

function writeManifest(data: any) {
    try {
        fs.writeFileSync(MANIFEST_PATH, JSON.stringify(data, null, 2), 'utf8');
        return true;
    } catch (e) {
        return false;
    }
}

// GET /api/admin/settings
export async function GET() {
    try {
        const manifest = readManifest();

        const status = {
            supabase: isSupabaseConfigured(),
            cloudinary: Boolean(process.env.CLOUDINARY_CLOUD_NAME || process.env.NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME),
            smtp: Boolean(process.env.SMTP_HOST && process.env.SMTP_USER),
            sqlSchemaExists: fs.existsSync(SQL_PATH),
        };

        return NextResponse.json({
            success: true,
            manifest,
            status,
        });
    } catch (error) {
        return NextResponse.json({ success: false, error: 'Failed to fetch settings' }, { status: 500 });
    }
}

// PUT /api/admin/settings
export async function PUT(request: Request) {
    try {
        const body = await request.json();
        const { manifest } = body;

        if (manifest) {
            writeManifest(manifest);
        }

        return NextResponse.json({ success: true, message: 'Settings saved successfully' });
    } catch (error) {
        return NextResponse.json({ success: false, error: 'Failed to save settings' }, { status: 500 });
    }
}
