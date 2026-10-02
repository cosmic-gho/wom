import fs from 'fs';
import path from 'path';
import { supabase, isSupabaseConfigured } from '@/lib/supabase';
import { Product, ProductCategory, LocationItem, NewsItem, PageItem, ResourceItem } from '@/types/content';

const contentDir = path.join(process.cwd(), 'content');

function readJsonFile<T>(filename: string): T[] {
  const filePath = path.join(contentDir, filename);
  if (!fs.existsSync(filePath)) return [];
  try {
    const raw = fs.readFileSync(filePath, 'utf8');
    return JSON.parse(raw) as T[];
  } catch (e) {
    console.error(`Error reading ${filename}:`, e);
    return [];
  }
}

// Products
export async function getProducts(): Promise<Product[]> {
  if (isSupabaseConfigured() && supabase) {
    try {
      const { data, error } = await supabase
        .from('products')
        .select('*')
        .order('id', { ascending: false });

      if (!error && data && data.length > 0) {
        return data.map((d: any) => ({
          id: d.id,
          title: d.title,
          slug: d.slug,
          excerpt: d.excerpt || '',
          contentHtml: d.content_html || d.contentHtml || '',
          date: d.date || d.created_at || '',
          modified: d.updated_at || d.modified || '',
          price: d.price ? Number(d.price) : null,
          currency: d.currency || 'USD',
          priceOnRequest: d.is_price_on_request !== undefined ? d.is_price_on_request : d.priceOnRequest,
          categories: Array.isArray(d.categories) ? d.categories : [],
          featuredImage: d.featured_image || d.featuredImage || null,
          seo: d.seo || {},
          breadcrumbs: d.breadcrumbs || [],
        }));
      }
    } catch (e) {
      console.warn('Supabase getProducts failed, using JSON fallback:', e);
    }
  }
  return readJsonFile<Product>('products.json');
}

export async function getProductBySlug(slug: string): Promise<Product | undefined> {
  const products = await getProducts();
  return products.find(p => p.slug === slug);
}

export async function getProductsByCategory(categorySlug: string): Promise<Product[]> {
  const products = await getProducts();
  return products.filter(p => p.categories && p.categories.some(c => c.slug === categorySlug));
}

// Categories
export async function getProductCategories(): Promise<ProductCategory[]> {
  if (isSupabaseConfigured() && supabase) {
    try {
      const { data, error } = await supabase
        .from('categories')
        .select('*')
        .order('id', { ascending: true });

      if (!error && data && data.length > 0) {
        return data.map((d: any) => ({
          id: d.id,
          name: d.name,
          slug: d.slug,
          description: d.description || '',
          count: d.count || 0,
          parent: d.parent_id !== undefined ? d.parent_id : d.parent || 0,
          seo: d.seo || {},
        }));
      }
    } catch (e) {
      console.warn('Supabase getProductCategories failed, using JSON fallback:', e);
    }
  }
  return readJsonFile<ProductCategory>('product-categories.json');
}

export async function getCategoryBySlug(slug: string): Promise<ProductCategory | undefined> {
  const categories = await getProductCategories();
  return categories.find(c => c.slug === slug);
}

// Locations
export async function getLocations(): Promise<LocationItem[]> {
  if (isSupabaseConfigured() && supabase) {
    try {
      const { data, error } = await supabase
        .from('locations')
        .select('*')
        .order('id', { ascending: true });

      if (!error && data && data.length > 0) {
        return data.map((d: any) => ({
          id: d.id,
          slug: d.slug || `location-${d.id}`,
          title: d.title,
          contentHtml: d.content_html || d.contentHtml || '',
          excerpt: d.excerpt || d.address || '',
          regions: d.region ? [d.region] : (d.regions || []),
          featuredImage: d.featured_image || d.featuredImage || null,
          seo: d.seo || {},
        }));
      }
    } catch (e) {
      console.warn('Supabase getLocations failed, using JSON fallback:', e);
    }
  }
  return readJsonFile<LocationItem>('locations.json');
}

export async function getLocationBySlug(slug: string): Promise<LocationItem | undefined> {
  const locations = await getLocations();
  return locations.find(l => l.slug === slug);
}

// News
export async function getNews(): Promise<NewsItem[]> {
  if (isSupabaseConfigured() && supabase) {
    try {
      const { data, error } = await supabase
        .from('news')
        .select('*')
        .order('id', { ascending: false });

      if (!error && data && data.length > 0) {
        return data.map((d: any) => ({
          id: d.id,
          slug: d.slug,
          title: d.title,
          date: d.date || d.created_at || '',
          contentHtml: d.content_html || d.contentHtml || '',
          excerpt: d.excerpt || '',
          categories: d.category ? [d.category] : (d.categories || []),
          featuredImage: d.featured_image || d.featuredImage || null,
          seo: d.seo || {},
        }));
      }
    } catch (e) {
      console.warn('Supabase getNews failed, using JSON fallback:', e);
    }
  }
  return readJsonFile<NewsItem>('news.json');
}

export async function getNewsBySlug(slug: string): Promise<NewsItem | undefined> {
  const news = await getNews();
  return news.find(n => n.slug === slug);
}

// Pages
export async function getPages(): Promise<PageItem[]> {
  return readJsonFile<PageItem>('pages.json');
}

export async function getPageBySlug(slug: string): Promise<PageItem | undefined> {
  const pages = await getPages();
  return pages.find(p => p.slug === slug);
}

// Resources
export async function getResources(): Promise<ResourceItem[]> {
  if (isSupabaseConfigured() && supabase) {
    try {
      const { data, error } = await supabase
        .from('resources')
        .select('*')
        .order('id', { ascending: false });

      if (!error && data && data.length > 0) {
        return data.map((d: any) => ({
          id: d.id,
          slug: d.slug || `resource-${d.id}`,
          title: d.title,
          contentHtml: d.description || '',
          excerpt: d.description || '',
          featuredImage: null,
          seo: { title: d.title, description: d.description || '' },
          fileUrl: d.file_url || d.fileUrl || '',
          category: d.category || '',
          type: d.type || 'PDF',
        }));
      }
    } catch (e) {
      console.warn('Supabase getResources failed, using JSON fallback:', e);
    }
  }
  return readJsonFile<ResourceItem>('resources.json');
}

export async function getResourceBySlug(slug: string): Promise<ResourceItem | undefined> {
  const resources = await getResources();
  return resources.find(r => r.slug === slug);
}
