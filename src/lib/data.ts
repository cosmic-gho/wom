import fs from 'fs';
import path from 'path';
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
export function getProducts(): Product[] {
  return readJsonFile<Product>('products.json');
}

export function getProductBySlug(slug: string): Product | undefined {
  return getProducts().find(p => p.slug === slug);
}

export function getProductsByCategory(categorySlug: string): Product[] {
  const products = getProducts();
  return products.filter(p => p.categories.some(c => c.slug === categorySlug));
}

// Categories
export function getProductCategories(): ProductCategory[] {
  return readJsonFile<ProductCategory>('product-categories.json');
}

export function getCategoryBySlug(slug: string): ProductCategory | undefined {
  return getProductCategories().find(c => c.slug === slug);
}

// Locations
export function getLocations(): LocationItem[] {
  return readJsonFile<LocationItem>('locations.json');
}

export function getLocationBySlug(slug: string): LocationItem | undefined {
  return getLocations().find(l => l.slug === slug);
}

// News
export function getNews(): NewsItem[] {
  return readJsonFile<NewsItem>('news.json');
}

export function getNewsBySlug(slug: string): NewsItem | undefined {
  return getNews().find(n => n.slug === slug);
}

// Pages
export function getPages(): PageItem[] {
  return readJsonFile<PageItem>('pages.json');
}

export function getPageBySlug(slug: string): PageItem | undefined {
  return getPages().find(p => p.slug === slug);
}

// Resources
export function getResources(): ResourceItem[] {
  return readJsonFile<ResourceItem>('resources.json');
}

export function getResourceBySlug(slug: string): ResourceItem | undefined {
  return getResources().find(r => r.slug === slug);
}
