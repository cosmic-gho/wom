-- ===================================================
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

-- Seeding Categories (31 records)
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (123, 'All Products', 'product', '', 0, '{"title":"WOM Products, Oilfield Equipment Products - WOM Group","description":"All WOM products meet ISO and API performance and complete vertical integration, combined with a well-managed supply chain, ensures that customers receive orders according to their schedule.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (124, 'Surface', 'surface', '', 123, '{"title":"Oilfield Surface Equipments Supplier - WOM Group","description":"WOM Group - a leading global oilfield surface equipment supplier provides arange of Surface oilfield products which are complemented by high-quality execution, engagement in early project phases along with innovative approach and digital capabilities.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (125, 'Subsea', 'subsea', '', 123, '{"title":"Subsea Equipment - Worldwide Oilfield Machine Inc.","description":"WOM subsea technology used for offshore oil and gas production is a highly specialized ﬁeld of application that places particular demands on engineering.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (126, 'Actuators', 'actuators', '', 124, '{"title":"WOM Actuators, Subsea Actuators Manufacturers - WOM Group","description":"Magnum Subsea Acuators are designed, built and tested to API 6A and 17D. It is equipped with anti -explosive decompression seals and energized non-elastomeric lip seals.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (127, 'Ball Valves', 'ball-valves', '', 124, '{"title":"Ball Valves, Ball Valves Oilfield Equipment – WOM Group","description":"WOM Group - a leading Ball Valves oilfield equipment company in USA, offers wide range of Ball Valves products.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (128, 'BOPs', 'bops', '', 124, '{"title":"BOPs Oilfield Equipments, Blowout Preventers (BOP) Products - WOM Group","description":"WOM''s BOP is pressure energized and features hydraulically oprated locking mechanisms to hold the rams closed without actuation pressure. BOP head serves as an upper non sealing wear surface for the movement of the packing unit.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (129, 'Controls and Instrumentation', 'controls-and-instrumentation', '', 124, '{"title":"Controls & Instrumentation - Worldwide Oilfield Machine","description":"WOM''s Controls and Instrumentation is the surface equipment that can assist in maintaining safety, ensuring effective control and longevity of machinery.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (130, 'Custom Designs', 'custom-designs', '', 124, '{"title":"Custom Designs - Worldwide Oilfield Machine Inc.","description":"WOM’s custom designed equipment utilizes Magnum technology wherever possible to provide the highest level of reliability in every package.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (131, 'Gate Valves', 'gate-valves', '', 124, '{"title":"Gate Valves, Gate Valves Oilfield Equipments - WOM Group","description":"WOM Group leading manufacture company of Gate Valves surface equipments. Gate Valves are very easy to use and long lasting when they are installed and maintained correctly.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (132, 'Manifolds', 'manifolds', '', 124, '{"title":"Manifolds Systems, Manifold Manufacturers - Worldwide Oilfield Machine Inc.","description":"WOM Manifolds Systems may incorporate magnum gate valves, check valves, plug vales. WOM designs manufactures and supplies high pressure choke and kill manifolds,standpipe,cement,well test and custom application manifolds.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (133, 'Pump Savers', 'pump-savers', '', 124, '{"title":"Pump Savers, Pump Savers Surface Equipment - WOM Group","description":"WOM’s Pump Savers uses easy-to-install rupture disks which require no special tools to remove and replace. It is available in a wide choice of end connections and can be trimmed to handle H2S and salt water environments.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (134, 'Wellheads & Christmas Trees', 'wellheads-christmas-trees', '', 124, '{"title":"Wellheads and Christmas Trees Products","description":"We offer a variety of Oilfield Christmas Tree Shearing equipment that are suitable for conventional and specialty wellhead systems.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (135, 'Well Test Equipment', 'well-test-equipment', '', 124, '{"title":"Well Test Equipment, Surface Well Test Equipment Supplier - WOM Group","description":"WOM, one of the leading Well Test Equipment Suppliers having a light weight surface control head designed for use in testing, perforating, and wire line operations. Read more about Well Test Equipment.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (136, 'Subsea Well Operations', 'intervention-systems', '', 125, '{"title":"Subsea Intervention System - Worldwide Oilfield Machine Inc.","description":"WOM''s Subsea Intervention Systems makes full use of magnum gate valve technology, incororating Hydraulic Fail-Close Gate Valves and Subsea Magnum Gate Valve in both the Emergency Disconnect package and the Lower Rise Package.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (250, 'Plug Valve', 'plug-valve', '', 124, '{"title":"Plug Valve Surface Equipment - Worldwide Oilfield Machine","description":"WOM Group leading supplier of Plug Valve Surface Equipment for oilfield industry. With unique bi-directional sealing design which creates pressure/energized balance between the slab gate and seat assemblies when subjected to line pressure.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (251, 'Check Valves', 'check-valves', '', 124, '{"title":"Check Valves Products - Worldwide Oilfield Machine Inc.","description":"WOM offers a range of Check valves products prevents the back flow in high pressure and/or high temperature mud lines, choke & kill manifolds and Christmas tree injection and kill lines.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (258, 'Chokes', 'chokes', '', 124, '{"title":"Drill Chokes, Drill Choke Surface Equipment Supplier - WOM Group","description":"WOM, one of the leading Drill Chokes surface equipment suppliers. These Drill Chokes are designed to provide accurate flow control throughout its operating range.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (261, 'Other Products', 'other-products', '', 123, '{"title":"WOM Other Products - Worldwide Oilfield Machine Inc.","description":"All WOM products meet ISO and API performance and are engineered to surpass quality requirements.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (263, 'Underbalanced Drilling', 'underbalanced-drilling', '', 124, '{"title":"Underbalanced Drilling (UBD) - Worldwide Oilfield Machine","description":"WOM Group offers Underbalanced Drilling (UBD) services, an advanced procedure used to drill oil and gas wells which increases well productivity, and reduces drilling problems.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (264, 'Subsea Intervention Systems', 'si-systems', '', 136, '{"title":"Subsea Intervention Systems - Worldwide Oilfield Machine","description":"WOM''s Subsea Intervention Systems (SI Systems) are designed for the unique challenges of deep and ultradeep water environments. Read more about Subsea intervention Systems (SI Systems)","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (265, 'Subsea Production Systems', 'subsea-production-systems', '', 125, '{"title":"Subsea Production Systems - Worldwide Oilfield Machine Inc.","description":"WOM Group has a wide range of Subsea Production Systems which are technically innovative Subsea solutions to enhance customers.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (266, 'Xmas Trees and Wellheads', 'xmas-trees-and-wellheads', '', 265, '{"title":"Xmas Trees and Wellheads - Worldwide Oilfield Machine","description":"Xmas Trees and Wellheads are the primary pressure controlling Equipment for an Oilfiled Industry. Both, wellhead systems and christmas tree are manufactured in different sizes and configuration as per customer''s requirment.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (269, 'Manifolds and Structures', 'subsea-manifolds-and-structures', '', 265, '{"title":"Subsea-Manifolds-and-Structures - Worldwide Oilfield Machine Inc.","description":"WOM has major areas of expertise in the design and construction of Subsea Manifolds. Subsea Manifold incorporates reliable Magnum subsea gate valves and actuators which have proven field history over the years.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (270, 'Diversified Products', 'diversified-products', '', 123, '{"title":"Diversified Products - Worldwide Oilfield Machine","description":"WOM group leading global oilfield company with diverse products which meets ISO and API performance, Also engineered to surpass quality requirements.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (271, 'Railways & Metro', 'railways-metro', '', 270, '{"title":"Railways &amp; Metro Archives - Worldwide Oilfield Machine","description":"In the market for Railways & Metro products? Visit this page to see the full list of Railways & Metro products we offer.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (284, 'Flow Control Products', 'flow-control-products', '', 124, '{"title":"Flow Control Products - Worldwide Oilfield Machine","description":"WOM Group, leading manufacturing company specializes in advanced technique, designing and manufacturing of required Flow Control Products.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (294, 'Riser Systems-10K and 15K', 'riser-systems', '', 264, '{"title":"Riser Systems-10K and 15K Archives - Worldwide Oilfield Machine","description":"In the market for a Riser System - 10K or 15K? Visit this page to see the full list of Deepwater Riser Systems we offer.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (295, 'Riserless Systems - 10K and 15K', 'riserless-systems', '', 264, '{"title":"Riserless Systems - 10K and 15K Archives","description":"In the market for a Riserless System - 10K and 15K? Visit this page to see the full list of Riser Systems we offer.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (296, 'Products', 'products-si-systems', '', 264, '{"title":"Products Archives - Worldwide Oilfield Machine","description":"In the market for a Subsea Intervention System? Visit this page to see the full list of Subsea Intervention Systems we offer.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (300, 'Connectors', 'connectors', '', 265, '{"title":"Connectors Archives - Worldwide Oilfield Machine","description":"In the market for Subsea Production Systems Connectors? Visit this page to see the full list of connectors we have to offer.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;
INSERT INTO public.categories (id, name, slug, description, parent_id, seo) VALUES (301, 'Subsea Valves and Actuators', 'products-subsea-ps', '', 265, '{"title":"Subsea Valves and Actuators Archives - Worldwide Oilfield Machine","description":"In the market for Subsea Valves and Actuators? Visit this page to see the full product list of Subsea Valves and Actuators we offer.","image":{"url":"/uploads/2019/11/WOMImg.jpg","originalUrl":"https://worldwideoilfieldmachinery.com/wp-content/uploads/2019/11/WOMImg.jpg","localExists":false}}'::jsonb) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;

-- Seeding Locations (17 records)
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (20499, 'WOM Colorado Facility', 'wom-colorado-facility', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (20784, 'Wilcrest Facility', 'wilcrest-facility', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (23463, 'Magna Specialty Steel (MSS)', 'magna-specialty-steel-mss', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (3346, 'Canemont Facility (International Headquarters)', 'canemont-international-headquarters', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (3384, 'WOM BOP Cunningham Facility', 'cunningham-facility', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (3400, 'WOM Inc. Fairmont Assembly &#038; Repair Facility', 'fairmont-assembly-repair-facility', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (3414, 'WOM Subsea Tanner USA Facility', 'tanner-subsea-facility', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (3430, 'WOM Middle East Dubai', 'wom-middle-east', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (3651, 'Magnum Technology Center Dubai', 'magnum-technology-center', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (3671, 'WOM UK Aberdeen Facility', 'aberdeen-facility', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (3685, 'WOM Asia Pacific Singapore', 'wom-asia-pacific', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (3700, 'Worldwide Oilfield Machine - India', 'pune-headquarters', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (3716, 'Magnum Forge &#038; Machine Works', 'magnum-forge-machine-works', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (3756, 'Magna Casting &#038; Machine Works', 'magna-casting-machine-works', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (8087, 'WOM Valves &#038; Controls Intl.', 'wom-valves-controls-intl', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (8253, 'WOM Midland Facility', 'wom-midland-usa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.locations (id, title, slug, region, address, city, country, phone, email, lat, lng) VALUES (9205, 'WOM Brazil', 'wom-brazil', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;

-- Seeding Resources (43 records)
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (16683, 'USA-Canemont API Q1', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (16824, 'AP-Singapore ISO 45001', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (17088, 'USA-Fairmont API 16D-013', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (19346, 'USA-Fairmont API 16A-0567', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (20852, 'USA-Canemont ISO 45001', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (20881, 'USA-Canemont ISO 14001', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (22865, 'India-MSARC00OOAU5', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (22867, 'India-Certificate of Accreditation', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (23378, 'USA-Cunningham API Q1', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (2375, 'USA-Canemont API 16A 0495', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (2378, 'USA-Canemont API 16C 0406', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (2381, 'USA-Canemont ISO 9001', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (2388, 'USA - Canemont CE-004-PED-H-WOM', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (2393, 'USA-Fairmont API 6A-1874', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (2397, 'USA-Fairmont API 6D-1689', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (2401, 'USA-Fairmont API 16C-0397', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (2404, 'USA-Fairmont API 17D-0161', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (2410, 'India API 6D-0548', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (2413, 'India ISO 9001', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (2419, 'USA-Canemont API 6A 1912', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (2420, 'USA-Canemont API 6D 1731', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7372, 'ME-Dubai ISO 9001  2015', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7375, 'ME-Dubai ISO 45001-2018(OHSAS)', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7378, 'ME-Dubai ISO 14001-2015', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7381, 'ME 13086-2018-CE-IND-ACCREDIA', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7385, 'ME 16A-1633', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7388, 'ME 16C 0311', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7391, 'ME 16A 0416', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7777, 'USA-Cunningham 16A-0079', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7782, 'USA-Cunningham  6A-0394', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7802, 'India 16A-0080', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7805, 'India 16C-0200', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7808, 'India 20E-0043', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7811, 'India 6A-0203', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7814, 'India ATEX-WOM', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7817, 'India CE Cert', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7820, 'India ISO 45001', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7826, 'India MSA0000AU4', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7832, 'AP-Singapore ISO 14001', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7838, 'AP-Singapore ISO 9001', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (7844, 'UK ISO 9001-ISO 14001 &#038; OHSAS 18001', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (8209, 'India ISO 14001', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.resources (id, title, category, file_url, file_size, description) VALUES (8420, 'India API Q1', NULL, NULL, '', '') ON CONFLICT (id) DO NOTHING;

-- Seeding Products (96 records)
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8978, '13 5/8-10K Wellhead / XT (H4 Connector)', '13-5-8-10k-wellhead-xt-h4-connector', '', '		<div data-elementor-type="wp-post" data-elementor-id="8978" class="elementor elementor-8978" data-elementor-post-type="product">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-44182840 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="44182840" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-42b42f2a" data-id="42b42f2a" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-76d1d1ef elementor-widget elementor-widget-text-editor" data-id="76d1d1ef" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									<p></p>
<p class="wp-block-paragraph">This product is suitable for water depths up to 1,000 ft (~300 m).</p>
<p></p>
<p></p>
<h3 class="womtitle wp-block-heading">Features</h3>
<p></p>
<p></p>
<ul class="wp-block-list">
<li>Used with WOM’s Intervention Riser System</li>
<li>18 ¾-10K H4 Hub with 13 5/8-10K API Flanged Top</li>
<li><span style="font-size: 1rem;">18 ¾ VX / MVX Metal Gasket Compatible</span></li>
<li>Hydraulically-actuated Secondary Lock Mechanism</li>
<li>Design Verified by DNV-GL</li>
</ul>
<p></p>
<p></p>
<h3 class="womtitle wp-block-heading">Industry Standards</h3>
<p></p>
<p></p>
<figure class="wp-block-table">
<table>
<tbody>
<tr>
<td>
  <strong>NAME</strong>
  </td>
<td>
  <strong>DESCRIPTION</strong>
  </td>
<td>
  <strong>REV</strong>
  </td>
</tr>
<tr>
<td>API 6A /ISO 10423   </td>
<td>
  Specification for Wellhead and Christmas Tree Equipment (Latest Edition)
  </td>
<td>   21st Ed. <br>Oct 2010   </td>
</tr>
<tr>
<td>API 17D /ISO 13628-4   </td>
<td>
  Specification for Subsea Wellhead &amp; Christmas Tree Equipment (Latest Edition)
  </td>
<td>
  2<sup>nd&nbsp;</sup>&nbsp;Ed.<br>  May 2011
  </td>
</tr>
<tr>
<td>API17G /ISO 13628-7   </td>
<td>
  Petroleum and natural gas industries &#8211; Design and operation of Subsea production systems-part 7: Completion / work over riser system
  </td>
<td>
  2<sup>nd</sup>&nbsp;Ed.<br>  July 2006
  </td>
</tr>
<tr>
<td>SAE AS4059   </td>
<td>
  Aerospace Fluid Power – Cleanliness Classification for Hydraulic Fluid&nbsp;</td>
<td>
  AS4059F<br>  Sept 2013
  </td>
</tr>
<tr>
<td>NACE MR0175 /ISO 15156   </td>
<td>
  Petroleum and natural gas industries- Materials for use in H<sub>2</sub>S-containing<br>  environments in oil and gas production
  </td>
<td>
  2<sup>nd</sup>&nbsp;Ed.<br>  July 2006
  </td>
</tr>
<tr>
<td>DNVGL-OS-E101   </td>
<td>
  Offshore standards, Drilling facilities
  </td>
<td>
  Jan 2018
  </td>
</tr>
</tbody>
</table>
</figure>
<p></p>
<p></p>
<h3 class="womtitle wp-block-heading">Operating Specification</h3>
<p></p>
<p></p>
<figure class="wp-block-table is-style-stripes">
<table>
<tbody>
<tr>
<td><strong>   PRESSURE   CRITERIA   </strong></td>
<td><strong>   SPECIFICATION   </strong></td>
</tr>
<tr>
<td>
  Maximum working pressure
  </td>
<td>
  10,000 Psi
  </td>
</tr>
<tr>
<td>
  Maximum Test pressure
  </td>
<td>
  15,000<br>  Psi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </td>
</tr>
<tr>
<td><strong>   TEMPERATURE/ DESIGN CRITERIA   </strong></td>
<td><strong>   SPECIFICATION   </strong></td>
</tr>
<tr>
<td>
  Temperature Rating
  </td>
<td>
  P+U
  </td>
</tr>
<tr>
<td>
  Min. Design Temperature
  </td>
<td>
  -20° F
  </td>
</tr>
<tr>
<td>
  Max. Design Temperature
  </td>
<td>
  250° F
  </td>
</tr>
<tr>
<td>
  Nominal bore size
  </td>
<td>
  7 3/8”
  </td>
</tr>
<tr>
<td>
  Drift Dia.
  </td>
<td>
  7.345 +.027/-.000
  </td>
</tr>
<tr>
<td>
  PSL Level
  </td>
<td>
  PSL-3G
  </td>
</tr>
<tr>
<td>
  PR Level
  </td>
<td>
  2
  </td>
</tr>
<tr>
<td>   <strong> INTERFACE   DATA   </strong> </td>
<td></td>
</tr>
<tr>
<td>
  Upper Connection
  </td>
<td>
  13-5/8-10K API Studded<br>  Flange<br>  BX-159 Ring Gasket<br>  9.5” Seal-sub pocket
  </td>
</tr>
<tr>
<td>
  Lower Connection
  </td>
<td>
  18- ¾ -10 K H4 hub
  </td>
</tr>
<tr>
<td>
  &nbsp;
  </td>
<td>
  SPECIFICATION
  </td>
</tr>
<tr>
<td>
  Water depth
  </td>
<td>
  10,000 FT (Based upon<br>  loading)
  </td>
</tr>
<tr>
<td>
  Service Condition
  </td>
<td>
  H2S per NACE MR 01-75
  </td>
</tr>
<tr>
<td>
  API Monogram
  </td>
<td>
  No
  </td>
</tr>
</tbody>
</table>
</figure>
<p></p>								</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		', '2019-10-03T17:40:40', NULL, 'USD', true, '[{"id":296,"name":"Products","slug":"products-si-systems"}]'::jsonb, '{"url":"/uploads/2019/10/H4Connector.jpg","width":432,"height":371,"alt":"13 5/8-10K Wellhead / XT (H4 Connector)"}'::jsonb, '{"title":"13 5/8-10K Wellhead / XT (H4 Connector) - WOM Group","description":"WOM Group leading hydraulic actuated equipment company. WOM developed a 13 5/8-10K Wellhead/XT connector (H4) Connector.","ogImage":"/uploads/2019/10/H4Connector.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8966, '13 5/8-15K Subsea Well Cap(Capping Stack)', '13-5-8-15k-subsea-well-capcapping-stack', '', '
<p class="wp-block-paragraph">This product controls, diverts, and shuts in a well flow stream during a well containment operation. </p>



<p class="has-vivid-red-color has-text-color wp-block-paragraph"><strong>WOM Well Cap was part of the system used while containing BP Macondo incident.</strong></p>



<h3 class="womtitle wp-block-heading">Features</h3>



<ul class="wp-block-list"><li><strong>WORKING DEPTH: </strong>The ability to fully operate in water depths of up to 10,000 feet</li><li><strong>SIZES:</strong>&nbsp; The WOM system has dual 13 5/8” ram
assemblies (cavities). Optional sizes can be provided.</li><li><strong>OPERATIONS:</strong> Interface is quickly adaptable to any
BOP stack interfaces or X-mas tree configuration. Deployment from a variety of
MODU or MSV vessels from semi to monohull. Sized and designed for rapid
optional transportation methods.</li><li><strong>uniqueness:</strong>
Control system both ROV operated as well as WOM incorporates direct controls to
latch the assembly and secure the well. Accumulation system can be charged
subsea from surface or from a SAM (subsea accumulator module).</li><li><strong>DESIGN:</strong>
Two dual block valves (fail safe) provide venting or circulation beneath the
rams. Two subsea chokes installed in the system, one at each dual block outlet.</li><li><strong>RELIABILITY:&nbsp; </strong>Controls preprogram capability for
valves either “open” or “closed” operation. This feature would be used after
the intervention system is installed and flow is being captured or the well is
being intervened or killed/temporarily abandoned. It would serve to either open
the vents or to secure them in the event of an emergency disconnect or drive
off of the vessel/rig.</li><li><strong>EASE OF OPERATIONS:</strong> The system is equipped with local subsea pressure gauges and optional acoustic transmitted pressure transducers to relay pressures above and below the rams to surface. Lighter weight assembly capable of being deployed on cable, drill pipe or riser as required. </li></ul>
', '2019-10-01T17:01:10', NULL, 'USD', true, '[{"id":295,"name":"Riserless Systems - 10K and 15K","slug":"riserless-systems"},{"id":299},{"id":264,"name":"Subsea Intervention Systems","slug":"si-systems"},{"id":298}]'::jsonb, '{"url":"/uploads/2019/10/Capping-Stack.jpg","width":600,"height":515,"alt":"13 5/8-15K Subsea Well Cap(Capping Stack)"}'::jsonb, '{"title":"13 5/8-15K Subsea Well Cap(Capping Stack) - Worldwide Oilfield Machine","description":"WOM''s Subsea Well Cap (Capping Stack) controls, diverts, and shuts in a well flow stream during a well containment operation.","ogImage":"/uploads/2019/10/Capping-Stack.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (9005, '13-5/8 - 10K Subsea Wellhead', '13-5-8-10k-subsea-wellhead', '', '		<div data-elementor-type="wp-post" data-elementor-id="9005" class="elementor elementor-9005" data-elementor-post-type="product">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-1d7b50ce elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="1d7b50ce" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-3b8b0aa0" data-id="3b8b0aa0" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-5f75cf17 elementor-widget elementor-widget-text-editor" data-id="5f75cf17" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									
<h3 class="has-text-align-center womtitle wp-block-heading">Apache Wellhead Australia</h3>
<p> </p>

<div class="wp-block-columns alignwide has-2-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-vertically-aligned-center is-layout-flow wp-block-column-is-layout-flow" style="flex-basis: 43.6%;">
<ul class="wp-block-list">
<li>Apache Stag 40H</li>
<li>80 m. Water Depth</li>
<li>Water Injection Tree.</li>
<li>Vertical XT: 5 X 2 – 5K</li>
</ul>

<p class="wp-block-paragraph"> </p>
</div>

<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow" style="flex-basis: 55.5%;">
<div class="wp-block-image is-style-default">
<figure class="aligncenter size-large is-resized"><a href="/uploads/2020/10/Apache-Wellhead.jpg"><img fetchpriority="high" decoding="async" data-src="/uploads/2019/10/WellheadSmall.jpg" class="wp-image-15843 lazyload" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" width="365" height="273" /><noscript><img decoding="async" data-src="/uploads/2019/10/WellheadSmall.jpg" class="wp-image-15843 lazyload" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" width="365" height="273"><noscript><img decoding="async" class="wp-image-15843" src="/uploads/2019/10/WellheadSmall.jpg" alt="" width="365" height="273" srcset="/uploads/2019/10/WellheadSmall.jpg 750w, /uploads/2019/10/WellheadSmall-300x225.jpg 300w" sizes="(max-width: 365px) 100vw, 365px" /></noscript></noscript></a></figure>
</div>
</div>
</div>

<h3 class="has-text-align-center womtitle wp-block-heading">JAMSTEC Subsea Wellhead Japan</h3>

<div class="wp-block-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow" style="flex-basis: 24%;">
<ul class="wp-block-list" id="block-77e73611-039c-4b70-b87d-c9d5652545ad">
<li>Methane Wells (3 x)</li>
<li>300 Meter Water Depth</li>
</ul>
</div>

<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow" style="flex-basis: 27.2%;">
<div class="wp-block-spacer" style="height: 54px;" aria-hidden="true"> </div>
</div>
</div>

<div class="wp-block-columns has-2-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<div class="wp-block-image">
<figure class="aligncenter size-large is-resized"><a href="/uploads/2019/10/JamstecWellhead.jpg"><img loading="lazy" decoding="async" data-src="/uploads/2019/10/JamstecWellhead.jpg" class="wp-image-15838 lazyload" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" width="563" height="422" /><noscript><img loading="lazy" decoding="async" data-src="/uploads/2019/10/JamstecWellhead.jpg" class="wp-image-15838 lazyload" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" width="563" height="422"><noscript><img loading="lazy" decoding="async" class="wp-image-15838" src="/uploads/2019/10/JamstecWellhead.jpg" alt="" width="563" height="422" srcset="/uploads/2019/10/JamstecWellhead.jpg 750w, /uploads/2019/10/JamstecWellhead-300x225.jpg 300w" sizes="(max-width: 563px) 100vw, 563px" /></noscript></noscript></a></figure>
</div>
</div>

<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<div class="wp-block-image">
<figure class="aligncenter size-large is-resized"><a href="/uploads/2019/10/JamstecWellhead2.jpg"><img loading="lazy" decoding="async" data-src="/uploads/2019/10/JamstecWellhead2.jpg" class="wp-image-15839 lazyload" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" width="563" height="422" /><noscript><img loading="lazy" decoding="async" data-src="/uploads/2019/10/JamstecWellhead2.jpg" class="wp-image-15839 lazyload" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" width="563" height="422"><noscript><img loading="lazy" decoding="async" class="wp-image-15839" src="/uploads/2019/10/JamstecWellhead2.jpg" alt="" width="563" height="422" srcset="/uploads/2019/10/JamstecWellhead2.jpg 750w, /uploads/2019/10/JamstecWellhead2-300x225.jpg 300w" sizes="(max-width: 563px) 100vw, 563px" /></noscript></noscript></a></figure>
</div>
</div>
</div>
								</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		', '2019-10-02T21:27:42', NULL, 'USD', true, '[{"id":266,"name":"Xmas Trees and Wellheads","slug":"xmas-trees-and-wellheads"}]'::jsonb, '{"url":"/uploads/2019/10/SubseaWellHead13.jpg","width":432,"height":371,"alt":"13-5/8 &#8211; 10K Subsea Wellhead"}'::jsonb, '{"title":"13-5/8 - 10K Subsea Wellhead - Worldwide Oilfield Machine","description":"In the market for a 13-5/8 – 10K Subsea Wellhead? Visit our page to learn its specifications and features. Downloadable brochure available.","ogImage":"/uploads/2019/10/SubseaWellHead13.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8684, '6 3/8-15K Coil Cutting Valves', '6-3-8-15k-coil-cutting-valves', '', '
<p class="wp-block-paragraph">Based on gate valve technology to cut and seal coil tubing, our CCV is equipped with a horizontal, hydraulically-actuated single gate made to shear and seal coiled tubing and wire line of a given specification in the wellbore. A seal is made after the shearing, isolating the pressure/fluids from both upstream and downstream. The coil cutting valve is powered by accumulators and can be overridden via ROV manual over-ride.</p>



<h3 class="womtitle wp-block-heading">Industry Standards</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  <strong>NAME</strong>
  </td><td>
  <strong>DESCRIPTION</strong>
  </td><td>
  <strong>REV</strong>
  </td></tr><tr><td>API 6A /<br>   ISO 10423   </td><td>
  Specification for Wellhead and Christmas Tree
  Equipment (Latest Edition)
  </td><td>
  20<sup>th</sup> Edition
  October 2010
  </td></tr><tr><td>API 17D /<br>   ISO 13628-4   </td><td>
  Specification for Subsea Wellhead &amp; Christmas
  Tree Equipment (Latest Edition)
  </td><td>
  2<sup>nd </sup>&nbsp;Edition
  May 2011
  </td></tr><tr><td>API 17G /<br>   ISO 13628-7   </td><td>
  Petroleum and natural gas industries- Design and
  operation of Subsea production systems-part 7: Completion / work over riser
  system
  </td><td>
  2<sup>nd </sup>&nbsp;Edition
  July 2006
  </td></tr><tr><td>SAE AS4059   </td><td>
  Aerospace Fluid Power – Cleanliness Classification
  for Hydraulic Fluid (Latest Edition)
  </td><td>
  AS4059F
  September 2013
  </td></tr><tr><td>NACE MR0175 /<br>   ISO 15156   </td><td>
  Petroleum and natural gas industries- Materials for
  use in H<sub>2</sub>S-containing environments in oil and gas production
  </td><td>
  2<sup>nd </sup>&nbsp;Edition
  July 2006
  </td></tr><tr><td>DNVGL-OS-E101   </td><td>
  Offshore standards, Drilling facilities
  </td><td>
  January 2018
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Operating Specification</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  <strong>Pressure
  / Loading Criteria</strong>
  </td><td>
  <strong>Specification</strong>
  </td></tr><tr><td>
  Maximum working pressure
  </td><td>
  15,000 Psi
  </td></tr><tr><td>
  Maximum Test pressure
  </td><td>
  22,500 Psi
  </td></tr><tr><td>
  <strong>Temperature
  / Design Criteria</strong>
  </td><td>
  <strong>Specification</strong>
  </td></tr><tr><td>
  Temperature Rating
  </td><td>
  P+U
  </td></tr><tr><td>
  Min. Design Temperature
  </td><td>
  -20° F
  </td></tr><tr><td>
  Max. Design Temperature
  </td><td>
  250° F
  </td></tr><tr><td>
  Nominal bore size
  </td><td>
  6 3/8”
  </td></tr><tr><td>
  Drift Dia
  </td><td>
  6.345 +.027/-.000
  </td></tr><tr><td>
  Shear Class
  </td><td>
  Coil Tubing and Wire line
  </td></tr><tr><td>
  Material Class
  </td><td>
  EE-NL (or) Customer Requirement
  </td></tr><tr><td>
  PSL Level
  </td><td>
  PSL-3G
  </td></tr><tr><td>
  PR Level
  </td><td>
  2
  </td></tr><tr><td>
  <strong>Operating
  Criteria</strong>
  </td><td>
  <strong>Specification</strong>
  </td></tr><tr><td>
  Water depth
  </td><td>
  10,000 FT
  </td></tr><tr><td>
  Service Condition
  </td><td>
  H2S per NACE MR 01-75
  </td></tr><tr><td>
  ROV override turns to Close
  </td><td>
  60-62 turns to Clock-wise
  </td></tr><tr><td>
  Torque to operate override
  </td><td>
  1900 ft-lbs
  </td></tr><tr><td>
  Torque Bucket
  </td><td>
  Class 5 (2.0” sq)
  </td></tr><tr><td>
  API Monogram
  </td><td>
  No
  </td></tr><tr><td>
  ROV Override
  </td><td>
  Open to Close only
  </td></tr><tr><td>
  Stroke
  </td><td>
  8.75”
  </td></tr></tbody></table></figure>



<p class="wp-block-paragraph">
















NOTE: ROV MOR is not capable of
shearing tubular



</p>



<h3 class="womtitle wp-block-heading">Hydraulic Data</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  Control Fluid Type
  </td><td>
  HW443 (or) Water based Glycol
  </td></tr><tr><td>
  Control Fluid Cleanliness
  </td><td>
  SAE AS4059 CLASS 6B-6F
  </td></tr><tr><td>
  Max. Hydraulic Working Pressure
  </td><td>
  3,000 psi
  </td></tr><tr><td>
  Max. Hydraulic Test Pressure
  </td><td>
  4,500 psi
  </td></tr><tr><td>
  Cylinder Volume
  </td><td>Open: 5.45 US GAL per one Actuator&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   <br>Close: 5.78 US GAL per one Actuator   </td></tr><tr><td>
  Compensator Fluid Type
  </td><td>
  BIOHYDRAN(2.6 US GAL APPROX) per one
  MOR
  </td></tr><tr><td>
  Compensator Check valves (cracking
  pressure)
  </td><td>
  50 psi
  </td></tr></tbody></table></figure>
', '2019-10-06T17:53:01', NULL, 'USD', true, '[{"id":296,"name":"Products","slug":"products-si-systems"},{"id":264,"name":"Subsea Intervention Systems","slug":"si-systems"}]'::jsonb, '{"url":"/uploads/2019/10/CoilCuttingValves.jpg","width":432,"height":371,"alt":"6 3/8-15K Coil Cutting Valves"}'::jsonb, '{"title":"6 3/8-15K Coil Cutting Valves - Worldwide Oilfield Machine","description":"In the market for a 6 3/8-15K Coil Cutting Valves? Visit our page to learn its specifications and features. Downloadable brochure available.","ogImage":"/uploads/2019/10/CoilCuttingValves.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8948, '6 3/8-15K Deepwater Riser System (DRS)', '6-3-8-15k-deepwater-riser-system-drs', '', '
<p class="wp-block-paragraph">The system comprises of the following: </p>



<ul class="wp-block-list"><li>A topside package to be located on a rig, including flow head system, service manifold package and HPU.</li><li>Riser system connected to the flow head and top of the emergency disconnect package.</li><li>A subsea intervention package that will be connected to the Christmas tree, comprising an Emergency Disconnection Package (EDP), a Lower Riser Package (LRP).</li></ul>



<h3 class="womtitle wp-block-heading">Features</h3>



<ul class="wp-block-list"><li>Unique design, utilizing metal-to-metal sealing gate valves in the intervention system. </li><li>Two levels of redundancy for safety. </li><li>Fitted with an emergency shutdown (ESD) control system. </li><li>All production bore valves are capable of cutting coil tubing. </li><li>MUX Control system improving response time in emergency functions.</li><li>Ability to disconnect EDP at high angle without potential damage. </li><li>The DRS can disconnect at +/-10°due to an enhanced frame design and the inclusion of a 2” retractable Annulus line stab assembly</li><li>Removable EDP Re-entry Mandrel </li><li>Increased coil cutting capability</li></ul>



<h3 class="womtitle wp-block-heading">Industry Standards</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td> <strong>NAME</strong>   </td><td><strong>DESCRIPTION</strong>   </td><td><strong>REV</strong>   </td></tr><tr><td>API 6A /ISO 10423   </td><td>Specification   for Wellhead and Christmas Tree Equipment (Latest Edition)   </td><td>20<sup>th</sup> Edition October 2010   </td></tr><tr><td>API 17D /&nbsp;ISO 13628-4   </td><td>Specification   for Subsea Wellhead &amp; Christmas Tree Equipment (Latest Edition)   </td><td>2<sup>nd   </sup>&nbsp;Edition May   2011   </td></tr><tr><td>API 17G / ISO 13628-7   </td><td>Petroleum   and natural gas industries- Design and operation of Subsea production   systems-part 7: Completion / work over riser system   </td><td>2<sup>nd   </sup>Edition   July   2006   </td></tr><tr><td>SAE  AS4059</td><td>Aerospace   Fluid Power – Cleanliness Classification for Hydraulic Fluid (Latest Edition)   </td><td>AS4059F September   2013   </td></tr><tr><td>NACE MR0175 /ISO 15156   </td><td>Petroleum   and natural gas industries- Materials for use in H<sub>2</sub>S-containing   environments in oil and gas production   </td><td>2<sup>nd  </sup>&nbsp;Edition July 2006   </td></tr><tr><td>DNVGL-OS-E101   </td><td>Offshore   standards, Drilling facilities   </td><td>January   2018   </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Operating Specification</h3>



<figure class="wp-block-table alignleft womblue is-style-stripes"><table class="has-fixed-layout"><tbody><tr><td>   <strong>PRESSURE   CRITERIA   </strong></td><td><strong>   SPECIFICATION </strong>  </td></tr><tr><td>
  Maximum working pressure
  </td><td>
  15,000 Psi
  </td></tr><tr><td>
  Maximum Test pressure
  </td><td>
  25,500
  Psi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
  </td></tr><tr><td>  <strong> TEMPERATURE   / DESIGN CRITERIA   </strong></td><td> <strong>  SPECIFICATION  </strong> </td></tr><tr><td>
  Temperature Rating
  </td><td>
  P+U
  </td></tr><tr><td>
  Min. Design Temperature
  </td><td>
  -20° F
  </td></tr><tr><td>
  Max. Design Temperature
  </td><td>
  250° F
  </td></tr><tr><td>
  Nominal bore size
  </td><td>
  6 3/8”
  </td></tr><tr><td>
  Drift Dia.
  </td><td>
  6.34 +.027/-.000
  </td></tr><tr><td>
  Material Class
  </td><td>
  EE-NL
  </td></tr><tr><td>
  PSL Level
  </td><td>
  PSL-3G
  </td></tr><tr><td>
  PR Level
  </td><td>
  2
  </td></tr><tr><td> <strong>  OPERATING   CRITERIA   </strong></td><td><strong>   SPECIFICATION   </strong></td></tr><tr><td>
  Water depth
  </td><td>
  10,000 FT (Based upon
  loading)
  </td></tr><tr><td>
  Service Condition
  </td><td>
  H2S per NACE MR 01-75
  </td></tr><tr><td>
  API Monogram
  </td><td>
  No
  </td></tr></tbody></table></figure>



<h2 class="womtitle wp-block-heading">Emergency Disconnect Package(EDP)</h2>



<div class="wp-block-columns has-2-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<p class="wp-block-paragraph"><br>The Emergency Disconnect Package (EDP) forms part of the well intervention package, which will be, used during well intervention operations from a DP or anchored Rig. The EDP is designed to allow disconnection of the riser system from the LRP assembly in the event of weather dictated disconnect, routine operational requirements or vessel induced drive off/ drift off situations.</p>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<figure class="wp-block-image"><img fetchpriority="high" decoding="async" width="287" height="237" data-src="/uploads/2019/10/DRS-EDP.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-8957 lazyload"/><noscript><img decoding="async" width="287" height="237" src="/uploads/2019/10/DRS-EDP.jpg" alt="" class="wp-image-8957"></noscript></figure>
</div>
</div>



<h3 class="womtitle wp-block-heading">Lower Riser Package(LRP)</h3>



<div class="wp-block-columns has-2-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<p class="wp-block-paragraph"><br><br>The Lower Riser Package (LRP) forms part of an Intervention Package. This equipment is designed to land out and lock onto a Subsea Production Tree and has surface-controlled gate valves to close in the well during intervention operations. </p>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<figure class="wp-block-image"><img decoding="async" width="287" height="237" data-src="/uploads/2019/10/LowerRiserPackage.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-8959 lazyload"/><noscript><img loading="lazy" decoding="async" width="287" height="237" src="/uploads/2019/10/LowerRiserPackage.jpg" alt="" class="wp-image-8959"></noscript></figure>
</div>
</div>
', '2019-10-11T14:56:36', NULL, 'USD', true, '[{"id":294,"name":"Riser Systems-10K and 15K","slug":"riser-systems"},{"id":264,"name":"Subsea Intervention Systems","slug":"si-systems"}]'::jsonb, '{"url":"/uploads/2019/10/DRS-Main.jpg","width":432,"height":371,"alt":"6 3/8-15K Deepwater Riser System (DRS)"}'::jsonb, '{"title":"Deepwater Riser System, 6 3/8-15K DRS - Worldwide Oilfield Machine","description":"Worldwide Oilfield Machine (WOM) developed a proprietary subsea Intervention Riser. Know more about 6 3/8-15K Deepwater Riser System (DRS).","ogImage":"/uploads/2019/10/DRS-Main.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8721, '6 3/8-15K Safety Head (Compact Cutting Device)', '6-3-8-15k-safety-head-ccd', '', '
<p class="wp-block-paragraph"><strong>Hydraulically operated, compact, shear and seal valve designed with high cutting performance and reliable post-cut sealing</strong></p>



<p class="wp-block-paragraph">This CCD is designed with opposing horizontal hydraulically actuated gate valves made to shear coiled tubing, drill pipe, and wire line of a given specification in the wellbore and seal from below.  A seal is made after the shearing, isolating the pressure/fluids beneath the CCD. It is used in offshore and/or high-pressure applications where cutting of the well string is required without leaving a snag. The device is powered by accumulators and can be overridden via ROV hot stab in either direction. </p>



<p class="wp-block-paragraph">With a reduced package size, our CCD can be easily transported and installed using economic methods, reducing overall time and costs for subsea projects. </p>



<p class="wp-block-paragraph">The gate valves are fail-as-is.
The external position indicator will show where the gate valve positions are at
all times. A locking mechanism prevents the gates from creeping back after they
have closed. In case of a failure, an override tool may be used to open or
close the CCD. This override tool is ROV actuated.</p>



<ul class="wp-block-list"><li>6-3/8” Bore, 15 KSI parallel cutting and sealing gate valve design.</li><li>Unidirectional coiled tubing cutting valve with recirculation capability.</li><li>Demountable actuators to facilitate in-situ maintenance. </li><li>Compact Design</li><li>Separate cutting and sealing components in a single device.</li></ul>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td><strong>Design Data</strong></td><td></td></tr><tr><td>
  Nominal Bore Diameter
  </td><td>
  Ø6 3/8” 
  </td></tr><tr><td>
  Design Wellbore Pressure
  </td><td>
  Working: 15,000 psi.<br>
  Test: 22,500 psi.
  </td></tr><tr><td>
  Design Standard
  </td><td>
  API 17G &amp; NORSOK D-002
  </td></tr><tr><td>
  Temperature Class (Design)
  </td><td>
  P+U (-20°F to 250°F)
  </td></tr><tr><td>
  Service
  </td><td>
  H<sub>2</sub>S -IN accordance with
  NACE MR0175
  </td></tr><tr><td>
  Drift Dia.
  </td><td>
  6.345 +.027/-.000
  </td></tr><tr><td>
  Design Life
  </td><td>
  Min. 20 years
  </td></tr><tr><td>
  Product Specification Level
  </td><td>
  PSL-3G
  </td></tr><tr><td>
  Shearing Class
  </td><td>
  Wireline/Coiled Tubing
  </td></tr></tbody></table></figure>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td><strong>Performance Data</strong></td><td></td></tr><tr><td>Maximum Hydraulic Pressure   </td><td>
  5,000 psi
  </td></tr><tr><td>Cylinder Volume (Total, Approx.)   </td><td>
  Open: 5.45 US gal (20.63 liters)
  Secondary Open: 5.45 US gal (20.63
  liters)
  Close: 5.77 US gal (21.86 liters)
  Secondary Close: 5.77 US gal (21.86
  liters)
  </td></tr><tr><td>Locking Piston Volumes   </td><td>
  Lock: 0.091 US gal (0.348 liters)
  Unlock: 0.019 US gal (0.072 liters)
  </td></tr><tr><td>Control Fluid Type   </td><td>
  HW443 (or) Water based Glycol
  </td></tr></tbody></table></figure>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>Validation Level</td><td></td></tr><tr><td>
  Design Validation Level
  </td><td>
  API-17G (3<sup>rd </sup>Edition-
  Ballot)
  </td></tr><tr><td>
  Certification
  </td><td>
  DNV-OS-E101 Cat. 1
  </td></tr></tbody></table></figure>
', '2019-10-08T21:51:28', NULL, 'USD', true, '[{"id":296,"name":"Products","slug":"products-si-systems"}]'::jsonb, '{"url":"/uploads/2019/10/SafetyHead6Inch.jpg","width":432,"height":371,"alt":"6 3/8-15K Safety Head (Compact Cutting Device)"}'::jsonb, '{"title":"6 3/8-15K Safety Head (Compact Cutting Device) - WOM Group","description":"WOM''s 6-3/8” – 15K Compact Cutting Device (CCD) designed with opposing horizontal hydraulically actuated gate valves made to shear coiled tubing, drill pipe, and wire line of a given specification in the wellbore and seal from below.","ogImage":"/uploads/2019/10/SafetyHead6Inch.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8726, '6 3/8-15K Surface Tree (Flow head)', '6-3-8-15k-surface-tree-flow-head', '', '
<p class="wp-block-paragraph">This surface flowhead assembly is an integral part of the Intervention riser string assembly. The unit allows the access to the well bore thru the riser with a variety of wireline and coil tubing tools. It is designed to accommodate coil tubing lift frames and is suspended via 10-3/4” standard casing elevators. </p>



<h3 class="womtitle wp-block-heading">Features</h3>



<ul class="wp-block-list">
<li>Compact
valve block design for reduced weight and package height.</li>



<li>Includes
two 6-3/8-15K field proven valve.</li>



<li>Includes
two 4-1/16-15K field proven valves.</li>



<li>Includes
a 6-3/8” 10k dynamic swivel assembly per NACE MR-01-75.</li>



<li>Mechanical
Over-ride for valve actuators.</li>
</ul>



<h3 class="womtitle wp-block-heading">Industry Standards</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  <strong>NAME</strong>
  </td><td>
  <strong>DESCRIPTION</strong>
  </td><td>
  <strong>REV</strong>
  </td></tr><tr><td>API   6A / ISO 10423   </td><td>Specification   for Wellhead and Christmas Tree Equipment (Latest Edition)   </td><td>20<sup>th</sup> Edition   October 2010   </td></tr><tr><td>API   17D /ISO 13628-4   </td><td>Specification   for Subsea Wellhead &amp; Christmas Tree Equipment (Latest Edition)   </td><td>2<sup>nd   </sup>&nbsp;Edition   May   2011   </td></tr><tr><td>API   17G /ISO 13628-7   </td><td>Petroleum   and natural gas industries- Design and operation of Subsea production   systems-part 7: Completion / work over riser system   </td><td>2<sup>nd   </sup>&nbsp;Edition   July   2006   </td></tr><tr><td>SAE AS4059   </td><td>Aerospace   Fluid Power – Cleanliness Classification for Hydraulic Fluid (Latest Edition)   </td><td>AS4059F   September   2013   </td></tr><tr><td>NACE MR0175 /ISO 15156   </td><td>Petroleum   and natural gas industries- Materials for use in H<sub>2</sub>S-containing   environments in oil and gas production   </td><td>2<sup>nd   </sup>&nbsp;Edition   July   2006   </td></tr><tr><td>DNVGL-OS-E101   </td><td>Offshore   standards, Drilling facilities   </td><td>January   2018   </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Operating Specification</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  <strong>Pressure / Loading Criteria</strong>
  </td><td>
  <strong>Specification</strong>
  </td></tr><tr><td>
  Maximum working pressure
  </td><td>
  15,000 Psi
  </td></tr><tr><td>
  Maximum Test pressure
  </td><td>
  22,500
  Psi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
  </td></tr><tr><td>
  Load Rating @250°F
  </td><td>
  1,500,000
  lbs @0 psi
  </td></tr><tr><td>
  Load Rating @250°F
  </td><td>
  750,
  000 lbs @10,000 psi
  </td></tr><tr><td>
  <strong>Temperature / Design Criteria</strong>
  </td><td>
  <strong>Specification</strong>
  </td></tr><tr><td>
  Temperature Rating
  </td><td>
  P+U
  </td></tr><tr><td>
  Min. Design Temperature
  </td><td>
  -20° F
  </td></tr><tr><td>
  Max. Design Temperature
  </td><td>
  250° F
  </td></tr><tr><td>
  Nominal bore size
  </td><td>
  &nbsp;Ø6 3/8”
  </td></tr><tr><td>
  Drift Dia
  </td><td>
  Ø 6.34 +.027/-.000
  </td></tr><tr><td>
  Material Class
  </td><td>
  EE-NL
  </td></tr><tr><td>
  PSL Level
  </td><td>
  PSL-3G
  </td></tr><tr><td>
  PR Level
  </td><td>
  2
  </td></tr><tr><td>
  Well Barrier type
  </td><td>
  2 x 6 3/8” Hydraulic
  gate valve 2 x 4 1/16” Spring-assist fail-safe-closed gate valves
  </td></tr><tr><td>
  Proven Cut Capability:
  </td><td>
  None (Can be incorporated if required for Slickline / Braided line /
  Electric line in SWAB valve on new equipment)
  </td></tr><tr><td>
  <strong>Operating Criteria</strong>
  </td><td>
  <strong>Specification</strong>
  </td></tr><tr><td>
  Water depth
  </td><td>
  10,000 FT
  </td></tr><tr><td>
  Service Condition
  </td><td>
  H2S per NACE MR 01-75
  </td></tr><tr><td>
  API Monogram
  </td><td>
  No
  </td></tr><tr><td>
  Test cap (Top of FH)
  </td><td>
  10.750-2 ACME-2G Pin
  </td></tr><tr><td>
  Test cap (Bottom of FH)
  </td><td>
  10.750-2 ACME-2G RH Pin
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Valves and Actuators</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td><strong>S No.</strong></td><td><strong>Valves</strong></td><td><strong>Nominal Size</strong></td><td><strong>Qty</strong></td></tr><tr><td>1</td><td>Swab valve</td><td>6-3/8”</td><td>1</td></tr><tr><td>2</td><td>Lower Master Valve</td><td>6-3/8”</td><td>1</td></tr><tr><td>3</td><td>Fail Safe wing valve</td><td>4-1/8”</td><td>2</td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Swab Valve</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  Nominal Size
  </td><td>
  Ø 6 3/8”
  </td></tr><tr><td>
  Maximum working pressure
  </td><td>
  15,000 Psi
  </td></tr><tr><td>
  Maximum Test pressure
  </td><td>
  22,500
  Psi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
  </td></tr><tr><td>
  Control Pressure
  </td><td>
  3,000 psi
  </td></tr><tr><td>
  Max. Control Test
  Pressure
  </td><td>
  4,500 psi
  </td></tr><tr><td>
  Actuator Type
  </td><td>
  Double Acting Hydraulic
  (Fail As Is)
  </td></tr><tr><td>
  Position Indicator
  </td><td>
  Yes
  </td></tr><tr><td>
  Over-ride
  </td><td>
  Yes (Separate Assy
  supplied with FH assembly)
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Lower Master Valve</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  Nominal Size
  </td><td>
  Ø 6 3/8”
  </td></tr><tr><td>
  Maximum working pressure
  </td><td>
  15,000 Psi
  </td></tr><tr><td>
  Maximum Test pressure
  </td><td>
  22,500
  Psi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
  </td></tr><tr><td>
  Control Pressure
  </td><td>
  3,000 psi
  </td></tr><tr><td>
  Max. Control Test
  Pressure
  </td><td>
  4,500 psi
  </td></tr><tr><td>
  Actuator Type
  </td><td>
  Double Acting (Fail As
  Is)
  </td></tr><tr><td>
  Position Indicator
  </td><td>
  Yes
  </td></tr><tr><td>
  Over-ride
  </td><td>
  Yes (Separate Assy
  supplied with FH assembly)
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading"> Choke / Kill Valve </h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  Nominal Size
  </td><td>
  Ø 4 1/16
  </td></tr><tr><td>
  Maximum working pressure
  </td><td>
  15,000 Psi
  </td></tr><tr><td>
  Maximum Test pressure
  </td><td>
  22,500
  Psi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
  </td></tr><tr><td>
  Control Pressure
  </td><td>
  3,000 psi
  </td></tr><tr><td>
  Max. Control Test
  Pressure
  </td><td>
  4,500 psi
  </td></tr><tr><td>
  Actuator Type
  </td><td>
  Fail Safe Close
  </td></tr><tr><td>
  Position Indicator
  </td><td>
  Yes
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading"> Interfaces </h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  Flow Line
  </td><td>
  3-1/16”-10K Flange (No X-Overs included)
  </td></tr><tr><td>
  Kill Line
  </td><td>
  3-1/16”-10K Flange (No X-Overs included)
  </td></tr><tr><td>
  Top 
  </td><td>
  10-3/4’’ – 2 ACME-2G BOX (Handling Sub) supplied with 7-1/16-10K API
  Test flange
  </td></tr><tr><td>
  Bottom
  </td><td>
  10-3/4’’ – 2 ACME-2G BOX (Saver Sub)
  </td></tr><tr><td>
  Sensor Interface
  </td><td>
  No
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">  Cross-Overs </h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  <strong>Position</strong>
  </td><td>
  <strong>Top connection</strong>
  </td><td>
  <strong>Bottom Connection</strong>
  </td></tr><tr><td>
  Connection between Saver-sub and Riser
  </td><td>
  10-3/4”-2 ACME-2G-RH (PIN)
  </td><td>
  10-3/4”-2 ACME-2G-RH (PIN)
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">  Hydraulic Data </h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  Control Fluid Type
  </td><td>
  HW443 (or) Water based Glycol
  </td></tr><tr><td>
  Control Fluid Cleanliness
  </td><td>
  SAE AS4059 CLASS 6B-6F
  </td></tr></tbody></table></figure>
', '2019-10-01T22:06:15', NULL, 'USD', true, '[{"id":296,"name":"Products","slug":"products-si-systems"}]'::jsonb, '{"url":"/uploads/2019/10/FlowHead7Inch.jpg","width":700,"height":601,"alt":"6 3/8-15K Surface Tree (Flow head)"}'::jsonb, '{"title":"6 3/8-15K Surface Tree (Flow head) - Worldwide Oilfield Machine","description":"In the market for a 6 3/8-15K Surface Tree Flowhead? Visit our page to learn its specifications and features. Downloadable brochure available.","ogImage":"/uploads/2019/10/FlowHead7Inch.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (16382, '7 3/8 -10K Deepwater Riser System (DRS)', '7-3-8-10k-deepwater-riser-system-drs', '', '
<p class="wp-block-paragraph"><strong>Worldwide Oil Machine (WOM)</strong> developed a proprietary subsea Intervention Riser. The system comprises from the surface to the seabed:</p>



<ul class="wp-block-list" id="block-519b570f-139c-4652-85ad-2f519c01d5ec"><li>A topside package to be located on a rig, including flow head system, service manifold package and HPU.</li><li>Riser system connected to the flow head and top of the emergency disconnect package.</li><li>A subsea intervention package that will be connected to the Christmas tree, comprising an Emergency Disconnection Package (EDP), a Lower Riser Package (LRP).</li></ul>



<h2 class="womtitle wp-block-heading">Features</h2>



<ul class="wp-block-list" id="block-0f28f4f1-e527-44a2-879e-33d445a4d464"><li>Unique design, utilizing metal-to-metal sealing gate valves in the intervention system.</li><li>Two levels of redundancy for safety.</li><li>Fitted with an emergency shutdown (ESD) control system.</li><li>All production bore valves are capable of cutting coil tubing.</li><li>MUX Control system improving response time in emergency functions.</li><li>Ability to disconnect EDP at high angle without potential damage. &#8211; The DRS can disconnect at +/-10°due to an enhanced frame design and the inclusion of a 2” retractable Annulus line stab assembly</li><li>Removable EDP Re-entry Mandrel</li><li>Increased coil cutting capability</li></ul>



<h2 class="womtitle wp-block-heading">Industry Standards</h2>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td> <strong>NAME</strong>   </td><td><strong>DESCRIPTION</strong>   </td><td><strong>REV</strong>   </td></tr><tr><td>API 6A /ISO 10423   </td><td>Specification   for Wellhead and Christmas Tree Equipment (Latest Edition)   </td><td>20<sup>th</sup> Edition October 2010   </td></tr><tr><td>API 17D /&nbsp;ISO 13628-4   </td><td>Specification   for Subsea Wellhead &amp; Christmas Tree Equipment (Latest Edition)   </td><td>2<sup>nd   </sup>&nbsp;Edition May   2011   </td></tr><tr><td>API 17G / ISO 13628-7   </td><td>Petroleum   and natural gas industries- Design and operation of Subsea production   systems-part 7: Completion / work over riser system   </td><td>2<sup>nd   </sup>Edition   July   2006   </td></tr><tr><td>SAE  AS4059</td><td>Aerospace   Fluid Power – Cleanliness Classification for Hydraulic Fluid (Latest Edition)   </td><td>AS4059F September   2013   </td></tr><tr><td>NACE MR0175 /ISO 15156   </td><td>Petroleum   and natural gas industries- Materials for use in H<sub>2</sub>S-containing   environments in oil and gas production   </td><td>2<sup>nd  </sup>&nbsp;Edition July 2006   </td></tr><tr><td>DNVGL-OS-E101   </td><td>Offshore   standards, Drilling facilities   </td><td>January   2018   </td></tr></tbody></table></figure>



<h2 class="womtitle wp-block-heading">Operating Specification</h2>



<figure class="wp-block-table alignleft womblue is-style-stripes"><table class="has-fixed-layout"><tbody><tr><td>   <strong>PRESSURE   CRITERIA   </strong></td><td class="has-text-align-center" data-align="center"><strong>   SPECIFICATION </strong>  </td></tr><tr><td>
  Maximum working pressure
  </td><td class="has-text-align-center" data-align="center">
  15,000 Psi
  </td></tr><tr><td>
  Maximum Test pressure
  </td><td class="has-text-align-center" data-align="center">
  25,500
  Psi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
  </td></tr><tr><td>  <strong> TEMPERATURE   / DESIGN CRITERIA   </strong></td><td class="has-text-align-center" data-align="center"> <strong>  SPECIFICATION  </strong> </td></tr><tr><td>
  Temperature Rating
  </td><td class="has-text-align-center" data-align="center">
  P+U
  </td></tr><tr><td>
  Min. Design Temperature
  </td><td class="has-text-align-center" data-align="center">
  -20° F
  </td></tr><tr><td>
  Max. Design Temperature
  </td><td class="has-text-align-center" data-align="center">
  250° F
  </td></tr><tr><td>
  Nominal bore size
  </td><td class="has-text-align-center" data-align="center">
  6 3/8”
  </td></tr><tr><td>
  Drift Dia.
  </td><td class="has-text-align-center" data-align="center">
  6.34 +.027/-.000
  </td></tr><tr><td>
  Material Class
  </td><td class="has-text-align-center" data-align="center">
  EE-NL
  </td></tr><tr><td>
  PSL Level
  </td><td class="has-text-align-center" data-align="center">
  PSL-3G
  </td></tr><tr><td>
  PR Level
  </td><td class="has-text-align-center" data-align="center">
  2
  </td></tr><tr><td> <strong>  OPERATING   CRITERIA   </strong></td><td class="has-text-align-center" data-align="center"><strong>   SPECIFICATION   </strong></td></tr><tr><td>
  Water depth
  </td><td class="has-text-align-center" data-align="center">
  10,000 FT (Based upon
  loading)
  </td></tr><tr><td>
  Service Condition
  </td><td class="has-text-align-center" data-align="center">
  H2S per NACE MR 01-75
  </td></tr><tr><td>
  API Monogram
  </td><td class="has-text-align-center" data-align="center">
  No
  </td></tr></tbody></table></figure>



<h2 class="womtitle wp-block-heading">Emergency Disconnect Package(EDP)</h2>



<div class="wp-block-columns has-2-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<p class="wp-block-paragraph"><br>The Emergency Disconnect Package (EDP) forms part of the well intervention package, which will be, used during well intervention operations from a DP or anchored Rig. The EDP is designed to allow disconnection of the riser system from the LRP assembly in the event of weather dictated disconnect, routine operational requirements or vessel induced drive off/ drift off situations.</p>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<figure class="wp-block-image"><img fetchpriority="high" decoding="async" width="287" height="237" data-src="/uploads/2019/10/DRS-EDP.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-8957 lazyload"/><noscript><img decoding="async" width="287" height="237" src="/uploads/2019/10/DRS-EDP.jpg" alt="" class="wp-image-8957"></noscript></figure>
</div>
</div>



<h3 class="womtitle wp-block-heading">Lower Riser Package(LRP)</h3>



<div class="wp-block-columns has-2-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<p class="wp-block-paragraph"><br><br>The Lower Riser Package (LRP) forms part of an Intervention Package. This equipment is designed to land out and lock onto a Subsea Production Tree and has surface-controlled gate valves to close in the well during intervention operations. </p>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<figure class="wp-block-image"><img decoding="async" width="287" height="237" data-src="/uploads/2019/10/LowerRiserPackage.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-8959 lazyload"/><noscript><img loading="lazy" decoding="async" width="287" height="237" src="/uploads/2019/10/LowerRiserPackage.jpg" alt="" class="wp-image-8959"></noscript></figure>
</div>
</div>
', '2020-12-08T11:26:12', NULL, 'USD', true, '[{"id":294,"name":"Riser Systems-10K and 15K","slug":"riser-systems"},{"id":264,"name":"Subsea Intervention Systems","slug":"si-systems"}]'::jsonb, '{"url":"/uploads/2019/10/DRS-Main.jpg","width":432,"height":371,"alt":"7 3/8 -10K Deepwater Riser System (DRS)"}'::jsonb, '{"title":"7 3/8 -10K Deepwater Riser System (DRS) - Worldwide Oilfield Machine","description":"Worldwide Oil Machine (WOM) has a Unique design, utilizing metal-to-metal sealing gate valves in the intervention system.","ogImage":"/uploads/2019/10/DRS-Main.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8689, '7 3/8-10K Coil Cutting Valves', '7-3-8-10k-coil-cutting-valves', '', '
<p class="wp-block-paragraph">Based on gate valve technology to cut and seal coil tubing, this CCV is equipped with horizontal hydraulically actuated single gate made to shear and seal coiled tubing and wire line of a given specification in the wellbore. A seal is made after the shearing, isolating the pressure/fluids from both upstream and downstream. The coil cutting valve is powered by accumulators and can be overridden via ROV manual over-ride.</p>



<h3 class="womtitle wp-block-heading">Industry Standards</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td><strong>NAME</strong></td><td>
  <strong>DESCRIPTION</strong>
  </td><td>
  <strong>REV</strong>
  </td></tr><tr><td>   API 6A / <br>ISO 10423   </td><td>Specification for Wellhead and Christmas Tree   Equipment (Latest Edition)   </td><td>
  20<sup>th</sup> Edition
  October 2010
  </td></tr><tr><td>   API 17D / <br>ISO 13628-4   </td><td>Specification for Subsea Wellhead &amp; Christmas   Tree Equipment (Latest Edition)   </td><td>
  2<sup>nd </sup>&nbsp;Edition
  May 2011
  </td></tr><tr><td>API 17G /<br>ISO 13628-7   </td><td>Petroleum and natural gas industries- Design and   operation of Subsea production systems-part 7: Completion / work over riser   system   </td><td>
  2<sup>nd </sup>&nbsp;Edition
  July 2006
  </td></tr><tr><td>SAE AS4059   </td><td>Aerospace Fluid Power – Cleanliness Classification   for Hydraulic Fluid (Latest Edition)   </td><td>
  AS4059F
  September 2013
  </td></tr><tr><td>NACE <br>MR0175 /<br>ISO 15156   </td><td>Petroleum and natural gas industries- Materials for   use in H<sub>2</sub>S-containing environments in oil and gas production   </td><td>
  2<sup>nd </sup>&nbsp;Edition
  July 2006
  </td></tr><tr><td>DNVGL-OS-E101   </td><td>Offshore standards, Drilling facilities   </td><td>
  January 2018
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Operating Specification</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  <strong>Pressure
  / Loading Criteria</strong>
  </td><td>
  <strong>Specification</strong>
  </td></tr><tr><td>
  Maximum working pressure
  </td><td>
  10,000 Psi
  </td></tr><tr><td>
  Maximum Test pressure
  </td><td>
  15,000 Psi
  </td></tr><tr><td>
  <strong>Temperature
  / Design Criteria</strong>
  </td><td>
  <strong>Specification</strong>
  </td></tr><tr><td>
  Temperature Rating
  </td><td>
  P+U
  </td></tr><tr><td>
  Min. Design Temperature
  </td><td>
  -20° F
  </td></tr><tr><td>
  Max. Design Temperature
  </td><td>
  250° F
  </td></tr><tr><td>
  Nominal bore size
  </td><td>
  7 3/8”
  </td></tr><tr><td>
  Drift Dia
  </td><td>
  7.345 +.027/-.000
  </td></tr><tr><td>
  Shear Class
  </td><td>
  Coil Tubing and Wire line
  </td></tr><tr><td>
  Material Class
  </td><td>
  EE-NL (or) Customer Requirement
  </td></tr><tr><td>
  PSL Level
  </td><td>
  PSL-3G
  </td></tr><tr><td>
  PR Level
  </td><td>
  2
  </td></tr><tr><td>
  <strong>Operating
  Criteria</strong>
  </td><td>
  <strong>Specification</strong>
  </td></tr><tr><td>
  Water depth
  </td><td>
  10,000 FT
  </td></tr><tr><td>
  Service Condition
  </td><td>
  H2S per NACE MR 01-75
  </td></tr><tr><td>
  ROV override turns to Close
  </td><td>
  60-62 turns to Clock-wise
  </td></tr><tr><td>
  Torque to operate override
  </td><td>
  1900 ft-lbs
  </td></tr><tr><td>
  Torque Bucket
  </td><td>
  Class 5 (2.0” sq)
  </td></tr><tr><td>
  API Monogram
  </td><td>
  No
  </td></tr><tr><td>
  ROV Override
  </td><td>
  Open to Close only
  </td></tr><tr><td>
  Stroke
  </td><td>
  9.75”
  </td></tr></tbody></table></figure>



<p class="wp-block-paragraph">NOTE: ROV MOR is not capable of shearing tubular</p>



<h3 class="womtitle wp-block-heading">Hydraulic Data</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  Control Fluid Type
  </td><td>
  HW443 (or) Water based Glycol
  </td></tr><tr><td>
  Control Fluid Cleanliness
  </td><td>
  SAE AS4059 CLASS 6B-6F
  </td></tr><tr><td>
  Max. Hydraulic Working Pressure
  </td><td>
  3,000 psi
  </td></tr><tr><td>
  Max. Hydraulic Test Pressure
  </td><td>
  4,500 psi
  </td></tr><tr><td>
  Cylinder Volume
  </td><td>   Open: 4.04 US GAL per one Actuator&nbsp;&nbsp;<br>   Close: 4.22 US GAL per one Actuator   </td></tr><tr><td>
  Compensator Fluid Type
  </td><td>
  BIOHYDRAN(2.6 US GAL APPROX) per one
  MOR
  </td></tr><tr><td>
  Compensator Check valves (cracking
  pressure)
  </td><td>
  50 psi
  </td></tr></tbody></table></figure>
', '2019-10-07T18:04:53', NULL, 'USD', true, '[{"id":296,"name":"Products","slug":"products-si-systems"},{"id":264,"name":"Subsea Intervention Systems","slug":"si-systems"}]'::jsonb, '{"url":"/uploads/2019/10/CoilCuttingValves7inch.jpg","width":432,"height":371,"alt":"7 3/8-10K Coil Cutting Valves"}'::jsonb, '{"title":"7 3/8-10K Coil Cutting Valves - Worldwide Oilfield Machine","description":"Worldwide Oilfield Machine has developed a 7-3/8”–10K Coil Cutting Valve based on gate valve concept to cut and seal coil tubing. The Coil cutting valve is equipped with horizontal hydraulically actuated single gate made to shear and seal coiled tubing and wire line of a given specification in the wellbore.","ogImage":"/uploads/2019/10/CoilCuttingValves7inch.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8973, '7 3/8-10K High Angle Release (HAR) Connector', '13-5-8-10k-high-angle-release-connector-har', '', '
<p class="wp-block-paragraph">The connector connects EDP package to the LRP by latching on to the re-entry mandrel. </p>



<h3 class="womtitle wp-block-heading">Features</h3>



<ul class="wp-block-list"><li>8 off corrosion resistant hydraulic cylinder for preload locking force.</li><li>2 off banks for both locking and unlocking circuit</li><li>Tapered lock mechanism </li><li>Visual indicator rods.</li></ul>



<h3 class="womtitle wp-block-heading">Industry Standards</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td><strong>NAME</strong>   </td><td>
  <strong>DESCRIPTION</strong>
  </td><td>
  <strong>REV</strong>
  </td></tr><tr><td>   API 6A /ISO 10423   </td><td>Specification   for Wellhead and Christmas Tree Equipment (Latest Edition)   </td><td>
  20<sup>th</sup> Edition
  October 2010
  </td></tr><tr><td>   API 17D /ISO 13628-4   </td><td>Specification   for Subsea Wellhead &amp; Christmas Tree Equipment (Latest Edition)   </td><td>
  2<sup>nd
  </sup>&nbsp;Edition
  May
  2011
  </td></tr><tr><td>   API 17G / ISO 13628-7   </td><td>Petroleum   and natural gas industries- Design and operation of Subsea production   systems-part 7: Completion / work over riser system   </td><td>
  2<sup>nd
  </sup>&nbsp;Edition
  July
  2006
  </td></tr><tr><td>SAE AS4059   </td><td>Aerospace   Fluid Power – Cleanliness Classification for Hydraulic Fluid (Latest Edition)   </td><td>
  AS4059F
  September
  2013
  </td></tr><tr><td>NACE MR0175 /ISO 15156   </td><td>Petroleum   and natural gas industries- Materials for use in H<sub>2</sub>S-containing   environments in oil and gas production   </td><td>
  2<sup>nd
  </sup>&nbsp;Edition
  July
  2006
  </td></tr><tr><td>DNVGL-OS-E101   </td><td>Offshore   standards, Drilling facilities   </td><td>
  January
  2018
  </td></tr></tbody></table></figure>



<h2 class="womtitle wp-block-heading">Operating Specification</h2>



<p class="wp-block-paragraph"></p>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td><strong>   PRESSURE   CRITERIA   </strong></td><td><strong>   SPECIFICATION</strong>   </td></tr><tr><td>
  Maximum working pressure
  </td><td>
  10,000 Psi
  </td></tr><tr><td>
  Maximum Test pressure
  </td><td>
  15,000
  Psi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
  </td></tr><tr><td>
  TEMPERATURE
  / DESIGN CRITERIA
  </td><td>
  SPECIFICATION
  </td></tr><tr><td>
  Temperature Rating
  </td><td>
  P+U
  </td></tr><tr><td>
  Min. Design Temperature
  </td><td>
  -20° F
  </td></tr><tr><td>
  Max. Design Temperature
  </td><td>
  250° F
  </td></tr><tr><td>
  Nominal bore size
  </td><td>
  7 3/8”
  </td></tr><tr><td>
  Drift Dia.
  </td><td>
  7.345 +.027/-.000
  </td></tr><tr><td>
  PSL Level
  </td><td>
  PSL-3G
  </td></tr><tr><td>
  PR Level
  </td><td>
  2
  </td></tr><tr><td>
  Disconnect angle (Max)
  </td><td>
  15 ° from vertical
  </td></tr><tr><td>
  Swallow
  </td><td>
  10.44”
  </td></tr><tr><td>
  Hydraulic circuits
  </td><td>
  8, (2 banks of 4)
  </td></tr><tr><td><strong>    INTERFACE   DATA    </strong></td><td></td></tr><tr><td>
  Upper Connection
  </td><td>
  13-5/8-10K API Studded
  BX-159 Ring Gasket†
  9.5” Seal-sub pocket
  </td></tr><tr><td>
  Lower Connection
  </td><td>
  13-5/8-10K API 16A hub
  112 gasket profile
  </td></tr><tr><td>
  Lock port connection x 2
  </td><td>
  ½” Parker
  </td></tr><tr><td>
  Unlock port connection x
  2
  </td><td>
  ½” Parker
  </td></tr><tr><td>
  Monitor Port
  </td><td>
  ¼” N.PT.
  </td></tr><tr><td>   <strong>CYLINDER   DATA    </strong></td><td></td></tr><tr><td>
  Locking Pressure (Nom)
  ††
  </td><td>
  2250 psi
  </td></tr><tr><td>
  Locking Pressure (Max)
  </td><td>
  3000 psi
  </td></tr><tr><td>
  Unlock Pressure (Max)
  </td><td>
  5000 psi (3300 psi min.)
  </td></tr><tr><td>
  Locking Volume (Max)
  </td><td>
  4.44 U. S GAL
  </td></tr><tr><td>
  Unlock Volume (Max)
  </td><td>
  3.72 U. S GAL
  </td></tr><tr><td>
  Ratio unlock to lock force
  (with above pressures)
  </td><td>
  1:1.45 @ 3000 psi lock
  1:1.94 @ 2250 psi lock
  </td></tr><tr><td>
  Cleanliness
  </td><td>
  AS4059 Class 6B &#8211; 6F
  </td></tr><tr><td><strong>    SPECIFICATION    </strong></td><td></td></tr><tr><td>
  Water depth
  </td><td>
  10,000 FT (Based upon
  loading)
  </td></tr><tr><td>
  Service Condition
  </td><td>
  H2S per NACE MR 01-75
  </td></tr><tr><td>
  API Monogram
  </td><td>
  No
  </td></tr></tbody></table></figure>
', '2019-10-04T17:24:01', NULL, 'USD', true, '[{"id":296,"name":"Products","slug":"products-si-systems"}]'::jsonb, '{"url":"/uploads/2019/10/HAR1.jpg","width":432,"height":371,"alt":"7 3/8-10K High Angle Release (HAR) Connector"}'::jsonb, '{"title":"7 3/8-10K High Angle Release (HAR) Connector - WOM Group","description":"Worldwide Oilfield Machine (WOM) developed a High Angle release Connector (HAR). The connector connects EDP package to the LRP by latching on to the re-entry mandrel.","ogImage":"/uploads/2019/10/HAR1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8702, '7 3/8-10K Safety Head (Compact Cutting Device)', '7-3-8-10k-safety-head-ccd', '', '
<p class="wp-block-paragraph"><strong>Hydraulically operated, compact, shear and seal valve designed with high cutting performance and reliable post-cut sealing</strong></p>



<p class="wp-block-paragraph">This CCD is designed with opposing horizontal hydraulically actuated gate valves made to shear coiled tubing, drill pipe, and wire line of a given specification in the wellbore and seal from below.  A seal is made after the shearing, isolating the pressure/fluids beneath the CCD. It is used in offshore and/or high-pressure applications where cutting of the well string is required without leaving a snag. The device is powered by accumulators and can be overridden via ROV hot stab in either direction. </p>



<p class="wp-block-paragraph">With a reduced package size, our CCD can be easily transported and installed using economic methods, reducing overall time and costs for subsea projects. </p>



<p class="wp-block-paragraph">The gate valves are fail-as-is.
The external position indicator will show where the gate valve positions are at
all times. A locking mechanism prevents the gates from creeping back after they
have closed. In case of a failure, an override tool may be used to open or
close the CCD. This override tool is ROV actuated.</p>



<ul class="wp-block-list"><li>7-3/8” Bore, 10 KSI parallel cutting and sealing gate valve design.</li><li>Unidirectional coiled tubing cutting valve with recirculation capability.</li><li>Demountable actuators to facilitate in-situ maintenance. </li><li>Compact Design</li><li>Separate cutting and sealing components in a single device.</li><li>3 ½” S135 Drill Pipe – Clean Cut </li></ul>



<figure class="wp-block-table alignwide is-style-stripes"><table><tbody><tr><td><strong>Design Data</strong></td><td></td></tr><tr><td>
  Nominal Bore Diameter
  </td><td>
  Ø7 3/8” 
  </td></tr><tr><td>
  Design Wellbore Pressure
  </td><td>
  Working: 10,000 psi.<br>
  Test: 15,000 psi.
  </td></tr><tr><td>
  Design Standard
  </td><td>
  API 17G &amp; NORSOK D-002
  </td></tr><tr><td>
  Temperature Class (Design)
  </td><td>
  P+U (-20°F to 250°F)
  </td></tr><tr><td>
  Service
  </td><td>
  H<sub>2</sub>S -IN accordance with
  NACE MR0175
  </td></tr><tr><td>
  Drift Dia.
  </td><td>
  7.345 +.027/-.000
  </td></tr><tr><td>
  Design Life
  </td><td>
  Min. 20 years
  </td></tr><tr><td>
  Product Specification Level
  </td><td>
  PSL-3G
  </td></tr><tr><td>
  Shearing Class
  </td><td>
  Wireline/Coiled Tubing
  </td></tr></tbody></table></figure>



<figure class="wp-block-table is-style-stripes"><table class="has-background" style="background-color:#f3f4f5"><tbody><tr><td><strong>Performance Data</strong></td><td></td></tr><tr><td>Maximum Hydraulic Pressure   </td><td>5,000 psi   </td></tr><tr><td>Cylinder Volume (Total, Approx.)   </td><td>Open: 5.45 US gal (20.63 liters)   <br>Secondary Open: 5.45 US gal (20.63   liters)   <br>Close: 5.77 US gal (21.86 liters)   <br>Secondary Close: 5.77 US gal (21.86   liters)   </td></tr><tr><td>Locking Piston Volumes   </td><td>Lock: 0.091 US gal (0.348 liters)   Unlock: 0.019 US gal (0.072 liters)   </td></tr><tr><td>Control Fluid Type   </td><td>HW443 (or) Water based Glycol   </td></tr><tr><td>Cutting Capabilities   </td><td>Performed 116 ksi Yield, 2.50” Solid   bar   </td></tr></tbody></table></figure>



<figure class="wp-block-table"><table><tbody><tr><td><strong>Validation Level</strong></td><td></td></tr><tr><td>Design Validation Level   </td><td>API-17G (3<sup>rd </sup>Edition &#8211;   Ballot)   </td></tr><tr><td>Certification   </td><td>DNV-OS-E101 Cat. 1   </td></tr></tbody></table></figure>
', '2019-10-09T18:28:38', NULL, 'USD', true, '[{"id":296,"name":"Products","slug":"products-si-systems"}]'::jsonb, '{"url":"/uploads/2019/10/SafetyHead.jpg","width":432,"height":371,"alt":"7 3/8-10K Safety Head (Compact Cutting Device)"}'::jsonb, '{"title":"7 3/8-10K Safety Head (Compact Cutting Device) - WOM Group","description":"WOM''s 7-3/8 – 10K Compact Cutting Device (CCD) designed with opposing horizontal hydraulically actuated gate valves made to shear coiled tubing, drill pipe, and wire line of a given specification in the wellbore and seal from below.","ogImage":"/uploads/2019/10/SafetyHead.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8716, '7 3/8-10K Surface Tree (Flow head)', '7-3-8-10k-surface-tree-flow-head', '', '
<p class="wp-block-paragraph">The surface flowhead assembly is an integral part of the Intervention riser string assembly. This unit allows the access to the well bore thru the riser with a variety of wireline and coil tubing tools. It is designed to accommodate coil tubing lift frames and is suspended via 10-3/4” standard casing elevators. </p>



<h3 class="womtitle wp-block-heading">Features</h3>



<ul class="wp-block-list">
<li>Compact
valve block design for reduced weight and package height.</li>



<li>Includes
two 7-3/8-10K field proven valve.</li>



<li>Includes
two 5-1/8-10K field proven valves.</li>



<li>Includes
a 7-3/8” 10k dynamic swivel assembly per NACE MR-01-75.</li>



<li>Mechanical
Over-ride for valve actuators.</li>
</ul>



<h3 class="womtitle wp-block-heading">Industry Standards</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  <strong>NAME</strong>
  </td><td>
  <strong>DESCRIPTION</strong>
  </td><td>
  <strong>REV</strong>
  </td></tr><tr><td>   API   6A /ISO 10423   </td><td>Specification for Wellhead and Christmas Tree Equipment (Latest Edition) </td><td>20<sup>th</sup> Edition October 2010   </td></tr><tr><td>API   17D /ISO 13628-4   </td><td>Specification for Subsea Wellhead &amp; Christmas Tree Equipment (Latest Edition) </td><td>2<sup>nd </sup>Edition May 2011   </td></tr><tr><td>API   17G /ISO 13628-7   </td><td>Petroleum and natural gas industries- Design and operation of Subsea production   systems-part 7: Completion / work over riser system   </td><td>2<sup>nd </sup>Edition July   2006   </td></tr><tr><td>SAE   AS4059   </td><td>Aerospace Fluid Power – Cleanliness Classification for Hydraulic Fluid (Latest Edition)</td><td>AS4059F September   2013   </td></tr><tr><td>NACE MR0175 /<br>ISO 15156   </td><td>Petroleum  and natural gas industries- Materials for use in H<sub>2</sub>S-containing   environments in oil and gas production </td><td>2<sup>nd </sup>Edition July 2006   </td></tr><tr><td>DNVGL-OS-E101   </td><td>Offshore standards, Drilling facilities   </td><td>January 2018   </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Operating Specification</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  <strong>Pressure / Loading Criteria</strong>
  </td><td>
  <strong>Specification</strong>
  </td></tr><tr><td>
  Maximum working pressure
  </td><td>
  10,000 Psi
  </td></tr><tr><td>
  Maximum Test pressure
  </td><td>
  15,000
  Psi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
  </td></tr><tr><td>
  Load Rating @250°F
  </td><td>
  1,500,000
  lbs @0 psi
  </td></tr><tr><td>
  Load Rating @250°F
  </td><td>
  750,
  000 lbs @10,000 psi
  </td></tr><tr><td>
  <strong>Temperature / Design Criteria</strong>
  </td><td>
  <strong>Specification</strong>
  </td></tr><tr><td>
  Temperature Rating
  </td><td>
  P+U
  </td></tr><tr><td>
  Min. Design Temperature
  </td><td>
  -20° F
  </td></tr><tr><td>
  Max. Design Temperature
  </td><td>
  250° F
  </td></tr><tr><td>
  Nominal bore size
  </td><td>
  &nbsp;Ø7 3/8”
  </td></tr><tr><td>
  Drift Dia
  </td><td>
  Ø 7.345 +.027/-.000
  </td></tr><tr><td>
  Material Class
  </td><td>EE-NL   </td></tr><tr><td>
  PSL Level
  </td><td>PSL-3G   </td></tr><tr><td>
  PR Level
  </td><td>2   </td></tr><tr><td>
  Well Barrier type
  </td><td>2 x 7 3/8” Hydraulic   gate valve 2 x 5 1/8” Spring-assist fail-safe-closed gate valves   </td></tr><tr><td>
  Proven Cut Capability:
  </td><td> None (Can be incorporated if required for Slickline / Braided line /   Electric line in SWAB valve on new equipment)   </td></tr><tr><td>
  <strong>Operating Criteria</strong>
  </td><td>
  <strong>Specification</strong>
  </td></tr><tr><td>
  Water depth
  </td><td>
  10,000 FT
  </td></tr><tr><td>
  Service Condition
  </td><td>
  H2S per NACE MR 01-75
  </td></tr><tr><td>
  API Monogram
  </td><td>
  No
  </td></tr><tr><td>
  Test cap (Top of FH)
  </td><td> 7 1/16”-10K API Flange   </td></tr><tr><td>
  Test cap (Bottom of FH)
  </td><td>10-1/8-4 ACME Pin   </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Valves and Actuators</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td><strong>S No.</strong></td><td><strong>Valves</strong></td><td><strong>Nominal Size</strong></td><td><strong>Qty</strong></td></tr><tr><td>
  1
  </td><td>
  Swab valve
  </td><td>
  7-3/8”
  </td><td>
  1
  </td></tr><tr><td>
  2
  </td><td>
  Lower Master Valve
  </td><td>
  7-3/8”
  </td><td>
  1
  </td></tr><tr><td>
  3
  </td><td>
  Fail Safe wing valve
  </td><td>
  5-1/8”
  </td><td>
  2
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Swab Valve</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  Size
  </td><td>
  7-3/8”
  </td></tr><tr><td>
  Maximum working pressure
  </td><td>
  10,000 Psi
  </td></tr><tr><td>
  Maximum Test pressure
  </td><td>
  15,000
  Psi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
  </td></tr><tr><td>
  Control Pressure
  </td><td>
  3,000 psi
  </td></tr><tr><td>
  Max. Control Test
  Pressure
  </td><td>
  4,500 psi
  </td></tr><tr><td>
  Actuator Type
  </td><td>
  Double Acting Hydraulic
  (Fail As Is)
  </td></tr><tr><td>
  Fluid Volume
  </td><td>
  Open: 1.25 US gal&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  Close: 1.29 US gal
  </td></tr><tr><td>
  Position Indicator
  </td><td>
  Yes
  </td></tr><tr><td>
  Over-ride
  </td><td>
  Yes (Separate Assy
  supplied with FH assembly)
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Lower Master Valve</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  Size
  </td><td>
  7-3/8”
  </td></tr><tr><td>
  Maximum working pressure
  </td><td>
  10,000 Psi
  </td></tr><tr><td>
  Maximum Test pressure
  </td><td>
  15,000
  Psi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
  </td></tr><tr><td>
  Control Pressure
  </td><td>
  3,000 psi
  </td></tr><tr><td>
  Max. Control Test
  Pressure
  </td><td>
  4,500 psi
  </td></tr><tr><td>
  Actuator Type
  </td><td>
  Double Acting (Fail As
  Is)
  </td></tr><tr><td>
  Fluid Volume
  </td><td>
  Open: 1.25 US gal&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  Close: 1.34 US gal
  </td></tr><tr><td>
  Position Indicator
  </td><td>
  Yes
  </td></tr><tr><td>
  Over-ride
  </td><td>
  Yes (Separate Assy
  supplied with FH assembly)
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Choke / Kill Valve</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  Size
  </td><td>
  5-1/8”
  </td></tr><tr><td>
  Maximum working pressure
  </td><td>
  10,000 Psi
  </td></tr><tr><td>
  Maximum Test pressure
  </td><td>
  15,000
  Psi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
  </td></tr><tr><td>
  Control Pressure
  </td><td>
  3,000 psi
  </td></tr><tr><td>
  Max. Control Test
  Pressure
  </td><td>
  4,500 psi
  </td></tr><tr><td>
  Actuator Type
  </td><td>
  Fail Safe Close
  </td></tr><tr><td>
  Fluid Volume
  </td><td>
  Open: 0.63 US gal&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  
  </td></tr><tr><td>
  Position Indicator
  </td><td>
  Yes
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Interfaces</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  Flow Line
  </td><td>
  4-1/16”-10K Flange (Customer Specific)
  </td></tr><tr><td>
  Kill Line
  </td><td>
  4-1/16”-10K Flange (Customer Specific)
  </td></tr><tr><td>
  Top 
  </td><td>
  10-1/8’’ – 4 ACME-2G BOX (Handling Sub) supplied with 7-1/16-10K API
  Test flange
  </td></tr><tr><td>
  Bottom
  </td><td>
  10-1/8’’ – 4 ACME-2G BOX (Saver Sub)
  </td></tr><tr><td>
  Chemical Injection
  </td><td>
  3/8” Autoclave HP port (QTY:2) at below SWAB valve
  </td></tr><tr><td>
  Sensor Interface
  </td><td>
  No
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Cross-Overs</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  <strong>Position</strong>
  </td><td>
  <strong>Top connection</strong>
  </td><td>
  <strong>Bottom Connection</strong>
  </td></tr><tr><td>
  Connection between Saver-sub and Riser
  </td><td>
  10-1/8”-4&nbsp; ACME-2G-RH (PIN)
  </td><td>
  Customer Specific Riser thread connection
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Hydraulic Data</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  Control Fluid Type
  </td><td>
  HW443 (or) Water based Glycol
  </td></tr><tr><td>
  Control Fluid Cleanliness
  </td><td>
  SAE AS4059 CLASS 6B-6F
  </td></tr></tbody></table></figure>
', '2019-10-02T21:43:00', NULL, 'USD', true, '[{"id":296,"name":"Products","slug":"products-si-systems"}]'::jsonb, '{"url":"/uploads/2019/10/FlowHead7Inch.jpg","width":700,"height":601,"alt":"7 3/8-10K Surface Tree (Flow head)"}'::jsonb, '{"title":"7 3/8-10K Surface Tree (Flow head) - Worldwide Oilfield Machine","description":"In the market for a 7 3/8-10K Surface Tree Flowhead? Visit our page to learn its specifications and features. Downloadable brochure available.","ogImage":"/uploads/2019/10/FlowHead7Inch.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8665, '7 3/8-10K Wireline Cutting Valves / Fail Closed(FSC)', '7-3-8-10k-wireline-cutting-valves', '', '
<p class="wp-block-paragraph">Based on gate valve technology to cut and seal wireline / slickline, this product is equipment with a hydraulically-actuated gate made to shear and seal wireline / slickline of a given specification in the wellbore. A seal is made after the shearing, isolating the pressure/fluids from both upstream and downstream.  The wireline / slickline cutting valve is powered by accumulators and can be overridden via ROV manual over-ride.</p>



<p class="wp-block-paragraph">The WOM wireline cutting valve is actuated by fail-safe close actuator and spring force is used in cutting of wireline. In addition to spring force, hydraulic pressure can be used for assisting while closing of valve.</p>



<h3 class="womtitle wp-block-heading">Industry Standards</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  <strong>NAME</strong>
  </td><td>
  <strong>DESCRIPTION</strong>
  </td><td>
  <strong>REV</strong>
  </td></tr><tr><td>API 6A /<br>   ISO 10423   </td><td>
  Specification for Wellhead and Christmas Tree
  Equipment (Latest Edition)
  </td><td>
  20<sup>th</sup> Edition
  October 2010
  </td></tr><tr><td>API 17D /<br>   ISO 13628-4   </td><td>
  Specification for Subsea Wellhead &amp; Christmas
  Tree Equipment (Latest Edition)
  </td><td>
  2<sup>nd </sup>&nbsp;Edition
  May 2011
  </td></tr><tr><td>API 17G /<br>   ISO 13628-7   </td><td>   Petroleum and natural gas industries- Design and   operation of Subsea production systems-part 7: Completion / work over riser   system   </td><td>
  2<sup>nd </sup>&nbsp;Edition
  July 2006
  </td></tr><tr><td>SAE AS4059   </td><td>
  Aerospace Fluid Power – Cleanliness Classification
  for Hydraulic Fluid (Latest Edition)
  </td><td>
  AS4059F
  September 2013
  </td></tr><tr><td>NACE MR0175 / <br>   ISO 15156   </td><td>
  Petroleum and natural gas industries- Materials for
  use in H<sub>2</sub>S-containing environments in oil and gas production
  </td><td>
  2<sup>nd </sup>&nbsp;Edition
  July 2006
  </td></tr><tr><td>DNVGL-OS-E101   </td><td>
  Offshore standards, Drilling facilities
  </td><td>
  January 2018
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Operating Specification</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  <strong>Pressure
  / Loading Criteria</strong>
  </td><td>
  <strong>Specification</strong>
  </td></tr><tr><td>
  Maximum working pressure
  </td><td>
  10,000 Psi
  </td></tr><tr><td>
  Maximum Test pressure
  </td><td>
  15,000 Psi
  </td></tr><tr><td>
  <strong>Temperature
  / Design Criteria</strong>
  </td><td>
  <strong>Specification</strong>
  </td></tr><tr><td>
  Temperature Rating
  </td><td>
  P+U
  </td></tr><tr><td>
  Min. Design Temperature
  </td><td>
  -20° F
  </td></tr><tr><td>
  Max. Design Temperature
  </td><td>
  250° F
  </td></tr><tr><td>
  Nominal bore size
  </td><td>
  7 3/8”
  </td></tr><tr><td>
  Drift Dia
  </td><td>
  7.345 +.027/-.000
  </td></tr><tr><td>
  Shear Class
  </td><td>
  Wireline and Slickline
  </td></tr><tr><td>
  Material Class
  </td><td>
  EE-NL (or) Customer Requirement
  </td></tr><tr><td>
  PSL Level
  </td><td>
  PSL-3G
  </td></tr><tr><td>
  PR Level
  </td><td>
  2
  </td></tr><tr><td>
  <strong>Operating
  Criteria</strong>
  </td><td>
  <strong>Specification</strong>
  </td></tr><tr><td>
  Water depth
  </td><td>
  10,000 FT
  </td></tr><tr><td>
  Service Condition
  </td><td>
  H2S per NACE MR 01-75
  </td></tr><tr><td>
  ROV override turns to Close
  </td><td>
  60-62 turns to Clock-wise
  </td></tr><tr><td>
  Torque to operate override
  </td><td>
  1900 ft-lbs
  </td></tr><tr><td>
  Torque Bucket
  </td><td>
  Class 5 (2.0” sq)
  </td></tr><tr><td>
  API Monogram
  </td><td>
  No
  </td></tr><tr><td>
  ROV Override
  </td><td>
  Open to Close only
  </td></tr><tr><td>
  Stroke
  </td><td>
  9.75”
  </td></tr></tbody></table></figure>



<p class="wp-block-paragraph">

 NOTE: ROV   MOR is not capable of shearing   

</p>



<h3 class="womtitle wp-block-heading">Hydraulic Data</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  Control Fluid Type
  </td><td>
  HW443 (or) Water based Glycol
  </td></tr><tr><td>
  Control Fluid Cleanliness
  </td><td>
  SAE AS4059 CLASS 6B-6F
  </td></tr><tr><td>
  Max. Hydraulic Working Pressure
  </td><td>
  3,000 psi
  </td></tr><tr><td>
  Max. Hydraulic Test Pressure
  </td><td>
  4,500 psi
  </td></tr><tr><td>
  Cylinder Volume
  </td><td>
  Open: 3.14 US GAL&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Close
  Assist: 2.74 US GAL
  </td></tr><tr><td>
  Compensator Fluid Type
  </td><td>
  BIOHYDRAN(2.6 US GAL APPROX) per one MOR
  </td></tr><tr><td>
  Compensator Check valves (cracking
  pressure)
  </td><td>
  50 psi
  </td></tr></tbody></table></figure>



<h3 class="womtitle wp-block-heading">Shear Test Performed</h3>



<p class="wp-block-paragraph">Items listed in the below table are the dimensions of
samples that were sheared by Wireline Cutting valves</p>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>
  <strong>CUTTING
  SAMPLE</strong>
  </td></tr><tr><td>
  0.464 Wireline (21K breaking strength)
  </td></tr><tr><td>
  0.372 E-line (2-37AZ17 MP35N) 1 strand
  </td></tr><tr><td>
  0.372 E-line (2-37AZ17 MP35N) 3
  strand
  </td></tr></tbody></table></figure>
', '2019-10-05T17:01:38', NULL, 'USD', true, '[{"id":296,"name":"Products","slug":"products-si-systems"},{"id":264,"name":"Subsea Intervention Systems","slug":"si-systems"}]'::jsonb, '{"url":"/uploads/2019/10/WirelineCuttingValves.jpg","width":432,"height":371,"alt":"7 3/8-10K Wireline Cutting Valves / Fail Closed(FSC)"}'::jsonb, '{"title":"7 3/8-10K Wireline Cutting Valves / Fail Closed(FSC) - WOM Group","description":"WOM has developed 7-3/8”–10K Wireline Cutting Valve based on gate valve concept to cut and seal wireline/Slickline. The wireline cutting valve is equipment with hydraulically actuated gate made to shear and seal wireline/slickline of a given specification in the wellbore.","ogImage":"/uploads/2019/10/WirelineCuttingValves.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8165, 'Adjustable Chokes', 'adjustable-chokes', '', '
<p class="wp-block-paragraph">Needle and Seat is one of the simplest design of adjustable chokes available. It has a standard choke body with an adjustable choke bonnet assembly and Seat. The major parts of the assembly are conical tip rising needle, stainless steel seat and an indicator calibrated in 1/64” increments to enable effective orifice diameters. In highly erosive service a tungsten carbide tipped needle and tungsten carbide lined seat can be supplied.</p>



<p class="wp-block-paragraph">Needle and seat design is suitable for standard erosive and corrosive services, and less severe service (non-high vibration applications i.e. high gas rates, high solids, etc.) that do not require tight shutoff.</p>



<h3 class="wp-block-heading">Product Specification &amp; Features:</h3>



<ul class="wp-block-list"><li>Wing nut style bonnet enables quick tear down of bonnet assembly.</li><li>Interchangeable components provides a maximum flexibility of choice.</li><li>Meet or exceed the minimum requirement specified by API 6A latest Edition</li></ul>



<h3 class="wp-block-heading">Applications:</h3>



<p class="wp-block-paragraph">Used in X-mas trees, production applications, choke and kill manifold, well testing and clean-up operations.</p>



<h3 class="wp-block-heading">Features and Benefits:</h3>



<ul class="wp-block-list"><li>Interchangeable components provide a maximum flexibility of choice.</li><li>Available in both manual and automated operation.</li><li>Meet or exceed API 6A requirements.</li></ul>
', '2020-06-14T02:20:08', NULL, 'USD', true, '[{"id":258,"name":"Chokes","slug":"chokes"}]'::jsonb, '{"url":"/uploads/2019/09/Adjustable-ChokesR1.jpg","width":432,"height":371,"alt":"Adjustable Chokes"}'::jsonb, '{"title":"Adjustable Chokes, Adjustable Chokes Oilfield Equipment - WOM Group","description":"WOM Group, one of the leading Adjustable Chokes Manufacturers. Adjustable Chokes comes up with a standard choke body with an adjustable choke bonnet assembly and Seat. Read more about Adjustable Chokes.","ogImage":"/uploads/2019/09/Adjustable-ChokesR1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (940, 'Advanced Control Systems', 'advanced-control-systems', '', '
<p class="wp-block-paragraph">The WOM Control System software is equipped with intelligence that allows mechanization of the well control manifolds. The software’s diagnostic configuration resides inside the WOM PLC/HMI. The software (PLC/HMI) is written using Siemens TIA portal.</p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<p class="wp-block-paragraph">WOM’s Advanced Control System is Copyright protected and patent pending.</p>



<p class="wp-block-paragraph"><strong>PLC/HMI Features</strong></p>



<ul class="wp-block-list"><li>15”/19” HMI</li><li>Widescreen-TFT-Display</li><li>16 Million Colors</li><li>Proficient Interface, MPI/profibus DP Interface</li><li>Panel Mount Design</li><li>Dual Power Supplies with Redundancy Module</li><li>DP/DP Coupler</li><li>Integrated Display on PLC Faceplate for Controller Status</li><li>Driller Interface</li><li>Data Logging and transfer</li></ul>



<p class="wp-block-paragraph">The WOM Control System software is equipped with intelligence that allows mechanization of the well control manifolds. The software’s diagnostic configuration resides inside the WOM PLC/HMI. The software (PLC/HMI) is written using Siemens TIA portal and includes the following features:</p>



<ul class="wp-block-list"><li>Integrated System Diagnostics</li><li>Fast error localization and error analysis</li><li>Identical visualization of error messages in the TIA Portal, on HMI, on the Web server and on the PLC CPU in plain text format</li></ul>



<h3 class="womtitle wp-block-heading"> Applications </h3>



<ul class="wp-block-list"><li>Choke and Kill System</li><li>Buffer Manifold Control</li><li>Managed Pressure Drilling (MPD)</li><li>MPD Interlocking System</li><li>PRV Control System</li><li>Single Set Point Choke Control System</li><li>ESD Systems</li><li>Wellhead Control System</li><li>Flowhead Control System</li><li>Liquid Seal Monitoring System</li></ul>



<p class="womtitle wp-block-paragraph"><strong>Industry Standards</strong></p>



<ul class="wp-block-list"><li>API 16C Monogram License</li><li>DNV-OS-E101</li><li>ABS CDS</li><li>ATEX</li><li>IECEx</li><li>CSA</li><li>Norsok</li></ul>
', '2019-07-17T09:51:02', NULL, 'USD', true, '[{"id":129,"name":"Controls and Instrumentation","slug":"controls-and-instrumentation"}]'::jsonb, '{"url":"/uploads/2019/07/Advanced-Control-Systems1.jpg","width":600,"height":515,"alt":"Advanced Control Systems"}'::jsonb, '{"title":"Advanced Control Systems - Worldwide Oilfield Machine","description":"WOM''s Advanced Control System software is equipped with intelligence that allows mechanization of the well control manifolds.","ogImage":"/uploads/2019/07/Advanced-Control-Systems1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (14993, 'Aftermarket Services', 'aftermarket-services', '', '		<div data-elementor-type="wp-post" data-elementor-id="14993" class="elementor elementor-14993" data-elementor-post-type="product">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-8b0968d elementor-section-height-min-height elementor-section-content-middle elementor-reverse-mobile elementor-section-boxed elementor-section-height-default elementor-section-items-middle" data-id="8b0968d" data-element_type="section" data-e-type="section" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
							<div class="elementor-background-overlay"></div>
							<div class="elementor-container elementor-column-gap-no">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-0afac4f" data-id="0afac4f" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-1001572 elementor-widget elementor-widget-heading" data-id="1001572" data-element_type="widget" data-e-type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
					<h1 class="elementor-heading-title elementor-size-default">Aftermarket Services</h1>				</div>
				</div>
				<div class="elementor-element elementor-element-d2f0959 elementor-widget elementor-widget-breadcrumbs" data-id="d2f0959" data-element_type="widget" data-e-type="widget" data-widget_type="breadcrumbs.default">
				<div class="elementor-widget-container">
					<p id="breadcrumbs"><span><span><a href="https://worldwideoilfieldmachinery.com/">Home</a></span></span></p>				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-e698e91 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="e698e91" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-d95f4de" data-id="d95f4de" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-d9a35fc elementor-widget elementor-widget-text-editor" data-id="d9a35fc" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									<p>We understand that our commitment to you continues well after you have purchased our products. WOM has multiple locations for Aftermarket Services around the world, in the USA, Dubai, Singapore, Brazil, Scotland, and India. Our newest aftermarket location is in Midland, Texas, serving the Permian Basin area with service and repair to support your operations and reduce downtime. We offer repair, recertification, and rebranding for your equipment, as well as a vast amount of aftermarket parts in stock for your immediate aftermarket needs. </p>								</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-ac2d1b5" data-id="ac2d1b5" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-387e2e9 elementor-arrows-position-inside elementor-widget elementor-widget-image-carousel" data-id="387e2e9" data-element_type="widget" data-e-type="widget" data-settings="{&quot;slides_to_show&quot;:&quot;1&quot;,&quot;navigation&quot;:&quot;arrows&quot;,&quot;autoplay&quot;:&quot;yes&quot;,&quot;pause_on_hover&quot;:&quot;yes&quot;,&quot;pause_on_interaction&quot;:&quot;yes&quot;,&quot;autoplay_speed&quot;:5000,&quot;infinite&quot;:&quot;yes&quot;,&quot;effect&quot;:&quot;slide&quot;,&quot;speed&quot;:500}" data-widget_type="image-carousel.default">
				<div class="elementor-widget-container">
							<div class="elementor-image-carousel-wrapper swiper" role="region" aria-roledescription="carousel" aria-label="Image Carousel" dir="ltr">
			<div class="elementor-image-carousel swiper-wrapper swiper-image-stretch" aria-live="off">
								<div class="swiper-slide" role="group" aria-roledescription="slide" aria-label="1 of 2"><figure class="swiper-slide-inner"><img decoding="async" data-src="/uploads/2020/08/AnyBrandRepair2.jpg" class="swiper-slide-image lazyload" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="Any Brand Repair" /><noscript><img decoding="async" class="swiper-slide-image" src="/uploads/2020/08/AnyBrandRepair2.jpg" alt="Any Brand Repair"></noscript></figure></div><div class="swiper-slide" role="group" aria-roledescription="slide" aria-label="2 of 2"><figure class="swiper-slide-inner"><img decoding="async" data-src="/uploads/2020/08/AnyBrandRepair.jpg" class="swiper-slide-image lazyload" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="Any Brand Repair" /><noscript><img decoding="async" class="swiper-slide-image" src="/uploads/2020/08/AnyBrandRepair.jpg" alt="Any Brand Repair"></noscript></figure></div>			</div>
												<div class="elementor-swiper-button elementor-swiper-button-prev" role="button" tabindex="0">
						<i aria-hidden="true" class="eicon-chevron-left"></i>					</div>
					<div class="elementor-swiper-button elementor-swiper-button-next" role="button" tabindex="0">
						<i aria-hidden="true" class="eicon-chevron-right"></i>					</div>
				
									</div>
						</div>
				</div>
				<div class="elementor-element elementor-element-d9979a9 elementor-widget elementor-widget-heading" data-id="d9979a9" data-element_type="widget" data-e-type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
					<div class="elementor-heading-title elementor-size-default">Repair of Most Major Brands</div>				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-170a1ce elementor-section-height-min-height elementor-section-boxed elementor-section-height-default elementor-section-items-middle" data-id="170a1ce" data-element_type="section" data-e-type="section" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
							<div class="elementor-background-overlay"></div>
							<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-7cdfeda" data-id="7cdfeda" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-28a4c68 elementor-invisible elementor-widget elementor-widget-heading" data-id="28a4c68" data-element_type="widget" data-e-type="widget" data-settings="{&quot;_animation&quot;:&quot;fadeInDown&quot;}" data-widget_type="heading.default">
				<div class="elementor-widget-container">
					<h2 class="elementor-heading-title elementor-size-default">Field Services, On-site Repairs, 
Recertification &amp; Inspections</h2>				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-4cad7c5 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="4cad7c5" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-17a0f62" data-id="17a0f62" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-307cc4d elementor-widget elementor-widget-text-editor" data-id="307cc4d" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									<ul><li>BOP hydraulic tests </li><li>Element changes </li><li>Choke manifold inspections and greasing </li><li>Accumulator inspections per API 16D S53 (6-month, yearly, 3-year, 5-year) </li><li>All major repairs on every make and model of accumulators </li><li>Gauge calibration </li><li>In-field valve repairs </li><li>Pulsation dampener repairs </li><li>BOP repairs to API 16AR standards available </li><li>Repair of all brands of gate valves and plug valves </li><li>Gate resurfacing / lapping</li></ul>								</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-29591c1" data-id="29591c1" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-8aa93d2 elementor-arrows-position-inside elementor-widget elementor-widget-image-carousel" data-id="8aa93d2" data-element_type="widget" data-e-type="widget" data-settings="{&quot;slides_to_show&quot;:&quot;1&quot;,&quot;navigation&quot;:&quot;arrows&quot;,&quot;autoplay&quot;:&quot;yes&quot;,&quot;pause_on_hover&quot;:&quot;yes&quot;,&quot;pause_on_interaction&quot;:&quot;yes&quot;,&quot;autoplay_speed&quot;:5000,&quot;infinite&quot;:&quot;yes&quot;,&quot;effect&quot;:&quot;slide&quot;,&quot;speed&quot;:500}" data-widget_type="image-carousel.default">
				<div class="elementor-widget-container">
							<div class="elementor-image-carousel-wrapper swiper" role="region" aria-roledescription="carousel" aria-label="Image Carousel" dir="ltr">
			<div class="elementor-image-carousel swiper-wrapper swiper-image-stretch" aria-live="off">
								<div class="swiper-slide" role="group" aria-roledescription="slide" aria-label="1 of 2"><figure class="swiper-slide-inner"><img decoding="async" data-src="/uploads/2020/08/Dimentional-Inspection2.jpg" class="swiper-slide-image lazyload" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="Dimentional-Inspection2" /><noscript><img decoding="async" class="swiper-slide-image" src="/uploads/2020/08/Dimentional-Inspection2.jpg" alt="Dimentional-Inspection2"></noscript></figure></div><div class="swiper-slide" role="group" aria-roledescription="slide" aria-label="2 of 2"><figure class="swiper-slide-inner"><img decoding="async" data-src="/uploads/2020/08/Dimentional-Inspection.jpg" class="swiper-slide-image lazyload" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="Dimentional-Inspection" /><noscript><img decoding="async" class="swiper-slide-image" src="/uploads/2020/08/Dimentional-Inspection.jpg" alt="Dimentional-Inspection"></noscript></figure></div>			</div>
												<div class="elementor-swiper-button elementor-swiper-button-prev" role="button" tabindex="0">
						<i aria-hidden="true" class="eicon-chevron-left"></i>					</div>
					<div class="elementor-swiper-button elementor-swiper-button-next" role="button" tabindex="0">
						<i aria-hidden="true" class="eicon-chevron-right"></i>					</div>
				
									</div>
						</div>
				</div>
				<div class="elementor-element elementor-element-2f51bb1 elementor-widget elementor-widget-heading" data-id="2f51bb1" data-element_type="widget" data-e-type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
					<div class="elementor-heading-title elementor-size-default">Dimensional Inspection</div>				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-c08c81c elementor-section-height-min-height elementor-section-boxed elementor-section-height-default elementor-section-items-middle" data-id="c08c81c" data-element_type="section" data-e-type="section" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
							<div class="elementor-background-overlay"></div>
							<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-94de806" data-id="94de806" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-b14c685 elementor-invisible elementor-widget elementor-widget-heading" data-id="b14c685" data-element_type="widget" data-e-type="widget" data-settings="{&quot;_animation&quot;:&quot;fadeInDown&quot;}" data-widget_type="heading.default">
				<div class="elementor-widget-container">
					<h2 class="elementor-heading-title elementor-size-default">Dimensional Inspection</h2>				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-0e479de elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="0e479de" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-a7808bc" data-id="a7808bc" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-9cf6566 elementor-widget elementor-widget-heading" data-id="9cf6566" data-element_type="widget" data-e-type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
					<h3 class="elementor-heading-title elementor-size-default">New Equipment &amp; Loose
Parts Sales</h3>				</div>
				</div>
				<div class="elementor-element elementor-element-5c9502c elementor-widget elementor-widget-text-editor" data-id="5c9502c" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									<p>• Flow Iron<br />• Blowout Preventers<br />• Gate Valves<br />• Ball Valves<br />• Chokes<br />• Well Test<br />• Flowback<br />• Choke and Kill Manifolds</p>								</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-f106e26" data-id="f106e26" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-bc57282 elementor-widget elementor-widget-heading" data-id="bc57282" data-element_type="widget" data-e-type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
					<h3 class="elementor-heading-title elementor-size-default">Repair, Recertification &amp;
Rebranding</h3>				</div>
				</div>
				<div class="elementor-element elementor-element-3579b0f elementor-widget elementor-widget-text-editor" data-id="3579b0f" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									<p>• Wellheads<br /><span style="font-size: 16px;">• Gate and Ball Valves <br />• Frac Valves and Frac Stack Accessories <br />• Blowout Preventers and Ram Blocks<br />• Chokes and Choke Panels <br />• Choke &amp; Kill Manifolds <br />• Well Test <br />• Flowback <br />• Accumulators <br />• Flow Iron</span></p>								</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-b911ba6" data-id="b911ba6" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap">
							</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-b3167ef elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="b3167ef" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-450c41d" data-id="450c41d" data-element_type="column" data-e-type="column" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-44d8896 elementor-widget elementor-widget-image" data-id="44d8896" data-element_type="widget" data-e-type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
												<figure class="wp-caption">
										<img fetchpriority="high" decoding="async" data-src="/uploads/2020/08/MPI.jpg" data-srcset="/uploads/2020/08/MPI.jpg 481w, /uploads/2020/08/MPI-300x225.jpg 300w" width="481" height="360" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" class="attachment-large size-large wp-image-14873 lazyload" alt="Magnetic Particle Testing"  sizes="(max-width: 481px) 100vw, 481px" /><noscript><img decoding="async" width="481" height="360" src="/uploads/2020/08/MPI.jpg" class="attachment-large size-large wp-image-14873" alt="Magnetic Particle Testing" srcset="/uploads/2020/08/MPI.jpg 481w, /uploads/2020/08/MPI-300x225.jpg 300w" sizes="(max-width: 481px) 100vw, 481px"></noscript>											<figcaption class="widget-image-caption wp-caption-text">Magnetic Particle Testing</figcaption>
										</figure>
									</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-e3ee1bc" data-id="e3ee1bc" data-element_type="column" data-e-type="column" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-bf0c5c3 elementor-widget elementor-widget-image" data-id="bf0c5c3" data-element_type="widget" data-e-type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
												<figure class="wp-caption">
										<img decoding="async" data-src="/uploads/2020/08/PressureTesting.jpg" data-srcset="/uploads/2020/08/PressureTesting.jpg 481w, /uploads/2020/08/PressureTesting-300x225.jpg 300w" width="481" height="360" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" class="attachment-large size-large wp-image-14875 lazyload" alt="Pressure Testing"  sizes="(max-width: 481px) 100vw, 481px" /><noscript><img loading="lazy" decoding="async" width="481" height="360" src="/uploads/2020/08/PressureTesting.jpg" class="attachment-large size-large wp-image-14875" alt="Pressure Testing" srcset="/uploads/2020/08/PressureTesting.jpg 481w, /uploads/2020/08/PressureTesting-300x225.jpg 300w" sizes="(max-width: 481px) 100vw, 481px"></noscript>											<figcaption class="widget-image-caption wp-caption-text">Pressure Testing</figcaption>
										</figure>
									</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-4bba462" data-id="4bba462" data-element_type="column" data-e-type="column" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-0587cfe elementor-widget elementor-widget-image" data-id="0587cfe" data-element_type="widget" data-e-type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
												<figure class="wp-caption">
										<img loading="lazy" decoding="async" data-src="/uploads/2020/08/GasTesting.jpg" data-srcset="/uploads/2020/08/GasTesting.jpg 481w, /uploads/2020/08/GasTesting-300x225.jpg 300w" width="481" height="360" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" class="attachment-large size-large wp-image-14874 lazyload" alt="Gas Testing"  sizes="(max-width: 481px) 100vw, 481px" /><noscript><img loading="lazy" decoding="async" width="481" height="360" src="/uploads/2020/08/GasTesting.jpg" class="attachment-large size-large wp-image-14874" alt="Gas Testing" srcset="/uploads/2020/08/GasTesting.jpg 481w, /uploads/2020/08/GasTesting-300x225.jpg 300w" sizes="(max-width: 481px) 100vw, 481px"></noscript>											<figcaption class="widget-image-caption wp-caption-text">Gas Testing</figcaption>
										</figure>
									</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-2ab3a50 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="2ab3a50" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-060eb50" data-id="060eb50" data-element_type="column" data-e-type="column" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-ff28eba elementor-widget elementor-widget-image" data-id="ff28eba" data-element_type="widget" data-e-type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
												<figure class="wp-caption">
										<img loading="lazy" decoding="async" data-src="/uploads/2020/08/Welding-Diverter.jpg" data-srcset="/uploads/2020/08/Welding-Diverter.jpg 322w, /uploads/2020/08/Welding-Diverter-268x300.jpg 268w" width="322" height="360" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" class="attachment-large size-large wp-image-14880 lazyload" alt="Welding Diverter"  sizes="(max-width: 322px) 100vw, 322px" /><noscript><img loading="lazy" decoding="async" width="322" height="360" src="/uploads/2020/08/Welding-Diverter.jpg" class="attachment-large size-large wp-image-14880" alt="Welding Diverter" srcset="/uploads/2020/08/Welding-Diverter.jpg 322w, /uploads/2020/08/Welding-Diverter-268x300.jpg 268w" sizes="(max-width: 322px) 100vw, 322px"></noscript>											<figcaption class="widget-image-caption wp-caption-text">Welding Diverter</figcaption>
										</figure>
									</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-a0de20b" data-id="a0de20b" data-element_type="column" data-e-type="column" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-66647e7 elementor-widget elementor-widget-image" data-id="66647e7" data-element_type="widget" data-e-type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
												<figure class="wp-caption">
										<img loading="lazy" decoding="async" data-src="/uploads/2020/08/Gate-Lapping.jpg" data-srcset="/uploads/2020/08/Gate-Lapping.jpg 322w, /uploads/2020/08/Gate-Lapping-268x300.jpg 268w" width="322" height="360" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" class="attachment-large size-large wp-image-14881 lazyload" alt="Gate Lapping"  sizes="(max-width: 322px) 100vw, 322px" /><noscript><img loading="lazy" decoding="async" width="322" height="360" src="/uploads/2020/08/Gate-Lapping.jpg" class="attachment-large size-large wp-image-14881" alt="Gate Lapping" srcset="/uploads/2020/08/Gate-Lapping.jpg 322w, /uploads/2020/08/Gate-Lapping-268x300.jpg 268w" sizes="(max-width: 322px) 100vw, 322px"></noscript>											<figcaption class="widget-image-caption wp-caption-text">Gate Lapping</figcaption>
										</figure>
									</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-6e99cb5" data-id="6e99cb5" data-element_type="column" data-e-type="column" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-ed21f5c elementor-widget elementor-widget-image" data-id="ed21f5c" data-element_type="widget" data-e-type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
												<figure class="wp-caption">
										<img loading="lazy" decoding="async" data-src="/uploads/2020/08/Welding-BOP.jpg" data-srcset="/uploads/2020/08/Welding-BOP.jpg 322w, /uploads/2020/08/Welding-BOP-268x300.jpg 268w" width="322" height="360" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" class="attachment-large size-large wp-image-14879 lazyload" alt="Welding BOP"  sizes="(max-width: 322px) 100vw, 322px" /><noscript><img loading="lazy" decoding="async" width="322" height="360" src="/uploads/2020/08/Welding-BOP.jpg" class="attachment-large size-large wp-image-14879" alt="Welding BOP" srcset="/uploads/2020/08/Welding-BOP.jpg 322w, /uploads/2020/08/Welding-BOP-268x300.jpg 268w" sizes="(max-width: 322px) 100vw, 322px"></noscript>											<figcaption class="widget-image-caption wp-caption-text">Welding BOP</figcaption>
										</figure>
									</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-3376d93 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="3376d93" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-4f131e1" data-id="4f131e1" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
							</div>
		</div>
					</div>
		</section>
				</div>
		', '2020-08-10T11:39:55', NULL, 'USD', true, '[]'::jsonb, '{"url":"/uploads/2020/08/AfterMarket_Featured_Image.jpg","width":400,"height":400,"alt":"Aftermarket Services"}'::jsonb, '{"title":"Aftermarket Services - Worldwide Oilfield Machine","description":"WOM Aftermarket Services has three convenient locations. We offer repair, recertification and rebranding of your equipment with a vast amount of equipment and parts in stock to help you succeed.","ogImage":"/uploads/2020/08/AfterMarket_Featured_Image.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (922, 'Annular Latched BOP', 'annular-bop', '', '
<ul class="wp-block-list">
<li>WOM’s Annular BOP has a conical bowl designed piston with a length-to-diameter ratio approaching 1 which eliminates tendencies to cock and bend during operations with off-center pipe or unevenly distributed accumulations of sand, cuttings, or other elements.Only Two Moving Parts (piston and packing unit) on the Annular BOP mean few areas are subject to wear. The BOP is safer and more efficient, requiring less maintenance and less downtime.</li>



<li>The latched lid design offers fast and easy access to the packing unit and wear seals. Conical Bowl Design of the Piston provides a simple and efficient method of closing the packing unit. With the piston serving as a sealing surface against the rubber packing unit, there is no metal-to-metal wear on the sealing surface and thus longer life results.</li>



<li>Field Replaceable Wear Plate in the BOP Lid serves as an upper non-sealing wear surface for the movement of the packing unit, making field repair fast and economical.</li>



<li>Maximum Packing Unit Life is possible with the provision for measuring piston stroke. This measurement indicates remaining packing unit life without disassembly and ensures the longest and safest use of the packing unit. Three Choices of Packing Unit Rubber Compounds permit more flexible applications.</li>



<li>The Packing Unit’s back to front feedable rubber maintains closure on the BOP. Large Pressure Energized Seals are used for dynamically sealing piston chambers to provide safe operation, long seal life, and less maintenance.</li>
</ul>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list">
<li><strong>Intuitive Design:&nbsp;</strong> WOM’s Annular BOP has a conical bowl designed piston with a length-to-diameter ratio approaching 1 which eliminates tendencies to cock and bend during operations with off-center pipe or unevenly distributed accumulations of sand, cuttings, or other elements</li>



<li>&nbsp;<strong>Tested Reliability</strong><strong>:&nbsp;</strong>The piston and packing unit are the only moving parts, ensuring minimal wear. This design enhances the ability of the packing unit to reopen to full bore position. When engaged, the pipe may rotate and tool joints stripped without breaking the seal. When an annular seal is achieved, well pressure reinforces the seal</li>



<li><strong>Hassle-Free Maintenance: </strong>Field-replaceable wear plate in the BOP head serves as an upper non-sealing wear surface for the movement of the packing unit, making field repair fast and economical. A piston stroke measurement indicator indicates remaining packing unit life without need for dis-assembly and ensures the longest and safest use of the packing unit.</li>
</ul>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">WOM’s Annular BOP is suitable for onshore and offshore applications.</p>



<ul class="wp-block-list">
<li>Available in sizes ranging from 7 1/16” through 21 ¼” and pressure ranging from 2K through 10K</li>



<li>Optional packing unit rubber compounds permit more flexible application</li>
</ul>
', '2019-07-18T19:31:08', NULL, 'USD', true, '[{"id":128,"name":"BOPs","slug":"bops"}]'::jsonb, '{"url":"/uploads/2019/07/WOMAnnular-BOP1.jpg","width":432,"height":371,"alt":"Annular Latched BOP"}'::jsonb, '{"title":"Annular Latched BOP - Worldwide Oilfield Machine","description":"In the market for an Annular Latched BOP? Visit this page to learn its specifications, applications, and features. PDF download available.","ogImage":"/uploads/2019/07/WOMAnnular-BOP1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8588, 'Annular Screwed BOP', 'annular-screwed-bop', '', '
<p class="wp-block-paragraph"> WOM’s Annular BOP has a conical bowl designed piston with a length-to-diameter ratio approaching 1 which eliminates tendencies to cock and bend during operations with off-center pipe or unevenly distributed accumulations of sand, cuttings, or other elements. Only two moving parts (piston and packing unit) result in fewer areas that are subject to wear. The BOP is safer and more efficient, requiring less maintenance and less downtime. </p>



<ul class="wp-block-list">
<li>Three choices of packing unit rubber compounds permit more flexible applications.</li>



<li>Screwed lid design of the WGK BOP is a simple, efficient, and strong method of connecting the lid to the body for safe operation without loose parts being lost down the hole or overboard.</li>



<li>Large pressure energized seals are used for dynamically sealing piston chambers to provide safe operation, long seal life, and less maintenance.</li>



<li>Piston sealing surfaces protected by operating fluid lowers friction and protects against galling and wear to increase seal life and reduce maintenance.</li>



<li>Operating chambers are tested to full BOP working pressure to ensure strength, reliability, and the ability to over-pressurize the chambers in emergencies. </li>
</ul>



<h3 class="womtitle wp-block-heading"> Specification and Features </h3>



<ul class="wp-block-list">
<li>Long piston with a length to diameter ratio approaching one eliminates tendencies to cock and bind during operations with off-center pipe or unevenly distributed accumulations of sand, cuttings, or other elements. This design enhances the ability of the packing unit to reopen to full bore position.</li>



<li>Conical bowl design of the piston provides a simple and efficient method of closing the packing unit. With the piston serving as a sealing surface against the rubber packing unit, there is no metal-to-metal wear on the sealing surface and thus longer life results.</li>



<li>Field replaceable wear plate in the BOP lid serves as an upper non-sealing wear surface for the movement of the packing unit, making field repair fast and economical.</li>



<li>Maximum packing unit life is possible with the provision for measuring piston stroke. This measurement indicates remaining packing unit life without disassembly and ensures the longest and safest use of the packing unit.</li>
</ul>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">WOM’s annular BOP is suitable for onshore and offshore applications.</p>



<ul class="wp-block-list">
<li>Available in sizes ranging from 7 1/16” through 21 ¼” and pressure ranging from 2K through 10K</li>



<li>Optional packing unit rubber compounds permit more flexible application</li>
</ul>
', '2019-04-06T12:29:22', NULL, 'USD', true, '[{"id":128,"name":"BOPs","slug":"bops"}]'::jsonb, '{"url":"/uploads/2019/10/AnnularScrewedBOP.jpg","width":432,"height":371,"alt":"Annular Screwed BOP"}'::jsonb, '{"title":"Annular Screwed BOP, Annular BOP - Worldwide Oilfield Machine","description":"In the market for an Annular Screwed BOP? Visit this page to learn its specifications, applications, and features. PDF download available.","ogImage":"/uploads/2019/10/AnnularScrewedBOP.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8601, 'Annular Spherical BOP', 'annular-spherical-bop', '', '
<p class="wp-block-paragraph">Our WSB annular BOP features a reliable, compact design with retrofittable swarf seal technology.  </p>



<p class="wp-block-paragraph">• <strong>Rugged, reliable spherical type sealing element &#8211; </strong>Provides positive seal after hundreds of tests to full working pressure <br>• <strong>Enhanced swarf seal</strong> &#8211; Designed to help prevent metal-to-metal damage from swarf entering the piston when performing milling<br>• <strong>Strong, simple construction</strong> – only five major parts<br>• <strong>Compact body saves space</strong> &#8211; Height is 15 to 20% less than equivalent annular BOP designs <br>•<strong> Simple hydraulic system</strong> &#8211; Optimized to only require two hydraulic connections for operation<br>•<strong> Wear rings on moving parts</strong> &#8211; Feature prevents metal-to metal contact, allowing for prolonged preventer life.<br>•<strong> Resistant to corrosive environments</strong> &#8211; Standard models are suitable for internal H2S service, and simple bolt and lifting shackle changes convert them for external H2S service.<br>• <strong>Ease of Service &#8211;  </strong>Element can be replaced without contamination of mud or grit into the hydraulic system</p>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">WOM’s Type WSB BOP was designed especially for surface installations and is also used on offshore platforms.</p>
', '2019-03-06T12:44:18', NULL, 'USD', true, '[{"id":128,"name":"BOPs","slug":"bops"}]'::jsonb, '{"url":"/uploads/2019/10/AnnularSphericalBOP.jpg","width":432,"height":371,"alt":"Annular Spherical BOP"}'::jsonb, '{"title":"Annular Spherical BOP - Worldwide Oilfield Machine","description":"WOM''s Annular BOP consists of just five major parts and only two moving parts, which are the piston and the packing unit.","ogImage":"/uploads/2019/10/AnnularSphericalBOP.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8564, 'API 20 E Bolting', 'api-20-e-bolting', '', '
<p class="wp-block-paragraph">WOM is proud to announce to the market, its new API 20E product line, in order to offer its clients fasteners even more reliable and safe. WOM has achieved benchmark quality and the shortest delivery duration in the industry with its complete in-house and vertically integrated capabilities. The obtaining of the API 20E guarantees WOM’s products are manufactured and tested under the most extreme conditions. WOM is able to manufacture (BSL) Bolting Specification Levels in the three-existing levels, which prove WOM’s commitment with technology and engineering excellence.</p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<p class="wp-block-paragraph">The API 20 E Bolting is manufactured in several material classes.</p>



<ul class="wp-block-list"><li>ASTM Grades</li><li>ASTM A193 &#8211; B7, B7M</li><li>ASTM A194 &#8211; 2H, 7, 2HM, 7M</li><li>ASTM A320 &#8211; Grades L7, L7M, L43</li></ul>



<p class="wp-block-paragraph">Bolting Specification Level (BSL) :</p>



<ul class="wp-block-list"><li>BSL-1</li><li>BSL-2</li><li>BSL-3</li></ul>



<p class="wp-block-paragraph">Types:</p>



<ul class="wp-block-list"><li>Hot Formed Bolts</li><li>Hot Formed Nuts</li><li>Machined Stud Bolts and Nuts</li></ul>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">This bolting is used in critical Surface &amp; Subsea applications equipment and API specification such as:</p>



<ul class="wp-block-list"><li>Valves &#8211; Wellheads &#8211; Xmas Trees &#8211; API 6A</li><li>Ball Valves &#8211; API 6D SS</li><li>Blowout Preventers &#8211; API 16A</li><li>Manifolds &#8211; API 16C/17D</li><li>Other HPHT Equipment</li></ul>
', '2019-07-04T21:29:02', NULL, 'USD', true, '[{"id":261,"name":"Other Products","slug":"other-products"}]'::jsonb, '{"url":"/uploads/2019/10/APIBolting1.jpg","width":800,"height":543,"alt":"API 20 E Bolting"}'::jsonb, '{"title":"API 20 E Bolting, API 20 E Bolting Manufacturers - WOM Group","description":"WOM leading manufacturing for API 20 E Bolting. WOM is proud to announce to the market, its new API 20E product line, in order to offer its clients fasteners even more reliable and safe.","ogImage":"/uploads/2019/10/APIBolting1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1093, 'Casing Head Spools', 'casing-head-spools', '', '
<p class="wp-block-paragraph">WOM’s WC-22 and WC-29 casing heads feature a versatile straight bore design that can accept a wide variety of slip and mandrel type casing hangers. WOM’s Casing Head Spools can be used in onshore and offshore environments, for general and sour service and in conventional or specialty wellhead systems. The WC-29 Casing Spool has a deeper bowl design which allows the use of the WC-29 Cashing Hanger for heavier casing loads.</p>



<h2 class="womtitle wp-block-heading">Specification and Features</h2>



<ul class="wp-block-list"><li><strong>Rugged &amp; Reliable: </strong>Optional integral double FS-seal, P-seal and Metal-to-Metal seal bottom preparation for HTHP applications</li><li><strong>Versatile Engineering: </strong>WOM Casing Head Spools are designed to accept WC-21, WC-22 and WC-29 casing slip hangers as well as Mandrel casing hangers</li><li><strong>Industry Certified:&nbsp;</strong>WOM Casing Head Spools are manufactured to API 6A specifications and are rated to 15,000 PSI</li></ul>



<h2 class="womtitle wp-block-heading">Applications</h2>



<p class="wp-block-paragraph">Our Casing Head Spools can be used in onshore and offshore environments, for general and sour service and in conventional or specialty wellhead systems.</p>



<ul class="wp-block-list"><li>PSL 1 to 3G certified</li><li>PR-1 certified</li><li>Available in DD-NL, EE-NL, FF-NL and HH-NL trims</li><li>Available in nominal flange sizes 11″ to 13-5/8″</li><li>Available with or without lockscrews</li><li>Optional landing base plate assemble for 20″ to 30″ conductor pipe</li></ul>
', '2019-07-18T07:04:28', NULL, 'USD', true, '[{"id":134,"name":"Wellheads & Christmas Trees","slug":"wellheads-christmas-trees"}]'::jsonb, '{"url":"/uploads/2019/07/Casing-Head-Spools.jpg","width":432,"height":371,"alt":"Casing Head Spools"}'::jsonb, '{"title":"Casing Head Spools, Oilfield Casing - Worldwide Oilfield Machine","description":"WOM’s casing head spools feature a versatile straight bore design that can accept a wide variety of slip and mandrel type casing hangers.","ogImage":"/uploads/2019/07/Casing-Head-Spools.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1081, 'Casing Heads', 'casing-heads', '', '
<p class="wp-block-paragraph"> WOM’s offering of Casing Head designs guarantee that our equipment is compatible with any industry-standard system. Casing Heads are compatible with WC-21, WC-22 and WC-29 casing hangers and Mandrel casing hangers.  </p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li><strong>Extreme Versatility:&nbsp; </strong>WOM’s offering of Casing Head designs guarantee that our equipment is compatible with any industry-standard system. Casing Heads are compatible with WC-21, WC-22 and WC-29 casing hangers and Mandrel casing hangers</li><li><strong>Built to Client Specifications: </strong>WOM Casing Heads are fully customized to meet any customer requirement</li><li><strong>Industry Certified: </strong>WOM Casing Heads are manufactured to API 6A specifications and rated to 10,000 PSI</li></ul>



<h3 class="womtitle wp-block-heading"> Applications </h3>



<ul class="wp-block-list"><li>WOM’s Casing Heads can be used in onshore and offshore environments, for general and sour service and in conventional or specialty wellhead systems.</li><li>PSL 1 -3 certified</li><li>PR-1 certified</li><li>Available in DD-NL, EE-NL, FF-NL and HH-NL trims</li><li>Available in nominal flange sizes 11″ to 21-1/4″</li><li>Available with threaded, studded or flange outlets</li><li>Available with or without lockscrews</li><li>Optional landing base plate assemble for 20″ to 30″ conductor pipe</li></ul>
', '2019-07-18T06:12:52', NULL, 'USD', true, '[{"id":134,"name":"Wellheads & Christmas Trees","slug":"wellheads-christmas-trees"}]'::jsonb, '{"url":"/uploads/2019/07/Casing-Heads.jpg","width":432,"height":371,"alt":"Casing Heads"}'::jsonb, '{"title":"Casing Heads, Casing Oilfield - Worldwide Oilfield Machine","description":"WOM offering of Casing Head designs guarantee that our equipment is compatible with any industry-standard system. Casing Heads are compatible with WC-21, WC-22 and WC-29 casing hangers and Mandrel casing hangers.","ogImage":"/uploads/2019/07/Casing-Heads.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1053, 'Cement Manifold', 'cement-manifold', '', '
<p class="wp-block-paragraph">WOM specializes in the manufacture of manifolds for a complete range of onshore and offshore applications. WOM manifold systems may incorporate WOM’s gate valves, check valves, plug valves, chokes, and WOM actuators depending upon the application.</p>



<p class="wp-block-paragraph">WOM manifold designs meet virtually any industry requirement, including environments up to 20,000 psi. Skid mounted and fully automated packages are available complete with control panels and instrumentation.</p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li><strong>Built with Magnum Technology: </strong>WOM’s cement manifolds incorporate patented Magnum Dual-Seal technology per customer requirements</li><li><strong>Quality Ensured: </strong>WOM’s cement manifolds are designed and constructed to provide unmatched quality at a cost-effective price to the customer</li><li><strong>Industry Certified: </strong>WOM’s fully vertically integrated manufacturing process allows for the highest level of quality control and ensures that all custom manifolds meet API specifications</li><li>WOM Cement Manifolds incorporate the patented Magnum Gate Valve or Model 700 and are designed for heavy slurry and high pressure</li></ul>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">WOM Cement Manifolds are designed for heavy slurry and high pressure.</p>
', '2019-07-17T19:43:30', NULL, 'USD', true, '[{"id":132,"name":"Manifolds","slug":"manifolds"}]'::jsonb, '{"url":"/uploads/2019/07/Cement-Manifold1R1.jpg","width":432,"height":371,"alt":"Cement Manifold"}'::jsonb, '{"title":"Cement Manifold, Cement Manifold Manufacturers - WOM Group","description":"WOM specializes in the manufacture of Cement Manifolds for a complete range of onshore and offshore applications. These Cement Manifolds are designed for heavy slurry and high pressure.","ogImage":"/uploads/2019/07/Cement-Manifold1R1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8193, 'Check Valves', 'check-valves', '', '
<p class="wp-block-paragraph">WOM offers a lift type check valve for the prevention of back flow in high pressure and/or high temperature mud lines, choke &amp; kill manifolds and Christmas tree injection and kill lines.</p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<p class="wp-block-paragraph">Available in sizes 1-13/16” through 4-1/16” (larger sizes available upon request) and pressure ratings of 3,000 psi through 20,000 psi, WOM Check Valves can be configured with flanged, butt weld, hub type, or a combination of end connections to suit customer’s specifications.</p>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">Used for for the prevention of back flow in high pressure and/or high temperature mud lines, choke &amp; kill manifolds and Christmas tree injection and kill lines.</p>
', '2019-04-27T23:22:42', NULL, 'USD', true, '[{"id":251,"name":"Check Valves","slug":"check-valves"}]'::jsonb, '{"url":"/uploads/2019/09/CheckValves.jpg","width":432,"height":371,"alt":"Check Valves"}'::jsonb, '{"title":"Check Valves, Check Valves Oilfield Equipment - WOM Group","description":"WOM leading oilfield company for Check Valves equipment. WOM offers a lift type check valve for the prevention of back flow in high pressure and/or high temperature mud lines, choke & kill manifolds and Christmas tree injection and kill lines.","ogImage":"/uploads/2019/09/CheckValves.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1029, 'Choke &#038; Kill Manifolds', 'choke-kill-manifolds', '', '
<p class="wp-block-paragraph">WOM’s choke and kill manifolds incorporate patented Magnum Dual-Seal technology and can be configured with a wide range of gate valves, check valves, plug valves, chokes and actuators per customer requirement. </p>



<p class="wp-block-paragraph">WOM specializes in the manufacture of manifolds for a complete range of onshore and offshore applications. WOM manifold systems may incorporate WOM’s Magnum gate valves, check valves, plug valves, chokes, and WOM actuators depending upon the application. WOM manifold designs meet virtually any industry requirement, including H2S environments up to 20,000 psi. Skid mounted and fully automated packages are available complete with control<br>panels and instrumentation.</p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li><strong>Built with Magnum Technology: </strong>WOM’s choke &amp; kill manifolds incorporate patented Magnum Dual-Seal technology and can be configured with a wide range of gate valves, check valves, plug valves, chokes and actuators per customer requirement</li><li><strong>Quality Ensured: </strong>WOM’s choke and kill manifolds are to meet virtually any industry standard, including H2S environments up to 20,000 psi and can be fully automated with accompanying control packages</li><li><strong>Industry Certified: </strong>WOM’s fully vertically integrated manufacturing process allows for the highest level of quality control and ensures that all choke and kill manifolds meet API 16C specifications and are trusted by clients such as Noble Drilling, Transocean Offshore, Schlumberger, Shell Offshore and many more</li></ul>
', '2019-07-17T18:21:22', NULL, 'USD', true, '[{"id":132,"name":"Manifolds","slug":"manifolds"}]'::jsonb, '{"url":"/uploads/2019/07/ChokeKill-ManifoldR1.jpg","width":600,"height":520,"alt":"Choke &#038; Kill Manifolds"}'::jsonb, '{"title":"Choke & Kill Manifolds - Worldwide Oilfield Machine","description":"WOM’s choke & kill manifolds incorporate patented Magnum Dual-Seal technology and can be configured with a wide range of gate valves, check valves, plug valves, chokes and actuators.","ogImage":"/uploads/2019/07/ChokeKill-ManifoldR1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (967, 'Custom Designed Systems', 'custom-designed-systems', '', '
<p class="wp-block-paragraph">Customer requirements for controlling unique pressure situations may not always be successfully achieved by off-the-shelf components. To address these potential situations, WOM provides custom designed systems for onshore, offshore and subsea applications.</p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li><strong>Proven Reliability: </strong>All of our custom designed production equipment uses our proprietary Magnum technology wherever possible to provide the highest level of reliability in every package</li><li><strong>Industry Compliant: </strong>WOM’s custom designed packages are made to meet and surpass the guidelines of both the client and industry regulatory agencies. All custom packages are manufactured using the same API and ISO approved facilities and methods with which WOM’s standard products are manufactured.</li></ul>



<p class="wp-block-paragraph">The basic building block of these systems is the Magnum Gate Valve. The versatility, adaptability and reliability of this valve design ensures ease of incorporation with other components to provide greater safety, longer service life and minimized maintenance.</p>



<h3 class="womtitle wp-block-heading"> Applications </h3>



<p class="wp-block-paragraph">The engineering staff at WOM has successfully developed numerous pressure control systems that have been installed to meet a wide range of operating conditions and flow control requirements.</p>
', '2019-07-17T11:33:43', NULL, 'USD', true, '[{"id":130,"name":"Custom Designs","slug":"custom-designs"}]'::jsonb, '{"url":"/uploads/2019/07/Custom-Designed-Systems.jpg","width":432,"height":371,"alt":"Custom Designed Systems"}'::jsonb, '{"title":"WOM Custom Designed Systems - Worldwide Oilfield Machine","description":"WOM provides custom designed systems for onshore, offshore and subsea applications. All of WOM’s custom designed production equipment utilizes Magnum technology wherever possible to provide the highest level of reliability in every package.","ogImage":"/uploads/2019/07/Custom-Designed-Systems.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1036, 'Custom Manifolds', 'woms-custom-manifolds', '', '
<p class="wp-block-paragraph">WOM’s custom manifolds incorporate patented Magnum Dual-Seal technology per customer requirement. WOM designs, manufactures and supplies high pressure (up to 20,000 psi) choke and kill manifolds, standpipe manifolds, cement manifolds, well test manifolds, MPD and custom application manifolds. Skid mounted and fully automated packages are available complete with control panels and instrumentation. WOM Manifold Systems may incorporate WOM Magnum Gate Valves, Check Valves, Chokes, and WOM Actuators depending upon the application.</p>



<h3 class="wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li><strong>Built with Magnum Technology: </strong>WOM’s custom manifolds incorporate patented Magnum Dual-Seal technology per customer requirement</li><li><strong>Quality Ensured:&nbsp;</strong>WOM’s custom manifolds are designed and constructed to provide unmatched quality at a cost-effective price to the customer</li><li><strong>Industry Certified: </strong>WOM’s fully vertically integrated manufacturing process allows for the highest level of quality control and ensures that all custom manifolds meet API 16C specifications.</li></ul>



<h3 class="wp-block-heading"> Applications </h3>



<p class="wp-block-paragraph">

WOM specializes in the manufacture of manifolds for a complete range of onshore and offshore oilfield applications.

</p>
', '2019-07-17T18:56:08', NULL, 'USD', true, '[{"id":132,"name":"Manifolds","slug":"manifolds"}]'::jsonb, '{"url":"/uploads/2019/07/Custom-ManifoldsR1.jpg","width":432,"height":371,"alt":"Custom Manifolds"}'::jsonb, '{"title":"Custom Manifolds, Custom Manifolds Surface Equipment - WOM Group","description":"WOM’s custom manifolds are designed and constructed to provide unmatched quality at a cost-effective price to the customer. WOM’s custom manifolds incorporate patented Magnum Dual-Seal technology per customer requirement.","ogImage":"/uploads/2019/07/Custom-ManifoldsR1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8863, 'Debris / Junk Catcher Manifold', 'debris-junk-catcher-manifold', '', '		<div data-elementor-type="wp-post" data-elementor-id="8863" class="elementor elementor-8863" data-elementor-post-type="product">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-279d16b6 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="279d16b6" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-66d8a5ac" data-id="66d8a5ac" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-29ece6e2 elementor-widget elementor-widget-text-editor" data-id="29ece6e2" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									<p></p>
<p class="wp-block-paragraph">The MTC Debris / Junk catcher manifold is designed to remove drilling, formation and proppant based debris / junk from the wellbore fluids during well testing operations to minimize the potential damage to pressure control and measuring equipment installed downstream. Our standard package consist of 3 ft 10K psi and 15K psi with options of 5 valves and 9 valves.&nbsp;</p>
<p></p>								</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		', '2019-08-08T16:43:17', NULL, 'USD', true, '[{"id":135,"name":"Well Test Equipment","slug":"well-test-equipment"}]'::jsonb, '{"url":"/uploads/2019/10/DebrisCatcher.jpg","width":432,"height":371,"alt":"Debris / Junk Catcher Manifold"}'::jsonb, '{"title":"Debris / Junk Catcher Manifold - Worldwide Oilfield Machine","description":"Debris / Junk Catcher Manifold is designed to remove drilling, formation and proppant based debris / junk from the wellbore fluids to minimize the potential damage.","ogImage":"/uploads/2019/10/DebrisCatcher.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8188, 'Disc Type Choke', 'disc-type-choke', '', '
<p class="wp-block-paragraph">WOM disc type choke features a robust design aimed at protecting sealing elements against erosive media and environmental detriment. </p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<p class="wp-block-paragraph">The disc type valve uses two tungsten carbide discs with holes of specific geometry. The upper disc is rotated relative to the lower disc (manually or by actuator) varying the orifice size. The discs are rotated 180 degrees between open and closed position. In addition, the lapped matting surfaces of the discs designed to provide positive seal. </p>



<h3 class="womtitle wp-block-heading"> Applications </h3>



<p class="wp-block-paragraph"> WOM disc type choke is a robust design that guarantees excellent controllability and protection of the sealing surfaces against erosive media. Available in  1-in., 1.5-in. and 3-in.   maximum orifice trim with 5000 to 15000 PSI maximum working pressure. </p>
', '2019-09-15T22:59:44', NULL, 'USD', true, '[{"id":258,"name":"Chokes","slug":"chokes"}]'::jsonb, '{"url":"/uploads/2019/09/DiskTypeChoke.jpg","width":432,"height":371,"alt":"Disc Type Choke"}'::jsonb, '{"title":"Disc Type Choke, Disc Type Choke Valve - WOM Group","description":"WOM disc type choke is a robust design that guarantees excellent controllability and protection of the sealing surfaces against erosive media. The disc type valve uses two Tungsten Carbide discs with holes of specific geometry.","ogImage":"/uploads/2019/09/DiskTypeChoke.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8183, 'Drilling Choke', 'drilling-choke', '', '
<p class="wp-block-paragraph">WOM drilling chokes offer the customer increased service life and cost savings in high pressure drilling operations especially where substantial amount of abrasive fluids are present. WOM Drilling chokes are designed to encounter large cuttings coming up with the drilling mud.</p>



<h3 class="womtitle wp-block-heading">Product Specification and Features</h3>



<ul class="wp-block-list"><li>Features cutting edge gate and seat design which reduces wear in extremely hostile flow conditions</li><li>Reversible gate and seat design increases life of the choke</li><li>Pressure balanced trim considerably reduces the torque required to operate the choke</li><li>Large body cavity around trim components reduces the speed of the solids in the fluids, thus enhances the body life</li><li>Extended wear sleeve limits downstream erosion to the trim, protecting the body from damage</li><li>Meet or exceed the minimum requirement specified by API 16C latest edition</li></ul>



<h3 class="wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">Their consistent performance has been proved in kick control, well testing, well clean-up and other harshest of conditions. Available in 1-3/4-in. orifice trim with 5,000, 10,000 and 15,000 PSI pressure ratings.</p>
', '2019-09-16T22:49:04', NULL, 'USD', true, '[{"id":258,"name":"Chokes","slug":"chokes"}]'::jsonb, '{"url":"/uploads/2019/09/DrillingChoke.jpg","width":432,"height":371,"alt":"Drilling Choke"}'::jsonb, '{"title":"Drilling Chokes, Drilling Choke Supplier - WOM Group","description":"WOM drilling chokes offer customer increased service life and cost savings in high pressure drilling operations especially where substantial amount of abrasive fluids are present. WOM drilling chokes are designed as per API 16C.","ogImage":"/uploads/2019/09/DrillingChoke.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (953, 'Drilling Choke Control Panel', 'standard-drilling-choke-control-panel', '', '
<p class="wp-block-paragraph">The WOM Control System software is equipped with intelligence that allows mechanization of the <a href="https://worldwideoilfieldmachinery.com/product/well-testing-choke-manifolds/">well control manifolds</a>. The software’s diagnostic configuration resides inside the WOM PLC/HMI. The software (PLC/HMI) is written using Siemens TIA portal.</p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<p class="wp-block-paragraph">WOM’s Standard Control Panel comes in configurations/ options:</p>



<ul class="wp-block-list"><li>Stand Alone/Floor Mount</li><li>Blind HPU</li><li>Remote Wall Mount</li></ul>



<p class="womtitle wp-block-paragraph"><strong>API 16C drilling conformance</strong></p>



<ul class="wp-block-list"><li>Emergency Operation Provisions
<ul><li>Nitrogen Connection</li><li>Hand Pump</li></ul>
</li><li>Rig Air Connection</li><li>Choke Pressure</li><li>Stand Pipe Pressure</li><li>Choke Position Indicator</li><li>PSC</li><li>Primary and Back Up Pump</li><li>Accumulator
<ul><li>Increase Choke Speed</li><li>Smooth Choke Operation</li><li>Emergency Power Source</li></ul>
</li><li>Choke Speed Control</li><li>Power to close Choke from fully open within 30 seconds</li></ul>



<h3 class="womtitle wp-block-heading">Applications</h3>



<ul class="wp-block-list"><li>Suitable for Zone 1 and Zone 2</li><li>DNV and ABS certified</li><li>316SS Internal Hard Tubing</li></ul>
', '2019-07-17T10:25:24', NULL, 'USD', true, '[{"id":129,"name":"Controls and Instrumentation","slug":"controls-and-instrumentation"}]'::jsonb, '{"url":"/uploads/2019/07/DrillingChokeControlPanel.jpg","width":600,"height":515,"alt":"Drilling Choke Control Panel"}'::jsonb, '{"title":"Drilling Choke Control Panel - Worldwide Oilfield Machine","description":"WOM''s Drilling Choke Control Panel is equipped with intelligence that allows mechanization of the well control manifolds. Its function in the system is to ensure pressure control during drilling operations.","ogImage":"/uploads/2019/07/DrillingChokeControlPanel.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (9142, 'Drilling Spools', 'drilling-spools', '', '
<p class="wp-block-paragraph">Drilling spools are designed and manufactured in accordance with API Spec 16A &amp; 6A, conforming to NACE MR 0175.</p>



<p class="wp-block-paragraph">Drilling Spools are Pressure-Containing equipment with end connections and outlets, stack in between drill through equipment.</p>



<p class="wp-block-paragraph">Drilling spools are designed to connect the BOP and wellhead, both side outlets of spool can be connected with valves or manifold to prevent blowout.</p>
', '2019-06-13T20:10:39', NULL, 'USD', true, '[{"id":261,"name":"Other Products","slug":"other-products"}]'::jsonb, '{"url":"/uploads/2019/06/Drilling-Spool-ISO.jpg","width":600,"height":600,"alt":"Drilling Spools"}'::jsonb, '{"title":"Drilling Spools, Drilling Spools Oilfield Equipment - WOM Group","description":"Drilling Spools are Pressure-Containing equipment with end connections and outlets, stack in between drill through equipment.","ogImage":"/uploads/2019/06/Drilling-Spool-ISO.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (961, 'Emergency Shutdown System', 'emergency-shutdown-systemesd', '', '		<div data-elementor-type="wp-post" data-elementor-id="961" class="elementor elementor-961" data-elementor-post-type="product">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-7adddd13 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="7adddd13" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-306d2a61" data-id="306d2a61" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-70033482 elementor-widget elementor-widget-text-editor" data-id="70033482" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									<p></p>
<p class="wp-block-paragraph">Our ESD system provides a fast acting functional safety shutdown in case of a hydrocarbon escape or other safety issues. This system located on the rig floor is designed to actuate <a href="https://worldwideoilfieldmachinery.com/product/well-test-valves/">SSV valves</a> installed on or near the <a href="https://worldwideoilfieldmachinery.com/product/flowheads/">flowhead</a>.</p>
<p></p>
<h3 class="womtitle wp-block-heading">Specification and Features</h3>
<p></p>
<p class="wp-block-paragraph">The control panel includes:</p>
<ul>
<li>One ESD local control; installed on the control panel face</li><li>Maximum five (5) Remote ESD control stations</li><li>Hi-pilot pressure set point; pilot device</li><li>Low-pilot pressure set point; pilot device</li><li>Fusible plug</li><li>One High Pressure hydraulic hose 100 feet, rated for 6,000 psi</li><li>Air Hose(s) for Remote Stations, 100 feet</li>
</ul>
<p></p>
<h3 class="womtitle wp-block-heading">Applications</h3>
<p></p>
<p class="wp-block-paragraph">Custom configurations available upon request.</p>
<p></p>								</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		', '2019-07-17T11:16:00', NULL, 'USD', true, '[{"id":129,"name":"Controls and Instrumentation","slug":"controls-and-instrumentation"}]'::jsonb, '{"url":"/uploads/2019/07/Emergency-Shutdown-SystemESD1.jpg","width":600,"height":515,"alt":"Emergency Shutdown System"}'::jsonb, '{"title":"Emergency Shutdown System, ESD System - Worldwide Oilfield Machine","description":"WOM’s Emergency Shutdown System (ESD) provides a fast acting functional safety shutdown in case of a hydrocarbon escape or other safety issues.","ogImage":"/uploads/2019/07/Emergency-Shutdown-SystemESD1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8178, 'External Sleeve Choke', 'external-sleeve-choke', '', '
<p class="wp-block-paragraph">External sleeve chokes are designed to provide accurate flow control throughout its operating range. The externally guided sleeve controls the opening and rate of flow. The flow is directed upward away from the outlet, impinges on itself in the center of the flow cage which in turn isolates the body bore from incoming turbulent flow, eliminating the body wear, and making it ideal for low capacity/high pressure drop applications.</p>



<h3 class="womtitle wp-block-heading">Product Specification and Features</h3>



<ul class="wp-block-list"><li>The seating is achieved through an isolated sealing element contact on a seat outside the flow cage</li><li>Pressure balanced trim considerably reduces the torque required to operate the choke</li><li>The trim characteristics is equal percentage that provides superior flow control, however, WOM can provide the linear trim as well on demand</li><li>Keeping the seat surface away from the high velocity flow protects the seat from throttling wear and the seat integrity is maintained</li><li>Meet or exceed the minimum requirement specified by API 6A latest edition</li></ul>



<h3 class="womtitle wp-block-heading"> Applications </h3>



<p class="wp-block-paragraph">External sleeve chokes are used in christmas trees, gas lift applications, choke manifolds, well<br>test applications, process platforms and FPSOs.</p>



<h2 class="womtitle has-luminous-vivid-orange-color has-text-color wp-block-heading">Model WES(H2)-20 and -30</h2>



<p class="wp-block-paragraph">WES(H2) series is an innovative modular design interconvertible between external sleeve, needle &amp; seat and fixed bean choke design. It can also be easily converted from manual to actuator operated and vice-versa<br>Model WES(H2) can be converted to needle and seat choke by replacing the stem and seat<br>For WES(H2) chokes, conversion from a manual to an actuated choke does not require the choke to be dis-assembled, decreasing downtime</p>



<figure class="wp-block-gallery aligncenter columns-1 is-cropped wp-block-gallery-1 is-layout-flex wp-block-gallery-is-layout-flex"><ul class="blocks-gallery-grid"><li class="blocks-gallery-item"><figure><img fetchpriority="high" decoding="async" width="432" height="371" data-src="/uploads/2020/06/WESChoke.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" data-id="13472" class="wp-image-13472 lazyload"/><noscript><img decoding="async" width="432" height="371" src="/uploads/2020/06/WESChoke.jpg" alt="" data-id="13472" class="wp-image-13472" srcset="/uploads/2020/06/WESChoke.jpg 432w, /uploads/2020/06/WESChoke-300x258.jpg 300w" sizes="(max-width: 432px) 100vw, 432px" /></noscript><figcaption class="blocks-gallery-item__caption">WES(H2)-20 <br>Manual &amp; Actuated</figcaption></figure></li></ul></figure>
', '2020-06-12T05:40:22', NULL, 'USD', true, '[{"id":258,"name":"Chokes","slug":"chokes"}]'::jsonb, '{"url":"/uploads/2019/09/External-Sleeve-Choke.jpg","width":432,"height":371,"alt":"External Sleeve Choke"}'::jsonb, '{"title":"External Sleeve Choke, External Sleeve Choke Manufacturers - WOM Group","description":"External Sleeve chokes are designed to provide accurate flow control throughout its operating range. The externally guided sleeve controls the opening and rate of flow.","ogImage":"/uploads/2019/09/External-Sleeve-Choke.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (9146, 'Flange Adaptor', 'flange-adaptor', '', '
<p class="wp-block-paragraph">Flange Adapters are Pressure-Containing equipment with end connections of variable nominal size and/or pressure ratings; used to connect other equipment of variable nominal sizes and/or pressure ratings.</p>



<p class="wp-block-paragraph">Flanged Adapters are designed and manufactured as per API Spec 6A &amp; 16A, conforming to NACE MR 0175.</p>
', '2019-06-13T20:18:41', NULL, 'USD', true, '[{"id":261,"name":"Other Products","slug":"other-products"}]'::jsonb, '{"url":"/uploads/2019/06/Adaptor-Spool-ISO.jpg","width":600,"height":600,"alt":"Flange Adaptor"}'::jsonb, '{"title":"Flange Adaptor, Flange Adaptor Pressure Containing Equipment","description":"WOM''s Flange Adapters are Pressure-Containing equipment with end connections of variable nominal size and/or pressure ratings; used to connect other equipment of variable nominal sizes and/or pressure ratings.","ogImage":"/uploads/2019/06/Adaptor-Spool-ISO.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (9904, 'Floating Ball Valve', 'floating-ball-valve', '', '
<p class="wp-block-paragraph">Our Floating Ball Valves provide the user with an exceedingly reliable and proven design offering maximum sealing against leaks. WOM’s Floating Ball Valves have separate ball and stem design with a free floating ball preloaded between the seats during assembly.  When pressure enters the valve from the upstream side, the ball stem slot allows the ball to float freely under pressure moving from its axis to seal on the downstream side, resulting in a pressure assisted seal. The stem remains in the valve axis, enhancing stem seal performance for a tight seal joint.</p>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph"> • Oil and gas service with NACE and Non-NACE based material selections.<br> • Pharmaceutical and Chemical Industry based material selection.<br> • Standard temperature range of -20˚F to 250˚F<br> • Temperature range of -40˚F to 250˚F can be supplied on demand.</p>
', '2019-06-05T12:07:28', NULL, 'USD', true, '[{"id":127,"name":"Ball Valves","slug":"ball-valves"}]'::jsonb, '{"url":"/uploads/2019/11/FloatingBallValve.jpg","width":432,"height":371,"alt":"Floating Ball Valve"}'::jsonb, '{"title":"Floating Ball Valve, Floating Ball Valve Manufacturers - WOM Group","description":"WOM Group manufacturers Floating Ball Valve with advanced technology. WOM’s Floating Ball Valves provide the user with an exceedingly reliable and proven design offering maximum sealing against leaks.","ogImage":"/uploads/2019/11/FloatingBallValve.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (12558, 'Flowback Chokes', 'flowback-chokes', '', '
<p class="wp-block-paragraph">The WOM Flowback choke, Model WFB is designed with Hammer Union end connectors and is well suited for fracking, flow back, and well service applications.</p>



<p class="wp-block-paragraph">Available in both a 2-in. body with a 1-in. maximum orifice and a 3-in. nominal body with a maximum orifice size of 2 inches.</p>
', '2020-06-13T01:50:51', NULL, 'USD', true, '[{"id":258,"name":"Chokes","slug":"chokes"},{"id":284,"name":"Flow Control Products","slug":"flow-control-products"}]'::jsonb, '{"url":"/uploads/2020/04/FLowBackChoke.jpg","width":753,"height":635,"alt":"Flowback Chokes"}'::jsonb, '{"title":"Flowback Chokes - Worldwide Oilfield Machine","description":"WOM Group provides Flowback choke that is designed with Hammer Union connections and is well suited for fracking, flow back, and well service applications.","ogImage":"/uploads/2020/04/FLowBackChoke.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (946, 'Flowhead Control Panel', 'flowhead-control-panel', '', '
<p class="wp-block-paragraph">WOM’s Flowhead Control Panel located on the rig floor allows for remote shut-in of the well at the flowhead. The system is designed to actuate a maximum of two (2) double acting hydraulic gate valves and two (2) fail-safe actuated valves.</p>



<h3 class="womtitle wp-block-heading"> Specification and Features </h3>



<p class="wp-block-paragraph">■ Two (2) hydraulic operated fail-safe actuated wing valves<br>■ One (1) hydraulic operated swab valve<br>■ One (1) hydraulic operated master valve</p>



<h3 class="womtitle wp-block-heading"> Applications</h3>



<p class="wp-block-paragraph">

Custom configurations available upon request.

</p>
', '2019-07-17T10:02:02', NULL, 'USD', true, '[{"id":129,"name":"Controls and Instrumentation","slug":"controls-and-instrumentation"}]'::jsonb, '{"url":"/uploads/2019/07/FlowheadControlSystem.jpg","width":600,"height":515,"alt":"Flowhead Control Panel"}'::jsonb, '{"title":"Flowhead Control Panel - Worldwide Oilfield Machine","description":"WOM’s Flowhead Control Panel located on the rig floor allows for remote shut-in of the well at the flowhead. Browse more information about Flowhead Control Panel.","ogImage":"/uploads/2019/07/FlowheadControlSystem.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (12562, 'Flowline Equipment', 'flowline-equipment', '', '
<p class="wp-block-paragraph">WOM provides a full range product offering for Well Service Solutions including well test and flowline equipment. Leveraging WOM’s worldwide quality manufacturing capacity and strategic stocking locations, WOM is ready to meet your demands.</p>
', '2020-06-10T14:54:56', NULL, 'USD', true, '[{"id":284,"name":"Flow Control Products","slug":"flow-control-products"}]'::jsonb, '{"url":"/uploads/2020/04/FlowLineEquipment3.jpg","width":432,"height":371,"alt":"Flowline Equipment"}'::jsonb, '{"title":"Flowline Equipment - Worldwide Oilfield Machine","description":"WOM Group provides a full range product offering for Well Service Solutions including well test and flowline equipment.","ogImage":"/uploads/2020/04/FlowLineEquipment3.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (9131, 'Hammer Unions', 'hammer-unions', '', '
<p class="wp-block-paragraph">WOM Hammer Unions offer a pressure-tight, positive seal for both standard and sour service. Each union is thoroughly inspected to ensure long, dependable service in the most extreme conditions. Available in stock at our Houston and Midland facilities.</p>



<ul class="wp-block-list"><li>Color coded for quick identification<ul><li> WOM Orange – Standard Service</li><li> Green – H2S Service</li></ul></li><li>Designed to meet and exceed NACE MR-01-75 and API requirements</li><li>Material manufactured to ASTM and/or AISI standards</li><li>All unions provide pressure-tight &amp; positive sealing for low-pressure services (500 to 2,000 PSI)</li><li>Range from 1/2” to 12” with cold working pressures from 500 to 20,000 PSI</li><li>Fully interchangeable with most major brands of Hammer Unions</li><li>WOM manufactured rubber seals</li></ul>



<h3 class="womtitle wp-block-heading"><strong>Highlights of WOM Hammer Unions</strong></h3>



<ul class="wp-block-list"><li> Universally interchangeable</li><li>Slim and light weight</li><li>Aesthetically better than other manufacturers</li><li>Cost effective </li></ul>



<figure class="wp-block-gallery columns-3 is-cropped wp-block-gallery-1 is-layout-flex wp-block-gallery-is-layout-flex"><ul class="blocks-gallery-grid"><li class="blocks-gallery-item"><figure><img fetchpriority="high" decoding="async" width="280" height="182" data-src="/uploads/2019/10/HammerUnion32.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" data-id="9132" data-link="https://worldwideoilfieldmachinery.com/?attachment_id=9132" class="wp-image-9132 lazyload"/><noscript><img decoding="async" width="280" height="182" src="/uploads/2019/10/HammerUnion32.jpg" alt="" data-id="9132" data-link="https://worldwideoilfieldmachinery.com/?attachment_id=9132" class="wp-image-9132"></noscript></figure></li><li class="blocks-gallery-item"><figure><img decoding="async" width="280" height="182" data-src="/uploads/2019/10/HammerUnion31.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" data-id="9133" data-link="https://worldwideoilfieldmachinery.com/?attachment_id=9133" class="wp-image-9133 lazyload"/><noscript><img loading="lazy" decoding="async" width="280" height="182" src="/uploads/2019/10/HammerUnion31.jpg" alt="" data-id="9133" data-link="https://worldwideoilfieldmachinery.com/?attachment_id=9133" class="wp-image-9133"></noscript></figure></li><li class="blocks-gallery-item"><figure><img loading="lazy" decoding="async" width="280" height="182" data-src="/uploads/2019/10/HammerUnion22.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" data-id="9134" data-link="https://worldwideoilfieldmachinery.com/?attachment_id=9134" class="wp-image-9134 lazyload"/><noscript><img loading="lazy" decoding="async" width="280" height="182" src="/uploads/2019/10/HammerUnion22.jpg" alt="" data-id="9134" data-link="https://worldwideoilfieldmachinery.com/?attachment_id=9134" class="wp-image-9134"></noscript></figure></li><li class="blocks-gallery-item"><figure><img loading="lazy" decoding="async" width="280" height="182" data-src="/uploads/2019/10/HammerUnion21.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" data-id="9135" data-link="https://worldwideoilfieldmachinery.com/?attachment_id=9135" class="wp-image-9135 lazyload"/><noscript><img loading="lazy" decoding="async" width="280" height="182" src="/uploads/2019/10/HammerUnion21.jpg" alt="" data-id="9135" data-link="https://worldwideoilfieldmachinery.com/?attachment_id=9135" class="wp-image-9135"></noscript></figure></li><li class="blocks-gallery-item"><figure><img loading="lazy" decoding="async" width="280" height="182" data-src="/uploads/2019/10/HammerUnion12.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" data-id="9136" data-link="https://worldwideoilfieldmachinery.com/?attachment_id=9136" class="wp-image-9136 lazyload"/><noscript><img loading="lazy" decoding="async" width="280" height="182" src="/uploads/2019/10/HammerUnion12.jpg" alt="" data-id="9136" data-link="https://worldwideoilfieldmachinery.com/?attachment_id=9136" class="wp-image-9136"></noscript></figure></li><li class="blocks-gallery-item"><figure><img loading="lazy" decoding="async" width="280" height="182" data-src="/uploads/2019/10/HammerUnion11.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" data-id="9137" data-link="https://worldwideoilfieldmachinery.com/?attachment_id=9137" class="wp-image-9137 lazyload"/><noscript><img loading="lazy" decoding="async" width="280" height="182" src="/uploads/2019/10/HammerUnion11.jpg" alt="" data-id="9137" data-link="https://worldwideoilfieldmachinery.com/?attachment_id=9137" class="wp-image-9137"></noscript></figure></li></ul></figure>



<p class="wp-block-paragraph"></p>
', '2020-06-09T20:01:11', NULL, 'USD', true, '[{"id":284,"name":"Flow Control Products","slug":"flow-control-products"}]'::jsonb, '{"url":"/uploads/2019/10/HammerUnionFeatured.jpg","width":432,"height":371,"alt":"Hammer Unions"}'::jsonb, '{"title":"Hammer Unions, Hammer Unions Manufacturers - WOM Group","description":"WOM''s Deep Riser Systems have operated in real time well pressures of up to 9000 PSI and water depths exceeding 9000 feet.","ogImage":"/uploads/2019/10/HammerUnionFeatured.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (12391, 'Hose Loops', 'hose-loops', '', '
<p class="wp-block-paragraph">WOM Cementing and Circulating hose loops utilize the combination of WOM’s swivel joint flexibility and hose design for easy connection and storage for transportation.</p>



<p class="wp-block-paragraph">Hose Loops can be custom ordered in non-standard lengths with minimal lead time for custom requirements.</p>



<ul class="wp-block-list"><li>Extra High Pressure Cementing/Circulating Hose Loops, Figure 1502 &amp; 1002, in 2” and 3” sizes.</li><li>&nbsp;For test lines, fracturing, acidizing, cementing and well servicing up to 15,000-psi CWP.</li><li>&nbsp;Manufactured to the highest quality standards in the industry.</li><li>Optimal combination of core strength and case hardness without sacrificing ductility.</li></ul>



<p class="wp-block-paragraph"></p>
', '2020-06-07T14:57:45', NULL, 'USD', true, '[{"id":284,"name":"Flow Control Products","slug":"flow-control-products"}]'::jsonb, '{"url":"/uploads/2020/04/HoseLoop.jpg","width":432,"height":371,"alt":"Hose Loops"}'::jsonb, '{"title":"Hose Loops, Hose Loops Equipment - Worldwide Oilfield Machine","description":"WOM Cementing and Circulating hose loops utilize the combination of WOM’s swivel joint flexibility and hose design for easy connection and storage for transportation.","ogImage":"/uploads/2020/04/HoseLoop.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (830, 'Hydraulic Fail-Safe Actuator', 'hydraulic-fail-safe-actuator', '', '		<div data-elementor-type="wp-post" data-elementor-id="830" class="elementor elementor-830" data-elementor-post-type="product">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-4ecf5251 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="4ecf5251" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-3b500d16" data-id="3b500d16" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-3dccb0a1 elementor-widget elementor-widget-text-editor" data-id="3dccb0a1" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									
<p class="wp-block-paragraph">Designed for both surface and subsea applications in conjunction with <a href="https://worldwideoilfieldmachinery.com/product/magnum-gate-valve/">Magnum Gate Valves</a>, the Hydraulic Fail-Safe Actuator houses a quick disconnect mechanism which allows for fast removal of actuator from valve without disturbing the body/bonnet connection. Once removed, it provides easy access to valve stem packing. In addition, the actuator body totally contains the spring under compression, making field service safer and quicker. Liberal use of wear rings prevents metal-to-metal contact, reducing wear, scoring, and galling. Available for use on valve sizes from 1-13/16” through 9” with <a href="https://worldwideoilfieldmachinery.com/certificate/certification/?_sf_s=API">API</a> ratings of 2,000 to 20,000 psi and as Fail-Open or Fail-Close to match pressure control requirements and customer applications.</p>

<p class="wp-block-paragraph">The <a href="https://worldwideoilfieldmachinery.com/product/magnum-subsea-hydraulic-actuator/">Magnum Subsea Actuator</a> design has been tested to a water depth of 13,200 ft and meets all specifications for <a href="https://worldwideoilfieldmachinery.com/product/13-5-8-10k-subsea-wellhead/">subsea wellhead</a> and <a href="https://worldwideoilfieldmachinery.com/product/wellhead-christmas-tree-systems/">Christmas tree</a> applications. In additional testing, the actuator has been cycled 5,000 times at full working pressure, providing reliability and safety in the most demanding subsea operations.</p>

<h3 class="womtitle wp-block-heading">Specification and Features</h3>

<ul class="wp-block-list">
<li><strong>Easy to Operate. </strong>WOM’s quick disconnect mechanism allows for fast removal of the actuator without breaking the body/bonnet connection providing immediate access to the stem packing</li>
<li> <strong>Designed for Convenience. </strong>WOM’s Fail-Safe Hydraulic Actuator has a single-forged, unitized top cap and cylinder for simple in-line maintenance</li>
<li><strong>Industry Certified. </strong>WOM’s Fail-Safe Hydraulic Actuator is manufactured and tested to <a href="https://worldwideoilfieldmachinery.com/certificate/certification/?_sf_s=API%206A">API 6A</a>. Factory preset drift eliminates the need for field adjustments</li>
</ul>

<h3 class="womtitle wp-block-heading">Applications</h3>

<p class="wp-block-paragraph">WOM’s Fail-Safe Hydraulic Actuator is suited for <a href="https://worldwideoilfieldmachinery.com/product_category/surface/">surface</a> applications.</p>
								</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		', '2019-07-15T18:04:32', NULL, 'USD', true, '[{"id":126,"name":"Actuators","slug":"actuators"}]'::jsonb, '{"url":"/uploads/2019/07/Hydraulic-Fail-Safe-Actuator2.jpg","width":432,"height":371,"alt":"Hydraulic Fail-Safe Actuator"}'::jsonb, '{"title":"Hydraulic Fail-Safe Actuator - Worldwide Oilfield Machine","description":"Hydraulic Fail-Safe Actuator houses a quick disconnect mechanism which allows for fast removal of actuator from valve without disturbing the body/bonnet connection.","ogImage":"/uploads/2019/07/Hydraulic-Fail-Safe-Actuator2.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (13424, 'Integral Connections', 'integral-connections', '', '
<p class="wp-block-paragraph">WOM provides a full range product offering for Well Service Solutions including integral connections. Leveraging WOM’s worldwide quality manufacturing capacity and strategic stocking locations, WOM is ready to meet your demands.</p>



<div class="wp-block-image"><figure class="aligncenter size-large"><a href="/uploads/2020/06/Integral-ConnectionsWOM.jpg"><img fetchpriority="high" decoding="async" width="714" height="610" data-src="/uploads/2020/06/Integral-ConnectionsWOM.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-13425 lazyload"/><noscript><img decoding="async" width="714" height="610" src="/uploads/2020/06/Integral-ConnectionsWOM.jpg" alt="" class="wp-image-13425" srcset="/uploads/2020/06/Integral-ConnectionsWOM.jpg 714w, /uploads/2020/06/Integral-ConnectionsWOM-300x256.jpg 300w" sizes="(max-width: 714px) 100vw, 714px" /></noscript></a></figure></div>
', '2020-06-05T12:46:08', NULL, 'USD', true, '[{"id":284,"name":"Flow Control Products","slug":"flow-control-products"}]'::jsonb, '{"url":"/uploads/2020/06/Integral-Connections.jpg","width":432,"height":371,"alt":"Integral Connections"}'::jsonb, '{"title":"Integral Connections, Integral Connections Oilfield Equipment - WOM Group","description":"\"WOM Group provides Well Service Solutions including integral connections. All Integral Connections are subjected to controlled heat-treat processes to help integrity.\"","ogImage":"/uploads/2020/06/Integral-Connections.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1201, 'Jumpers', 'jumpers', '', '
<p class="wp-block-paragraph">Our API-certified subsea structures conforms to API guidelines and are thoroughly inspected by both first and third party inspectors before being delivered to the customer.  Rigid jumpers consist of a pipe structure with both ends welded with flow line connectors. Jumpers are typically used as an interface between subsea wells, manifolds, riser bases and flowlines while accommodating significant static and dynamic loads. Jumpers are designed with bends to allow for expansion and contraction of the flowline or pipeline due to changes in pressure and temperature. </p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<p class="wp-block-paragraph"><strong>Built to Client Specifications: </strong>WOM manufactures a variety of API-certified subsea structures that can be customized to customer requirement</p>



<p class="wp-block-paragraph"><strong>Quality Ensured: </strong>WOM’s API-certified subsea structures conforms to API guidelines and are thoroughly inspected by both first and third party inspectors before being delivered to the customer</p>



<p class="wp-block-paragraph"><strong>Industry Certified: </strong>WOM’s fully vertically integrated manufacturing process allows for complete supervision in every step of the process to produce API-certified subsea structures</p>



<ul class="wp-block-list"><li>Transport production&nbsp;fluid&nbsp;between two subsea components.</li><li>Connects subsea structures such as PLEM/PLETs and riser bases</li><li>Provides means to inject water in to the well</li></ul>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph"> Jumpers are custom-engineered to customer’s requirements. </p>



<div class="wp-block-columns has-3-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<figure class="wp-block-image"><img fetchpriority="high" decoding="async" width="350" height="183" data-src="/uploads/2019/10/Jumpers5.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-8931 lazyload"/><noscript><img decoding="async" width="350" height="183" src="/uploads/2019/10/Jumpers5.jpg" alt="" class="wp-image-8931" srcset="/uploads/2019/10/Jumpers5.jpg 350w, /uploads/2019/10/Jumpers5-300x157.jpg 300w" sizes="(max-width: 350px) 100vw, 350px" /></noscript><figcaption>Simple Jumper Lift Design</figcaption></figure>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<figure class="wp-block-image"><img decoding="async" width="350" height="183" data-src="/uploads/2019/10/Jumpers4.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-8932 lazyload"/><noscript><img loading="lazy" decoding="async" width="350" height="183" src="/uploads/2019/10/Jumpers4.jpg" alt="" class="wp-image-8932" srcset="/uploads/2019/10/Jumpers4.jpg 350w, /uploads/2019/10/Jumpers4-300x157.jpg 300w" sizes="(max-width: 350px) 100vw, 350px" /></noscript><figcaption>Inhouse Analysis</figcaption></figure>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<figure class="wp-block-image"><img loading="lazy" decoding="async" width="350" height="183" data-src="/uploads/2019/10/Jumper6.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-8933 lazyload"/><noscript><img loading="lazy" decoding="async" width="350" height="183" src="/uploads/2019/10/Jumper6.jpg" alt="" class="wp-image-8933" srcset="/uploads/2019/10/Jumper6.jpg 350w, /uploads/2019/10/Jumper6-300x157.jpg 300w" sizes="(max-width: 350px) 100vw, 350px" /></noscript><figcaption>Fabrication with Jig Structure</figcaption></figure>
</div>
</div>
', '2019-10-01T18:35:00', NULL, 'USD', true, '[{"id":269,"name":"Manifolds and Structures","slug":"subsea-manifolds-and-structures"}]'::jsonb, '{"url":"/uploads/2019/07/Jumpers.jpg","width":432,"height":371,"alt":"Jumpers"}'::jsonb, '{"title":"Jumpers, Jumpers Oilfield Equipment - Worldwide Oilfield Machine","description":"WOM Group manufactures Jumpers that are used as an interface between subsea wells, manifolds, riser bases, and flowlines while accommodating significant static and dynamic loads.","ogImage":"/uploads/2019/07/Jumpers.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1015, 'Line Pressure Operated SSV', 'magnum-line-pressure-operated-surface-safety-gate-valve', '', '
<p class="wp-block-paragraph">WOM’s Magnum Line Pressure Operated Surface Safety Gate Valve (LPOSSV) incorporates the dual seal system providing a thru-conduit, upstream and downstream metal-to-metal seal. The body cavity is exposed to line pressure only while the valve is being cycled, ensuring better lubricant retention, less exposure to line contaminants and longer service life with less maintenance.</p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li><strong>Intuitive Engineering</strong>: WOM’s LPOSSV uses line pressure as a control pressure to activate the actuator, resulting in a self-operating system. High and low pressure pilots monitor line pressure continuously</li><li><strong>Unmatched Precision: </strong>Gate and seat faces are hard faced and polished to 1-2 RMS allowing for a positive metal-to-metal seal</li><li><strong>Increased Service Life: </strong>The Magnum Gate Valve design incorporates many features to extend the service life of the valve such as a T-slot stem and gate connection, allowing the gate to float between seats without misalignment of the stem under pressure</li></ul>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">Installed on flow lines, header valves, gathering lines, pipelines and transmission lines, the LPOSSV is ideal for single point protection.</p>



<ul class="wp-block-list"><li>Colmonoy 4, 5 &amp; 75, tungsten carbide, stellite and other HF materials are available</li><li>Compatible with elastomer-assist metal-to-metal seals or non-elastomeric seals</li><li>Centralized stem threads and t-nut combined with t-slot gate reduce the overall torque needed to cycle the valve</li><li>API-approved for working pressures from 2,000 PSI to 20,000 PSI</li><li>Available in sizes ranging from 1 13/16-in. to 7 1/16-in.</li></ul>
', '2019-07-17T16:09:53', NULL, 'USD', true, '[{"id":131,"name":"Gate Valves","slug":"gate-valves"}]'::jsonb, '{"url":"/uploads/2019/07/Magnum-Line-Pressure-Operated-Surface-Safety-Gate-Valve2R1.jpg","width":432,"height":371,"alt":"Line Pressure Operated SSV"}'::jsonb, '{"title":"Line Pressure Operated SSV - Worldwide Oilfield Machine","description":"WOM’s Magnum Line Pressure Operated Surface Safety Gate Valve ,LPOSSV, incorporates the Dual Seal system providing a thru-conduit, upstream and downstream metal-to-metal seal.","ogImage":"/uploads/2019/07/Magnum-Line-Pressure-Operated-Surface-Safety-Gate-Valve2R1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (13485, 'Magnum Choke', 'magnum-choke', '', '
<p class="wp-block-paragraph">Our Magnum Chokes offer the customer increased service life and cost savings in high pressure applications, extreme service conditions where the substantial amount of abrasives and debris are present. I extreme services/operations the magnum choke’s robust design minimizes the operational downtime and equipment damages.</p>



<h2 class="womtitle wp-block-heading">Product Specification &amp; Features:</h2>



<ul class="wp-block-list"><li>The Magnum Choke body can accommodate 3-in., 2-in. or 1.5-in. orifice with respect to change in process parameters. All sizes of trims are interchangeable within the same choke body</li><li>Optional manipulator system allows the operator to slide and swing the bonnet assembly for quick tear down for trim changes</li><li>Designed to provide tight shut off</li><li>Pressure balanced trim considerably reduces the torque required to operate the choke</li><li>Large body cavity around trim components reduces the velocity of the solids in the fluids, thus enhances the body life.</li><li>Extended wear sleeve limits downstream erosion to the trim, protecting the body from damage</li><li>Gate is fully guided by the bonnet extension which can be rotated with respect to bonnet to shift the surface wear</li><li>Meets or exceeds the requirement specified by API6A and API 16C.</li></ul>



<h2 class="womtitle wp-block-heading">Applications:</h2>



<p class="wp-block-paragraph">Used for extreme applications like flow back, drilling, choke and kill, coil tubing, well control and snubbing.</p>



<div class="wp-block-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<div class="wp-block-image"><figure class="aligncenter size-large"><img fetchpriority="high" decoding="async" width="432" height="371" data-src="/uploads/2020/06/Magnum-Choke.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-13490 lazyload"/><noscript><img decoding="async" width="432" height="371" src="/uploads/2020/06/Magnum-Choke.jpg" alt="" class="wp-image-13490" srcset="/uploads/2020/06/Magnum-Choke.jpg 432w, /uploads/2020/06/Magnum-Choke-300x258.jpg 300w" sizes="(max-width: 432px) 100vw, 432px" /></noscript><figcaption>Hydraulic motor driven manual override</figcaption></figure></div>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<div class="wp-block-image"><figure class="aligncenter size-large"><img decoding="async" width="432" height="371" data-src="/uploads/2020/06/Magnum-Choke2.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-13491 lazyload"/><noscript><img loading="lazy" decoding="async" width="432" height="371" src="/uploads/2020/06/Magnum-Choke2.jpg" alt="" class="wp-image-13491" srcset="/uploads/2020/06/Magnum-Choke2.jpg 432w, /uploads/2020/06/Magnum-Choke2-300x258.jpg 300w" sizes="(max-width: 432px) 100vw, 432px" /></noscript><figcaption>Linear electric actuator driven (Servo)</figcaption></figure></div>
</div>
</div>



<h2 class="wp-block-heading">Additional Features:</h2>



<h4 class="wp-block-heading"><strong>Pressure Balancing Hole</strong></h4>



<p class="wp-block-paragraph">Pressure balance hole is provided in all WOM choke valves so as to equalise the pressure around the stem seal which reduces the stem load and in turn the torque required to operate the valve.</p>



<div class="wp-block-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow" style="flex-basis:33.33%">
<div class="wp-block-image"><figure class="aligncenter size-large"><img loading="lazy" decoding="async" width="201" height="208" data-src="/uploads/2020/06/Micrometer-Indicator.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-13493 lazyload"/><noscript><img loading="lazy" decoding="async" width="201" height="208" src="/uploads/2020/06/Micrometer-Indicator.jpg" alt="" class="wp-image-13493"></noscript></figure></div>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow" style="flex-basis:66.66%">
<h4 class="wp-block-heading"><strong>Micrometer Indicator</strong></h4>



<p class="wp-block-paragraph">Linear allowance in the Micrometer Indicator marking for easy calibration of the Indicator after assembly.<br>Large visual Dial Indicator for easy operation. <br>Stem travel, percentage open and bean size are shown on the Indicator Marking for easy and correct positioning of the valve.</p>
</div>
</div>



<div class="wp-block-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow" style="flex-basis:66.66%">
<h4 class="wp-block-heading"><br><strong>Thumb Screw</strong></h4>



<p class="wp-block-paragraph">Thumb Screw maintains set position of the stem by resisting rotation of the drive nut.</p>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow" style="flex-basis:33.33%">
<figure class="wp-block-image size-large is-resized"><img loading="lazy" decoding="async" data-src="/uploads/2020/06/Thumb-Screw.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-13494 lazyload" width="149" height="149"/><noscript><img loading="lazy" decoding="async" src="/uploads/2020/06/Thumb-Screw.jpg" alt="" class="wp-image-13494" width="149" height="149" srcset="/uploads/2020/06/Thumb-Screw.jpg 288w, /uploads/2020/06/Thumb-Screw-150x150.jpg 150w" sizes="(max-width: 149px) 100vw, 149px" /></noscript></figure>



<p class="wp-block-paragraph"></p>
</div>
</div>



<div class="wp-block-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow" style="flex-basis:33.33%">
<div class="wp-block-image"><figure class="aligncenter size-large"><img loading="lazy" decoding="async" width="248" height="219" data-src="/uploads/2020/06/LipSeal.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-13495 lazyload"/><noscript><img loading="lazy" decoding="async" width="248" height="219" src="/uploads/2020/06/LipSeal.jpg" alt="" class="wp-image-13495"></noscript></figure></div>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow" style="flex-basis:66.66%">
<h4 class="wp-block-heading"><br><strong>Stem Packing and LIP Seals</strong></h4>



<p class="wp-block-paragraph">Spring energized lip seals with scrapers used for dynamic seals enhance reliability of stem packing and pressure balance sealing.</p>
</div>
</div>
', '2020-06-09T22:38:17', NULL, 'USD', true, '[{"id":258,"name":"Chokes","slug":"chokes"}]'::jsonb, '{"url":"/uploads/2020/06/Magnum-Choke2.jpg","width":432,"height":371,"alt":"Magnum Choke"}'::jsonb, '{"title":"Magnum Choke, Magnum Choke Surface Equipment - WOM Group","description":"WOM''s Magnum chokes offer the customer increased service life and cost savings in high pressure applications, extreme service conditions where the substantial amount of abrasives and debris are present.","ogImage":"/uploads/2020/06/Magnum-Choke2.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (976, 'Magnum Gate Valve', 'magnum-gate-valve', '', '
<p class="wp-block-paragraph">Unique bi-directional sealing design provides a thru-conduit, upstream and downstream seal which creates a pressure-energized balance between the slab gate and seat assemblies when subjected to line pressure. </p>



<h3 class="womtitle wp-block-heading"> Specification and Features </h3>



<ul class="wp-block-list"><li><strong>Surpassing Industry Standards</strong>: T-slot stem and gate connection allows the gate to float between seats without misalignment of the stem under pressure; centralized stem threads and t-nut combined with t-slot gate reduce the overall torque needed to cycle the valve</li><li><strong>World-Class Precision: </strong>Gate and seat faces are hard faced and polished to 1-2 RMS allowing for a positive metal-to-metal seal</li><li><strong>Increased Service Life: </strong>The body cavity is exposed to line pressure only while the valve is being cycled, ensuring better lubricant retention, less exposure to line contaminants and longer service life with less maintenance</li><li>Available in sizes 1-13/16-in. to 9-in.</li><li>Working pressure ratings of 2,000 to 20,000 psi</li><li>Full bore, thru-conduit seal</li><li>Bi-directional sealing</li><li>Lower torque</li><li>Longer life of valve</li><li>Elastomer assist metal-to-metal seal or non-elastomeric seals</li><li>Differential avoids pressure lock</li><li>Extended service life with minimal maintenance requirements</li></ul>



<p class="wp-block-paragraph"></p>
', '2019-09-20T13:34:07', NULL, 'USD', true, '[{"id":131,"name":"Gate Valves","slug":"gate-valves"}]'::jsonb, '{"url":"/uploads/2019/07/WOM-MAgnumGateValve.jpg","width":432,"height":371,"alt":"Magnum Gate Valve"}'::jsonb, '{"title":"Magnum Gate Valve - Worldwide Oilfield Machine","description":"WOM Group Manufacturers unique bi-directional sealing design providing a thru-conduit, upstream and downstream seal which creates a pressure-energized balance between the slab gate and seat assemblies when subjected to line pressure.","ogImage":"/uploads/2019/07/WOM-MAgnumGateValve.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (12120, 'Magnum Gate Valve with Electric Gear Actuator', 'magnum-gate-valve-with-electric-gear-actuator', '', '
<p class="wp-block-paragraph"> Unique bi-directional sealing design provides a thru-conduit, upstream and downstream seal which creates a pressure-energized balance between the slab gate and seat assemblies when subjected to line pressure. </p>



<h3 class="womtitle wp-block-heading"> Specification and Features </h3>



<ul class="wp-block-list"><li><strong>Surpassing Industry Standards</strong>: T-slot stem and gate connection allows the gate to “float” between seats without misalignment of the stem under pressure. Centralized stem threads and t-nut combined with t-slot gate reduce the overall torque needed to cycle the valve.</li><li><strong>World-Class Precision: </strong>Gate and seat faces are hard faced and polished to 1-2 RMS allowing for a positive metal-to-metal seal</li><li><strong>Increased Service Life: </strong>The body cavity is exposed to line pressure only while the valve is being cycled, ensuring better lubricant retention, less exposure to line contaminants and longer service life with less maintenance</li><li>Available in sizes 1-13/16-in. to 9-in.</li><li>Working pressure ratings of 2,000 to 20,000 psi</li><li>Full bore, thru-conduit seal</li><li>Bi-directional sealing</li><li>Lower torque</li><li>Longer life of valve</li><li>Elastomer assist metal-to-metal seal or non-elastomeric seals</li><li>Differential avoids pressure lock</li><li>Extended service life with minimum maintenance requirements</li></ul>
', '2019-07-09T15:50:49', NULL, 'USD', true, '[{"id":131,"name":"Gate Valves","slug":"gate-valves"}]'::jsonb, '{"url":"/uploads/2020/03/GateValve-with-electric-gear-actuatorR1.jpg","width":700,"height":601,"alt":"Magnum Gate Valve with Electric Gear Actuator"}'::jsonb, '{"title":"Magnum Gate Valve with Electric Gear Actuator - WOM Group","description":"WOM leading oilfield company for Magnum Gate Valves with electric gear actuator equipment. Unique bi-directional sealing design provides a thru-conduit, upstream and downstream seal which creates a pressure-energized balance between the slab gate and seat assemblies when subjected to line pressure.","ogImage":"/uploads/2020/03/GateValve-with-electric-gear-actuatorR1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1000, 'Magnum Mud Gate Valve', 'magnum-mud-gate-valve', '', '
<p class="wp-block-paragraph">The Magnum Mud Gate Valve has a unique bi-directional sealing design which provides a thru-conduit, upstream and downstream seal which creates a pressure-energized balance between the slab gate and seat assemblies when subjected to line pressure.</p>



<ul class="wp-block-list"><li><strong>Dual Seal Technology: </strong>Magnum Mud Gate Valve has a unique bi-directional sealing design which provides a thru-conduit, upstream and downstream seal which creates a pressure-energized balance between the slab gate and seat assemblies when subjected to line pressure</li><li><strong>Engineered to Surpass</strong>: Magnum Mud Gate Valve’s  T-slot stem and gate connection allows the gate to float between seats without misalignment of the stem under pressure; centralized stem threads and t-nut combined with t-slot gate reduce the overall torque needed to cycle the valve</li><li><strong>Unmatched Precision: </strong>Magnum Mud Gate Valve is designed in a way that gate and seat faces are hard faced and polished to 1-2 RMS allowing for a positive metal-to-metal seal</li><li><strong>Increased Service Life: </strong>Body cavity is exposed to line pressure only while the valve is being cycled, ensuring better lubricant retention, less exposure to line contaminants and longer service life with less maintenance</li></ul>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li>Features WOM’s patented Dual Seal system</li><li>Through-Conduit Seal in full open and full closed positions</li><li>Through-Conduit seal eliminates the turbulence experienced in paddle gate mud valves</li><li>Skirt seat prevents contaminants from entering the valve body cavity</li><li>Can be easily serviced in-line and all internal components can be inspected and replaced</li></ul>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">WOM’s Mud Gate Valves are specifically designed for mud, cement, fracturing, and water service.</p>



<ul class="wp-block-list"><li>Available in sizes 1-13/16-in. to 5-in.</li><li>Available in working pressures from 3,000 PSI through 15,000 PSI</li><li>WOM Mud Valves can be supplied with flange, hammer union, hub, threaded, or butt weld ends</li><li>All WOM Mud Valves meet or exceed the requirements of API 6A</li></ul>
', '2019-09-18T15:21:58', NULL, 'USD', true, '[{"id":131,"name":"Gate Valves","slug":"gate-valves"}]'::jsonb, '{"url":"/uploads/2019/07/Magnum-Mud-Gate-ValveR1.jpg","width":432,"height":371,"alt":"Magnum Mud Gate Valve"}'::jsonb, '{"title":"Magnum Mud Gate Valve, Magnum Mud Gate Valve Manufacturers - WOM Group","description":"WOM''s Magnum Mud Gate Valve has a Unique bi-directional sealing design which provides a thru-conduit, upstream and downstream seal which creates a pressure-energized balance between the slab gate and seat assemblies when subjected to line pressure.","ogImage":"/uploads/2019/07/Magnum-Mud-Gate-ValveR1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1061, 'Magnum Pump Saver', 'magnum-pump-saver', '', '
<p class="wp-block-paragraph">When looking for new ways to protect expensive rig equipment, repeatability is the key. All rig systems use pop-off valves to protect the pump from over pressurization. When the conventional pop-off valve trips a rig pump, treating line, pressure vessel or any other high pressure high-flow environment, their spring relief valve design achieves approximately 10% repeatability. To compensate you have two options: reset the valve higher, risking pump damage or reset lower inviting frequent false over-pressure events each requiring a reset.</p>



<p class="wp-block-paragraph">With the Magnum Pump Saver, you can depend on a consistent +/- 5 percent repeatability up to 3,500 psi and a remarkably precise +/- 3 percent repeatability over 3,500 psi. This amazing accuracy is the result of an easy to install rupture disk design. With no springs or wearing parts the WOM Pump Saver is the last relief valve you will ever need.</p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li><strong>Consistent and Reliable: </strong>WOM’s Magnum Pump Saver uses easy-to-install rupture disks which require no special tols to remove and replace</li><li><strong>Highly Customizable: </strong>WOM’s Magnum Pump Saver is available in a wide choice of end connections and can be trimmed to handle H2S and salt water environments</li><li><strong>Unmatched Precision</strong>: WOM’s Magnum Pump Saver offers a consistent +/- 5 percent repeatability up to 3,500 PSI and a remarkably precise  +/- 3 percent repeatability over 3,500 PSI</li><li>Magnum Pump Saver is 4 times more accurate than standard industry pop/relief valves</li><li>Quick make-up cap assembly</li><li>Manufactured from quality high pressure forged materials</li></ul>
', '2019-07-18T03:18:22', NULL, 'USD', true, '[{"id":133,"name":"Pump Savers","slug":"pump-savers"}]'::jsonb, '{"url":"/uploads/2019/07/Pump-Saver.jpg","width":432,"height":371,"alt":"Magnum Pump Saver"}'::jsonb, '{"title":"Magnum Pump Saver, Magnum Pump Saver Oilfield Equipment - WOM","description":"\"WOM’s Magnum Pump Saver is 4 times more accurate than standard industry pop/relief valves. It is available in a wide choice of end connections and can be trimmed to handle H2S and salt water environments.\"","ogImage":"/uploads/2019/07/Pump-Saver.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (13995, 'Magnum SP™  Frac Valve', 'frac-valve', '', '		<div data-elementor-type="wp-post" data-elementor-id="13995" class="elementor elementor-13995" data-elementor-post-type="product">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-103f9aed elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="103f9aed" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-77449345" data-id="77449345" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-1f019a1c elementor-widget elementor-widget-text-editor" data-id="1f019a1c" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									<p></p>
<p class="wp-block-paragraph">Hydraulic fracturing and flowback operations require safe, reliable, smooth operation every time. Only WOM offers patented, maintenance-free gate valves that keep your operation running smoothly while using fewer resources, protecting personnel, and preserving the environment.</p>
<p></p>
<p></p>
<p class="wp-block-paragraph">Our decades of field-proven gate valve technology led us to build the ultimate frac valve—the Magnum SP. Engineered with industry and environmental needs in mind, this valve features advanced sealing technology in an optimized, modular design. This ground-breaking gate valve delivers reliable performance with unmatched advantages, including a reduced footprint and less weight. Together with our integrated manufacturing process, we are committed to delivering a quality valve that is built to last.</p>
<p></p>
<p></p>
<p class="wp-block-paragraph">Our Magnum SP frac valve delivers a high-value alternative to conventional valves. This technology eliminates labor, downtime, and the need for additional grease during fracing operations. Multiply performance, uptime, and profit all with a single valve at every stage of your project.</p>
<p></p>								</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		', '2019-09-23T15:25:21', NULL, 'USD', true, '[{"id":284,"name":"Flow Control Products","slug":"flow-control-products"},{"id":288},{"id":131,"name":"Gate Valves","slug":"gate-valves"}]'::jsonb, '{"url":"/uploads/2020/06/Frac-Valve.jpg","width":432,"height":371,"alt":"Magnum SP™  Frac Valve"}'::jsonb, '{"title":"Frac Valve, Frac Valve Oilfield Equipment - WOM Group","description":"WOM''s Frac Valve was engineered for easy operation with reduced torque even in high-differential pressure, and designed for high performance, increasing productivity, minimizing maintenance, downtime and operating costs in general.","ogImage":"/uploads/2020/06/Frac-Valve.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1196, 'Magnum Subsea Dual Block Gate Valve', 'magnum-subsea-dual-block', '', '
<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li>Dual Seal Technology: Unique bi-directional sealing design provides a thru-conduit, upstream and downstream seal which creates a pressure-energized balance between the slab gate and seat assemblies when subjected to line pressure</li><li> Surpassing Industry Standards: WOM’s Horizontal Subsea Trees feature horizontally-positioned primary valves allows for easy access for tubing retrieval and workover intervention operations, without requiring the tree to be removed</li><li> World-Class Precision: Gate and seat faces are hard faced and polished to 1-2 RMS allowing for a positive metal-to-metal seal</li><li> Increased Service Life: Body cavity is exposed to line pressure only while the valve is being cycled, ensuring better lubricant retention, less exposure to line contaminants and longer service life with less maintenance</li></ul>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph"> The Magnum Subsea Gate Valve is available in a Dual Block configuration in sizes up to 7 1/16″ and in working pressures up to 20,000 psi.</p>
', '2019-07-19T18:31:41', NULL, 'USD', true, '[{"id":301,"name":"Subsea Valves and Actuators","slug":"products-subsea-ps"}]'::jsonb, '{"url":"/uploads/2019/07/Magnum-Subsea-Dual-Block.jpg","width":432,"height":371,"alt":"Magnum Subsea Dual Block Gate Valve"}'::jsonb, '{"title":"Magnum Subsea Dual Block - Worldwide Oilfield Machine","description":"WOM''s Magnum Subsea Dual Block has a unique bi-directional sealing design providing a thru-conduit, upstream and downstream seal which creates a pressure-energized balance between the slab gate and seat assemblies when subjected to line pressure.","ogImage":"/uploads/2019/07/Magnum-Subsea-Dual-Block.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1188, 'Magnum Subsea Gate Valve', 'magnum-subsea-gate-valve', '', '
<p class="wp-block-paragraph">All Magnum Subsea Gate Valves are designed, manufactured, and tested to API 6A and 17G. Unique bi-directional sealing design provides a thru-conduit, upstream and downstream seal which creates a pressure-energized balance between the slab gate and seat assemblies when subjected to line pressure.</p>



<p class="wp-block-paragraph"></p>



<h3 class="womtitle wp-block-heading"> Specification and Features </h3>



<p class="wp-block-paragraph"><strong>Engineered to Surpass</strong>: T-slot stem and gate connection allows the gate to “float” between seats without misalignment of the stem under pressure. Centralized stem threads and t-nut combined with t-slot gate reduce the overall torque needed to cycle the valve</p>



<p class="wp-block-paragraph"><strong>Unmatched Precision:&nbsp;</strong>Gate and seat faces are hard faced and polished to 1-2 RMS allowing for a positive metal-to-metal seal</p>



<p class="wp-block-paragraph"><strong>Increased Service Life: </strong>Body cavity is exposed to line pressure only while the valve is being cycled, ensuring better lubricant retention, less exposure to line contaminants and longer service life with less maintenance</p>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">Magnum Subsea Gate Valves&nbsp;meet all specifications for subsea wellhead and Christmas Tree applications.</p>



<ul class="wp-block-list"><li>Available in sizes ranging from 2 1/16” through 7 3/8”</li><li>Available in working pressures up to 15,000 psi</li><li>Magnum Subsea Valve design tested to a water depth of 13,200 feet</li><li>Quick disconnect mechanism for the actuator allows fast removal without disturbing the body/bonnet connection; Provides easy access to stem packing</li><li>Pressure equalization system is available (0 psi differential pressure)</li></ul>
', '2019-07-19T18:00:32', NULL, 'USD', true, '[{"id":301,"name":"Subsea Valves and Actuators","slug":"products-subsea-ps"}]'::jsonb, '{"url":"/uploads/2019/07/SubSea-GateValve.jpg","width":600,"height":520,"alt":"Magnum Subsea Gate Valve"}'::jsonb, '{"title":"Magnum Subsea Gate Valve - Worldwide Oilfield Machine","description":"WOM''s all Magnum Subsea Gate Valves are designed, manufactured, and tested to API 6A and 17G.Unique bi-directional sealing design provides a thru-conduit, upstream and downstream seal which creates a pressure-energized balance between the slab gate and seat assemblies when subjected to line pressure.","ogImage":"/uploads/2019/07/SubSea-GateValve.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1177, 'Magnum Subsea Hydraulic Actuator', 'magnum-subsea-hydraulic-actuator', '', '
<p class="wp-block-paragraph">WOM’s Subsea Hydraulic Actuator features a single-acting actuator with a true fail-safe spring return. Available in both fail-open or fail-close configurations to match pressure control requirements and customer applications.</p>



<p class="wp-block-paragraph"> WOM’s Magnum Subsea Hydraulic Actuator has single-forged unitized top cap and cylinder for simple in-line maintenance. Quick disconnect mechanism allows for fast removal of actuator without breaking the body/bonnet connection, providing immediate access to the stem packing. </p>



<h3 class="womtitle wp-block-heading"> Specification and Features </h3>



<p class="wp-block-paragraph"><strong>“True” Fail-Safe: </strong>WOM’s Subsea Hydraulic Actuator features a single-acting actuator with a true fail-safe spring return. Available in both fail-open or fail-close configurations to match pressure control requirements and customer applications</p>



<p class="wp-block-paragraph"><strong>Hassle-free Maintenance:&nbsp;</strong> WOM’s Magnum Subsea Hydraulic Actuator has single-forged unitized top cap and cylinder for simple in-line maintenance. Quick disconnect mechanism allows for fast removal of actuator without breaking&nbsp;the body/bonnet connection, providing immediate access to the stem packing</p>



<p class="wp-block-paragraph"><strong>nmatched Reliability: </strong>WOM’s Magnum Subsea Hydraulic Actuator is capable of&nbsp;operating under&nbsp;harsh deepwater conditions&nbsp;for years without maintenance. Designed, built and test to API 6A &amp; 17D guidelines, the Magnum subsea actuator is one of the most reliable actuators in the industry</p>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">The Magnum Subsea Hydraulic Actuator&nbsp;design has been tested to a water depth of 13,200 and meets all specifications for subsea wellhead and Christmas tree applications.</p>



<ul class="wp-block-list"><li>API rated for pressures from 2,000 to 20,000 PSI</li><li>Compatible with valves sized from 1-13/16” through 7-3/8”</li><li>Pressure equalization system is available (0 PSI&nbsp;differential pressure)</li><li>Compatible with anti-explosive decompression seals and energized non-elastomeric lip seals</li><li>ROV override optional</li></ul>
', '2019-07-19T17:37:39', NULL, 'USD', true, '[{"id":301,"name":"Subsea Valves and Actuators","slug":"products-subsea-ps"}]'::jsonb, '{"url":"/uploads/2019/07/Magnum-Subsea-Hydraulic-Actuator.jpg","width":432,"height":371,"alt":"Magnum Subsea Hydraulic Actuator"}'::jsonb, '{"title":"Magnum Subsea Hydraulic Actuator - WOM Group","description":"WOM’s Magnum Subsea Hydraulic Actuator has single-forged unitized top cap and cylinder for simple in-line maintenance. WOM’s Subsea Hydraulic Actuator features a single-acting actuator with a true fail-safe spring return.","ogImage":"/uploads/2019/07/Magnum-Subsea-Hydraulic-Actuator.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (986, 'Model 200M Gate Valve', 'model-200m-gate-valve', '', '
<p class="wp-block-paragraph"> WOM’s Model 200M has a forged body and bonnet and incorporates WOM’s Dual-Seal assembly to ensure easy closing and a positive metal-to-metal seal without excessive force </p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li><strong>Dual Seal Technology: </strong>WOM’s Model 200M has a forged body and bonnet and incorporates WOM’s Dual-Seal assembly to ensure easy closing and a positive metal-to-metal seal without excessive force</li><li><strong>World-Class Flexibility:</strong> The Model 200 Gate Valve is available in the standard flanged, butt-weld and block body configurations and available with elastomeric and non-elastomeric seals</li><li><strong>Rugged Performance: </strong>The 200M Gate Valve has been API 6A fire tested to 450ºF and can be fitted for HPHT service</li></ul>



<h3 class="womtitle wp-block-heading"> Applications </h3>



<p class="wp-block-paragraph">The 200M Gate Valve model can be equipped with a pneumatic or hydraulic actuator and is ideally suited for manifold and Christmas tree applications.</p>



<ul class="wp-block-list"><li>Bi-directional design provides flow direction versatility and increased service life</li><li>Available in sizes ranging from 1 13/16-in. through 5 1/8-in.</li><li>Grease injection fittings located in both the bonnet and body</li><li>Bearing cap grease fittings allow positive bearing lubrication</li><li>Rated for working pressures ranging from 2,000 PSI to 15,000 PSI</li></ul>
', '2019-09-19T14:28:12', NULL, 'USD', true, '[{"id":131,"name":"Gate Valves","slug":"gate-valves"}]'::jsonb, '{"url":"/uploads/2019/09/Model200-Gate-ValveR2.jpg","width":432,"height":371,"alt":"Model 200M Gate Valve"}'::jsonb, '{"title":"Model 200M Gate Valve - Worldwide Oilfield Machine","description":"WOM''s model 200M Gate Valve model can be equipped with a pneumatic or hydraulic actuator and is ideally suited for manifold and Christmas tree applications.","ogImage":"/uploads/2019/09/Model200-Gate-ValveR2.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1022, 'Model 500 Gate Valve', 'model-500-gate-valve', '', '
<p class="wp-block-paragraph">The Model 500 Gate Valve provides the versatility and interchangeability necessary for a wide range of demanding flow control applications, including manifolds and christmas trees. Body and bonnet are constructed of forged steel for maximum reliability and safety. For severe applications, weld-clad corrosion-resistant alloy linings can be applied to base forgings for maximum protection for the valve’s internal service area. These valves are also available in forged stainless steel. </p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li>Available in sizes 1-13/16-in. to 7-1/16-in.</li><li>Working pressure ratings of 3,000 to 15,000 psi</li><li>Metal-to-metal and elastomeric sealing</li><li>Bi-directional, downstream sealing</li><li>Back-seating stem</li><li>Grease injection fitting</li><li>One-piece seat and gate deign</li><li>Wedge guide design</li><li>Lower torque</li><li>Spec – API-6A</li><li>NACE – MR-01-75</li><li>PSL – 3G</li><li>PR – 2</li><li>Material Class – AA to HH-NL</li><li>Temperature – L + X (-50º F to 350º F)</li></ul>



<p class="wp-block-paragraph"></p>



<h3 class="womtitle wp-block-heading">Applications</h3>



<ul class="wp-block-list"><li>The Model 500 Gate Valves prove versatility and interchangeability necessary for a wide range of demanding flow control applications, including manifolds and christmas trees. The body and the bonnet are constructed of forged steel for maximum reliability and safety</li><li>For severe applications, weld-clad corrosion-resistant alloy linings can be applied to base forgings for maximum protection for the valve’s internal service area</li></ul>
', '2019-07-17T16:18:40', NULL, 'USD', true, '[{"id":131,"name":"Gate Valves","slug":"gate-valves"}]'::jsonb, '{"url":"/uploads/2019/07/Model-500-Gate-ValveR1.jpg","width":432,"height":371,"alt":"Model 500 Gate Valve"}'::jsonb, '{"title":"Model 500 Gate Valve, Model 500 Gate Vales Manufacturers - WOM Group","description":"WOM''s Model 500 Gate Valves provide the versatility and interchangeability necessary for a wide range of demanding flow control applications, including Manifolds and Christmas Trees.","ogImage":"/uploads/2019/07/Model-500-Gate-ValveR1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (9887, 'Model 550 Gate Valve', 'model-550-gate-valve', '', '
<p class="wp-block-paragraph">The Model 550 Gate Valves provide the versatility and interchangeability necessary for a wide range of demanding flow control applications, including manifolds and christmas trees. Body and Bonnet are constructed of forged steel for maximum reliability and safety.<br>For severe applications, weld-clad corrosion-resistant alloy linings can be applied to base forgings for maximum protection for the valve’s internal service area.<br> Model 550 Gate Valves are also available in forged stainless steel.</p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<h4 class="wp-block-heading">Bi-Directional Sealing</h4>



<ul class="wp-block-list"><li>The Gate-and-Seat assembly seals in both directions by downsteam sealing. The Gate and Seat can be reversed for increased service life.</li></ul>



<h4 class="wp-block-heading">One-Piece Gate and Seat Design</h4>



<ul class="wp-block-list"><li>Bi-directional sealing, Seat to Body and Gate to Seat</li><li>Easy to replace</li></ul>



<h4 class="wp-block-heading">Metal-to-Metal Seal</h4>



<ul class="wp-block-list"><li> Sealing at gate-to-seat and seat-to-body is metal-to-metal</li><li> All WOM Gate valves feature a metal Bonnet seal</li></ul>



<h4 class="wp-block-heading">Lower Torque</h4>



<ul class="wp-block-list"><li> Superior finish on Gate and Seats</li><li>Balanced forces on Gate and Seats</li><li>Floating Gate with T-Slot</li></ul>



<h4 class="wp-block-heading">Back-Seating Stem</h4>



<ul class="wp-block-list"><li> Stem metal-to-metal backseat with bonnet to isolate stuffing box from line pressure, allows Stem packing to be replaced under cavity pressure</li></ul>



<h4 class="wp-block-heading">Grease Injection Fitting</h4>



<ul class="wp-block-list"><li>Grease injection fitting located in bonnet, eliminating body penetration</li><li>Bearing cap grease fitting allows positive bearing lubrication</li><li>Grease port can be used to test the back seat integrity.</li></ul>



<h4 class="wp-block-heading">Improved Seat Seal Design </h4>



<ul class="wp-block-list"><li>Two spring-loaded lip seals on each seat at the Seat-to-Body interface</li><li>Protects the metal seal surface of the seat, gate, and body from damage</li><li>Reliable performance at very low pressures</li><li>The double seal design provides maximum protection against intrusion of particle contaminants into the valve cavity</li><li>Prevents sand particles from affecting the metal to metal seals</li><li>Prevents erosion in drilling mud applications</li><li>One-piece seats and a solid slab gate offer reliable sealing plus ease of field service</li><li>No special tools are required to replace the gate and seat</li></ul>



<p class="wp-block-paragraph"></p>
', '2019-11-05T10:45:12', NULL, 'USD', true, '[{"id":131,"name":"Gate Valves","slug":"gate-valves"}]'::jsonb, '{"url":"/uploads/2019/11/Model550GV.jpg","width":432,"height":371,"alt":"Model 550 Gate Valve"}'::jsonb, '{"title":"Model 550 Gate Valve, Gate Valves Manufacturers - WOM Group","description":"WOM''s Model 550 Gate Valves provides the versatility and interchangeability necessary for a wide range of demanding flow control applications, including Manifolds and Christmas Trees.","ogImage":"/uploads/2019/11/Model550GV.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (994, 'Model 600 Mud Valve', 'model-600-mud-valve', '', '
<p class="wp-block-paragraph">WOM’s Model 600 Mud Valve features a seat assembly engineered with a lock shell design to ensure accurate seat alignment every time the valve is cycled. WOM’s Model 600 Mud Valve body cavity area is designed to allow continuous flushing by the fluid flow. This action prevents the valve from sanding up, even in standpipe installations.<br> WOM’s Model 600 Mud Valve is in-line field repairable and has several features which make maintaining the valve easy and efficient such as a rising stem design, a visual position indicator lens and replaceable stem packing. </p>



<h3 class="womtitle wp-block-heading">Specifications and Features</h3>



<p class="wp-block-paragraph">WOM’s Model 600 Mud Valves are offered with threaded, weld and flanged end connections. End connections vary by size and pressure rating depending on customer requirements.</p>



<ul class="wp-block-list"><li>Available in sizes ranging from 1 13/16-in. to 5 1/8-in.</li><li>Rated for working pressures ranging from 5,000 PSI through 7,500 PSI</li><li>Heavy duty roller bearings standard to reduce torque</li><li>AA trim standard</li><li>Conforms to API Class 7,000 requirements</li></ul>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">

WOM’s Model 600 Mud Valve is designed for rigorous heavy-duty service in abrasive conditions and specifically engineered for the tough requirements of oilfield services. Model 600 Mud Valves are commonly used for a number of oilfield applications such as high pressure mixing lines, standpipe manifolds, wellheads, production manifolds and production gathering systems.

</p>
', '2019-09-15T14:50:56', NULL, 'USD', true, '[{"id":131,"name":"Gate Valves","slug":"gate-valves"}]'::jsonb, '{"url":"/uploads/2019/07/Model-600-Mud-ValveR1.jpg","width":432,"height":371,"alt":"Model 600 Mud Valve"}'::jsonb, '{"title":"Model 600 Mud Valve, Mud Valves Manufacturers - WOM Group","description":"WOM’s Model 600 Mud Valve features a seat assembly engineered with a “lock shell” design to ensure accurate seat alignment every time the valve is cycled.","ogImage":"/uploads/2019/07/Model-600-Mud-ValveR1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1155, 'MTC Well Test Equipment', 'magnum-technology-center-well-test-equipment', '', '		<div data-elementor-type="wp-post" data-elementor-id="1155" class="elementor elementor-1155" data-elementor-post-type="product">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-3b78744c elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="3b78744c" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-3d03b4b3" data-id="3d03b4b3" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-608d9c92 elementor-widget elementor-widget-text-editor" data-id="608d9c92" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									<p></p>
<p class="wp-block-paragraph"><span style="font-size: 1rem;">Magnum Technology Center (MTC) designs and manufactures complete equipment packages for well testing &amp; production and managed pressure drilling services. </span>Visit their site for more details on <a href="http://www.mtc-intl.com/">MTC’s well test offerings</a><span style="font-size: 1rem;">.</span></p>
<p></p>
<p></p>
<h3 class="wp-block-heading">Specification and Features</h3>
<p></p>
<p></p>
<ul class="wp-block-list">
<li><strong>Versatile Engineering: </strong>Magnum Technology Center’s (MTC) Trailer-Mounted Test Package offers a completely configurable design on a compact and trailer system which contains both testing equipment and operating facilities</li>
<li><strong>Designed for Convenience: </strong>MTC offers an extensive catalog of onshore and offshore well test equipment that has been specifically designed to be as compact and easily deploy-able as possible</li>
<li><strong>Ultimate Reliability: </strong>As part of the WOM Group, MTC has full access to the resources and engineering capacity of WOM and makes liberal use of Magnum valves in all of its well test equipment</li>
</ul>
<p></p>
<p></p>
<h3 class="wp-block-heading">Applications</h3>
<p></p>
<p></p>
<p class="wp-block-paragraph">Used for well testing applications.</p>
<p></p>								</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		', '2019-07-18T12:57:00', NULL, 'USD', true, '[{"id":135,"name":"Well Test Equipment","slug":"well-test-equipment"}]'::jsonb, '{"url":"/uploads/2019/07/MTC-Well-TestR1.jpg","width":432,"height":371,"alt":"MTC Well Test Equipment"}'::jsonb, '{"title":"MTC Well Test Equipment - Worldwide Oilfield Machine","description":"WOM''s Magnum Technology Center’s (MTC) Trailer-Mounted Test Package offers a completely configurable design on a compact and trailer system which contains both testing equipment and operating facilities.","ogImage":"/uploads/2019/07/MTC-Well-TestR1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1207, 'Mud Mats', 'mud-mats', '', '
<p class="wp-block-paragraph"> Mud mats provide a foundation for subsea equipment. According to the soil’s untrained shear strength and the supported equipment’s loading conditions, a mud mat may vary in overall size and skirt depth to prove the bearing capacity, overturning and sliding &amp; torsion capability of subsea equipment. </p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<p class="wp-block-paragraph"><strong>Built to Client Specifications: </strong>WOM manufactures a variety of API-certified subsea structures that can be customized to customer requirement</p>



<p class="wp-block-paragraph"><strong>Quality Ensured: </strong>WOM’s API-certified subsea structures conforms to API guidelines and are thoroughly inspected by both first and third party inspectors before being delivered to the customer</p>



<p class="wp-block-paragraph"><strong>Industry Certified: </strong>WOM’s fully vertically integrated manufacturing process allows for complete supervision in every step of the process to produce API-certified subsea structures</p>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">

Mud mats are custom-engineered per customer’s requirements.

</p>
', '2019-10-03T18:38:17', NULL, 'USD', true, '[{"id":269,"name":"Manifolds and Structures","slug":"subsea-manifolds-and-structures"}]'::jsonb, '{"url":"/uploads/2019/07/Mud-Mat.jpg","width":432,"height":371,"alt":"Mud Mats"}'::jsonb, '{"title":"Mud Mats, Mud Mats Subsea Equipment - WOM Group","description":"Mud mats provide a foundation for subsea equipment. According to the soil’s untrained shear strength and the supported equipment’s loading conditions, a mud mat may vary in overall size and skirt depth to prove the bearing capacity, overturning and sliding & torsion capability of subsea equipment.","ogImage":"/uploads/2019/07/Mud-Mat.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (838, 'Patented Dual-Seal Ball Valves', 'patented-dual-seal-ball-valves', '', '
<p class="wp-block-paragraph">WOM’s Dual Seal Ball Valve is the only trunnion mounted ball valve with two independent seats on both sides of the ball. The Primary Seat take the normal wear and tear when the valve is cycled. If it ever gets damaged the Secondary Seat takes over. This redundant sealing technology can more than double the useful life of the valve. Additionally, even after the Primary Seat gets damaged, it will continue to work as a wiper ring. Each time the valve is cycled the Primary Seat will clean trash and line debris off of the ball before it can damage the Secondary Seat.</p>



<h3 class="womtitle wp-block-heading">Features</h3>



<ul class="wp-block-list"><li><strong>Triple Seal Capable: </strong>In applications where there is a single direction of flow, the downstream sealing assembly can be re-configured to provide a third independent seal</li><li><strong>Engineered for Safety: </strong><a href="https://worldwideoilfieldmachinery.com/patents/">Patented</a> split-block trunnion eases valve operation and acts like a retainer ring for a blow-out proof stem,&nbsp;installed from the valve’s interior to maximize safety. Integral stop ensures precise 90 degrees of rotation</li><li><strong>Industry Certified: </strong>600 Class to 1500 class ball valves tested and fire-safe per <a href="https://worldwideoilfieldmachinery.com/certificate/certification/">ISO, API 6FA or API 607 guidelines</a></li><li><strong>Eliminates Downtime: </strong>Secondary seat energizes automatically if the primary seal is damaged, maintaining 100% operational capacity while allowing for replacement valves to be readied to minimize downtime</li><li><strong>Effortless Operation: </strong>All WOM ball valves are Double Block and Bleed capable and the integrity of the seals can be checked while the valve is still in-line. In liquids service, valves self-relieve pressure from thermal expansion internally</li></ul>



<h3 class="womtitle wp-block-heading"> Applications </h3>



<p class="wp-block-paragraph">Designed to replace thru-conduit gate valves in mainline service. Ideal for <a href="https://worldwideoilfieldmachinery.com/product_category/manifolds/">manifolds</a>, tank farms, pig launchers, river crossings, hot-taps or any other application where a positive, bubble-tight seal is required. The Dual-Seal Ball Valve is capable of acting as an emergency shut-down valve when used with a fail-close actuator.</p>



<ul class="wp-block-list"><li>Available in sizes from 2” to 36″</li><li>Available in API 6D-rated pressure classes 150-1500, working pressures from 285 PSI to 3,705 PSI</li><li>Available in API 6A-rated working pressures from 2,000 PSI to 3,000 PSI, 2 1/16″ to 7 1/16″</li></ul>



<p class="wp-block-paragraph"></p>



<p class="wp-block-paragraph"></p>



<div class="wp-block-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<figure class="wp-block-image size-large"><a href="https://worldwideoilfieldmachinery.com/news_item/worlds-first-36-inch-dual-seal-ball-valve/"><img fetchpriority="high" decoding="async" width="490" height="342" data-src="/uploads/2020/11/BallValve36Inch.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-16328 lazyload"/><noscript><img decoding="async" width="490" height="342" src="/uploads/2020/11/BallValve36Inch.jpg" alt="" class="wp-image-16328" srcset="/uploads/2020/11/BallValve36Inch.jpg 490w, /uploads/2020/11/BallValve36Inch-300x209.jpg 300w" sizes="(max-width: 490px) 100vw, 490px" /></noscript></a></figure>



<p class="has-text-align-center has-small-font-size wp-block-paragraph"><a href="https://worldwideoilfieldmachinery.com/news_item/worlds-first-36-inch-dual-seal-ball-valve/">World’s First 36-Inch Dual Seal Ball Valve</a></p>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<figure class="wp-block-image size-large"><a href="https://worldwideoilfieldmachinery.com/webinar/dual-seal-ball-valve/"><img decoding="async" width="490" height="342" data-src="/uploads/2020/11/BallValveWebinar.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-16329 lazyload"/><noscript><img loading="lazy" decoding="async" width="490" height="342" src="/uploads/2020/11/BallValveWebinar.jpg" alt="" class="wp-image-16329" srcset="/uploads/2020/11/BallValveWebinar.jpg 490w, /uploads/2020/11/BallValveWebinar-300x209.jpg 300w" sizes="(max-width: 490px) 100vw, 490px" /></noscript></a></figure>



<p class="has-text-align-center has-small-font-size wp-block-paragraph"><a href="https://worldwideoilfieldmachinery.com/webinar/dual-seal-ball-valve/">Webinar on Dual-Seal Ball Valve</a></p>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<figure class="wp-block-image size-large"><a href="https://worldwideoilfieldmachinery.com/the-myth-of-the-better-mousetrap/"><img loading="lazy" decoding="async" width="490" height="342" data-src="/uploads/2020/11/BallValveMT.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-16330 lazyload"/><noscript><img loading="lazy" decoding="async" width="490" height="342" src="/uploads/2020/11/BallValveMT.jpg" alt="" class="wp-image-16330" srcset="/uploads/2020/11/BallValveMT.jpg 490w, /uploads/2020/11/BallValveMT-300x209.jpg 300w" sizes="(max-width: 490px) 100vw, 490px" /></noscript></a></figure>



<p class="has-text-align-center has-small-font-size wp-block-paragraph"><a href="https://worldwideoilfieldmachinery.com/the-myth-of-the-better-mousetrap/">The Myth of the Better Mousetrap</a></p>
</div>
</div>
', '2019-07-15T18:35:02', NULL, 'USD', true, '[{"id":127,"name":"Ball Valves","slug":"ball-valves"}]'::jsonb, '{"url":"/uploads/2019/07/Patented-Dual-Seal-Ball-Valves-pic1.jpg","width":432,"height":371,"alt":"Patented Dual-Seal Ball Valves"}'::jsonb, '{"title":"Patented Dual-Seal Ball Valves, Ball Valve Seals - WOM Group","description":"WOM’s Patented Dual Seal Ball Valve is the only trunnion mounted ball valve with two independent seats on both sides of the ball. The Primary Seat take the normal wear and tear when the valve is cycled. If it ever gets damaged the Secondary Seat takes over.","ogImage":"/uploads/2019/07/Patented-Dual-Seal-Ball-Valves-pic1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1220, 'PLEM/PLET', 'plem-plet', '', '
<p class="wp-block-paragraph">WOM’s Pipe Line End Manifolds (PLEM’s) and Pipe Line End Terminations (PLET’s) utilize Magnum Dual Block Valves (ROV Operated) and Magnum Subsea Gate Valves.  PLET’s come with standard interfaces such as swivel flange, gooseneck or straight header per client’s specification </p>



<h3 class="womtitle wp-block-heading">PLET</h3>



<p class="wp-block-paragraph">The Pipe Line End Termination (PLET) is a termination structure between
the main pipeline and a rigid spool jumper or / flexible hose. The PLET consist
of ROV operated Isolation WOM Single or Dual Gate Valves and hubs. It is
installed within the pipeline by horizontal or vertical direction due to the
first end or second installation. The standard interface such as swivel flange
and Gooseneck or straight header provided to meet client’s specification.</p>



<h3 class="womtitle wp-block-heading">PLEM</h3>



<p class="wp-block-paragraph">
















The Pipe Line End
Manifold (PLEM) is a subsea structure acts as a connection point between the
main or branch pipeline. The PLEM consist of WOM Dual Block Valves (ROV
Operated), Gate Valves, Tees and hubs. PLEM has facilities for Multiphase
Flowmeter, pig launching and/or receiving. The standard interface and
components such as hubs and flange outlets are provided for production and well
service line to meet client’s specific requirements. The PLEM vary in size and
complexity and can include a greater variety of features and facilities



</p>



<h3 class="womtitle wp-block-heading"> Specification and Features </h3>



<p class="wp-block-paragraph"><strong>Custom Engineering</strong>: PLEM’s have facilities for multiphase flowmeters and pig launching and/or receiving equipment. The standard interface and components such as hubs and flange outlets are provided for oil &amp; gas production and well service lines to meet client’s specific requirements. PLEM’s vary in size and complexity and can include a variety of features and facilities</p>



<p class="wp-block-paragraph"><strong>Flexible Design:&nbsp;</strong>PLET’s come with standard interfaces such as swivel flange, gooseneck or straight header per client’s specification</p>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph"> All PLEM’s and PLET’s are custom-manufactured to meet customer’s specific application. </p>



<h3 class="womtitle wp-block-heading">DOF Group-Galoc Project</h3>



<div class="wp-block-columns has-2-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<p class="wp-block-paragraph"><strong>WOM AP</strong> (formerly known as Magnum Subsea Systems) successfully completed and delivered subsea production equipment to DOF Group.&nbsp; The
equipment was custom-designed for the Galoc Phase II project taking place in the South China Sea, south of Manila in the Philippines at 290 meters (951ft) below sea.<br><br>The subsea equipment consists of a pipeline end termination (PLET), jumper spools with flow-line connectors,a gooseneck connector and a subsea riser base installed by&nbsp;the DOF construction vessel.&nbsp; The construction vessel completed the installation activities and connected two wells&nbsp;into the floating production, storage and offloading (FPSO) &nbsp;vessel, Rubicon Intrepid, in December 2013</p>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<figure class="wp-block-image is-resized"><img fetchpriority="high" decoding="async" data-src="/uploads/2019/10/DOFPlet.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-8946 lazyload" width="373" height="339"/><noscript><img decoding="async" src="/uploads/2019/10/DOFPlet.jpg" alt="" class="wp-image-8946" width="373" height="339" srcset="/uploads/2019/10/DOFPlet.jpg 449w, /uploads/2019/10/DOFPlet-300x273.jpg 300w" sizes="(max-width: 373px) 100vw, 373px" /></noscript></figure>
</div>
</div>
', '2019-10-04T18:59:49', NULL, 'USD', true, '[{"id":269,"name":"Manifolds and Structures","slug":"subsea-manifolds-and-structures"}]'::jsonb, '{"url":"/uploads/2019/07/Plem-plet.jpg","width":432,"height":371,"alt":"PLEM/PLET"}'::jsonb, '{"title":"Plem Plet, Plem Plet Oilfield Equipments - WOM Group","description":"WOM’s Pipe Line End Manifolds (PLEM’s) and Pipe Line End Terminations (PLET’s) utilize Magnum Dual Block Valves (ROV Operated) and Magnum Subsea Gate Valves.","ogImage":"/uploads/2019/07/Plem-plet.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8171, 'Plug and Cage Choke', 'plug-and-cage-choke', '', '
<p class="wp-block-paragraph">The WOM control chokes are available with a plug and cage or an external sleeve trim. These chokes are designed to provide accurate flow control throughout its operating range. The internal internally guided plug controls the opening and rate of flow. It is a robust design with its maximum flow capacity, making it ideal for oil production water injection and chemical injection services.</p>



<h3 class="womtitle wp-block-heading"> Product Specification and Features </h3>



<ul class="wp-block-list"><li>The WOM Plug and Cage style choke features a tungsten carbide cage as the throttling mechanism with a protective steel carrier around it</li><li>Outer Steel carrier is for protection against impacts from debris in the production fluid</li><li>The trim characteristics is equal percentage that provides superior flow control, however, WOM can provide the linear trim as well on demand</li><li>Pressure balanced trim considerably reduces the torque required to operate the choke</li><li>Plug is fully guided at the ID of sleeve and is rigidly attached to the stem to resist any induced vibration damage</li><li>Meet or exceed the minimum requirement specified by API 6A latest edition</li></ul>



<h3 class="womtitle wp-block-heading"> Applications </h3>



<p class="wp-block-paragraph">Plug and cage chokes are used for high capacity/medium pressure drop application, Used in christmas tree, process platforms, FPSOs.</p>
', '2020-06-12T21:49:27', NULL, 'USD', true, '[{"id":258,"name":"Chokes","slug":"chokes"}]'::jsonb, '{"url":"/uploads/2019/09/PlugandCageChoke.jpg","width":432,"height":371,"alt":"Plug and Cage Choke"}'::jsonb, '{"title":"Plug and Cage Choke, Plug and Cage Control Choke - WOM Group","description":"WOM''s control chokes are available with a plug & cage or an external sleeve trim. Plug and Cage chokes are designed to provide accurate flow control throughout its operating range.","ogImage":"/uploads/2019/09/PlugandCageChoke.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1008, 'Plug Valve', 'plug-valve', '', '
<p class="wp-block-paragraph">The Model 700 Plug Valve is a tapered seal, lubricated, quarter-turn plug valve for rapid operation in both onshore and offshore applications designed to control the movement of fluid through the flow line. It is engineered to provide low operating torque and is resistant to tough, abrasive, and corrosive conditions in drilling, production and pressure pumping applications.</p>



<p class="wp-block-paragraph"><strong>End Connection Options:</strong><br>WOM offers several end connection choices for the Model 700 that are field proven for reliability and performance. Connection types such as Hammer Unions, API Flanged, and Clamp Hub End are available. All sizes of WOM valves can be equipped with any choice of end connection or combination to suit specific applications, with working pressure ratings up to 15,000 psi.</p>



<h3 class="womtitle wp-block-heading">Key Design features:</h3>



<ul class="wp-block-list"><li>Bi-directional sealing</li><li>Low torque</li><li>Floating (T-slot) Plug</li><li>Soft Sealing</li></ul>



<h3 class="womtitle wp-block-heading">Advantages:</h3>



<ul class="wp-block-list"><li>Flow pressure helps in effective sealing</li><li>T-slot boosts consistent sure seal</li><li>Leak paths are reduced while adjusting nut is made blind</li><li>Quarter-turn valves</li></ul>



<h3 class="womtitle wp-block-heading">Technical Specifications:</h3>



<ul class="wp-block-list"><li>Sizes: 1-13/16” to 4-1/16”</li><li>Flanged / Hub / Hammer Union Ends</li><li>Working pressure rating: 2,000 to 15,000 psi</li><li>Temperature rating: -20° F to 350° F (P + X)</li><li>Performance requirement: PR-2</li><li>Complies to API Spec. 6A</li><li>Product Specification Level: PSL-1 thru’ PSL-3</li><li>Complies to NACE -MR01-75</li><li>Manual, Gear operated, and Hydraulic available.</li></ul>



<h3 class="womtitle wp-block-heading">Specification and Features </h3>



<ul class="wp-block-list"><li><strong>World-Class Flexibility: </strong>All sizes of WOM valves can be equipped with any choice of end connection or combination to suit specific applications, with working pressure ratings up to 15,000 psi.</li><li><strong>Highly Customizable: </strong>WOM offers several end connection choices for the Model 700 that are field proven for reliability and performance. Connection types such as Hammer Unions, API Flanged, and Clamp Hub End are available.</li></ul>
', '2020-06-14T12:35:45', NULL, 'USD', true, '[{"id":284,"name":"Flow Control Products","slug":"flow-control-products"},{"id":250,"name":"Plug Valve","slug":"plug-valve"}]'::jsonb, '{"url":"/uploads/2019/07/PlugValve.jpg","width":432,"height":371,"alt":"Plug Valve"}'::jsonb, '{"title":"Plug Valve, Plug Valve Surface Equipment - WOM Group","description":"WOM''s Plug Valve is a tapered seal, lubricated, quarter-turn plug valve for rapid operation in both onshore and offshore applications designed to control the movement of fluid through the flow line.","ogImage":"/uploads/2019/07/PlugValve.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (834, 'Pneumatic Fail-Safe Actuator', 'pneumatic-fail-safe-actuator', '', '
<p class="wp-block-paragraph">Pneumatic Fail-Safe Actuator is compatible with anti-explosive decompression seals and energized non-elastomeric lip seals WOM’s quick disconnect mechanism allows for fast removal of the actuator without breaking the body/bonnet connection providing immediate access to the stem packing. Redundant wear rings ensure that the WOM fail-safe pneumatic actuator will deliver the user a long operational&nbsp;life with minimal service &amp; repair.</p>



<h3 class="womtitle wp-block-heading"> Specification and Features </h3>



<ul class="wp-block-list"><li><strong>Easy to Operate:&nbsp;</strong>&nbsp;WOM’s quick disconnect mechanism allows for fast removal of the actuator without breaking&nbsp;the body/bonnet connection providing immediate access to the stem packing</li><li>&nbsp;<strong>Designed for Convenience</strong><strong>:&nbsp;</strong>WOM’s Fail-Safe Pneumatic Actuator&nbsp;has a single-forged, unitized top cap and cylinder for simple in-line maintenance</li><li><strong>Industry Certified:</strong>&nbsp;WOM’s Fail-Safe Pneumatic Actuator is&nbsp;manufactured and tested to API 6A. Factory preset drift eliminates the need for field adjustments</li></ul>



<h3 class="womtitle wp-block-heading"> Applications</h3>



<p class="wp-block-paragraph">WOM’s Fail-Safe Pneumatic Actuator is suited for surface applications.</p>



<ul class="wp-block-list"><li>Rated for 5,000 PSI and 10,000 PSI</li></ul>



<p class="wp-block-paragraph"> </p>
', '2019-07-15T18:19:12', NULL, 'USD', true, '[{"id":126,"name":"Actuators","slug":"actuators"}]'::jsonb, '{"url":"/uploads/2019/07/Pneumatic-Fail-Safe-Actuator-2.jpg","width":432,"height":371,"alt":"Pneumatic Fail-Safe Actuator"}'::jsonb, '{"title":"Pneumatic Fail-Safe Actuator - Worldwide Oilfield Machine","description":"Pneumatic Fail-Safe Actuator is compatible with anti-explosive decompression seals and energized non-elastomeric lip seals WOM’s quick disconnect mechanism allows for fast removal of the actuator without breaking the body/bonnet connection providing immediate access to the stem packing.","ogImage":"/uploads/2019/07/Pneumatic-Fail-Safe-Actuator-2.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8158, 'Positive Choke', 'positive-choke', '', '
<p class="wp-block-paragraph">The simplest configuration of the choke, which has a blanking plug assembly and flow bean in a standard choke body provides fixed flow conditions with respect to the various size of choke flow beans. Choke flow beans have tapered entrance to provide a smooth flow with minimized turbulence and beans retain their accuracy for a longer period of time. Sizes of choke flow beans of both integral and fractional 64th are available.</p>



<h3 class="womtitle wp-block-heading"> Product Specification &amp; Features </h3>



<ul class="wp-block-list"><li>Wing nut style bonnet enables quick tear down of bonnet assembly.</li><li>Interchangeable components which gives maximum flexibility of choice by utilizing one body and changing beans, seats and top-work (bonnet) assembly to convert positive chokes to adjustable chokes and vice versa.</li><li>Meet or exceed the minimum requirement specified by API 6A latest Edition</li></ul>



<h3 class="womtitle wp-block-heading"> Applications</h3>



<p class="wp-block-paragraph">Used in X-mas trees, production applications, choke and kill manifold, well testing and clean<br>up operations.</p>
', '2020-06-14T02:25:09', NULL, 'USD', true, '[{"id":258,"name":"Chokes","slug":"chokes"}]'::jsonb, '{"url":"/uploads/2019/09/Positive-Choke.jpg","width":432,"height":371,"alt":"Positive Choke"}'::jsonb, '{"title":"Positive Choke - Worldwide Oilfield Machine","description":"WOM designs, manufactures and supplies a wide range of low maintenance chokes with a choice of trims, temperature ratings and end connections to meet a variety of services. Positive Choke Equipments are manufactured to API 6A.","ogImage":"/uploads/2019/09/Positive-Choke.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (13456, 'Pressure Balanced Adjustable Chokes', 'pressure-balanced-adjustable-chokes', '', '
<h2 class="wp-block-heading">Model WPB-30 &amp; -40</h2>



<p class="wp-block-paragraph">These are the improved version of standard needle &amp; seat type chokes, where the operating torque is significantly reduced by balancing the pressure across the gate.</p>



<ul class="wp-block-list"><li>Lower torque eliminates the requirement of gear box thus considerably reducing the number of turns to operate the choke.</li><li>Elimination of gear box makes field maintenance easy. It also eliminates the possibility of over-torqueing the stem, thus prevents the possible damage to the trim components.</li><li>The indicator is designed to show the exact bean size in the window.</li><li>Available in high pressure with larger trims i.e. 2” and 3” orifice.</li></ul>
', '2020-06-13T01:55:23', NULL, 'USD', true, '[{"id":258,"name":"Chokes","slug":"chokes"}]'::jsonb, '{"url":"/uploads/2020/06/PressureBalancedChoke.jpg","width":432,"height":371,"alt":"Pressure Balanced Adjustable Chokes"}'::jsonb, '{"title":"Pressure Balanced Adjustable Chokes - Worldwide Oilfield Machine","description":"Pressure Balanced Adjustable Chokes are the advanced version of standard needle & seat type chokes, where the operating torque is significantly reduced by balancing the pressure across the gate.","ogImage":"/uploads/2020/06/PressureBalancedChoke.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (12381, 'Pups Joints', 'pups-joints', '', '
<p class="wp-block-paragraph">WOM brand Pup Joints are available in NPST and Integral Style for both standard and H2S services, NACE MR-01-75/ISO 15156.</p>



<ul class="wp-block-list"><li>Available in butt weld, integral, threaded (LPT &amp; NPST)</li><li>Forged from Alloy Steel one-piece construction</li><li>Sizes from 2” to 3”. Integral Pup Joint available in lengths up to 12 feet while threaded /butt weld is available up to 20 feet</li><li>Available in 6,000 to 20,000 PSI pressure rating</li><li>All products manufactured from forged steel which meets ASTM and/or AISI standards</li><li>Available in both standard and H2S service</li><li>Typical Applications Include:<ul><li>Well Testing</li></ul><ul><li>Fracturing</li><li>Cement Manifolds</li></ul></li></ul>
', '2020-06-08T14:31:56', NULL, 'USD', true, '[{"id":284,"name":"Flow Control Products","slug":"flow-control-products"}]'::jsonb, '{"url":"/uploads/2020/04/PupJointsFeatured.jpg","width":432,"height":371,"alt":"Pups Joints"}'::jsonb, '{"title":"Pups Joints - Worldwide Oilfield Machine","description":"WOM manufactured Pups Joints are available in NPST and Integral Style for both standard and H2S services, NACE MR-01-75/ISO 15156.","ogImage":"/uploads/2020/04/PupJointsFeatured.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (9081, 'Railways &#038; Metro', 'railways-metro', '', '		<div data-elementor-type="wp-post" data-elementor-id="9081" class="elementor elementor-9081" data-elementor-post-type="product">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-842031e elementor-section-height-min-height elementor-section-content-middle elementor-reverse-mobile elementor-section-boxed elementor-section-height-default elementor-section-items-middle" data-id="842031e" data-element_type="section" data-e-type="section" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
							<div class="elementor-background-overlay"></div>
							<div class="elementor-container elementor-column-gap-no">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-9f9b723" data-id="9f9b723" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-bf85634 elementor-widget elementor-widget-heading" data-id="bf85634" data-element_type="widget" data-e-type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
					<h1 class="elementor-heading-title elementor-size-default">Railways &amp; Metro</h1>				</div>
				</div>
				<div class="elementor-element elementor-element-fcd01fb elementor-widget elementor-widget-breadcrumbs" data-id="fcd01fb" data-element_type="widget" data-e-type="widget" data-widget_type="breadcrumbs.default">
				<div class="elementor-widget-container">
					<p id="breadcrumbs"><span><span><a href="https://worldwideoilfieldmachinery.com/">Home</a></span></span></p>				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-5b26645 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="5b26645" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-99a89c5" data-id="99a89c5" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-22067fc elementor-widget elementor-widget-heading" data-id="22067fc" data-element_type="widget" data-e-type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
					<h2 class="elementor-heading-title elementor-size-default">Railways &amp; Metro Products</h2>				</div>
				</div>
				<section class="elementor-section elementor-inner-section elementor-element elementor-element-456cd1f elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="456cd1f" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-50 elementor-inner-column elementor-element elementor-element-2b46a89" data-id="2b46a89" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-c23d1f5 elementor-cta--skin-cover elementor-animated-content elementor-bg-transform elementor-bg-transform-zoom-in elementor-widget elementor-widget-call-to-action" data-id="c23d1f5" data-element_type="widget" data-e-type="widget" data-widget_type="call-to-action.default">
				<div class="elementor-widget-container">
							<div class="elementor-cta">
					<div class="elementor-cta__bg-wrapper">
				<div class="elementor-cta__bg elementor-bg" style="background-image: url(/uploads/2019/10/AntiRollBar.jpg);" role="img" aria-label="Railways &amp; Metro"></div>
				<div class="elementor-cta__bg-overlay"></div>
			</div>
							<div class="elementor-cta__content">
				
									<h2 class="elementor-cta__title elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
						Anti-Roll Bar					</h2>
				
									<div class="elementor-cta__description elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
						<ul>
  <li>Supplied developmental order to Indian Railway (RC, Kapurthala) successfully last year</li>
  <li>Recently supplied to Modern coach factory, Raibareli</li> 
</ul>					</div>
				
									<div class="elementor-cta__button-wrapper elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
					<a class="elementor-cta__button elementor-button elementor-size-" href="#enq_form">
						Click Here					</a>
					</div>
							</div>
						</div>
						</div>
				</div>
				<div class="elementor-element elementor-element-081e17c elementor-widget elementor-widget-heading" data-id="081e17c" data-element_type="widget" data-e-type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
					<h2 class="elementor-heading-title elementor-size-default">Anti Roll Bar</h2>				</div>
				</div>
				<div class="elementor-element elementor-element-8ec7088 elementor-cta--skin-cover elementor-animated-content elementor-bg-transform elementor-bg-transform-zoom-in elementor-widget elementor-widget-call-to-action" data-id="8ec7088" data-element_type="widget" data-e-type="widget" data-widget_type="call-to-action.default">
				<div class="elementor-widget-container">
							<div class="elementor-cta">
					<div class="elementor-cta__bg-wrapper">
				<div class="elementor-cta__bg elementor-bg" style="background-image: url(/uploads/2019/10/CentrePivotPinAssembly.jpg);" role="img" aria-label="Railways &amp; Metro"></div>
				<div class="elementor-cta__bg-overlay"></div>
			</div>
							<div class="elementor-cta__content">
				
									<h2 class="elementor-cta__title elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
						Centre Pivot Pin Assembly					</h2>
				
									<div class="elementor-cta__description elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
						<ul>
  <li>Supplied to Indian Railways for Kolkata Metro under Import Substitution
</li>
  <li>Developed a Manufacturing Process, Jigs and Fixtures specially for critical welding of CCP</li> 
<li>
Setting up a highly engineered robotic welding facility specially for bulk production of Centre Pivot pin Assembly</li>
</ul>




					</div>
				
									<div class="elementor-cta__button-wrapper elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
					<a class="elementor-cta__button elementor-button elementor-size-" href="#enq_form">
						Click Here					</a>
					</div>
							</div>
						</div>
						</div>
				</div>
				<div class="elementor-element elementor-element-48784d9 elementor-widget elementor-widget-heading" data-id="48784d9" data-element_type="widget" data-e-type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
					<h2 class="elementor-heading-title elementor-size-default">Centre Pivot Pin Assembly</h2>				</div>
				</div>
				<div class="elementor-element elementor-element-5ff30d3 elementor-cta--skin-cover elementor-animated-content elementor-bg-transform elementor-bg-transform-zoom-in elementor-widget elementor-widget-call-to-action" data-id="5ff30d3" data-element_type="widget" data-e-type="widget" data-widget_type="call-to-action.default">
				<div class="elementor-widget-container">
							<div class="elementor-cta">
					<div class="elementor-cta__bg-wrapper">
				<div class="elementor-cta__bg elementor-bg" style="background-image: url(/uploads/2019/10/TorsionBarAssemblies.jpg);" role="img" aria-label="Railways &amp; Metro"></div>
				<div class="elementor-cta__bg-overlay"></div>
			</div>
							<div class="elementor-cta__content">
				
									<h2 class="elementor-cta__title elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
						Torsion Bar Assemblies					</h2>
				
									<div class="elementor-cta__description elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
						<ul>
  <li>Supplying one of the longest and critical Torsion Bar Assemblies to UK Railways
</li>
  <li>Developed a vertical Heat Treatment facility for such long bars, maximum up to 03 meters</li> 
<li>
The assembly of this component is done using critical hot shrink fitting assembly</li>
</ul>




					</div>
				
									<div class="elementor-cta__button-wrapper elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
					<a class="elementor-cta__button elementor-button elementor-size-" href="#enq_form">
						Click Here					</a>
					</div>
							</div>
						</div>
						</div>
				</div>
				<div class="elementor-element elementor-element-b362cf4 elementor-widget elementor-widget-heading" data-id="b362cf4" data-element_type="widget" data-e-type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
					<h2 class="elementor-heading-title elementor-size-default">Torsion Bar Assemblies</h2>				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-50 elementor-inner-column elementor-element elementor-element-5173c57" data-id="5173c57" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-54697d6 elementor-cta--skin-cover elementor-animated-content elementor-bg-transform elementor-bg-transform-zoom-in elementor-widget elementor-widget-call-to-action" data-id="54697d6" data-element_type="widget" data-e-type="widget" data-widget_type="call-to-action.default">
				<div class="elementor-widget-container">
							<div class="elementor-cta">
					<div class="elementor-cta__bg-wrapper">
				<div class="elementor-cta__bg elementor-bg" style="background-image: url(/uploads/2019/10/Anti-RollBarFork.jpg);" role="img" aria-label="Railways &amp; Metro"></div>
				<div class="elementor-cta__bg-overlay"></div>
			</div>
							<div class="elementor-cta__content">
				
									<h2 class="elementor-cta__title elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
						Anti-Roll Bar Fork					</h2>
				
									<div class="elementor-cta__description elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
						<ul>
  <li>Closed Die Forged Product</li>
  <li>Supplied developmental order to Indian Railways (RCF, Kapurthala) successfully</li> 
</ul>



					</div>
				
									<div class="elementor-cta__button-wrapper elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
					<a class="elementor-cta__button elementor-button elementor-size-" href="#enq_form">
						Click Here					</a>
					</div>
							</div>
						</div>
						</div>
				</div>
				<div class="elementor-element elementor-element-e95741d elementor-widget elementor-widget-heading" data-id="e95741d" data-element_type="widget" data-e-type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
					<h2 class="elementor-heading-title elementor-size-default">Anti Roll Bar Fork</h2>				</div>
				</div>
				<div class="elementor-element elementor-element-0323737 elementor-cta--skin-cover elementor-animated-content elementor-bg-transform elementor-bg-transform-zoom-in elementor-widget elementor-widget-call-to-action" data-id="0323737" data-element_type="widget" data-e-type="widget" data-widget_type="call-to-action.default">
				<div class="elementor-widget-container">
							<div class="elementor-cta">
					<div class="elementor-cta__bg-wrapper">
				<div class="elementor-cta__bg elementor-bg" style="background-image: url(/uploads/2019/10/TractionCenter.jpg);" role="img" aria-label="Railways &amp; Metro"></div>
				<div class="elementor-cta__bg-overlay"></div>
			</div>
							<div class="elementor-cta__content">
				
									<h2 class="elementor-cta__title elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
						Traction Centre					</h2>
				
									<div class="elementor-cta__description elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
						<ul>
  <li>Traction Centre is a component manufactured by Single-piece Closed Die Forging</li>
  <li>
Developed a manufacturing process for mass production of this component</li> 
</ul>

					</div>
				
									<div class="elementor-cta__button-wrapper elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
					<a class="elementor-cta__button elementor-button elementor-size-" href="#enq_form">
						Click Here					</a>
					</div>
							</div>
						</div>
						</div>
				</div>
				<div class="elementor-element elementor-element-c6a4e45 elementor-widget elementor-widget-heading" data-id="c6a4e45" data-element_type="widget" data-e-type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
					<h2 class="elementor-heading-title elementor-size-default">Traction Centre</h2>				</div>
				</div>
				<div class="elementor-element elementor-element-5e36e49 elementor-cta--skin-cover elementor-animated-content elementor-bg-transform elementor-bg-transform-zoom-in elementor-widget elementor-widget-call-to-action" data-id="5e36e49" data-element_type="widget" data-e-type="widget" data-widget_type="call-to-action.default">
				<div class="elementor-widget-container">
							<div class="elementor-cta">
					<div class="elementor-cta__bg-wrapper">
				<div class="elementor-cta__bg elementor-bg" style="background-image: url(/uploads/2019/10/LowerSpringSeat.jpg);" role="img" aria-label="Railways &amp; Metro"></div>
				<div class="elementor-cta__bg-overlay"></div>
			</div>
							<div class="elementor-cta__content">
				
									<h2 class="elementor-cta__title elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
						Traction Centre					</h2>
				
									<div class="elementor-cta__description elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
						<ul>
  <li>Lower Spring Seat as Forged and coated with Red Oxide Primer</li>
  <li>
Supplied to Indian Railways (ICF, Chennai) successfully</li> 
</ul>

					</div>
				
									<div class="elementor-cta__button-wrapper elementor-cta__content-item elementor-content-item elementor-animated-item--enter-from-top">
					<a class="elementor-cta__button elementor-button elementor-size-" href="#enq_form">
						Click Here					</a>
					</div>
							</div>
						</div>
						</div>
				</div>
				<div class="elementor-element elementor-element-cef9e3e elementor-widget elementor-widget-heading" data-id="cef9e3e" data-element_type="widget" data-e-type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
					<h2 class="elementor-heading-title elementor-size-default">Lower Spring Seat</h2>				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<div class="elementor-element elementor-element-a50c946 elementor-widget elementor-widget-menu-anchor" data-id="a50c946" data-element_type="widget" data-e-type="widget" data-widget_type="menu-anchor.default">
				<div class="elementor-widget-container">
							<div class="elementor-menu-anchor" id="enq_form"></div>
						</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		', '2019-10-12T18:55:56', NULL, 'USD', true, '[{"id":271,"name":"Railways & Metro","slug":"railways-metro"}]'::jsonb, '{"url":"/uploads/2019/10/Railways.jpg","width":510,"height":340,"alt":"Railways &#038; Metro"}'::jsonb, '{"title":"Railways & Metro - Worldwide Oilfield Machine","description":"Some of our products include Anti Roll Bar, Anti Roll Bar Fork, Centre Pivot Pin Assembly, Traction Centre, Torsion Bar Assemblies and Lower Spring Seat.","ogImage":"/uploads/2019/10/Railways.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (14007, 'Reliable Actuator System', 'wom-ras', '', '
<p class="wp-block-paragraph">Due to its proven reliability, the WOM RAS (Reliable Actuator System) sets the standard for the Oil &amp; Gas industry by offering the hydraulic version. Complete one stop solutions that reflect a deep appreciation of Oil &amp; Gas customer needs &amp; industry standards.<br>WOM RAS is a cost-effective modular design that allows a high degree of customization while delivering performance on all fronts.</p>



<h3 class="womtitle wp-block-heading">Familiarity with Oil and Gas Standards</h3>



<p class="wp-block-paragraph">WOM RAS is part of the <a href="https://worldwideoilfieldmachinery.com/product_category/product/">WOM Product</a> portfolio. Central to our success is a deep understanding of the industry requirements and our engineering expertise gained<br>throughout all these years.<br>Unlike conventional, heavy and bulky Scotch &amp; Yoke Actuators, WOM provides RAS Actuator, an alternative double acting hydraulic actuator having a cutting edge over industry competitors.</p>



<h3 class="womtitle wp-block-heading">Key Benefits</h3>



<ul class="wp-block-list"><li>Superlative <a href="https://worldwideoilfieldmachinery.com/certificate/certification/">quality</a> and performance</li><li>Operating time is low</li><li>Meets all Oil and Gas industry regulations</li><li>Industry’s most compact actuator design for quarter turn <a href="https://worldwideoilfieldmachinery.com/product_category/gate-valves/">valves</a> like b<a href="https://worldwideoilfieldmachinery.com/product_category/ball-valves/">all</a>, <a href="https://worldwideoilfieldmachinery.com/product/plug-valve/">plug</a>, butterfly, etc.</li><li>Fully adaptable to your needs</li><li>Minimal maintenance and running cost</li></ul>



<p class="wp-block-paragraph">WOM developed RAS actuators has following added advantages when compared to industry available actuators:</p>



<ol class="wp-block-list"><li>Lowest weight</li><li>Centre of gravity is almost at the center</li><li>Compact end-to-end dimensions</li><li>Wide range of torque</li></ol>



<p class="wp-block-paragraph">WOM RAS Actuator minimizes environmental impact in several ways:<br>• Offers very low energy consumption compared to pneumatic systems<br>• Designed for low energy consumption and require minimum of oil<br>• Can be disassembled into small pieces and recycled.<br>• If the oil is kept clean and particle free, only the sealing needs to be changed occasionally, extending life</p>
', '2019-06-01T16:23:43', NULL, 'USD', true, '[{"id":126,"name":"Actuators","slug":"actuators"},{"id":127,"name":"Ball Valves","slug":"ball-valves"},{"id":284,"name":"Flow Control Products","slug":"flow-control-products"}]'::jsonb, '{"url":"/uploads/2020/06/WOM-RAS.jpg","width":432,"height":371,"alt":"Reliable Actuator System"}'::jsonb, '{"title":"WOM Reliable Actuator System (RAS) - Worldwide Oilfield Machine","description":"WOM''s RAS (Reliable Actuator System) sets the standard for the Oil & Gas industry by offering the hydraulic version. WOM RAS is a cost-effective modular design that allows a high degree of customization while delivering performance on all fronts.","ogImage":"/uploads/2020/06/WOM-RAS.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (7895, 'Replaceable Seat Seal Assembly', 'replaceable-seat-seal-assembly', '', '		<div data-elementor-type="wp-post" data-elementor-id="7895" class="elementor elementor-7895" data-elementor-post-type="product">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-7b6f270f elementor-section-content-top elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="7b6f270f" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-no">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-2a4e6ddc" data-id="2a4e6ddc" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-63fc8848 elementor-widget elementor-widget-text-editor" data-id="63fc8848" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									<p></p>
<p class="wp-block-paragraph"><span style="font-size: 16px;">WOM&#8217;s replaceable seat inserts reduce downtime by eliminating the need to send your BOP to repair facilities for service.&nbsp;</span><span style="font-size: 16px;">The modular design allows for quick changeout of the BOP sealing area onsite.&nbsp;</span></p><p><strong style="font-size: 16px;">WOM’S INNOVATIVE SOLUTION FOR DRILLING INDUSTRY</strong><br></p>
<p></p>
<p></p>
<ul class="wp-block-list">
<li>Based on repair and remanufacturing historical and operational data, Ram Preventer Body has long lead.</li>
<li> Cavity-Wellbore fabrication, remanufacturing, material handling and transportation.</li>
<li> Delayed process time by 4 to 5 weeks, BOP to deliver for onboard operation.</li>
</ul>
<p></p>
<p></p>
<h3 class="wp-block-heading">Specification and Features</h3>
<p></p>
<p></p>
<ul><li>Pressure sealing on all type of rams</li>
<li>Low pressure, high pressure capabilities&nbsp;</li>
<li>Bore sealing aids back pressure when rams are closed</li>
<li>Cavity carrier sealing is achieved for pressure below the rams</li>
<li>Anti-vibration cup point grubbing set screws avoid loosening of seat insert carrier</li>
<li>Ease of on-board installation</li>
</ul>
<p class="wp-block-paragraph"></p>
<p></p>
<h3 class="wp-block-heading">Applications</h3>
<p></p>
<p></p>
<p class="wp-block-paragraph">Used in ram BOP bodies.</p>
<p></p>								</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		', '2019-09-24T15:19:47', NULL, 'USD', true, '[{"id":128,"name":"BOPs","slug":"bops"}]'::jsonb, '{"url":"/uploads/2019/09/Replaceable-Seat-Seal-Assembly.jpg","width":432,"height":371,"alt":"Replaceable Seat Seal Assembly"}'::jsonb, '{"title":"Replaceable Seat Seal Assembly - Worldwide Oilfield Machine","description":"Replaceable Seat Seal Assembly, the next generation of Ram Blowout Preventer Body, the model type WU, successfully substitutes an extensive and prolonged process of Machining, Welding, Pre & Post-Heat Treatment, reducing re-manufacturing lead time.","ogImage":"/uploads/2019/09/Replaceable-Seat-Seal-Assembly.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1213, 'Riser Base', 'riser-base', '', '
<p class="wp-block-paragraph">Riser bases are subsea support structures used to tie-in a pipeline at one end and provide vertical flange connection to facilities to connect riser jumper at the other.  A Riser base typically consists of ROV-Operated isolation WOM Magnum Gate Valves and hubs. Due to the large tension load of the riser jumper, the riser base can be separated as a mud-mat and a piping skid which are terminated at the riser jumper and can be installed to some inclined direction to facilitate the riser’s required entry angle. </p>



<h3 class="womtitle wp-block-heading"> Specification and Features </h3>



<p class="wp-block-paragraph"><strong>Built to Client Specifications: </strong>WOM manufactures a variety of API-certified subsea structures that can be customized to customer requirement</p>



<p class="wp-block-paragraph"><strong>Quality Ensured: </strong>WOM’s API-certified subsea structures conforms to API guidelines and are thoroughly inspected by both first and third party inspectors before being delivered to the customer</p>



<p class="wp-block-paragraph"><strong>Industry Certified: </strong>WOM’s fully vertically integrated manufacturing process allows for complete supervision in every step of the process to produce API-certified subsea structures</p>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph"> Riser Bases are custom-engineered per the customer’s requirements. </p>
', '2019-10-02T18:41:47', NULL, 'USD', true, '[{"id":269,"name":"Manifolds and Structures","slug":"subsea-manifolds-and-structures"}]'::jsonb, '{"url":"/uploads/2019/07/Riser-Base.jpg","width":432,"height":371,"alt":"Riser Base"}'::jsonb, '{"title":"Riser Base, Riser Base Oilfield Equipment - WOM Group","description":"WOM''s Riser Bases are subsea support structures used to tie-in a pipeline at one end and provide vertical flange connection to facilities to connect riser jumper at the other.","ogImage":"/uploads/2019/07/Riser-Base.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (933, 'Snubbing BOP', 'woms-snubbing-bop', '', '
<p class="wp-block-paragraph">WOM’s Snubbing BOP is pressure energized and features hydraulically operated locking mechanisms to hold the rams closed without actuation pressure. The Snubbing BOP operating system is designed to provide a fast and reliable seal around pipe or casing in the wellbore, maintained even with loss of closing pressure.  Ram packing materials are generous and self-feeding, in addition to being quick and easy to replace. Hydraulically opening bonnets allow for easy access to replace rams or change rams with several other compatible ram configurations. All operating parts can be replaced on site. </p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li><strong style="font-size: 1rem;">Easy to Operate:&nbsp;</strong><span style="font-size: 1rem;">&nbsp;Pressure energized and features hydraulically operated locking mechanisms to hold the rams closed without actuation pressure.</span></li><li><strong>Fast and Reliable Seal</strong>: Operating system is designed to provide a fast and reliable seal around pipe or casing in the wellbore, maintained even with loss of closing pressure.</li><li><strong>Designed for Convenience:&nbsp;</strong>Ram packing materials are generous and self-feeding, in addition to being quick and easy to replace.</li><li><strong>Optimized Maintenance:&nbsp;</strong>Hydraulically opening bonnets allow for easy access to replace rams or change rams with several other compatible ram configurations. All operating parts in the BOP can be replaced on site.</li></ul>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">WOM’s Snubbing BOPs are suited for all standard wireline applications wireline operations for running and retrieving tools in a well under pressure. The rams and ram packers are specially fitted with nylon inserts attached to the ram packer elastomer.</p>



<ul class="wp-block-list"><li>Capable of handling wireline roughly 1/16″ in thickness and 3/16″ in width</li></ul>
', '2019-07-17T09:39:04', NULL, 'USD', true, '[{"id":128,"name":"BOPs","slug":"bops"}]'::jsonb, '{"url":"/uploads/2019/07/Snubbing-BOP-pic1.jpg","width":432,"height":371,"alt":"Snubbing BOP"}'::jsonb, '{"title":"Snubbing BOP, Snubbing Bop Stack - Worldwide Oilfield Machine","description":"WOM’s Snubbing BOP is pressure energized and features hydraulically operated locking mechanisms to hold the rams closed without actuation pressure.","ogImage":"/uploads/2019/07/Snubbing-BOP-pic1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (15946, 'Spacer Spools', 'spacer-spool', '', '
<p class="wp-block-paragraph">Spacer spools are designed and manufactured in accordance with API Spec 16A &amp; 6A, conforming to NACE MR 0175.</p>



<p class="wp-block-paragraph">Spacer Spools are Pressure-Containing equipment with end connections, stack in between drill through equipment.</p>



<p class="wp-block-paragraph">Spacer Spool are used to provide separation between two components with equal-sized end connections.</p>



<figure class="wp-block-gallery has-nested-images columns-default is-cropped wp-block-gallery-1 is-layout-flex wp-block-gallery-is-layout-flex">
<figure class="wp-block-image size-large"><a href="/uploads/2020/10/SpacerSpool1.jpg"><img fetchpriority="high" decoding="async" width="800" height="466" data-src="/uploads/2020/10/SpacerSpool1.jpg" data-id="15951" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-15951 lazyload"/><noscript><img decoding="async" width="800" height="466" data-id="15951" src="/uploads/2020/10/SpacerSpool1.jpg" alt="" class="wp-image-15951" srcset="/uploads/2020/10/SpacerSpool1.jpg 800w, /uploads/2020/10/SpacerSpool1-300x175.jpg 300w, /uploads/2020/10/SpacerSpool1-768x447.jpg 768w" sizes="(max-width: 800px) 100vw, 800px" /></noscript></a></figure>



<figure class="wp-block-image size-large"><a href="/uploads/2020/10/SpacerSpool2.jpg"><img decoding="async" width="800" height="353" data-src="/uploads/2020/10/SpacerSpool2.jpg" data-id="15950" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-15950 lazyload"/><noscript><img loading="lazy" decoding="async" width="800" height="353" data-id="15950" src="/uploads/2020/10/SpacerSpool2.jpg" alt="" class="wp-image-15950" srcset="/uploads/2020/10/SpacerSpool2.jpg 800w, /uploads/2020/10/SpacerSpool2-300x132.jpg 300w, /uploads/2020/10/SpacerSpool2-768x339.jpg 768w" sizes="(max-width: 800px) 100vw, 800px" /></noscript></a></figure>



<figure class="wp-block-image size-large"><a href="/uploads/2020/10/SpacerSpool3.jpg"><img loading="lazy" decoding="async" width="800" height="600" data-src="/uploads/2020/10/SpacerSpool3.jpg" data-id="15949" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-15949 lazyload"/><noscript><img loading="lazy" decoding="async" width="800" height="600" data-id="15949" src="/uploads/2020/10/SpacerSpool3.jpg" alt="" class="wp-image-15949" srcset="/uploads/2020/10/SpacerSpool3.jpg 800w, /uploads/2020/10/SpacerSpool3-300x225.jpg 300w, /uploads/2020/10/SpacerSpool3-768x576.jpg 768w" sizes="(max-width: 800px) 100vw, 800px" /></noscript></a></figure>



<figure class="wp-block-image size-large"><a href="/uploads/2020/10/SpacerSpool4.jpg"><img loading="lazy" decoding="async" width="800" height="600" data-src="/uploads/2020/10/SpacerSpool4.jpg" data-id="15948" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-15948 lazyload"/><noscript><img loading="lazy" decoding="async" width="800" height="600" data-id="15948" src="/uploads/2020/10/SpacerSpool4.jpg" alt="" class="wp-image-15948" srcset="/uploads/2020/10/SpacerSpool4.jpg 800w, /uploads/2020/10/SpacerSpool4-300x225.jpg 300w, /uploads/2020/10/SpacerSpool4-768x576.jpg 768w" sizes="(max-width: 800px) 100vw, 800px" /></noscript></a></figure>



<figure class="wp-block-image size-large"><a href="/uploads/2020/10/SpacerSpool5.jpg"><img loading="lazy" decoding="async" width="800" height="450" data-src="/uploads/2020/10/SpacerSpool5.jpg" data-id="15947" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-15947 lazyload"/><noscript><img loading="lazy" decoding="async" width="800" height="450" data-id="15947" src="/uploads/2020/10/SpacerSpool5.jpg" alt="" class="wp-image-15947" srcset="/uploads/2020/10/SpacerSpool5.jpg 800w, /uploads/2020/10/SpacerSpool5-300x169.jpg 300w, /uploads/2020/10/SpacerSpool5-768x432.jpg 768w" sizes="(max-width: 800px) 100vw, 800px" /></noscript></a></figure>
</figure>
', '2020-10-13T13:28:21', NULL, 'USD', true, '[{"id":261,"name":"Other Products","slug":"other-products"}]'::jsonb, '{"url":"/uploads/2020/10/Spacer-Spool-ISO.jpg","width":600,"height":600,"alt":"Spacer Spools"}'::jsonb, '{"title":"Spacer Spools | Spacer Spools Oilfield Equipments - WOM Group","description":"WOM''s Spacer Spools are Pressure-Containing equipment with end connections, stack in between drill through equipment. Spacer Spool are used to provide separation between two components with equal-sized end connections.","ogImage":"/uploads/2020/10/Spacer-Spool-ISO.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (13478, 'Special Multistage Trim', 'special-multistage-trim', '', '
<p class="wp-block-paragraph">Special energy dissipating, velocity controlled, disc stack trim can be provided as a solution to severe service applications. Including anti cavitation, high pressure drop, and low noise services.</p>



<p class="wp-block-paragraph">In the special multistage trim, the resistance, number and area of the individual flow passages are custom matched to the specific application, and exit velocities are managed to eliminate cavitation and erosion in liquid service and vibration and noise in gas service.</p>
', '2020-06-12T04:31:28', NULL, 'USD', true, '[{"id":258,"name":"Chokes","slug":"chokes"}]'::jsonb, '{"url":"/uploads/2020/06/MultiStageTrim.jpg","width":432,"height":371,"alt":"Special Multistage Trim"}'::jsonb, '{"title":"Special Multistage Trim - Worldwide Oilfield Machine","description":"Special Multistage trim can be provided as a solution to severe service applications including anti cavitation, high pressure drop, and low noise services.","ogImage":"/uploads/2020/06/MultiStageTrim.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1074, 'SPII Compact Wellhead', 'spii-compact-wellhead', '', '
<p class="wp-block-paragraph">Our SPII Compact Wellhead’s design is based on field-proven and tested technology and allows for a wide range of customizable features.</p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li><strong>Enhanced Safety: </strong>Provides an increased level of safety due to a design with minimum through-wall penetrations. Mandrel-type hangers offer complete BOP control, eliminating work under the BOP stack and further enhancing safety</li><li><strong>Minimum Components, Maximum Flexibility: </strong>Uses a minimum number of components, all of which are interchangeable within the system resulting in reduced installation time, possible leak paths and overall costs</li><li><strong>Industry Certified &amp; Field Proven: </strong>Designed to meet API 6A requirements, certified to PSL 1-4 and is capable of operating in temperatures ranging from 0-350º F</li></ul>



<p class="wp-block-paragraph"></p>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">Suited for all standard wellhead applications.</p>



<ul class="wp-block-list"><li>Cold cut option available for emergency applications</li><li>Material classification AA-HH meeting NACE requirements</li></ul>
', '2019-08-18T04:19:42', NULL, 'USD', true, '[{"id":134,"name":"Wellheads & Christmas Trees","slug":"wellheads-christmas-trees"}]'::jsonb, '{"url":"/uploads/2019/07/SPII-Compact-Wellhead.jpg","width":432,"height":371,"alt":"SPII Compact Wellhead"}'::jsonb, '{"title":"SPII Compact Wellhead - Worldwide Oilfield Machine","description":"WOM’s SPII Compact Wellhead provides an increased level of safety due to a design with minimum through-wall penetrations. Mandrel-type hangers offer complete BOP control, eliminating work under the BOP stack and further enhancing safety.","ogImage":"/uploads/2019/07/SPII-Compact-Wellhead.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1045, 'Standpipe Manifold', 'woms-standpipe-manifold', '', '
<p class="wp-block-paragraph">WOM specializes in the manufacture of manifolds for a complete range of onshore and offshore applications. WOM manifold systems may incorporate WOM’s Magnum gate valves, check valves, plug valves, chokes, and WOM actuators depending upon the application. WOM manifold designs meet virtually any industry requirement, including H2S environments up to 20,000 psi. Skid mounted and fully automated packages are available complete with control panels and instrumentation. WOM’s Standpipe manifold incorporates Magnum Mud Gate Valves or Model 600 Mud Gate Valves and are rated in pressures up to 20,000 psi. </p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li><strong>Built with Magnum Technology: </strong>WOM’s Standpipe Manifold incorporates Magnum Mud Gate Valves or Model 600 Mud Gate Valves and are rated in pressures up to 20,000 psi</li><li><strong>Quality Ensured: </strong>WOM’s Standpipe Manifolds are designed and constructed to provide unmatched quality at a cost-effective price to the customer</li><li><strong>Industry Certified: </strong>WOM’s fully vertically integrated manufacturing process allows for the highest level of quality control and ensures that all custom manifolds meet API specifications</li></ul>



<h3 class="womtitle wp-block-heading"> Applications </h3>



<p class="wp-block-paragraph">

All Standpipe manifold systems are designed, manufactured and certified in accordance to recognized oilfield standards. Welded, flanged, hubbed, high-pressure fittings and hammer union constructions are available to meet customer preference.

</p>
', '2019-07-17T19:31:31', NULL, 'USD', true, '[{"id":132,"name":"Manifolds","slug":"manifolds"}]'::jsonb, '{"url":"/uploads/2019/07/Sandpipe_ManifoldR1.jpg","width":600,"height":520,"alt":"Standpipe Manifold"}'::jsonb, '{"title":"Standpipe Manifold, WOM Manifold Systems - Worldwide Oilfield Machine","description":"WOM specializes in the manufacture of manifolds for a complete range of onshore and offshore applications. Standpipe manifold systems are designed, manufactured and certified in accordance to recognized oilfield standards.","ogImage":"/uploads/2019/07/Sandpipe_ManifoldR1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1165, 'Subsea Intervention System', 'subsea-intervention-system', '', '
<p class="wp-block-paragraph">WOM’s Subsea Intervention System (SIS) makes full use of Magnum gate valve technology, incorporating Hydraulic Fail-Close Gate Valves and Subsea Magnum Gate Valve in both the Emergency Disconnect Package and the Lower Rise Package.</p>



<p class="wp-block-paragraph">WOM’s Subsea Intervention Systems are available in both Riser and Riser-less configurations. WOM’s LIS design considers maintainability and ease of internal/external inspection and cleaning.</p>



<h3 class="womtitle wp-block-heading"> Specification and Features </h3>



<ul class="wp-block-list"><li><strong>Magnum gate valve Technology for Maximum Reliability: </strong>WOM’s Subsea Intervention System (SIS) makes full use of Magnum gate valve technology, incorporating Hydraulic Fail-Close Gate Valves and Subsea Magnum Gate Valve in both the Emergency Disconnect Package and the Lower Rise Package</li><li><strong>Engineered for Safety:&nbsp;</strong> WOM’s SIS isolates wellbore pressure while tools are being changed out providing two levels of redundancy for increased safety. A pilot-operated directional control valve fed from an independent subsea accumulator bank ensures a reliable and rapid response to ESD commands from the surface</li><li><strong>Industry Certified: </strong>WOM’s SIS is certified to API 6A and ISO 10423 specifications and is PR2 and PSL3G rated</li><li>Magnum Gate Valve and actuator can cut up to 2-7/8” coil tubing to shut in the well without leaving a slug in the valve body</li><li>Emergency Disconnect Package is a monoblock construction measuring 7-3/8” and is capable of withstanding up to 10,000 PSI</li><li>Lower Riser Package is a monoblock construction measuring 13-5/8” and is capable of withstanding up to 10,000 PSI</li></ul>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">WOM’s Subsea Intervention Systems can be used for both shallow and deep water operations. The SIS can be installed and retrieved using both wireline and non-wireline systems and rig mobilization is not required for its deployment.</p>



<ul class="wp-block-list"><li>Designed to connect to both horizontal and vertical subsea trees</li><li>Designed for a working pressure of 10,000 PSI</li><li>Rated to temperatures from 0°F to 250°F (-18°C t o 121°C)</li><li>Standard trim level EE </li></ul>
', '2019-10-09T07:14:10', NULL, 'USD', true, '[{"id":136,"name":"Subsea Well Operations","slug":"intervention-systems"}]'::jsonb, '{"url":"/uploads/2019/07/Subsea-Intervention-System.jpg","width":432,"height":371,"alt":"Subsea Intervention System"}'::jsonb, '{"title":"Subsea Intervention System (SIS) - Worldwide Oilfield Machine","description":"WOM’s Subsea Intervention System (SIS) makes full use of Magnum gate valve technology, incorporating Hydraulic Fail-Close Gate Valves and Subsea Magnum Gate Valve in both the Emergency Disconnect Package and the Lower Rise Package.","ogImage":"/uploads/2019/07/Subsea-Intervention-System.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8936, 'SubSea Manifolds', 'subsea-manifolds', '', '
<p class="wp-block-paragraph">WOM has major areas of expertise in the design and construction of Subsea Manifolds, PLETs and PLEMs.  We provide detail engineering and project management to our clients to ensure successful completion of these structures.  Subsea Manifold incorporates reliable Magnum subsea gate valves and actuators which have proven field history over the years.</p>



<h3 class="womtitle wp-block-heading">Features</h3>



<ul class="wp-block-list"><li>Combines flow from multiple individual wells and distributes it to the designated flowlines.</li><li>Allows well streams to be switched between flowlines or header</li><li>Provides the facility to incorporate isolation valves, multiphase flow meters and flow control devices</li><li>Provides distribution on services chemical and hydraulic fluid</li><li>Can provide pigging loops to allow round trip pigging</li><li>Manifold structure provides support for piping and provides protection to control equipment, piping and&nbsp;&nbsp;&nbsp;&nbsp; electro distribution circuit</li><li>Provides working interface for ROV</li><li>Seabed foundation system provided if required</li></ul>



<div class="wp-block-columns has-4-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<figure class="wp-block-image"><img fetchpriority="high" decoding="async" width="365" height="306" data-src="/uploads/2019/10/SubseaManifoldSmall1.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-8937 lazyload"/><noscript><img decoding="async" width="365" height="306" src="/uploads/2019/10/SubseaManifoldSmall1.jpg" alt="" class="wp-image-8937" srcset="/uploads/2019/10/SubseaManifoldSmall1.jpg 365w, /uploads/2019/10/SubseaManifoldSmall1-300x252.jpg 300w" sizes="(max-width: 365px) 100vw, 365px" /></noscript></figure>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<figure class="wp-block-image"><img decoding="async" width="432" height="371" data-src="/uploads/2019/10/SubseaManifold2.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-8938 lazyload"/><noscript><img loading="lazy" decoding="async" width="432" height="371" src="/uploads/2019/10/SubseaManifold2.jpg" alt="" class="wp-image-8938" srcset="/uploads/2019/10/SubseaManifold2.jpg 432w, /uploads/2019/10/SubseaManifold2-300x258.jpg 300w" sizes="(max-width: 432px) 100vw, 432px" /></noscript></figure>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<figure class="wp-block-image"><img loading="lazy" decoding="async" width="365" height="306" data-src="/uploads/2019/10/SubseaManifoldSmall3.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-8939 lazyload"/><noscript><img loading="lazy" decoding="async" width="365" height="306" src="/uploads/2019/10/SubseaManifoldSmall3.jpg" alt="" class="wp-image-8939" srcset="/uploads/2019/10/SubseaManifoldSmall3.jpg 365w, /uploads/2019/10/SubseaManifoldSmall3-300x252.jpg 300w" sizes="(max-width: 365px) 100vw, 365px" /></noscript></figure>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<figure class="wp-block-image"><img loading="lazy" decoding="async" width="365" height="306" data-src="/uploads/2019/10/SubseaManifoldSmall4.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-8940 lazyload"/><noscript><img loading="lazy" decoding="async" width="365" height="306" src="/uploads/2019/10/SubseaManifoldSmall4.jpg" alt="" class="wp-image-8940" srcset="/uploads/2019/10/SubseaManifoldSmall4.jpg 365w, /uploads/2019/10/SubseaManifoldSmall4-300x252.jpg 300w" sizes="(max-width: 365px) 100vw, 365px" /></noscript></figure>
</div>
</div>



<h3 class="womtitle wp-block-heading">SubSea Manifold &#8211; Chevron</h3>



<ul class="wp-block-list"><li>East Sterling Manifold (North Sea)</li><li>Chevron PLETs for offshore Angola Project</li></ul>



<p class="wp-block-paragraph"></p>
', '2019-10-11T12:26:22', NULL, 'USD', true, '[{"id":269,"name":"Manifolds and Structures","slug":"subsea-manifolds-and-structures"}]'::jsonb, '{"url":"/uploads/2019/10/SubseaManifold1.jpg","width":432,"height":371,"alt":"SubSea Manifolds"}'::jsonb, '{"title":"Subsea Manifolds, Subsea Manifold Manufacturers - WOM Group","description":"WOM has major areas of expertise in the design and construction of Subsea Manifolds, PLETs and PLEMs. We provide detail engineering and project management to our clients to ensure successful completion of these structures.","ogImage":"/uploads/2019/10/SubseaManifold1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (7950, 'Super Power Tandem Boosters', 'super-power-tandem-boosters', '', '		<div data-elementor-type="wp-post" data-elementor-id="7950" class="elementor elementor-7950" data-elementor-post-type="product">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-208c3108 elementor-section-content-top elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="208c3108" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-no">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-41684adf" data-id="41684adf" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-12db22ea elementor-widget elementor-widget-text-editor" data-id="12db22ea" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									<p></p>
<p class="wp-block-paragraph">Super Power (SP) Tandem Boosters are designed to enhance the shearing force of any size r<a href="https://worldwideoilfieldmachinery.com/product/wu-ram-type-bop/">am-type BOP</a>.</p>
<p></p>
<p></p>
<p class="wp-block-paragraph">• Eliminates need for spacers, connectors and other parts used in traditional tandem boosters <br>• SP Boosters provide twice the shearing force than traditional Tandem Boosters<br>• Weighs less than traditional boosters<br>• Other major brands of BOPs may be retrofitted with SP Tandem Boosters</p>
<p></p>
<p></p>
<h3 class="wp-block-heading">Specification and Features</h3>
<p></p>
<p></p>
<p class="wp-block-paragraph"><strong style="font-size: 16px;">Requires only Three Main Components</strong></p>
<p></p>
<p></p>
<ul class="wp-block-list">
<li>Housing</li>
<li>Piston</li>
<li>End Plate</li>
</ul>
<p></p>
<p></p>
<p class="wp-block-paragraph"><strong>Installation is easy for any size of <a href="https://worldwideoilfieldmachinery.com/product/wu-ram-type-bop/">Ram Blowout Preventers</a></strong></p>
<p></p>
<p></p>
<ul class="wp-block-list">
<li>Reduced Size</li>
<li>Reduced Weight</li>
<li>Reduced Overall Cost</li>
</ul>
<p></p>
<p></p>
<p class="wp-block-paragraph"><strong>Twice the force than traditional tandem boosters</strong></p>
<p></p>
<p></p>
<ul class="wp-block-list">
<li>Shears larger and heavier sizes of drill pipe required for deep drilling</li>
<li>Rigid power capable of shearing pipe at any extreme well condition and harsh environment</li>
</ul>
<p></p>
<p></p>
<h3 style="font-style: normal;">Applications</h3>
<p class="wp-block-paragraph" style="font-size: 16px; font-style: normal; font-weight: 400;">
</p><p style="font-size: 16px; font-style: normal; font-weight: 400;">
</p><p><span style="font-size: 16px; font-style: normal; font-weight: 400;">Super Power (SP) Tandem Boosters are designed to enhance the shearing force of any size</span><span style="font-size: 16px; font-style: normal; font-weight: 400;">&nbsp;</span><a style="font-size: 16px; font-style: normal; font-weight: 400; background-color: #ffffff;" href="https://worldwideoilfieldmachinery.com/product/wu-ram-type-bop/">Ram-Type BOP</a>.&nbsp; WOM has completed multiple s<span style="font-size: 16px;">uccessful shear tests on 13 5/8-in.-10K BOPs using SP-Tandem Boosters.&nbsp;</span></p>
<p></p>
<p></p>
<p class="wp-block-paragraph"><strong>Example of Test Results: S-135 Grade Drill Pipe Sizes</strong></p>
<p></p>
<p></p>
<ul class="wp-block-list">
<li>OD 5-in. PPF 25.6, closing pressure 2,300 psi</li>
<li>OD 5-1/2-in. PPF 24.7, closing pressure 2,200 psi</li>
<li>OD 6-5/8-in. PPF 25.2, closing pressure 1,500 psi</li>
<li>OD 6-5/8-in. PPF 27.6, closing pressure 2,400 psi</li>
</ul>
<p></p>
<p></p>
<h3 class="wp-block-heading">&nbsp;</h3>
<p></p>								</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		', '2019-09-25T15:27:20', NULL, 'USD', true, '[{"id":128,"name":"BOPs","slug":"bops"}]'::jsonb, '{"url":"/uploads/2019/09/SPBoosterInsetRi.jpg","width":432,"height":371,"alt":"Super Power Tandem Boosters"}'::jsonb, '{"title":"Super Power Tandem Boosters, Ram Boosters - WOM Group","description":"WOM''s Super Power (SP)Tandem Boosters are designed to enhance the shearing force of any size Ram-Type BOP. Read more about SP Tandem Boosters.","ogImage":"/uploads/2019/09/SPBoosterInsetRi.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (12396, 'Swivel Joints', 'swivel-joints', '', '
<p class="wp-block-paragraph">WOM Swivel Joints are available in sizes 2” – 3” with pressure ratings up to 15,000 PSI.</p>



<p class="wp-block-paragraph"><strong>Features include:</strong></p>



<ul class="wp-block-list"><li>Eight short radius Swivel Joint styles and configurations are available</li><li>Threaded, integral wing union, beveled for welding or flanged end connections are available</li><li>Sizes available 1’’ to 3’’ furnished with high nitrile packing and brass or stainless steel ring</li><li>All joints are specially heat treated to achieve optimal hardness</li><li>All materials meet ASTM and/or AISI standards</li><li>100% quality control and testing</li><li>Stock Availability in WOM Houston and Midland Facilities</li><li>Sour gas Swivel Joints are manufactured in accordance with the National Association of Corrosion Engineers (NACE) standard MR-01-75 &amp; the American Petroleum Institute’s (API) standard RP-14-E</li><li>Ease rotation and movement without sacrificing strength and integrity of the steel</li><li>Streamlined bore minimizes flow restrictions, turbulence and pressure drop</li><li>Long-sweep Swivel Joints have extra-long radius elbows for better flow characteristics</li><li>Manufactured specifically for high pressure applications</li><li>Dual and tri-race ball bearing Swivel Joints are matched to load capacities &amp; service conditions</li><li>All ball races are either flame hardened, carburized &amp; hardened or snap-in stainless steel</li></ul>
', '2020-06-06T15:12:06', NULL, 'USD', true, '[{"id":284,"name":"Flow Control Products","slug":"flow-control-products"}]'::jsonb, '{"url":"/uploads/2020/04/SwivelJointFeatured.jpg","width":432,"height":371,"alt":"Swivel Joints"}'::jsonb, '{"title":"Swivel Joints, Swivel Joints Oilfield Equipment - WOM Group","description":"WOM Group manufactures Swivel joints, precision components for the connection between hoses pipes and rotating parts of machines.","ogImage":"/uploads/2020/04/SwivelJointFeatured.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (7964, 'Torque Reducer Gate Valve', 'torque-reducer-gate-valve', '', '
<p class="wp-block-paragraph">The operating cycles of High Pressure Manual Gate Valve is a tough task in  extreme weather conditions  which requires  3 to 4 persons to operate the valve.  WOM has re-engineered and come-up with an  innovative design of torque reducers, which has unique operating mechanism which greatly reduces the operating torque  so that the valve can be opened or closed with ease of operation by single person.</p>



<p class="wp-block-paragraph">WOM&#8217;s Torque Reducer valves do not have a balance stem mechanism, which uniquely eliminates one of the leak paths. This valve is more compact in height as compared to other Torque Reducer valves available in market, giving more flexibility to accommodate for any application. </p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<p class="wp-block-paragraph"></p>



<ul class="wp-block-list"><li>Cost effective</li><li>Remarkable low operating torque so that single person can operate the valve with ease of operation</li><li>Comfortable working height</li><li>Leak path elimination without the use of a balance stem mechanism</li><li>Selective back seat sealing for rising stem provides proven safety to replace stem packing in full open condition</li><li>Quicker and safe operation</li><li>Ball screw structure lowers operating time</li><li>Easy onsite upgrades without major modifications</li></ul>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">

Used in the operating cycles of High Pressure Manual Gate Valve.

</p>
', '2019-09-25T15:47:46', NULL, 'USD', true, '[{"id":131,"name":"Gate Valves","slug":"gate-valves"}]'::jsonb, '{"url":"/uploads/2019/09/TorqueReducer1.jpg","width":432,"height":371,"alt":"Torque Reducer Gate Valve"}'::jsonb, '{"title":"Torque Reducer Gate Valve - Worldwide Oilfield Machine","description":"WOM’s Torque Reducer has unique operating mechanism which greatly reduces the operating torque so that the valve can be opened or closed with ease of operation by single person.","ogImage":"/uploads/2019/09/TorqueReducer1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1109, 'Tubing Hangers', 'tubing-hangers', '', '
<p class="wp-block-paragraph">Our Tubing Hangers allow for nippling up/down the Christmas tree without blowout preventer (BOP) protection. </p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<p class="wp-block-paragraph"><strong>Extreme Versatility: </strong>Feature an annulus compression elastomer seal pack off or an optional annulus metal-to-metal seal energized by a compression ring. </p>



<p class="wp-block-paragraph"><strong>Versatile Engineering: </strong>Can be fitted with internal or external running and retrieving thread as well as with continuous or non-continuous Down Hole Control Line preparation. All Tubing Hangers feature a standard type “H” Back Pressure Valve preparation and are available with API or Premium bottom internal thread</p>



<p class="wp-block-paragraph"><strong>Industry Certified: </strong>Manufactured to API-6A specifications with stainless or Inconel body material and can be customized to meet special requirements</p>



<h3 class="womtitle wp-block-heading"> Applications </h3>



<p class="wp-block-paragraph">Suitable for conventional and specialty wellhead systems, onshore and offshore and general and sour service applications. They are specially suited for applications which require suspending production tubing, containing annulus pressure between the tubing and production casing and containing pressure and fluids within the tubing bore.</p>



<ul class="wp-block-list"><li>Available in nominal sizes from 11” to 7 1/16”</li><li>Available in pressure ratings to 20,000 psi</li><li>Metal-to-Metal seals are standard for high pressure (15,000 psi and above) completions</li></ul>
', '2019-07-18T08:39:33', NULL, 'USD', true, '[{"id":134,"name":"Wellheads & Christmas Trees","slug":"wellheads-christmas-trees"}]'::jsonb, '{"url":"/uploads/2019/07/Tubing-Hangers.jpg","width":432,"height":371,"alt":"Tubing Hangers"}'::jsonb, '{"title":"Tubing Hangers, Tubing Hangers Surface Equipment - WOM Group","description":"WOM Tubing Hangers allow for nippling up/down the Christmas tree without blowout preventer (BOP) protection. WOM Tubing Hangers feature an annulus compression elastomer seal pack off or an optional annulus metal-to-metal seal energized by a compression ring.","ogImage":"/uploads/2019/07/Tubing-Hangers.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1118, 'Tubing Head Adapters', 'tubing-head-adapters', '', '
<p class="wp-block-paragraph">Our Tubing Head Adapters are designed for containing pressure and fluids within the tubing bore and are fully customizable for the project at hand. </p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<p class="wp-block-paragraph"><strong>Built to Client Specifications: </strong>Options include continuous or non-continuous Down Hole Control Line inlet preparation and integral manual or actuated Lower Master Valve.</p>



<p class="wp-block-paragraph"><strong>Versatile Engineering: </strong>Designed to serve in all well completion and direct transition from tubing hanger extended neck to Christmas Tree scenarios. Available with S-seal or metal-to-metal seal bottom preparation and with DD-NL, EE-NL, FF-NL and HH-NL trims.</p>



<p class="wp-block-paragraph"><strong>Industry Certified:&nbsp;</strong>Manufactured to API 6A specifications.</p>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">Suitable for conventional and specialty wellhead systems, onshore and offshore and general and sour service applications. </p>



<ul class="wp-block-list"><li>Available in studded or flange bottom sizes from 11” to 7 1/16” and studded or flange top sizes from 2 1/16” to 4 1/16”</li><li>Available in pressure ratings up to 20,000 psi</li><li>PSL-1 to 3G Certified</li><li>PR-1 Certified</li></ul>
', '2019-07-18T09:08:37', NULL, 'USD', true, '[{"id":134,"name":"Wellheads & Christmas Trees","slug":"wellheads-christmas-trees"}]'::jsonb, '{"url":"/uploads/2019/07/Tubing-Head-Adapters.jpg","width":432,"height":371,"alt":"Tubing Head Adapters"}'::jsonb, '{"title":"Tubing Head Adapters - Worldwide Oilfield Machine","description":"WOM Tubing Head Adapters are designed to serve in all well completion and direct transition from tubing hanger extended neck to Christmas Tree scenarios.","ogImage":"/uploads/2019/07/Tubing-Head-Adapters.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1100, 'Tubing Head Spools', 'tubing-head-spools', '', '
<p class="wp-block-paragraph">Our WTC series tubing spools feature a versatile straight bore design for single and multiple completions in working pressures through 20,000 psi. This design accepts all WTC series tubing hangers and easily converts from a single completion to multiple completion with the addition of an alignment pin or pins.</p>



<p class="wp-block-paragraph">These tubing spools can be furnished with integral “OO”, “P” and “PP” seals, “X” bushing, “PE” bushing, “4-0” bushing, and metal to metal preparations. Standard outlets are studded, but can be furnished with flanged or threaded outlets. Available options include clamp hubs. This product accepts a wide range of tubing hanger style including mandrel and wrap-around. </p>



<h3 class="womtitle wp-block-heading"> Specification and Features </h3>



<p class="wp-block-paragraph"><strong>Rugged &amp; Reliable: </strong>Optional integral double FS-seal, P-seal and Metal-to-Metal seal bottom preparation for HTHP application</p>



<p class="wp-block-paragraph"><strong>Versatile Engineering:&nbsp;</strong>Features a straight bore design for single and multiple completions. This design accepts all WTC series tubing hangers and easily converts from a single completion to multiple completions</p>



<p class="wp-block-paragraph"><strong>Industry Certified:&nbsp;</strong>Manufactured to API 6A specifications and are rated to 20,000 PSI</p>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">WOM Tubing Heads can be used in onshore and offshore environments, for general and sour service and in conventional or specialty wellhead systems.</p>



<ul class="wp-block-list"><li>PSL 1 to 3G certified</li><li>PR-1 certified</li><li>Available in DD-NL, EE-NL, FF-NL and HH-NL trims</li><li>Available in nominal flange sizes 11″ to 7-1/16″</li><li>Available with full set of lockscrews</li><li>Optional integral single or double Down Hole Control Line (DHCL) preparation</li></ul>
', '2019-07-18T07:44:26', NULL, 'USD', true, '[{"id":134,"name":"Wellheads & Christmas Trees","slug":"wellheads-christmas-trees"}]'::jsonb, '{"url":"/uploads/2019/07/WTC-22-FS-ET-Tubing-Head-Spool.jpg","width":432,"height":371,"alt":"Tubing Head Spools"}'::jsonb, '{"title":"Tubing Head Spools, Tubing Head Spools Oilfield Equipment - WOM Group","description":"WOM’s WTC series Tubing Head Spools feature a versatile straight bore design for single and multiple completions in working pressures through 20,000 psi. Read more about Tubing Head Spools.","ogImage":"/uploads/2019/07/WTC-22-FS-ET-Tubing-Head-Spool.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8867, 'Underbalanced Drilling Trailer Package', 'ubd-trailer-package', '', '		<div data-elementor-type="wp-post" data-elementor-id="8867" class="elementor elementor-8867" data-elementor-post-type="product">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-e937725 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="e937725" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-9c7bdf" data-id="9c7bdf" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-53ccb2f3 elementor-widget elementor-widget-text-editor" data-id="53ccb2f3" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									
<p class="wp-block-paragraph" style="text-align: left;">Underbalanced Drilling (UBD) trailer and skid mounted equipment packages are designed and manufactured in house with the attention to detail that ensures the equipment can be deployed and rigged up rapidly to be ready to go online for operations in the minimum possible timeframe. The format and layout of the equipment on each trailer or skid is constantly under evaluation by our very experienced well services operations team during the design and manufacturing stages to make sure it is both operationally and maintenance friendly to optimize the troubleshooting and repairs of any real time issues that might develop during live operations as well as routine maintenance shutdowns.</p>

<p class="wp-block-paragraph">MTC manufactures both trailer mounted and skid mounted UBD packages for integration with conventional derrick or coil tubing type drilling rigs and can provide the primary UBD choke control manifold(s) in both the 5K psi and 10K psi API 6A pressure range with various options of size and layout formats depending on the customers&#8217; individual requirements.</p>
								</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		', '2019-08-08T17:04:53', NULL, 'USD', true, '[{"id":263,"name":"Underbalanced Drilling","slug":"underbalanced-drilling"}]'::jsonb, '{"url":"/uploads/2019/10/UBDTrailerpackage.jpg","width":432,"height":371,"alt":"Underbalanced Drilling Trailer Package"}'::jsonb, '{"title":"UBD Trailer, Oilfiled Industry - Worldwide Oilfield Machine Inc.","description":"Magnum Technology Center is a Company spcialized in providing integrated solutions with advanced delivery to the oilfiled industry.","ogImage":"/uploads/2019/10/UBDTrailerpackage.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1233, 'Vertical Flowline Connectors', 'vertical-flowline-connectors', '', '
<p class="wp-block-paragraph"> Subsea connectors are one of the most critical parts of any subsea system, as they are required to seal under heavy loads. WOM’s subsea connectors use hydraulically actuated Collet segments or lock rings to connect to the hub and generate pre-load. </p>



<h3 class="wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li>Hydraulic
Flowline/Jumper/Umbilical connector<ul><li>7” -5K with Gooseneck
Assembly </li></ul><ul><li>Available both fully
cladded and partial cladded</li></ul><ul><li>Suitable for Water depth
of 1000 ft. (~ 300 m) </li></ul></li><li>Primary
Metal Seal &amp; Secondary Elastomeric Seals<ul><li>Hydraulic Gasket
Retention/Release Mechanism</li></ul><ul><li>Seal testing feature for
Subsea verification</li></ul></li><li>Taper
Lock with Mechanical Secondary Lock Mechanism<ul><li>Positive unlock key
mechanism</li></ul></li><li>Custom
top end connection <ul><li>weld neck / ACME
threaded / API Flange</li></ul></li></ul>



<h3 class="wp-block-heading">Operating Specification</h3>



<figure class="wp-block-table is-style-stripes"><table><tbody><tr><td>   <strong>PRESSURE   CRITERIA   </strong></td><td>   <strong>SPECIFICATION   </strong></td></tr><tr><td>
  Maximum working pressure
  </td><td>
  3,000 Psi
  </td></tr><tr><td>
  Maximum Test pressure
  </td><td>
  4,500
  Psi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
  </td></tr><tr><td> <strong>  TEMPERATURE   / DESIGN CRITERIA   </strong></td><td><strong>   SPECIFICATION  </strong> </td></tr><tr><td>
  Temperature Rating
  </td><td>
  P-U
  </td></tr><tr><td>
  Permissible Angular
  Misalignment
  </td><td>
  +/ &#8211; 3°
  </td></tr><tr><td>
  Hydraulic Operating
  Pressure
  </td><td>
  1,500 psi
  </td></tr><tr><td>
  Material Class
  </td><td>
  EE
  </td></tr><tr><td>
  PSL Level
  </td><td>
  PSL-3G
  </td></tr><tr><td>
  PR Level
  </td><td>
  2
  </td></tr><tr><td>
  Design Life
  </td><td>
  15 Years
  </td></tr><tr><td><strong>   OPERATING   CRITERIA   </strong></td><td><strong>   SPECIFICATION   </strong></td></tr><tr><td>
  Water depth
  </td><td>
  984 ft (300 m)
  </td></tr></tbody></table></figure>
', '2019-06-19T19:16:58', NULL, 'USD', true, '[{"id":300,"name":"Connectors","slug":"connectors"}]'::jsonb, '{"url":"/uploads/2019/06/VerticalFlowlineConnector.jpg","width":432,"height":371,"alt":"Vertical Flowline Connectors"}'::jsonb, '{"title":"Vertical Flowline Connectors, Subsea Connectors - WOM Group","description":"WOM''s Vertical Flowline connectors are one of the most critical parts of any subsea system, as they are required to seal under heavy loads. Subsea connectors use hydraulically actuated Collet segments or lock rings to connect to the hub and generate pre-load.","ogImage":"/uploads/2019/06/VerticalFlowlineConnector.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1150, 'Well Testing Choke Manifolds', 'well-testing-choke-manifolds', '', '
<figure class="wp-block-gallery columns-4 is-cropped wp-block-gallery-1 is-layout-flex wp-block-gallery-is-layout-flex"><ul class="blocks-gallery-grid"><li class="blocks-gallery-item"><figure><a href="/uploads/2019/10/DiamondShapedChokeManifold.jpg"><img fetchpriority="high" decoding="async" width="707" height="500" data-src="/uploads/2019/10/DiamondShapedChokeManifold.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" data-id="9529" data-link="https://worldwideoilfieldmachinery.com/product/choke-manifolds/diamondshapedchokemanifold/" class="wp-image-9529 lazyload"/><noscript><img decoding="async" width="707" height="500" src="/uploads/2019/10/DiamondShapedChokeManifold.jpg" alt="" data-id="9529" data-link="https://worldwideoilfieldmachinery.com/product/choke-manifolds/diamondshapedchokemanifold/" class="wp-image-9529" srcset="/uploads/2019/10/DiamondShapedChokeManifold.jpg 707w, /uploads/2019/10/DiamondShapedChokeManifold-300x212.jpg 300w" sizes="(max-width: 707px) 100vw, 707px" /></noscript></a><figcaption class="blocks-gallery-item__caption">Diamond Shape 4-Valve Choke Manifold</figcaption></figure></li><li class="blocks-gallery-item"><figure><a href="/uploads/2019/10/RectangularShapedManifold.jpg"><img decoding="async" width="707" height="500" data-src="/uploads/2019/10/RectangularShapedManifold.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" data-id="9530" data-link="https://worldwideoilfieldmachinery.com/product/choke-manifolds/rectangularshapedmanifold/" class="wp-image-9530 lazyload"/><noscript><img loading="lazy" decoding="async" width="707" height="500" src="/uploads/2019/10/RectangularShapedManifold.jpg" alt="" data-id="9530" data-link="https://worldwideoilfieldmachinery.com/product/choke-manifolds/rectangularshapedmanifold/" class="wp-image-9530" srcset="/uploads/2019/10/RectangularShapedManifold.jpg 707w, /uploads/2019/10/RectangularShapedManifold-300x212.jpg 300w" sizes="(max-width: 707px) 100vw, 707px" /></noscript></a><figcaption class="blocks-gallery-item__caption">Rectangular Shape 4-Valve Choke Manifold</figcaption></figure></li><li class="blocks-gallery-item"><figure><a href="/uploads/2019/10/5ValveChokeManifold.jpg"><img loading="lazy" decoding="async" width="707" height="500" data-src="/uploads/2019/10/5ValveChokeManifold.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" data-id="9531" data-link="https://worldwideoilfieldmachinery.com/product/choke-manifolds/5valvechokemanifold/" class="wp-image-9531 lazyload"/><noscript><img loading="lazy" decoding="async" width="707" height="500" src="/uploads/2019/10/5ValveChokeManifold.jpg" alt="" data-id="9531" data-link="https://worldwideoilfieldmachinery.com/product/choke-manifolds/5valvechokemanifold/" class="wp-image-9531" srcset="/uploads/2019/10/5ValveChokeManifold.jpg 707w, /uploads/2019/10/5ValveChokeManifold-300x212.jpg 300w" sizes="(max-width: 707px) 100vw, 707px" /></noscript></a><figcaption class="blocks-gallery-item__caption"> 5 Valve Choke Manifold with Bypass Valve </figcaption></figure></li><li class="blocks-gallery-item"><figure><a href="/uploads/2019/10/8ValveChokeManifold.jpg"><img loading="lazy" decoding="async" width="707" height="500" data-src="/uploads/2019/10/8ValveChokeManifold.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" data-id="9532" data-link="https://worldwideoilfieldmachinery.com/product/choke-manifolds/8valvechokemanifold/" class="wp-image-9532 lazyload"/><noscript><img loading="lazy" decoding="async" width="707" height="500" src="/uploads/2019/10/8ValveChokeManifold.jpg" alt="" data-id="9532" data-link="https://worldwideoilfieldmachinery.com/product/choke-manifolds/8valvechokemanifold/" class="wp-image-9532" srcset="/uploads/2019/10/8ValveChokeManifold.jpg 707w, /uploads/2019/10/8ValveChokeManifold-300x212.jpg 300w" sizes="(max-width: 707px) 100vw, 707px" /></noscript></a><figcaption class="blocks-gallery-item__caption"> 8 Valve Choke Manifold </figcaption></figure></li><li class="blocks-gallery-item"><figure><a href="/uploads/2019/10/ExpandableChokeManifold.jpg"><img loading="lazy" decoding="async" width="707" height="500" data-src="/uploads/2019/10/ExpandableChokeManifold.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" data-id="9533" data-link="https://worldwideoilfieldmachinery.com/product/choke-manifolds/expandablechokemanifold/" class="wp-image-9533 lazyload"/><noscript><img loading="lazy" decoding="async" width="707" height="500" src="/uploads/2019/10/ExpandableChokeManifold.jpg" alt="" data-id="9533" data-link="https://worldwideoilfieldmachinery.com/product/choke-manifolds/expandablechokemanifold/" class="wp-image-9533" srcset="/uploads/2019/10/ExpandableChokeManifold.jpg 707w, /uploads/2019/10/ExpandableChokeManifold-300x212.jpg 300w" sizes="(max-width: 707px) 100vw, 707px" /></noscript></a><figcaption class="blocks-gallery-item__caption"> Expandable Choke Manifold with Splitted Skid </figcaption></figure></li><li class="blocks-gallery-item"><figure><a href="/uploads/2019/10/FloorChokeManifold.jpg"><img loading="lazy" decoding="async" width="707" height="500" data-src="/uploads/2019/10/FloorChokeManifold.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" data-id="9534" data-link="https://worldwideoilfieldmachinery.com/product/choke-manifolds/floorchokemanifold/" class="wp-image-9534 lazyload"/><noscript><img loading="lazy" decoding="async" width="707" height="500" src="/uploads/2019/10/FloorChokeManifold.jpg" alt="" data-id="9534" data-link="https://worldwideoilfieldmachinery.com/product/choke-manifolds/floorchokemanifold/" class="wp-image-9534" srcset="/uploads/2019/10/FloorChokeManifold.jpg 707w, /uploads/2019/10/FloorChokeManifold-300x212.jpg 300w" sizes="(max-width: 707px) 100vw, 707px" /></noscript></a><figcaption class="blocks-gallery-item__caption"> Floor Choke Manifold with Removable Frame </figcaption></figure></li><li class="blocks-gallery-item"><figure><a href="/uploads/2019/10/8ChokeManifoldwithCrane.jpg"><img loading="lazy" decoding="async" width="707" height="500" data-src="/uploads/2019/10/8ChokeManifoldwithCrane.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" data-id="9535" data-link="https://worldwideoilfieldmachinery.com/product/choke-manifolds/8chokemanifoldwithcrane/" class="wp-image-9535 lazyload"/><noscript><img loading="lazy" decoding="async" width="707" height="500" src="/uploads/2019/10/8ChokeManifoldwithCrane.jpg" alt="" data-id="9535" data-link="https://worldwideoilfieldmachinery.com/product/choke-manifolds/8chokemanifoldwithcrane/" class="wp-image-9535" srcset="/uploads/2019/10/8ChokeManifoldwithCrane.jpg 707w, /uploads/2019/10/8ChokeManifoldwithCrane-300x212.jpg 300w" sizes="(max-width: 707px) 100vw, 707px" /></noscript></a><figcaption class="blocks-gallery-item__caption"> 8 Valve Choke Manifold with Removable Crane </figcaption></figure></li></ul></figure>



<h3 class="womtitle wp-block-heading">Overview</h3>



<p class="wp-block-paragraph">Over the years, we have gained considerable knowledge and experience in the design and manufacture of Well Test Products. These products include Flowhead, Surface Safety Valves(SSV), Choke Manifolds. We specialize in design and manufacture of any choke manifold to the customer’s specific need including multiple valve and choke configurations, incorporating single or double pressure barrier &amp; according to various industry-standard pressure and temperature ratings and service requirements. </p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<p class="wp-block-paragraph"><strong>Magnum Technology: </strong> Our Choke Manifolds incorporate Magnum Gate Valves which have set the industry standard for reliability</p>



<p class="wp-block-paragraph"><strong>Designed for Convenience: </strong>Choke Manifolds in five valve rectangular and four valve diamond patterns for limited space on offshore rigs</p>



<p class="wp-block-paragraph"><strong>Highly Customizable:</strong> Custom designs to virtually any client specification</p>



<h3 class="womtitle wp-block-heading"> Product Features/Benefits:</h3>



<ul class="wp-block-list"><li><span style="font-size: 1rem;">Choke Manifolds in 4-Valve, 5-Valve, 8-Valve &amp; 9-Valves with typical rectangular and diamond patterns for limited space on offshore rigs. </span></li><li><span style="font-size: 1rem;">Choke manifolds built with range of WOM manufactured field proven valves &amp; chokes including Manual, Hydraulic pneumatic etc.</span></li><li>Choke manifolds supplied with data headers for sampling. </li><li>Choke manifolds complete with inhouse manufactured control panel. </li><li>Inhouse Forging, Casting &amp; Manufacturing enables complicated shapes and dimensions for blocks or any other components. </li><li>Manifolds with crane installed skid for easy maintenance in field</li><li>Choke manifolds can be built with variety of skids including installation skids with or without roof type, removable frame, DNV certified, Non certified, transportation only skid per customer requirement and space constrain.</li><li>Third party inspections for manifold and skids per customer requirement.</li><li>Global aftermarket presence.</li><li>Recertification available on site at a customer facility or at a WOM facility</li></ul>



<h3 class="womtitle wp-block-heading"> Applications </h3>



<p class="wp-block-paragraph"></p>



<ul class="wp-block-list"><li>Onshore &amp; Offshore Well testing </li><li>Cleanup and flowback. </li></ul>
', '2019-08-18T12:26:00', NULL, 'USD', true, '[{"id":135,"name":"Well Test Equipment","slug":"well-test-equipment"}]'::jsonb, '{"url":"/uploads/2019/08/Choke-Kill-Manifolds-R1.jpg","width":432,"height":371,"alt":"Well Testing Choke Manifolds"}'::jsonb, '{"title":"Well Testing Choke Manifolds, Well Test Equipment - WOM Group","description":"WOM has over the years gained considerable knowledge and experience in the design and manufacture of Well test equipment including Well Testing Choke Manifolds, Onshore & Offshore Well Testing and many more.","ogImage":"/uploads/2019/08/Choke-Kill-Manifolds-R1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1142, 'Well Testing Flowheads', 'flowheads', '', '		<div data-elementor-type="wp-post" data-elementor-id="1142" class="elementor elementor-1142" data-elementor-post-type="product">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-1da4aff2 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="1da4aff2" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-50e91f38" data-id="50e91f38" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-5aac9180 elementor-widget elementor-widget-text-editor" data-id="5aac9180" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									<p></p>
<figure class="wp-block-gallery-2 is-layout-flex wp-block-gallery-is-layout-flex">
<p><span style="font-size: 16px;">We offer a wide range of well test products, such as flowheads, Surface Safety Valves (SSV), choke manifolds. We can design flowhead and surface test trees to the customer’s specific need, including: multiple configurations, incorporating Lower Master Valve (LMV) integral to flowhead block, LMV below Swivel to various industry-standard pressure and temperature ratings and service requirements.</span></p>
</figure>
<p></p>
<p></p>
<h3 class="wp-block-heading">Product Features/Benefits</h3>
<p></p>
<p></p>
<ul class="wp-block-list">
<li>Incorporates industry-leading Magnum Gate Valves</li>
<li>Designed with ACME Threads to accommodate high tensile load capacity</li>
<li>API-17G analyzed ACME thread connections</li>
<li>API-17G Qualified swivel</li>
<li>Top handling sub compatible to standard elevator sizes</li>
<li>An oil or grease filled swivel assembly below the central body of the surface test tree enables tubing to rotate freely, providing a means to manipulate the tool string while the test tree remains stationary</li>
<li>Swivel also has lock pins that can be engaged to prevent it from rotating for transportation and rig up if desired</li>
<li>Allows rotation of platform connection to flowhead without rotating string below swivel</li>
<li>Hydraulically actuated, fail-safe close gate valve for use in well testing, perforating, and wireline operations offshore with fast closing time</li>
<li>Wireline Cutting Gate Valve is available to use when performing wireline operations on offshore platforms</li>
<li>Work platform provides easy access to handling sub</li>
<li>Removable crash frame included to provide protection for valves and actuators.</li>
<li>Flowhead is incorporated with hook points for co-flex hose on production and kill lines to reduce load on wings</li>
<li>In-house forging, casting and manufacturing enables complicated shapes and dimensions for blocks or any other components</li>
<li>Flowhead supplied with DNV certified  or non-certified basket for transport</li>
<li>Third-party inspections for flowhead and basket per customer requirement</li>
<li>Global aftermarket presence</li>
<li>Recertification available on site at a customer facility or at a WOM facility</li>
</ul>
<p></p>
<p></p>
<h3 class="wp-block-heading">Specification</h3>
<p></p>
<p></p>
<ul class="wp-block-list">
<li>Pressures ranges from 5,000 psi to 20,000 psi</li>
<li>Size ranges from 2-1/16-in. to 7-3/8-in.</li>
<li>Main bore loaded connections are available in ACME threaded or Flange connections</li>
<li>Material Class suitable for standard service to High H<sub>2</sub>S &amp; CO<sub>2</sub> including DD to HH-NL</li>
<li>Temperature class ranges from L to X (–50<span style="font-size: 11.0pt; line-height: 107%; font-family: Symbol; mso-ascii-font-family: Calibri; mso-ascii-theme-font: minor-latin; mso-fareast-font-family: Calibri; mso-fareast-theme-font: minor-latin; mso-hansi-font-family: Calibri; mso-hansi-theme-font: minor-latin;">°</span>F to 350<span style="font-size: 11.0pt; line-height: 107%; font-family: Symbol; mso-ascii-font-family: Calibri; mso-ascii-theme-font: minor-latin; mso-fareast-font-family: Calibri; mso-fareast-theme-font: minor-latin; mso-hansi-font-family: Calibri; mso-hansi-theme-font: minor-latin;">°</span>F [–46<span style="font-size: 11.0pt; line-height: 107%; font-family: Symbol; mso-ascii-font-family: Calibri; mso-ascii-theme-font: minor-latin; mso-fareast-font-family: Calibri; mso-fareast-theme-font: minor-latin; mso-hansi-font-family: Calibri; mso-hansi-theme-font: minor-latin;">°</span>C to 180<span style="font-size: 11.0pt; line-height: 107%; font-family: Symbol; mso-ascii-font-family: Calibri; mso-ascii-theme-font: minor-latin; mso-fareast-font-family: Calibri; mso-fareast-theme-font: minor-latin; mso-hansi-font-family: Calibri; mso-hansi-theme-font: minor-latin;">°</span>C)</li>
<li>Product specification level: PSL 1 or 3G</li>
<li>Overlay options are available</li>
<li>Variety of crossovers options available at production and kill lines</li>
<li>Compliance with API specification 6A/ISO 10423, API specification 17G/ISO 13628-7, Norsok</li>
<li>Surface flow tree and swivel qualified per API-17G/ISO 13628-7</li>
<li>API 6A monogrammed components</li>
<li>Third-party certification</li>
<li>Variety of override options for valves are available, i.e.,  manual, hydraulic etc.</li>
<li>Option of wireline cutting valve available</li>
<li>Supplied with DNVGL-ST-E271 certified basket and slings</li>
<li>Options include: standard or custom configurations, instrumentation for pressure readings, ports for glycol injections, various structural components to operate chokes and valves, etc.</li>
</ul>
<p></p>
<p></p>
<h3 class="wp-block-heading">Applications</h3>
<p></p>
<p></p>
<p class="wp-block-paragraph"></p>
<p></p>
<ul class="wp-block-list">
<li>Onshore and offshore well testing</li>
<li>Well intervention work such as slickline and coiled tubing</li>
<li>Reservoir clean up</li>
<li>Subsea installation completion</li>
<li>Well stimulation</li>
</ul>
<p></p>								</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		', '2019-08-18T12:14:43', NULL, 'USD', true, '[{"id":135,"name":"Well Test Equipment","slug":"well-test-equipment"}]'::jsonb, '{"url":"/uploads/2019/07/FlowHeadR1.jpg","width":600,"height":520,"alt":"Well Testing Flowheads"}'::jsonb, '{"title":"Well Testing Flowheads, Well Testing Flowhead Manufacturers - WOM Group","description":"WOM has over the years gained considerable knowledge and experience in the design and manufacture of Well Test Products. WOM can design Flowhead & Surface Test Trees to the customer’s specific need including multiple configurations.","ogImage":"/uploads/2019/07/FlowHeadR1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1135, 'Well Testing Surface Safety Valve (SSV)', 'well-test-valves', '', '
<div class="wp-block-columns has-2-columns is-layout-flex wp-container-core-columns-is-layout-7387b849 wp-block-columns-is-layout-flex">
<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<div class="wp-block-image"><figure class="aligncenter is-resized"><a href="/uploads/2019/10/SSVWithLiftingFrame.jpg"><img fetchpriority="high" decoding="async" data-src="/uploads/2019/10/SSVWithLiftingFrame.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-9549 lazyload" width="244" height="293"/><noscript><img decoding="async" src="/uploads/2019/10/SSVWithLiftingFrame.jpg" alt="" class="wp-image-9549" width="244" height="293" srcset="/uploads/2019/10/SSVWithLiftingFrame.jpg 500w, /uploads/2019/10/SSVWithLiftingFrame-250x300.jpg 250w" sizes="(max-width: 244px) 100vw, 244px" /></noscript></a><figcaption>SSV with Lifting Frame and Crossover</figcaption></figure></div>
</div>



<div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow">
<div class="wp-block-image"><figure class="aligncenter is-resized"><a href="/uploads/2019/10/SSVWithRoofTypeLiftingFrame.jpg"><img decoding="async" data-src="/uploads/2019/10/SSVWithRoofTypeLiftingFrame.jpg" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="" class="wp-image-9548 lazyload" width="236" height="283"/><noscript><img loading="lazy" decoding="async" src="/uploads/2019/10/SSVWithRoofTypeLiftingFrame.jpg" alt="" class="wp-image-9548" width="236" height="283" srcset="/uploads/2019/10/SSVWithRoofTypeLiftingFrame.jpg 500w, /uploads/2019/10/SSVWithRoofTypeLiftingFrame-250x300.jpg 250w" sizes="(max-width: 236px) 100vw, 236px" /></noscript></a><figcaption>SSV with Roof Type Lifting Frame</figcaption></figure></div>
</div>
</div>



<h3 class="womtitle wp-block-heading">Overview</h3>



<p class="wp-block-paragraph">The WOM surface safety valve (SSV) is a hydraulically actuated, fail-safe close gate valve for use in well testing, perforating, and wireline operations. We have vast, field-proven experience in design and manufacture of SSVs, including customized to specifications. Examples include multiple configurations incorporating SSV with hydraulic or pneumatic actuators and variety of crossovers to accommodate customer connection to various industry-standard pressure and temperature ratings and service requirements. </p>



<h3 class="womtitle wp-block-heading">Product Features/Benefits</h3>



<ul class="wp-block-list"><li>Incorporates proprietary our Magnum Gate Valves</li><li>Offering SSV with hydraulic, pneumatic actuator and crossovers with union or hub end connections for easy connections on field. WOM custom designs and builds SSV to virtually any client specification</li><li>In-house manufactured control panel with emergency shut down system</li><li>In-house forging, casting and manufacturing enables complicated shapes and dimensions for blocks or any other components</li><li>SSV with variety of skids options including installation lifting frame with or without roof type, removable frame, DNV certified, Non certified, transportation only lifting frame per customer requirement and space constrain</li><li>Third party inspections for manifold and skids per customer requirement</li><li>Global aftermarket presence</li><li>Recertification available on site at a customer facility or at a WOM facility</li></ul>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li><span style="font-size: 1rem;"> </span>Pressures Ranges from 5,000 psi to 20,000 psi</li><li>Size Ranges from 1-13/16-in. to 7-1/16-in.</li><li>Material Class suitable for Standard service to High H<sub>2</sub>S and CO<sub>2</sub> including DD to HH-NL</li><li>Temperature Class Ranges from L to X (–50°F to 450°F [–46°C to 232°C])</li><li>Product specification level: PSL 1 or 3G</li><li>Qualified &amp; validated per API 6A, API 17D and API 6FA</li><li>Overlay options are available</li><li>Variety of crossovers options available at inlet and outlet including Union, Hubs etc.</li><li>Compliance with API specification 6A/ISO 10423, API specification 17D/ISO 13628-4, API specification 6FA, Norsok.</li><li>API 6A monogrammed components.</li><li>Supplied with DNVGL-ST-E273/271 Lifting frame and slings</li><li>Third-party certification</li><li>Options include: standard or custom configurations, instrumentation for pressure readings, ports for glycol injections, various structural components to operate chokes and valves, etc.</li></ul>



<h3 class="womtitle wp-block-heading"> Applications </h3>



<p class="wp-block-paragraph"></p>



<ul class="wp-block-list"><li>Exploration and appraisal well testing</li><li>Onshore and offshore well testing </li><li>Cleanup and flowback</li></ul>
', '2019-07-18T10:18:40', NULL, 'USD', true, '[{"id":135,"name":"Well Test Equipment","slug":"well-test-equipment"}]'::jsonb, '{"url":"/uploads/2019/07/Well-Test-ValveR1.jpg","width":600,"height":520,"alt":"Well Testing Surface Safety Valve (SSV)"}'::jsonb, '{"title":"Well Testing Surface safety Valve (SSV), Well Test Valves - WOM Group","description":"WOM offers Well Testing Surface safety Valve (SSV) with hydraulic, pneumatic actuator & crossovers with union or hub end connections for easy connections on field.","ogImage":"/uploads/2019/07/Well-Test-ValveR1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1067, 'Wellhead &#038; Christmas Tree Systems', 'wellhead-christmas-tree-systems', '', '
<p class="wp-block-paragraph">The Patented Magnum Gate Valve, the key component of any WOM wellhead system, provides the most reliable long-term seal and lowest life cycle costs. WOM designs, manufacturers and supplies Wellhead and Christmas Tree systems of all sizes, working pressures and trims to meet any client specification.</p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<ul class="wp-block-list"><li><strong>Built to Client Specifications:&nbsp;</strong>WOM designs, manufacturers and supplies&nbsp;Wellhead and Christmas Tree systems&nbsp;of all sizes, working pressures and trims to meet any client specification</li><li><strong>Quality Ensured:&nbsp;</strong>WOM’s full line of&nbsp;Wellhead and Christmas Tree systems incorporate the patented Magnum Gate Valve providing reliable, long-term operation with low maintenance</li><li><strong>Industry Certified: </strong>WOM’s fully vertically integrated manufacturing process allows for complete supervision in every step of the process to produce API-certified Wellhead and Christmas Tree system</li></ul>



<h3 class="womtitle wp-block-heading">Applications</h3>



<p class="wp-block-paragraph">Onshore and offshore applications</p>
', '2019-08-18T03:51:57', NULL, 'USD', true, '[{"id":134,"name":"Wellheads & Christmas Trees","slug":"wellheads-christmas-trees"}]'::jsonb, '{"url":"/uploads/2019/07/Wellhead-Christmas-Tree-SystemsR1.jpg","width":432,"height":371,"alt":"Wellhead &#038; Christmas Tree Systems"}'::jsonb, '{"title":"Wellhead Christmas Tree Saver, Christmas Tree Oil and Gas - WOM Group","description":"WOM Group offers variety of Wellhead Christmas tree equipments for Oil & Gas products. Browse our range of Christmas Tree products.","ogImage":"/uploads/2019/07/Wellhead-Christmas-Tree-SystemsR1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (1128, 'Wellheads &#038; Christmas Trees', 'api-standard-wellhead-christmas-tree-equipment', '', '
<p class="wp-block-paragraph">WOM manufactures a variety of API-certified wellhead products that can be customized to customer requirement. </p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<p class="wp-block-paragraph"><strong>Quality Ensured: </strong>Conforms to API guidelines and are thoroughly inspected by both first and third party inspectors before being delivered to the customer</p>



<p class="wp-block-paragraph"><strong>Industry Certified: </strong>Fully vertically integrated manufacturing process allows for complete supervision in every step of the process to produce API-certified wellhead equipment</p>



<h3 class="womtitle wp-block-heading"> Applications </h3>



<p class="wp-block-paragraph">Suited for use in any application specified in API guidelines. WOM is a full line manufacturer with API 6A, 16A, 16C, 16D, 17D and ISO certifications.</p>
', '2019-08-18T09:57:40', NULL, 'USD', true, '[{"id":134,"name":"Wellheads & Christmas Trees","slug":"wellheads-christmas-trees"}]'::jsonb, '{"url":"/uploads/2019/08/API_Certified_Wellhead1.jpg","width":600,"height":515,"alt":"Wellheads &#038; Christmas Trees"}'::jsonb, '{"title":"Wellhead & Christmas Tree - Worldwide Oilfield Machine","description":"WOM manufactures a variety of API-certified wellhead products that can be customized to customer requirement. WOM’s API-certified wellhead equipment conforms to API guidelines and are thoroughly inspected by both first and third party inspectors before being delivered to the customer.","ogImage":"/uploads/2019/08/API_Certified_Wellhead1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8609, 'WMSP Diverter', 'wmsp-diverter', '', '
<p class="wp-block-paragraph">Our 29 1/2&#8243; 500  psi diverter is an annular BOP that closes and seals off on tubulars in the wellbore. It also completely seals off the open hole to full-rated working pressure by compression of a reinforced packing unit. </p>



<h3 class="womtitle wp-block-heading">Specification and Features</h3>



<p class="wp-block-paragraph">

Products are designed to NACE MR-01-75 materials standards for resistance to sulfide stress cracking.

</p>



<h3 class="womtitle wp-block-heading"> Applications </h3>



<p class="wp-block-paragraph">The 29 1/2&#8243; 500 psi WMSP diverter has been developed for use on surface installations.</p>
', '2019-05-06T14:34:30', NULL, 'USD', true, '[{"id":128,"name":"BOPs","slug":"bops"}]'::jsonb, '{"url":"/uploads/2019/10/WMSPDiverter1.jpg","width":432,"height":371,"alt":"WMSP Diverter"}'::jsonb, '{"title":"WMSP Diverter, WMSP Diverter Oilfield Equipment - WOM Group","description":"WMSP Diverter is an annular type BOP which will close and seal off on tubulars in the well bore or completely seal off the open hole to full rated working pressure by compression of a reinforced packing unit. The 29 1/2″ 500 psi WMSP Diverter has been developed for use on surface installations.","ogImage":"/uploads/2019/10/WMSPDiverter1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (21103, 'WOM-SP HPHT Ram Elastomers', 'elastomers', '', '		<div data-elementor-type="wp-post" data-elementor-id="21103" class="elementor elementor-21103" data-elementor-post-type="product">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-3c0aa14 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="3c0aa14" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-2a72cf8" data-id="2a72cf8" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-7ca422d elementor-widget elementor-widget-text-editor" data-id="7ca422d" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									<p>When you need reliable sealing performance in <b>extreme sour conditions</b>, we have you covered. WOM-SP HPHT ram elastomers are designed and manufactured per API 16A (4th Edition) and NACE using our proprietary rubber formulation. The result: extreme heat resistance, enhanced physical properties, and increased chemical resistance.</p>
<h3 style="font-style: normal;">Specifications</h3>
<ul>
<li><b>Application: </b>High Pressure, High Temperature (HPHT)&nbsp;</li>
<li><b>Extreme Temperature Rating: </b>350°F with excursions up to 365°F&nbsp;</li>
<li><b>Sour Service: </b>45% H<sub>2</sub>S gas mixture (35% H<sub>2</sub>S + 10% CO<sub>2</sub>)&nbsp;</li>
<li><b>Applicable Products</b>: Packers, Top Seals, ConRods, and Bonnet Seals&nbsp;&nbsp;</li>
</ul>								</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		', '2022-08-23T14:07:29', NULL, 'USD', true, '[]'::jsonb, '{"url":"/uploads/2022/08/IMG_3393_edited-square-1024x1024.png","width":1024,"height":1024,"alt":"WOM-SP HPHT Ram Elastomers"}'::jsonb, '{"title":"WOM-SP HPHT Ram Elastomers - Worldwide Oilfield Machine","description":"In the market for WOM-SP HPHT Ram Elastomers? Visit our page to learn its specifications and features. Downloadable brochure available.","ogImage":"/uploads/2022/08/IMG_3393_edited-square-1024x1024.png"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (913, 'WU Ram Type BOP', 'wu-ram-type-bop', '', '		<div data-elementor-type="wp-post" data-elementor-id="913" class="elementor elementor-913" data-elementor-post-type="product">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-37025cf3 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="37025cf3" data-element_type="section" data-e-type="section">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-37e00c8f" data-id="37e00c8f" data-element_type="column" data-e-type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-6a0bdc11 elementor-widget elementor-widget-text-editor" data-id="6a0bdc11" data-element_type="widget" data-e-type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
									<p></p>
<p class="wp-block-paragraph">The simple, compact design of the U-type BOP makes it the most widely deployed BOP type in both onshore and offshore operations.</p>
<p>The <strong>WU ram-type BOP</strong> operating system is engineered to provide fast and reliable closure around pipe or casing in all standard well control applications. The easy-to-operate system is pressure energized and features hydraulically operated locking mechanisms to hold the rams closed without continuous actuation pressure.</p>
<p>All parts and components of the WU ram type BOP are precision machined to be fully interchangeable with the U types produced by the major OEMs. Overall dimensions are the same, making it easy to change the stack without any major rework to the rig.</p>
<p>Major components are forged for uniform strength and come standard with chrome-plated cylinders and ram change pistons. The life and performance of our operating pistons are enhanced by the surface alloy, Colmonoy™, a stronger and longer-lasting coating than the standard tungsten carbide.</p>
<p></p>
<h3 class="womtitle wp-block-heading">Major Features</h3>
<p></p>
<ul class="wp-block-list">
<li>Major components are forged and come standard with chrome-plated cylinders and ram change pistons</li>
<li>Operating pistons are coated with Colmonoy™ surface alloy</li>
<li>Close-die forging makes the stack lighter when compared to square bodies available in the market</li>
<li>Parts are fully interchangeable with most major brands of U-type BOPs and can be replaced on location</li>
<li>Global network of maintenance and repair facilities<strong><br /></strong></li>
</ul>
<p></p>
<h3 class="womtitle wp-block-heading">Specifications</h3>
<p></p>
<p class="wp-block-paragraph"></p>
<ul class="wp-block-list">
<li>Sizes: 7 1/16-in. through 26 ¾-in.</li>
<li>Pressure range: 2,000 psi through 15,000 psi</li>
</ul>
<p></p>								</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		', '2019-07-19T19:07:42', NULL, 'USD', true, '[{"id":128,"name":"BOPs","slug":"bops"}]'::jsonb, '{"url":"/uploads/2019/07/WOMWU-Ram-Type-BOP1.jpg","width":432,"height":371,"alt":"WU Ram Type BOP"}'::jsonb, '{"title":"WU Ram Type BOP, BOP Rams - Worldwide Oilfield Machine","description":"WOM’s WU Ram BOP is pressure energized and features hydraulically operated locking mechanisms to hold the rams closed without actuation pressure.","ogImage":"/uploads/2019/07/WOMWU-Ram-Type-BOP1.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO public.products (id, title, slug, excerpt, content_html, date, price, currency, is_price_on_request, categories, featured_image, seo) VALUES (8996, 'X-Mas Tree for Mudline Suspension System', 'x-mas-tree-for-mudline-suspension-system', '', '
<p class="wp-block-paragraph">WOM offers Trees to be used on shallow water completions for marginal fields. Typically used along with jack up completion in shallow water operations. A cost-effective solution for shallow water completions coupled with WOM’s MLS Wellhead.</p>



<h3 class="womtitle wp-block-heading">Features</h3>



<ul class="wp-block-list"><li>Available
in EE, FF &amp; HH Material Class.</li><li>Combination
of WOM’s dual-seal Hydraulic &amp; Manual valves.</li><li>H<sub>2</sub>S
Service.</li><li>5,000-
15,000 psi rated working pressure. </li><li>Diver
or ROV quick makeup WOM’s WQ Mechanical Connector for reduced make-up/ Break-up
time/</li><li>5”
Production x 2” Annulus Nominal Bore</li><li>Monitoring
of annulus pressure via annulus access valve.</li><li>3
½” Tubing hanger with four down hole functions</li><li>Optional
Protective Structure (FFS) available</li></ul>
', '2019-10-05T20:20:06', NULL, 'USD', true, '[{"id":266,"name":"Xmas Trees and Wellheads","slug":"xmas-trees-and-wellheads"}]'::jsonb, '{"url":"/uploads/2019/10/VerticalXTre.jpg","width":432,"height":371,"alt":"X-Mas Tree for Mudline Suspension System"}'::jsonb, '{"title":"X-Mas Tree for Mudline Suspension System - Worldwide Oilfield Machine","description":"WOM offers X-Mas Trees to be used on shallow water completions for marginal fields. Typically used along with jack up completion in shallow water operations. A cost-effective solution for shallow water completions coupled with WOM’s MLS Wellhead.","ogImage":"/uploads/2019/10/VerticalXTre.jpg"}'::jsonb) ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;

-- Seeding Site Settings
INSERT INTO public.site_settings (key, value) VALUES ('general', '{"name":"Worldwide Oilfield Machine (WOM)","tagline":"Total Solutions for Oil & Gas Industry","headquarters":"Houston, Texas, USA","stats":{"totalProducts":96,"totalCategories":31,"totalLocations":17,"totalNewsArticles":83,"totalResources":43,"totalCorePages":14},"navigation":[{"label":"Home","href":"/"},{"label":"About Us","children":[{"label":"Our Story","href":"/our-story"},{"label":"Our Core Policies","href":"/our-core-policies"},{"label":"Certifications","href":"/certifications"},{"label":"Patents","href":"/patents"},{"label":"The American Dream","href":"/americandream"}]},{"label":"Products","href":"/products","featuredCategories":["Gate Valves","Ball Valves","BOPs","Chokes","Wellheads & Christmas Trees","Subsea Intervention Systems"]},{"label":"Locations","href":"/locations"},{"label":"News & Events","href":"/news"},{"label":"Resources","href":"/resources"},{"label":"Careers","href":"/wom-careers"},{"label":"Contact Us","href":"/contact-us"}],"socials":{"facebook":"https://www.facebook.com/womglobalgroup","twitter":"https://x.com/womglobalgroup","instagram":"https://www.instagram.com/womglobalgroup/","youtube":"https://www.youtube.com/channel/UC9dLzkFrVOaA8ISDRpAvA7A"}}'::jsonb) ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;

-- ===================================================
-- SYNCHRONIZE POSTGRESQL SEQUENCES
-- Prevents "duplicate key value violates unique constraint" errors
-- ===================================================
SELECT setval('public.products_id_seq', COALESCE((SELECT MAX(id) FROM public.products), 1));
SELECT setval('public.news_id_seq', COALESCE((SELECT MAX(id) FROM public.news), 1));
SELECT setval('public.locations_id_seq', COALESCE((SELECT MAX(id) FROM public.locations), 1));
SELECT setval('public.resources_id_seq', COALESCE((SELECT MAX(id) FROM public.resources), 1));
SELECT setval('public.inquiries_id_seq', COALESCE((SELECT MAX(id) FROM public.inquiries), 1));
SELECT setval('public.site_settings_id_seq', COALESCE((SELECT MAX(id) FROM public.site_settings), 1));

