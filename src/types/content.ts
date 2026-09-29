export interface ImageData {
  url: string;
  width?: number | null;
  height?: number | null;
  alt: string;
}

export interface SEOData {
  title: string;
  description: string;
  ogImage?: string | null;
}

export interface ProductCategory {
  id: number;
  name: string;
  slug: string;
  description: string;
  count: number;
  parent: number;
  seo?: SEOData;
}

export interface Product {
  id: number;
  slug: string;
  title: string;
  contentHtml: string;
  excerpt: string;
  date: string;
  modified: string;
  categories: { id: number; name?: string; slug?: string }[];
  featuredImage: ImageData | null;
  seo: SEOData;
  breadcrumbs: string[];
}

export interface LocationItem {
  id: number;
  slug: string;
  title: string;
  contentHtml: string;
  excerpt: string;
  regions: string[];
  featuredImage: ImageData | null;
  seo: SEOData;
}

export interface NewsItem {
  id: number;
  slug: string;
  title: string;
  date: string;
  contentHtml: string;
  excerpt: string;
  categories: string[];
  featuredImage: ImageData | null;
  seo: SEOData;
}

export interface PageItem {
  id: number;
  slug: string;
  title: string;
  contentHtml: string;
  excerpt: string;
  featuredImage: ImageData | null;
  seo: SEOData;
}

export interface ResourceItem {
  id: number;
  slug: string;
  title: string;
  contentHtml: string;
  excerpt: string;
  featuredImage: ImageData | null;
  seo: SEOData;
}
