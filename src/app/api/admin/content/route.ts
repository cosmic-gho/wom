import { NextResponse } from 'next/server';
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
        console.error(`Error writing ${filename}:`, error);
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

// GET /api/admin/content?type=products&search=...&id=...
export async function GET(request: Request) {
    try {
        const { searchParams } = new URL(request.url);
        const type = searchParams.get('type') || 'products';
        const filename = FILE_MAP[type];

        if (!filename) {
            return NextResponse.json({ success: false, error: 'Invalid content type' }, { status: 400 });
        }

        let items = readJsonFile(filename);

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
        const items = readJsonFile(filename);

        // Calculate new ID
        const existingIds = items.map((i: any) => Number(i.id)).filter(n => !isNaN(n));
        const newId = existingIds.length > 0 ? Math.max(...existingIds) + 1 : 1;

        // Generate slug if missing
        const rawTitle = item.title || item.name || `item-${newId}`;
        const generatedSlug = item.slug ? slugify(item.slug) : slugify(rawTitle);

        const nowIso = new Date().toISOString();

        const newItem = {
            id: newId,
            ...item,
            slug: generatedSlug,
            date: item.date || nowIso,
            modified: nowIso,
        };

        items.unshift(newItem); // put latest first

        const success = writeJsonFile(filename, items);
        if (!success) {
            return NextResponse.json({ success: false, error: 'Failed to save to disk' }, { status: 500 });
        }

        return NextResponse.json({ success: true, data: newItem, message: 'Created successfully' });
    } catch (error) {
        return NextResponse.json({ success: false, error: 'Failed to create item' }, { status: 500 });
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
        const items = readJsonFile(filename);
        const numericId = Number(item.id);

        const index = items.findIndex((i: any) => i.id === numericId || String(i.id) === String(item.id));
        if (index === -1) {
            return NextResponse.json({ success: false, error: 'Item not found' }, { status: 404 });
        }

        const nowIso = new Date().toISOString();
        const updatedItem = {
            ...items[index],
            ...item,
            id: items[index].id, // preserve original ID type/value
            modified: nowIso,
        };

        if (item.title || item.name) {
            if (item.slug) {
                updatedItem.slug = slugify(item.slug);
            }
        }

        items[index] = updatedItem;

        const success = writeJsonFile(filename, items);
        if (!success) {
            return NextResponse.json({ success: false, error: 'Failed to save updates to disk' }, { status: 500 });
        }

        return NextResponse.json({ success: true, data: updatedItem, message: 'Updated successfully' });
    } catch (error) {
        return NextResponse.json({ success: false, error: 'Failed to update item' }, { status: 500 });
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
        const items = readJsonFile(filename);
        const numericId = Number(id);

        const filtered = items.filter((i: any) => i.id !== numericId && String(i.id) !== String(id));

        if (filtered.length === items.length) {
            return NextResponse.json({ success: false, error: 'Item not found' }, { status: 404 });
        }

        const success = writeJsonFile(filename, filtered);
        if (!success) {
            return NextResponse.json({ success: false, error: 'Failed to save after deletion' }, { status: 500 });
        }

        return NextResponse.json({ success: true, message: 'Deleted successfully' });
    } catch (error) {
        return NextResponse.json({ success: false, error: 'Failed to delete item' }, { status: 500 });
    }
}
