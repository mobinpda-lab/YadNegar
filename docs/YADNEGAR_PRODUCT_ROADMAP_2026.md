# طرح جامع محصول و نقشه راه یادنگار
## نسخه 1.0 — 2026-08-28

**Repository:** `mobinpda-lab/YadNegar`  
**مرجع حقیقت:** GitHub Reality  
**جهت محصول:** مدیریت کار و پیگیری فارسی با تاریخچه پایدار، تجربه روزمحور و حافظه شخصی سبک  

> این سند از روی مستندات زنده یادنگار، قابلیت‌های موجود، Issue #151 و مقایسه با Arvin-clean تدوین شده است. اصل راهبردی: قابلیت موجود توسعه داده شود؛ Foundation موازی ساخته نشود.

## 1. چشم‌انداز محصول
یادنگار باید از یک ابزار ثبت و نگهداری اطلاعات به یک دستیار روزانه ساده و سریع تبدیل شود که به کاربر کمک کند بداند چه کارهایی دارد، آخرین وضعیت هر کار چه بوده، امروز چه چیزی نیاز به توجه دارد، چه چیزهایی عقب افتاده‌اند و قدم بعدی چیست.

اصل تجربه:
`باز کن → امروز را ببین → کار را پیدا کن → پیگیری ثبت کن → ادامه بعدی را مشخص کن → تمام`

## 2. هویت و محدوده
یادنگار نباید به یک سامانه سنگین مدیریت پروژه تبدیل شود. محصول برای استفاده شخصی و روزمره، پیگیری تماس‌ها، امور اداری، مالی، خانوادگی، کاری و ایده‌ها طراحی می‌شود.

هویت غیرقابل‌مذاکره:
- فارسی و RTL-first
- تقویم و نمایش جلالی
- ارقام فارسی در UI
- عملکرد سریع با حداقل کلیک
- Offline-first و حفظ داده محلی
- تاریخچه پیگیری‌ها به‌عنوان دارایی اصلی
- عدم حذف ناخواسته داده
- Backup/Restore
- «بسم الله الرحمن الرحیم» به‌عنوان بخشی از هویت Home

## 3. Foundation موجود که باید Reuse شود
طبق مستندات فعلی پروژه:
- یک tracked-task root پایدار و FollowUpهای persistent child
- description اختیاری، create/edit/detail و history
- Search در title + description + FollowUp text
- Jalali/Persian presentation با Gregorian/ISO persistence
- Reminder foundation با none/daily/weekly و timezone محلی
- PDF فارسی RTL برای همه/انتخاب‌شده/یک کار + Share/Print
- JSON schema-versioned، schema v5، reads v1-v4، tmp/bak recovery و Backup/Restore

نتیجه: Roadmap جدید عمدتاً Product/UX و extension همین foundationهاست، نه بازنویسی معماری.

## 4. درس‌های قابل انتقال از Arvin
قابلیت‌های باارزش آروین برای یادنگار:
- Swipe چپ و راست
- Tag
- انتخاب چندتایی و عملیات گروهی
- Archive
- Trash/Restore
- Backup/Restore UX
- Calendar
- Reminder/Notification

انتقال باید روی مدل داده و معماری یادنگار انجام شود و Copy مستقیم Storage یا UI آروین ممنوع است.

## 5. ستون‌های اصلی آینده محصول
### A — Today / Attention Center
Home به مرکز توجه امروز تبدیل شود: پیگیری‌های امروز، عقب‌افتاده‌ها، مهم‌ها، بدون پیگیری و اخیراً به‌روزرسانی‌شده؛ همه compact و قابل جمع‌شدن.

### B — FollowUp First
ثبت پیگیری سریع‌ترین عملیات باشد: Detail `+`، Swipe چپ/راست، Quick Action. فرم با task از قبل انتخاب‌شده، تقویم جلالی جدولی و ساعت 24 ساعته.

### C — Personal Organization
Tags، Star، Archive، Trash و فیلترها بدون شلوغ کردن Home.

### D — Reliability & Portability
Backup/Restore قابل فهم، Export، recovery، و بعداً Cloud Backup.

### E — Smart Assistance
پس از تثبیت پایه‌ها: تشخیص کار فراموش‌شده، پیشنهاد پیگیری، Summary و semantic search؛ AI هرگز Source of Truth نباشد.

## 6. Roadmap اجرایی
### Wave 1 — UX فوری و ورودی پیگیری (Issue #151)
1. «بسم الله الرحمن الرحیم» بالای Home
2. Jalali Date Picker ماهانه/جدولی
3. Time Picker ساعت‌گرد 24 ساعته
4. Swipe دوطرفه روی task برای FollowUp همان root

DoD: عدم عملیات مخرب با Swipe، RTL/Persian digits، widget tests، parent correctness، analyze/test/Android Green.

### Wave 2 — Today و Overdue
Home نشان دهد:
- Today
- Overdue
- Upcoming
- Active task بدون Next FollowUp

Derived state تا حد ممکن Persist نشود؛ فقط زمان برنامه‌ریزی‌شده اقدام بعدی در صورت نیاز domain data است.

### Wave 3 — Reminder کامل برای Tracked Task / FollowUp
Reminder foundation موجود reuse شود. وضعیت Reminder در Detail، reschedule امن بعد edit/restart، notification tap به همان task. monthly/custom فقط در صورت نیاز واقعی.

### Wave 4 — Tag + Star + Quick Filter
چند Tag برای root، رنگ فقط Presentation، filter Home، search در Tag name و Star به‌عنوان flag سبک مستقل.

### Wave 5 — Archive + Trash + Restore
Archive بدون حذف history. حذف معمولی به Trash، Restore، permanent delete فقط با تأیید صریح. سازگار با Backup/Restore.

### Wave 6 — Multi-select / Bulk Actions
Archive، Restore، Tag add/remove، Star/unstar، PDF selected از مسیر موجود، حذف گروهی با guard قوی.

### Wave 7 — Recurring FollowUp / Next Action
daily / weekly / monthly / custom interval. FollowUp recurrence از Reminder recurrence جدا بماند.

### Wave 8 — Calendar View
تقویم رسمی هجری شمسی برای FollowUpهای ثبت‌شده، موعدهای آینده، Reminderها و روزهای دارای فعالیت؛ بدون storage مستقل.

### Wave 9 — Backup/Restore UX + Cloud
ابتدا Local end-to-end: create, restore, last backup, validation, overwrite warning, smoke restore. سپس provider cloud با manual sync قبل از auto sync.

### Wave 10 — Smart Layer
ابتدا rule-based: مدت طولانی بدون پیگیری، موعد گذشته، بدون next action، summary ساده. سپس AI: history summary، next-action suggestion، زمان پیشنهادی و semantic search.

## 7. Navigation پیشنهادی
سطح اول محدود بماند:
1. خانه / امروز
2. جستجو
3. تقویم
4. آرشیو
5. تنظیمات

Trash، Backup، Export و Tag Management مسیر ثانویه باشند.

## 8. مدل Home پیشنهادی
1. «بسم الله الرحمن الرحیم»
2. Search
3. Today summary
4. Overdue warning در صورت وجود
5. Active tracked tasks
6. FAB / quick capture

Task Card:
- title
- description کوتاه
- latest FollowUp
- relative time
- Star
- Tagهای محدود
- Today/Overdue visual state
- Swipe left/right → FollowUp

## 9. Search نهایی
Exact search به‌مرور title، description، FollowUp و Tag را پوشش دهد. Archive/Star در Filter باشند. semantic search در آینده لایه مکمل باشد نه جایگزین exact search.

## 10. اصول UX
- عملیات اصلی حداکثر 1 تا 2 gesture
- destructive action هرگز Swipe مستقیم نباشد
- pickerها mobile-first
- Persian digits در تاریخ/زمان visible
- empty state واضح
- accessibility label برای icon-only actions
- قابلیت پیشرفته در secondary surfaces

## 11. اصول معماری
- یک Repository/Storage
- عدم ایجاد Task/FollowUp DB موازی
- migration additive
- derived state تا حد ممکن non-persisted
- Reminder foundation reuse
- PDF/Share/Print reuse
- Search service دوم ممنوع بدون نیاز اثبات‌شده
- Calendar projection روی داده موجود
- Cloud فقط بعد از Local reliability

## 12. Schema Evolution پیشنهادی
فقط هنگام implementation:
- v6 احتمالی: nextActionAt / status مورد نیاز Today
- v7 احتمالی: tags + star
- v8 احتمالی: archive/trash lifecycle
- v9 احتمالی: recurrence

این شماره‌ها قطعی نیستند و Fresh Audit زمان اجرا تعیین‌کننده است.

## 13. کیفیت هر Wave
`Focused Test → Full flutter test → flutter analyze → Android Build → UI Evidence (برای UI) → fresh scope → merge → post-main proof`

برای Data: backward compatibility + migration + recovery + backup/restore tests.
برای Reminder: schedule/edit/delete + restart reconciliation + timezone behavior.

## 14. اولویت نهایی
### P0
- Issue #151
- Today / Overdue
- Tracked-task Reminder integration
- Backup/Restore reliability

### P1
- Tag
- Star
- Archive
- Trash/Restore
- Calendar View

### P2
- Bulk Actions
- Recurring FollowUp
- Cloud Backup

### P3
- Smart/AI Layer

## 15. خارج از Scope فعلی
- Collaboration/Team
- حساب کاربری اجباری
- Backend مستقل
- Kanban/Gantt پیچیده
- Chat داخلی
- CRM سنگین
- AI خودمختار برای تغییر داده

## 16. Maximum Parallel
Laneها:
- Product/UX: Wave 1 → Today → Tags/Archive
- Core/Data: فقط migration لازم Feature فعال
- Reminder: tracked-task next-action integration
- Reliability: Backup/Restore + recovery tests
- Release/CI: Android + exact-head evidence
- Documentation: sync پس از هر Wave Verify‌شده

## 17. قدم اجرایی فعلی
1. Issue #151 اجرا شود.
2. همزمان Gap Audit برای Today/Overdue و Reminder integration انجام شود.
3. پس از Merge Wave 1، Issueهای کوچک Wave 2 ساخته شوند.
4. Backup/Restore foundation در Lane مستقل end-to-end Audit شود.
5. اسناد canonical بعد از محصول Verify‌شده sync شوند.

## 18. اصل نهایی
یادنگار قرار نیست بیشترین Feature را داشته باشد؛ باید در چند ثانیه پاسخ دهد:

> «امروز چه چیزی را باید پیگیری کنم و آخرین وضعیتش چه بوده؟»

هر Feature جدید فقط وقتی وارد محصول شود که این هدف یا Data Safety/Portability را تقویت کند.
