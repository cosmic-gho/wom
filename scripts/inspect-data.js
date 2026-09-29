const fs = require('fs');
const path = require('path');

const sampleDirs = {
  pages: 'wp-json/wp/v2/pages',
  product: 'wp-json/wp/v2/product',
  product_category: 'wp-json/wp/v2/product_category',
  location: 'wp-json/wp/v2/location',
  news_item: 'wp-json/wp/v2/news_item',
  resource_library: 'wp-json/wp/v2/resource_library'
};

for (const [key, dir] of Object.entries(sampleDirs)) {
  const fullDir = path.resolve(__dirname, '..', dir);
  if (fs.existsSync(fullDir)) {
    const files = fs.readdirSync(fullDir).filter(f => !fs.statSync(path.join(fullDir, f)).isDirectory());
    if (files.length > 0) {
      const data = JSON.parse(fs.readFileSync(path.join(fullDir, files[0]), 'utf8'));
      console.log('=== ' + key + ' (sample: ' + files[0] + ') ===');
      console.log('Keys:', Object.keys(data));
      console.log('Title:', data.title ? data.title.rendered : data.name);
      console.log('Slug:', data.slug);
      console.log('Yoast title:', data.yoast_head_json ? data.yoast_head_json.title : null);
      console.log('Yoast description:', data.yoast_head_json ? data.yoast_head_json.description : null);
      console.log('Yoast image:', data.yoast_head_json && data.yoast_head_json.og_image ? data.yoast_head_json.og_image[0] : null);
      console.log('----------------------------------------------------');
    }
  }
}
