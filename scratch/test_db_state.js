const fs = require('fs');
const path = require('path');
if (typeof globalThis.WebSocket === 'undefined') {
    try { globalThis.WebSocket = require('ws'); } catch (e) { globalThis.WebSocket = class DummyWebSocket { }; }
}
const { createClient } = require('@supabase/supabase-js');

const envPath = path.join(__dirname, '..', '.env.local');
const envText = fs.readFileSync(envPath, 'utf8');
const env = {};
envText.split(/\r?\n/).forEach(line => {
    const match = line.match(/^\s*([\w.-]+)\s*=\s*(.*)?\s*$/);
    if (match) env[match[1]] = (match[2] || '').replace(/^["']|["']$/g, '');
});

const supabase = createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.NEXT_PUBLIC_SUPABASE_ANON_KEY);

async function checkDb() {
    const { data: products, error } = await supabase.from('products').select('id, title, slug').order('id', { ascending: true });
    if (error) {
        console.error('Error fetching products:', error);
        return;
    }
    console.log(`Found ${products.length} products in Supabase:`);
    console.log(products.map(p => ({ id: p.id, title: p.title })));

    // Try inserting with explicit id = 1 (simulating POST in /api/admin/content/route.ts)
    const testPayloadWithId = {
        id: 1,
        title: 'Duplicate ID Test',
        slug: 'duplicate-id-test-1',
        excerpt: 'Test',
        content_html: 'Test',
    };
    const { error: errWithId } = await supabase.from('products').insert([testPayloadWithId]);
    console.log('\nInsert with explicit id=1 error:', errWithId?.message);

    // Try inserting with explicit id = 999999
    const testPayloadHighId = {
        id: 999999,
        title: 'High ID Test',
        slug: 'high-id-test',
        excerpt: 'Test',
        content_html: 'Test',
    };
    const { data: insertedData, error: errHighId } = await supabase.from('products').insert([testPayloadHighId]).select();
    console.log('\nInsert with high id=999999 result:', { insertedData, error: errHighId?.message });

    if (!errHighId && insertedData?.length > 0) {
        await supabase.from('products').delete().eq('id', 999999);
        console.log('Cleaned up high id test row');
    }
}

checkDb();
