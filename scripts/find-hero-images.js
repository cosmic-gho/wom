const fs = require('fs');
const path = require('path');

function getFiles(dir, files = []) {
  if (!fs.existsSync(dir)) return files;
  const list = fs.readdirSync(dir);
  for (const file of list) {
    const full = path.join(dir, file);
    if (fs.statSync(full).isDirectory()) {
      getFiles(full, files);
    } else if (/\.(jpg|jpeg|png)$/i.test(file)) {
      const stat = fs.statSync(full);
      // larger images suitable for hero backgrounds
      if (stat.size > 200 * 1024) {
        files.push({
          path: full.replace(path.resolve(__dirname, '../public'), '').replace(/\\/g, '/'),
          name: file,
          size: stat.size
        });
      }
    }
  }
  return files;
}

const all = getFiles(path.resolve(__dirname, '../public/uploads'));
all.sort((a, b) => b.size - a.size);
console.log(all.slice(0, 20));
