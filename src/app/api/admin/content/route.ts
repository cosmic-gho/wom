import { NextResponse } from 'next/server';
import { supabase, isSupabaseConfigured } from '@/lib/supabase';
import fs from 'fs';
import path from 'path';

const CONTENT_DIR = path.join(process.cwd(), 'content');

const FILE_MAP: Record<string, string> = {
    products: 'products.json',
    categories: 'product-categories.json',
    news: 'news.json',
    locations: 'locations.json',
    resources: 'resources.json',
    pages: 'pages.json',
};

const TABLE_MAP: Record<string, string> = {
    products: 'products',
    categories: 'categories',
    news: 'news',
    locations: 'locations',
    resources: 'resources',
};

function readJsonFile<T = any>(filename: string): T[] {
    const filePath = path.join(CONTENT_DIR, filename);
    if (!fs.existsSync(filePath)) return [];
    try {
        const raw = fs.readFileSync(filePath, 'utf8');
        return JSON.parse(raw) as T[];
    } catch (error) {
        console.error(`Error reading ${filename}:`, error);
        return [];
    }
}

function writeJsonFile<T = any>(filename: string, data: T[]): boolean {
    const filePath = path.join(CONTENT_DIR, filename);
    try {
        fs.writeFileSync(filePath, JSON.stringify(data, null, 2), 'utf8');
        return true;
    } catch (error) {
        console.warn(`Local JSON write skipped/failed for ${filename}:`, error);
        return false;
    }
}

function slugify(text: string): string {
    return text
        .toString()
        .toLowerCase()
        .trim()
        .replace(/\s+/g, '-')
        .replace(/[^\w\-]+/g, '')
        .replace(/\-\-+/g, '-');
}

// Format item payload for Supabase database table
function formatForSupabase(type: string, item: any) {
    if (type === 'products') {
        const numPrice = item.price !== undefined && item.price !== null ? Number(item.price) : null;
        const hasValidPrice = numPrice !== null && !isNaN(numPrice) && numPrice > 0;
        return {
            id: item.id ? Number(item.id) : undefined,
            title: item.title,
            slug: item.slug,
            excerpt: item.excerpt || '',
            content_html: item.contentHtml || item.content_html || '',
            date: item.date || new Date().toISOString(),
            price: numPrice,
            currency: item.currency || 'USD',
            is_price_on_request: hasValidPrice ? false : (item.priceOnRequest !== undefined ? item.priceOnRequest : true),
            categories: item.categories || [],
            featured_image: item.featuredImage || item.featured_image || {},
            seo: item.seo || {},
        };
    }
    return item;
}

// GET /api/admin/content?type=products&search=...&id=...
export async function GET(request: Request) {
    try {
        const { searchParams } = new URL(request.url);
        const type = searchParams.get('type') || 'products';
        const filename = FILE_MAP[type];
        const tableName = TABLE_MAP[type];

        if (!filename) {
            return NextResponse.json({ success: false, error: 'Invalid content type' }, { status: 400 });
        }

        let items: any[] = [];
        let fetchedFromSupabase = false;

        // Try Supabase first if configured
        if (isSupabaseConfigured() && supabase && tableName) {
            try {
                const { data, error } = await supabase
                    .from(tableName)
                    .select('*')
                    .order('created_at', { ascending: false });

                if (!error && data && data.length > 0) {
                    // Normalize database column names to camelCase for frontend compatibility
                    items = data.map((d: any) => ({
                        ...d,
                        contentHtml: d.content_html || d.contentHtml,
                        featuredImage: d.featured_image || d.featuredImage,
                        priceOnRequest: d.is_price_on_request !== undefined ? d.is_price_on_request : d.priceOnRequest,
                    }));
                    fetchedFromSupabase = true;
                }
            } catch (sErr) {
                console.warn('Supabase fetch failed, falling back to local JSON:', sErr);
            }
        }

        if (!fetchedFromSupabase) {
            items = readJsonFile(filename);
        }

        const id = searchParams.get('id');
        const slug = searchParams.get('slug');
        const search = searchParams.get('search');

        if (id) {
            const numericId = Number(id);
            const item = items.find((i: any) => i.id === numericId || String(i.id) === id);
            if (!item) {
                return NextResponse.json({ success: false, error: 'Item not found' }, { status: 404 });
            }
            return NextResponse.json({ success: true, data: item });
        }

        if (slug) {
            const item = items.find((i: any) => i.slug === slug);
            if (!item) {
                return NextResponse.json({ success: false, error: 'Item not found' }, { status: 404 });
            }
            return NextResponse.json({ success: true, data: item });
        }

        if (search) {
            const term = search.toLowerCase();
            items = items.filter((i: any) => {
                const title = (i.title || i.name || '').toLowerCase();
                const desc = (i.excerpt || i.description || '').toLowerCase();
                return title.includes(term) || desc.includes(term);
            });
        }

        const limit = searchParams.get('limit');
        if (limit) {
            const numLimit = parseInt(limit, 10);
            items = items.slice(0, numLimit);
        }

        return NextResponse.json({
            success: true,
            count: items.length,
            data: items,
        });
    } catch (error) {
        console.error('GET content error:', error);
        return NextResponse.json({ success: false, error: 'Failed to fetch content' }, { status: 500 });
    }
}

// POST /api/admin/content (Create)
export async function POST(request: Request) {
    try {
        const body = await request.json();
        const { type, item } = body;

        if (!type || !FILE_MAP[type]) {
            return NextResponse.json({ success: false, error: 'Invalid content type' }, { status: 400 });
        }

        if (!item || typeof item !== 'object') {
            return NextResponse.json({ success: false, error: 'Item payload required' }, { status: 400 });
        }

        const filename = FILE_MAP[type];
        const tableName = TABLE_MAP[type];
        const items = readJsonFile(filename);

        // Calculate new ID
        const existingIds = items.map((i: any) => Number(i.id)).filter((n) => !isNaN(n));
        const newId = existingIds.length > 0 ? Math.max(...existingIds) + 1 : Date.now();

        // Generate slug if missing
        const rawTitle = item.title || item.name || `item-${newId}`;
        const generatedSlug = item.slug ? slugify(item.slug) : slugify(rawTitle);
        const nowIso = new Date().toISOString();

        const newItem = {
            id: item.id ? Number(item.id) : newId,
            ...item,
            slug: generatedSlug,
            date: item.date || nowIso,
            modified: nowIso,
        };

        let savedToSupabase = false;

        // Save to Supabase if configured
        if (isSupabaseConfigured() && supabase && tableName) {
            try {
                const dbPayload = formatForSupabase(type, newItem);
                const { data, error } = await supabase.from(tableName).insert([dbPayload]).select();
                if (error) {
                    console.error('Supabase INSERT Error:', error);
                } else {
                    savedToSupabase = true;
                    if (data && data[0]) {
                        newItem.id = data[0].id;
                    }
                }
            } catch (dbErr) {
                console.error('Supabase INSERT Exception:', dbErr);
            }
        }

        // Save to local JSON file (graceful try/catch)
        items.unshift(newItem);
        const diskSuccess = writeJsonFile(filename, items);

        if (!savedToSupabase && !diskSuccess) {
            return NextResponse.json(
                { success: false, error: 'Failed to save to database or disk' },
                { status: 500 }
            );
        }

        return NextResponse.json({
            success: true,
            data: newItem,
            message: 'Created successfully',
            provider: savedToSupabase ? 'supabase' : 'disk',
        });
    } catch (error: any) {
        console.error('POST content error:', error);
        return NextResponse.json({ success: false, error: error.message || 'Failed to create item' }, { status: 500 });
    }
}

// PUT /api/admin/content (Update)
export async function PUT(request: Request) {
    try {
        const body = await request.json();
        const { type, item } = body;

        if (!type || !FILE_MAP[type]) {
            return NextResponse.json({ success: false, error: 'Invalid content type' }, { status: 400 });
        }

        if (!item || item.id === undefined) {
            return NextResponse.json({ success: false, error: 'Item with ID required' }, { status: 400 });
        }

        const filename = FILE_MAP[type];
        const tableName = TABLE_MAP[type];
        const items = readJsonFile(filename);
        const numericId = Number(item.id);

        const index = items.findIndex((i: any) => i.id === numericId || String(i.id) === String(item.id));
        const nowIso = new Date().toISOString();

        const updatedItem = {
            ...(index !== -1 ? items[index] : {}),
            ...item,
            id: numericId,
            modified: nowIso,
        };

        if (item.title || item.name) {
            if (item.slug) {
                updatedItem.slug = slugify(item.slug);
            }
        }

        let savedToSupabase = false;

        // Update in Supabase if configured
        if (isSupabaseConfigured() && supabase && tableName) {
            try {
                const dbPayload = formatForSupabase(type, updatedItem);
                const { error } = await supabase.from(tableName).update(dbPayload).eq('id', numericId);
                if (error) {
                    console.error('Supabase UPDATE Error:', error);
                } else {
                    savedToSupabase = true;
                }
            } catch (dbErr) {
                console.error('Supabase UPDATE Exception:', dbErr);
            }
        }

        // Update local JSON file
        if (index !== -1) {
            items[index] = updatedItem;
        } else {
            items.unshift(updatedItem);
        }
        const diskSuccess = writeJsonFile(filename, items);

        if (!savedToSupabase && !diskSuccess) {
            return NextResponse.json(
                { success: false, error: 'Failed to save updates to database or disk' },
                { status: 500 }
            );
        }

        return NextResponse.json({
            success: true,
            data: updatedItem,
            message: 'Updated successfully',
            provider: savedToSupabase ? 'supabase' : 'disk',
        });
    } catch (error: any) {
        console.error('PUT content error:', error);
        return NextResponse.json({ success: false, error: error.message || 'Failed to update item' }, { status: 500 });
    }
}

// DELETE /api/admin/content?type=products&id=123
export async function DELETE(request: Request) {
    try {
        const { searchParams } = new URL(request.url);
        const type = searchParams.get('type');
        const id = searchParams.get('id');

        if (!type || !FILE_MAP[type]) {
            return NextResponse.json({ success: false, error: 'Invalid content type' }, { status: 400 });
        }

        if (!id) {
            return NextResponse.json({ success: false, error: 'Item ID required' }, { status: 400 });
        }

        const filename = FILE_MAP[type];
        const tableName = TABLE_MAP[type];
        const items = readJsonFile(filename);
        const numericId = Number(id);

        let deletedFromSupabase = false;

        if (isSupabaseConfigured() && supabase && tableName) {
            try {
                const { error } = await supabase.from(tableName).delete().eq('id', numericId);
                if (!error) deletedFromSupabase = true;
            } catch (dbErr) {
                console.error('Supabase DELETE Exception:', dbErr);
            }
        }

        const filtered = items.filter((i: any) => i.id !== numericId && String(i.id) !== String(id));
        writeJsonFile(filename, filtered);

        return NextResponse.json({ success: true, message: 'Deleted successfully' });
    } catch (error: any) {
        console.error('DELETE content error:', error);
        return NextResponse.json({ success: false, error: error.message || 'Failed to delete item' }, { status: 500 });
    }
}
