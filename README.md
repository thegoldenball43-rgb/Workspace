# Evolve Neo — Studio Workspace (Independent Deployable Edition)

نسخة مستقلة بالكامل عن ChatGPT Sites، قابلة للتشغيل الفوري في أي متصفح والنشر المباشر على **Cloudflare Pages** أو **GitHub Pages** أو أي استضافة ويب قياسية، مع مخطط قاعدة بيانات SQL جاهز لـ **Cloudflare D1**.

## التشغيل الفوري على جهازك (VS Code أو المتصفح)
1. فك ضغط الملف وافتح المجلد في VS Code أو انقر مرتين على `index.html`.
2. يعمل التطبيق مباشرةً بكامل وظائفه (الفواتير، PDF المستقل، العملاء، المشاريع، المهام، العقود، الخزنة المشفرة AES-GCM، ومزامنة بريفات Firebase).
3. لحفظ نسخة احتياطية أو نقل البيانات بين الأجهزة: افتح **الإعدادات ← تصدير قاعدة البيانات JSON**.

## النشر المستقل على Cloudflare Pages (خلال دقيقة واحدة)
1. ارفع هذا المجلد إلى مستودع GitHub خاص (Private Repository).
2. في لوحة تحكم **Cloudflare Dashboard → Workers & Pages → Create → Pages → Connect to Git**.
3. اختر المستودع، واترك Build Command فارغاً، وحدد Build output directory كـ `/`.
4. اربط الدومين الخاص بك (`Custom Domain`) مثل `workspace.evolveneo.com`.

## التوسع المستقبلي بقاعدة بيانات سحابية (Cloudflare D1 + R2)
- مخطط الجداول العلائقية الكامل جاهز في `db/schema.sql`.
- عند إضافة API Worker للمصادقة وتعدد المستخدمين، نفّذ:
  ```sh
  npx wrangler d1 create evolve-neo-db
  npx wrangler d1 execute evolve-neo-db --remote --file db/schema.sql
  ```
