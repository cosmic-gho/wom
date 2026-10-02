const fs = require('fs');
const path = require('path');

// Fix Node 20 missing native WebSocket for Supabase Realtime
if (typeof globalThis.WebSocket === 'undefined') {
  try {
    globalThis.WebSocket = require('ws');
  } catch (e) {
    // If ws module is not found, define a dummy class to satisfy constructor check
    globalThis.WebSocket = class DummyWebSocket {};
  }
}

const { createClient } = require('@supabase/supabase-js');

const envPath = path.join(__dirname, '..', '.env.local');
const envText = fs.readFileSync(envPath, 'utf8');
const env = {};
envText.split(/\r?\n/).forEach(line => {
  const match = line.match(/^\s*([\w.-]+)\s*=\s*(.*)?\s*$/);
  if (match) {
    let value = match[2] || '';
    if (value.length > 0 && value.startsWith('"') && value.endsWith('"')) {
      value = value.substring(1, value.length - 1);
    }
    env[match[1]] = value;
  }
});

const url = env.NEXT_PUBLIC_SUPABASE_URL;
const key = env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

const supabase = createClient(url, key, {
  auth: { persistSession: false },
});

async function testInsert() {
  const payload = {
    title: 'Full Hydraulic Machine Test',
    slug: 'full-hydraulic-machine-test',
    excerpt: 'Test excerpt',
    content_html: '<p>Test</p>',
    date: new Date().toISOString(),
    price: 195000,
    currency: 'USD',
    is_price_on_request: false,
    categories: [{ id: 296, name: 'Products', slug: 'products-si-systems' }],
    featured_image: {},
    seo: { title: 'Test', description: 'Test' }
  };

  const { data, error } = await supabase.from('products').insert([payload]).select();
  console.log('INSERT RESULT:', JSON.stringify({ data, error }, null, 2));
}

testInsert();
