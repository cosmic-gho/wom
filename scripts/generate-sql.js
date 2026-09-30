const fs = require('fs');
const path = require('path');

const contentDir = path.join(__dirname, '..', 'content');
const outputSqlPath = path.join(__dirname, '..', 'supabase', 'schema.sql');

if (!fs.existsSync(path.join(__dirname, '..', 'supabase'))) {
    fs.mkdirSync(path.join(__dirname, '..', 'supabase'), { recursive: true });
}

function readJson(filename) {
    const p = path.join(contentDir, filename);
    if (!fs.existsSync(p)) return [];
    try {
        return JSON.parse(fs.readFileSync(p, 'utf8'));
    } catch (e) {
        return [];
    }
}

function escapeSql(str) {
    if (str === null || str === undefined) return 'NULL';
    if (typeof str === 'number' || typeof str === 'boolean') return str;
    if (typeof str === 'object') return `'${JSON.stringify(str).replace(/'/g, "''")}'::jsonb`;
    return `'${String(str).replace(/'/g, "''")}'`;
}

let sql = `-- ===================================================
-- WOM GROUP - SUPABASE DATABASE SCHEMA & INITIAL DATA
-- Run this script in the Supabase SQL Editor to initialize all tables
-- ===================================================

-- 1. Product Categories Table
CREATE TABLE IF NOT EXISTS public.categories (
    id BIGINT PRIMARY KEY,
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    description TEXT,
    parent_id BIGINT DEFAULT 0,
    seo JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Products Catalog Table
CREATE TABLE IF NOT EXISTS public.products (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    excerpt TEXT,
    content_html TEXT,
    date TEXT,
    price NUMERIC,
    currency TEXT DEFAULT 'USD',
    is_price_on_request BOOLEAN DEFAULT true,
    categories JSONB DEFAULT '[]'::jsonb,
    featured_image JSONB DEFAULT '{}'::jsonb,
    seo JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Ensure new columns exist if products table was created in a previous script run
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS price NUMERIC;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS currency TEXT DEFAULT 'USD';
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS is_price_on_request BOOLEAN DEFAULT true;

-- 3. News & Media Announcements
CREATE TABLE IF NOT EXISTS public.news (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    excerpt TEXT,
    content_html TEXT,
    author TEXT,
    date TEXT,
    category TEXT,
    featured_image JSONB DEFAULT '{}'::jsonb,
    seo JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Global Facility Locations
CREATE TABLE IF NOT EXISTS public.locations (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    slug TEXT,
    region TEXT,
    address TEXT,
    city TEXT,
    country TEXT,
    phone TEXT,
    email TEXT,
    lat NUMERIC,
    lng NUMERIC,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Resources & Downloads
CREATE TABLE IF NOT EXISTS public.resources (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    category TEXT,
    file_url TEXT,
    file_size TEXT,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. Contact Inquiries & Leads Inbox
CREATE TABLE IF NOT EXISTS public.inquiries (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    company TEXT,
    phone TEXT,
    subject TEXT,
    message TEXT NOT NULL,
    status TEXT DEFAULT 'unread', -- 'unread', 'read', 'archived', 'replied'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7. Global Site Settings
CREATE TABLE IF NOT EXISTS public.site_settings (
    id BIGSERIAL PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    value JSONB NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security (RLS) & Grant Public Read Access
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.news ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inquiries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.site_settings ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if re-running script for idempotency
DROP POLICY IF EXISTS "Allow public read access for categories" ON public.categories;
DROP POLICY IF EXISTS "Allow public read access for products" ON public.products;
DROP POLICY IF EXISTS "Allow public read access for news" ON public.news;
DROP POLICY IF EXISTS "Allow public read access for locations" ON public.locations;
DROP POLICY IF EXISTS "Allow public read access for resources" ON public.resources;
DROP POLICY IF EXISTS "Allow public read access for settings" ON public.site_settings;
DROP POLICY IF EXISTS "Allow public insert for inquiries" ON public.inquiries;

DROP POLICY IF EXISTS "Full admin control categories" ON public.categories;
DROP POLICY IF EXISTS "Full admin control products" ON public.products;
DROP POLICY IF EXISTS "Full admin control news" ON public.news;
DROP POLICY IF EXISTS "Full admin control locations" ON public.locations;
DROP POLICY IF EXISTS "Full admin control resources" ON public.resources;
DROP POLICY IF EXISTS "Full admin control inquiries" ON public.inquiries;
DROP POLICY IF EXISTS "Full admin control settings" ON public.site_settings;

-- Create Policies for Anonymous Read Access & Authenticated Full Access
CREATE POLICY "Allow public read access for categories" ON public.categories FOR SELECT USING (true);
CREATE POLICY "Allow public read access for products" ON public.products FOR SELECT USING (true);
CREATE POLICY "Allow public read access for news" ON public.news FOR SELECT USING (true);
CREATE POLICY "Allow public read access for locations" ON public.locations FOR SELECT USING (true);
CREATE POLICY "Allow public read access for resources" ON public.resources FOR SELECT USING (true);
CREATE POLICY "Allow public read access for settings" ON public.site_settings FOR SELECT USING (true);
CREATE POLICY "Allow public insert for inquiries" ON public.inquiries FOR INSERT WITH CHECK (true);

-- Allow all operations for service_role / authenticated admin
CREATE POLICY "Full admin control categories" ON public.categories FOR ALL USING (true);
CREATE POLICY "Full admin control products" ON public.products FOR ALL USING (true);
CREATE POLICY "Full admin control news" ON public.news FOR ALL USING (true);
CREATE POLICY "Full admin control locations" ON public.locations FOR ALL USING (true);
CREATE POLICY "Full admin control resources" ON public.resources FOR ALL USING (true);
CREATE POLICY "Full admin control inquiries" ON public.inquiries FOR ALL USING (true);
CREATE POLICY "Full admin control settings" ON public.site_settings FOR ALL USING (true);

-- ===================================================
-- SEED DATA INSERT STATEMENTS
-- ===================================================
`;

// Categories
const categories = readJson('product-categories.json');
sql += `\n-- Seeding Categories (${categories.length} records)\n`;
categories.forEach(c => {
    sql += `INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (${c.id}, ${escapeSql(c.name)}, ${escapeSql(c.slug)}, ${escapeSql(c.description || '')}, ${c.parent || 0}, ${escapeSql(c.seo || {})}) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;\n`;
});

// Locations
const locations = readJson('locations.json');
sql += `\n-- Seeding Locations (${locations.length} records)\n`;
locations.forEach(l => {
    sql += `INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (${l.id || 'DEFAULT'}, ${escapeSql(l.title)}, ${escapeSql(l.slug)}, ${escapeSql(l.region)}, ${escapeSql(l.address)}, ${escapeSql(l.city)}, ${escapeSql(l.country)}, ${escapeSql(l.phone)}, ${escapeSql(l.email)}, ${l.lat || 'NULL'}, ${l.lng || 'NULL'}) ON CONFLICT (id) DO NOTHING;\n`;
});

// Resources
const resources = readJson('resources.json');
sql += `\n-- Seeding Resources (${resources.length} records)\n`;
resources.forEach(r => {
    sql += `INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (${r.id || 'DEFAULT'}, ${escapeSql(r.title)}, ${escapeSql(r.category)}, ${escapeSql(r.file_url || r.url)}, ${escapeSql(r.file_size || '')}, ${escapeSql(r.description || '')}) ON CONFLICT (id) DO NOTHING;\n`;
});

// Products
const products = readJson('products.json');
sql += `\n-- Seeding Products (${products.length} records)\n`;
products.forEach(p => {
    sql += `INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (${p.id}, ${escapeSql(p.title)}, ${escapeSql(p.slug)}, ${escapeSql(p.excerpt || '')}, ${escapeSql(p.contentHtml || '')}, ${escapeSql(p.date || '')}, ${p.price || 'NULL'}, ${escapeSql(p.currency || 'USD')}, ${p.priceOnRequest !== false}, ${escapeSql(p.categories || [])}, ${escapeSql(p.featuredImage || {})}, ${escapeSql(p.seo || {})}) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;\n`;
});

// Site Manifest / Settings
const siteManifest = readJson('site-manifest.json');
sql += `\n-- Seeding Site Settings\n`;
sql += `INSERT INTO public.site_settings (key, value) VALUES ('general', ${escapeSql(siteManifest)}) ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;\n`;

fs.writeFileSync(outputSqlPath, sql, 'utf8');
console.log(`Generated SQL schema successfully at ${outputSqlPath}`);
