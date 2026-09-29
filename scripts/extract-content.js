const fs = require('fs');
const path = require('path');

const rootDir = path.resolve(__dirname, '..');
const wpJsonDir = path.join(rootDir, 'wp-json', 'wp', 'v2');
const uploadsDir = path.join(rootDir, 'wp-content', 'uploads');
const outDir = path.join(rootDir, 'content');

if (!fs.existsSync(outDir)) {
  fs.mkdirSync(outDir, { recursive: true });
}

function normalizeImageUrl(url) {
  if (!url) return null;
  // Check if it points to wp-content/uploads/
  const match = url.match(/wp-content\/uploads\/(.+)$/);
  if (match) {
    const relPath = match[1];
    const localPath = path.join(uploadsDir, relPath.replace(/\//g, path.sep));
    const exists = fs.existsSync(localPath);
    return {
      url: `/uploads/${relPath}`,
      originalUrl: url,
      localExists: exists
    };
  }
  return {
    url,
    originalUrl: url,
    localExists: false
  };
}

function cleanHtml(html) {
  if (!html) return '';
  // Replace remote womgroup uploads URLs with local /uploads/
  let cleaned = html.replace(/https?:\/\/(?:www\.)?womgroup\.com\/wp-content\/uploads\//g, '/uploads/');
  cleaned = cleaned.replace(/wp-content\/uploads\//g, '/uploads/');
  return cleaned;
}

function loadDirectory(dirPath) {
  if (!fs.existsSync(dirPath)) return [];
  const files = fs.readdirSync(dirPath);
  const items = [];
  for (const file of files) {
    const fullPath = path.join(dirPath, file);
    if (fs.statSync(fullPath).isDirectory()) continue;
    try {
      const content = JSON.parse(fs.readFileSync(fullPath, 'utf8'));
      items.push(content);
    } catch (e) {
      // skip invalid JSON
    }
  }
  return items;
}

console.log('--- Starting Extraction from wp-json/wp/v2 ---');

// 1. Product Categories
const rawProductCategories = loadDirectory(path.join(wpJsonDir, 'product_category'));
const productCategoryMap = {};
const productCategories = rawProductCategories.map(cat => {
  const item = {
    id: cat.id,
    name: cat.name ? cat.name.replace(/&amp;/g, '&') : '',
    slug: cat.slug,
    description: cat.description || '',
    count: cat.count || 0,
    parent: cat.parent || 0,
    seo: {
      title: cat.yoast_head_json?.title || cat.name,
      description: cat.yoast_head_json?.description || cat.description || '',
      image: normalizeImageUrl(cat.yoast_head_json?.og_image?.[0]?.url)
    }
  };
  productCategoryMap[cat.id] = item;
  return item;
});
fs.writeFileSync(path.join(outDir, 'product-categories.json'), JSON.stringify(productCategories, null, 2));
console.log(`✓ Extracted ${productCategories.length} product categories`);

// 2. Regions
const rawRegions = loadDirectory(path.join(wpJsonDir, 'region'));
const regionMap = {};
const regions = rawRegions.map(reg => {
  const item = {
    id: reg.id,
    name: reg.name ? reg.name.replace(/&amp;/g, '&') : '',
    slug: reg.slug,
    count: reg.count || 0
  };
  regionMap[reg.id] = item;
  return item;
});
fs.writeFileSync(path.join(outDir, 'regions.json'), JSON.stringify(regions, null, 2));
console.log(`✓ Extracted ${regions.length} regions`);

// 3. News Categories
const rawNewsCategories = loadDirectory(path.join(wpJsonDir, 'news_category'));
const newsCategoryMap = {};
const newsCategories = rawNewsCategories.map(ncat => {
  const item = {
    id: ncat.id,
    name: ncat.name ? ncat.name.replace(/&amp;/g, '&') : '',
    slug: ncat.slug
  };
  newsCategoryMap[ncat.id] = item;
  return item;
});
fs.writeFileSync(path.join(outDir, 'news-categories.json'), JSON.stringify(newsCategories, null, 2));
console.log(`✓ Extracted ${newsCategories.length} news categories`);

// 4. Products
const rawProducts = loadDirectory(path.join(wpJsonDir, 'product'));
const products = rawProducts.map(p => {
  const catIds = p.product_category || [];
  const cats = catIds.map(cid => productCategoryMap[cid] ? { id: cid, name: productCategoryMap[cid].name, slug: productCategoryMap[cid].slug } : { id: cid }).filter(Boolean);
  
  const ogImg = p.yoast_head_json?.og_image?.[0];
  const featuredImage = normalizeImageUrl(ogImg?.url);

  return {
    id: p.id,
    slug: p.slug,
    title: p.title?.rendered ? p.title.rendered.replace(/&amp;/g, '&').replace(/&#8211;/g, '-').replace(/&#8217;/g, "'") : '',
    contentHtml: cleanHtml(p.content?.rendered || ''),
    excerpt: p.excerpt?.rendered ? p.excerpt.rendered.replace(/<[^>]+>/g, '').trim() : '',
    date: p.date,
    modified: p.modified,
    categories: cats,
    featuredImage: featuredImage ? {
      url: featuredImage.url,
      width: ogImg?.width || null,
      height: ogImg?.height || null,
      alt: p.title?.rendered || ''
    } : null,
    seo: {
      title: p.yoast_head_json?.title || p.title?.rendered || '',
      description: p.yoast_head_json?.description || '',
      ogImage: featuredImage?.url || null
    },
    breadcrumbs: p.yoast_head_json?.schema?.['@graph']?.find(g => g['@type'] === 'BreadcrumbList')?.itemListElement?.map(b => b.name) || []
  };
});
// Sort products by title
products.sort((a, b) => a.title.localeCompare(b.title));
fs.writeFileSync(path.join(outDir, 'products.json'), JSON.stringify(products, null, 2));
console.log(`✓ Extracted ${products.length} products`);

// 5. Locations
const rawLocations = loadDirectory(path.join(wpJsonDir, 'location'));
const locations = rawLocations.map(loc => {
  const regionIds = loc.region || [];
  const regionNames = regionIds.map(rid => regionMap[rid]?.name).filter(Boolean);
  const ogImg = loc.yoast_head_json?.og_image?.[0];
  const featuredImage = normalizeImageUrl(ogImg?.url);

  return {
    id: loc.id,
    slug: loc.slug,
    title: loc.title?.rendered ? loc.title.rendered.replace(/&amp;/g, '&').replace(/&#8211;/g, '-').replace(/&#8217;/g, "'") : '',
    contentHtml: cleanHtml(loc.content?.rendered || ''),
    excerpt: loc.excerpt?.rendered ? loc.excerpt.rendered.replace(/<[^>]+>/g, '').trim() : '',
    regions: regionNames,
    featuredImage: featuredImage ? {
      url: featuredImage.url,
      width: ogImg?.width || null,
      height: ogImg?.height || null,
      alt: loc.title?.rendered || ''
    } : null,
    seo: {
      title: loc.yoast_head_json?.title || loc.title?.rendered || '',
      description: loc.yoast_head_json?.description || ''
    }
  };
});
fs.writeFileSync(path.join(outDir, 'locations.json'), JSON.stringify(locations, null, 2));
console.log(`✓ Extracted ${locations.length} locations`);

// 6. News Items & Posts
const rawNews = loadDirectory(path.join(wpJsonDir, 'news_item'));
const rawPosts = loadDirectory(path.join(wpJsonDir, 'posts'));
const allNewsItems = [...rawNews, ...rawPosts].map(n => {
  const catIds = n.news_category || n.categories || [];
  const cats = catIds.map(cid => newsCategoryMap[cid]?.name).filter(Boolean);
  const ogImg = n.yoast_head_json?.og_image?.[0];
  const featuredImage = normalizeImageUrl(ogImg?.url);

  return {
    id: n.id,
    slug: n.slug,
    title: n.title?.rendered ? n.title.rendered.replace(/&amp;/g, '&').replace(/&#8211;/g, '-').replace(/&#8217;/g, "'") : '',
    date: n.date,
    contentHtml: cleanHtml(n.content?.rendered || ''),
    excerpt: n.excerpt?.rendered ? n.excerpt.rendered.replace(/<[^>]+>/g, '').trim() : '',
    categories: cats,
    featuredImage: featuredImage ? {
      url: featuredImage.url,
      width: ogImg?.width || null,
      height: ogImg?.height || null,
      alt: n.title?.rendered || ''
    } : null,
    seo: {
      title: n.yoast_head_json?.title || n.title?.rendered || '',
      description: n.yoast_head_json?.description || ''
    }
  };
});
// Remove duplicates by slug and sort by date descending
const uniqueNews = [];
const seenNewsSlugs = new Set();
for (const item of allNewsItems) {
  if (!seenNewsSlugs.has(item.slug)) {
    seenNewsSlugs.add(item.slug);
    uniqueNews.push(item);
  }
}
uniqueNews.sort((a, b) => new Date(b.date) - new Date(a.date));
fs.writeFileSync(path.join(outDir, 'news.json'), JSON.stringify(uniqueNews, null, 2));
console.log(`✓ Extracted ${uniqueNews.length} news items and articles`);

// 7. Pages
const rawPages = loadDirectory(path.join(wpJsonDir, 'pages'));
const pages = rawPages.map(page => {
  const ogImg = page.yoast_head_json?.og_image?.[0];
  const featuredImage = normalizeImageUrl(ogImg?.url);

  return {
    id: page.id,
    slug: page.slug,
    title: page.title?.rendered ? page.title.rendered.replace(/&amp;/g, '&').replace(/&#8211;/g, '-').replace(/&#8217;/g, "'") : '',
    contentHtml: cleanHtml(page.content?.rendered || ''),
    excerpt: page.excerpt?.rendered ? page.excerpt.rendered.replace(/<[^>]+>/g, '').trim() : '',
    featuredImage: featuredImage ? {
      url: featuredImage.url,
      width: ogImg?.width || null,
      height: ogImg?.height || null,
      alt: page.title?.rendered || ''
    } : null,
    seo: {
      title: page.yoast_head_json?.title || page.title?.rendered || '',
      description: page.yoast_head_json?.description || ''
    }
  };
});
fs.writeFileSync(path.join(outDir, 'pages.json'), JSON.stringify(pages, null, 2));
console.log(`✓ Extracted ${pages.length} core pages`);

// 8. Resources
const rawResources = loadDirectory(path.join(wpJsonDir, 'resource_library'));
const resources = rawResources.map(res => {
  const ogImg = res.yoast_head_json?.og_image?.[0];
  const featuredImage = normalizeImageUrl(ogImg?.url);
  return {
    id: res.id,
    slug: res.slug,
    title: res.title?.rendered ? res.title.rendered.replace(/&amp;/g, '&').replace(/&#8211;/g, '-').replace(/&#8217;/g, "'") : '',
    contentHtml: cleanHtml(res.content?.rendered || ''),
    excerpt: res.excerpt?.rendered ? res.excerpt.rendered.replace(/<[^>]+>/g, '').trim() : '',
    featuredImage: featuredImage ? {
      url: featuredImage.url,
      width: ogImg?.width || null,
      height: ogImg?.height || null,
      alt: res.title?.rendered || ''
    } : null,
    seo: {
      title: res.yoast_head_json?.title || res.title?.rendered || '',
      description: res.yoast_head_json?.description || ''
    }
  };
});
fs.writeFileSync(path.join(outDir, 'resources.json'), JSON.stringify(resources, null, 2));
console.log(`✓ Extracted ${resources.length} resources & certificates`);

// 9. Site Summary Manifest
const manifest = {
  name: "Worldwide Oilfield Machine (WOM)",
  tagline: "Total Solutions for Oil & Gas Industry",
  headquarters: "Houston, Texas, USA",
  stats: {
    totalProducts: products.length,
    totalCategories: productCategories.length,
    totalLocations: locations.length,
    totalNewsArticles: uniqueNews.length,
    totalResources: resources.length,
    totalCorePages: pages.length
  },
  navigation: [
    { label: "Home", href: "/" },
    {
      label: "About Us",
      children: [
        { label: "Our Story", href: "/our-story" },
        { label: "Our Core Policies", href: "/our-core-policies" },
        { label: "Certifications", href: "/certifications" },
        { label: "Patents", href: "/patents" },
        { label: "The American Dream", href: "/americandream" }
      ]
    },
    {
      label: "Products",
      href: "/products",
      featuredCategories: [
        "Gate Valves",
        "Ball Valves",
        "BOPs",
        "Chokes",
        "Wellheads & Christmas Trees",
        "Subsea Intervention Systems"
      ]
    },
    { label: "Locations", href: "/locations" },
    { label: "News & Events", href: "/news" },
    { label: "Resources", href: "/resources" },
    { label: "Careers", href: "/wom-careers" },
    { label: "Contact Us", href: "/contact-us" }
  ],
  socials: {
    facebook: "https://www.facebook.com/womglobalgroup",
    twitter: "https://x.com/womglobalgroup",
    instagram: "https://www.instagram.com/womglobalgroup/",
    youtube: "https://www.youtube.com/channel/UC9dLzkFrVOaA8ISDRpAvA7A"
  }
};
fs.writeFileSync(path.join(outDir, 'site-manifest.json'), JSON.stringify(manifest, null, 2));
console.log('✓ Generated site-manifest.json');
console.log('--- Extraction Complete! ---');
