# سند اجرایی یکپارچه پروژه یادنگار

## Maximum Parallel + Production Orchestrator

از این لحظه فرآیند توسعه، تکمیل، تست، مستندسازی، Merge و Release پروژه **یادنگار (YadNegar)** باید تحت اصل دائمی زیر انجام شود:

**ادامه با حالت Maximum Parallel؛ سریع، خودکار، مستند و با گزارش کوتاه غیر فنی.**

Production Orchestrator بخشی از اجرای همین اصل است و جایگزین Maximum Parallel نیست.

## 1. اصل اجرایی مادر
تمام کارهای مستقل پروژه باید تا حد ممکن هم‌زمان انجام شوند. اگر یک Lane، PR، CI یا Integration مسدود شد، فقط همان مسیر متوقف شود و سایر Laneهای مستقل ادامه پیدا کنند.

اصل دائمی:

**Parallelism در توسعه حداکثری است، اما Merge به main سریالی، محافظت‌شده و Evidence-Based باقی می‌ماند.**

هدف اصلی: کمترین زمان مرده بین توسعه، CI، Android validation، مستندسازی و Release.

## 2. منبع حقیقت پروژه
ترتیب اعتبار:

**GitHub Reality > Product Contract تأییدشده > Governance > Current-State Docs > Conversation Memory**

Repository اصلی: `mobinpda-lab/YadNegar`  
Branch اصلی: `main`

Baseline ثبت‌شده هنگام تدوین این سند: `b8f49ab4b1bd24991030f4090578b236c28710d0`

آخرین Merge ثبت‌شده: `#170 — add 8-minute YadNegar Production Orchestrator`

قبل از هر ادامه واقعی باید GitHub دوباره Fresh Audit شود. اگر main تغییر کرده بود، baseline جدید GitHub به‌صورت خودکار جایگزین این مقدار شود. Historical Green هرگز برای Head جدید معتبر تلقی نشود.

## 3. مدل اصلی محصول
مدل canonical یادنگار:

`Tracked Task Root → Persistent FollowUps → Jalali/Persian History → Search → PDF/Print/Share`

هر کار پیگیری‌دار یک Root پایدار دارد. FollowUpها فرزندان پایدار همان Root هستند. تاریخچه Parent و Siblingها باید حفظ شود. Flat Timeline قدیمی فقط Legacy tooling است و نباید تبدیل به foundation دوم محصول شود.

## 4. قانون معماری
یک منبع داده اصلی وجود دارد. یک JSON persistence foundation وجود دارد. نباید برای قابلیت‌های جدید Task store دوم، FollowUp store دوم، Reminder scheduler دوم، Search foundation دوم، PDF engine دوم، Backup engine دوم، Project database دوم یا Calendar/Today store دوم ساخته شود.

اصل: **Reuse Before Add**

هر قابلیت جدید ابتدا باید foundation موجود را توسعه دهد.

## 5. Storage و Migration
Storage باید backward-compatible باقی بماند.

قوانین:
- migration مخرب ممنوع
- read-time rewrite ممنوع
- safe-write upgrade
- tmp/bak crash recovery
- Backup/Restore معتبر
- schema جدید فقط در صورت نیاز واقعی
- schema جدید نباید فقط برای راحتی implementation ایجاد شود

نسخه‌های قدیمی باید تا حد قرارداد جاری قابل خواندن باقی بمانند. FollowUp نباید Project membership مستقل از Parent داشته باشد.

## 6. Maximum Parallel
Laneهای مستقل باید هم‌زمان جلو بروند.

Laneهای اصلی: Product، Reminder، Home / Today، FollowUp UX، Reports، Projects، Search، Release، Android Validation، Automation، Documentation و Governance.

هر Lane باید به Sliceهای کوچک، کم‌ریسک و قابل برگشت شکسته شود. PRها ترجیحاً کوچک و کم‌Conflict باشند. حرکت main نباید کل پروژه را متوقف کند. فقط Lane متاثر Fresh Compare/Rebuild شود.

## 7. Production Orchestrator
یادنگار دارای Production Orchestrator مستقل است.

Cadence: **هر 8 دقیقه**

وظیفه Orchestrator:
- بررسی PRهای مجاز
- Fresh-read کردن current main
- بررسی exact Head SHA
- بررسی Fast CI
- بررسی Android/Release chain
- جلوگیری از stale evidence
- جلوگیری از Merge روی base قدیمی
- Merge فقط با expected-head
- Merge یکی‌یکی
- Post-main validation
- ادامه Queue بعد از هر Merge

Production Orchestrator باید ابزار اجرایی Maximum Parallel باشد، نه مانع توسعه موازی.

## 8. قانون CI
هیچ Head تغییرکرده‌ای حق استفاده از CI قبلی را ندارد.

برای هر PR باید در صورت مرتبط بودن exact-head Fast CI، UI Evidence، Android Full Chain، fresh compare، mergeability و expected-head lock بررسی شود.

Android Full Chain موجود یادنگار:

`Fast CI → Android Build → Candidate → Smoke/Recovery → Readiness → Release Draft → Approval/Rollback`

تا زمانی که قرارداد CI تغییر نکرده، foundation جدید CI ساخته نشود.

## 9. قانون Merge
توسعه: **Maximum Parallel**  
Merge: **Serial**

هر Merge باید روی current main معتبر باشد، Head ثابت داشته باشد، stale نباشد، CI مربوط به همان exact Head باشد، Fresh Compare معتبر داشته باشد، behind=0 یا معادل معتبر آن داشته باشد، mergeability زنده بررسی شود، expected_head_sha استفاده شود و Post-main proof داشته باشد.

Merge دو PR به‌صورت مخرب و هم‌زمان ممنوع است.

## 10. وضعیت فعلی محصول
قابلیت‌های اصلی موجود:
- Tracked Task Root
- Persistent FollowUps
- تاریخچه فارسی/جلالی
- Description
- Search
- Project membership
- Home root-only
- one repository snapshot per reload
- latest real FollowUp semantics
- FollowUp swipe امن
- Jalali monthly grid
- 24-hour time picker
- PDF / Print / Share
- date-based reports
- JSON Backup/Restore
- Reminder foundation
- recurrence none/daily/weekly
- Today Center
- Next Action

این قابلیت‌ها foundation موجود پروژه هستند و نباید با نسخه دوم بازسازی شوند.

## 11. Home Contract
Home فقط Root Taskها را نمایش دهد. FollowUpها داخل history/detail متعلق به همان Root هستند. Home باید از یک repository snapshot در هر reload استفاده کند.

Search حداقل Task title، Description و FollowUp text را پوشش دهد. Latest FollowUp واقعی مبنای نمایش آخرین پیگیری است و زمان ایجاد Root نباید به‌جای FollowUp واقعی نمایش داده شود.

## 12. FollowUp Contract
FollowUp باید به یک Root مشخص متصل باشد، history Parent را حفظ کند، siblingها را حذف یا overwrite نکند، Project context را از Parent بگیرد، قابلیت ویرایش امن داشته باشد و Reminder مستقل خود را در صورت فعال‌بودن داشته باشد.

Swipe چپ یا راست روی Task باید FollowUp capture برای همان Root باز کند. Swipe نباید Root را delete/dismiss کند.

## 13. Lane فعال فعلی — Reminder
PR فعال ثبت‌شده: `#168 — complete tracked task and follow-up reminders`

این Lane اکنون یکی از Critical Product Lanes است.

Root Task: set/change/clear reminder + recurrence none/daily/weekly.  
FollowUp: reminder مستقل + edit + clear + recurrence + parent/history preservation.  
Detail: نمایش Reminder و recurrence با Jalali/Persian و 24-hour.

قانون:

`Next Action = برنامه اقدام`  
`Reminder = اعلان`

این دو نباید در مدل یا UI با هم ادغام شوند.

## 14. Reminder Architecture
Foundation موجود باید reuse شود:
- Reminder model
- JSON persistence
- TimelineReminderScheduler
- AndroidLocalTimelineReminderScheduler
- flutter_local_notifications
- startup reconcile
- restore reconcile
- Persian reminder picker

ممنوع: scheduler دوم، notification engine دوم، reminder store دوم یا picker دوم بدون نیاز واقعی.

ترتیب write:

**Durable Save → Schedule / Reschedule / Cancel**

نه برعکس.

## 15. Reminder Safety
باید set، change، clear، delete، restart، restore، reconciliation، permission denied، past-time fail-safe، daily recurrence و weekly recurrence پوشش داده شود. FollowUp reminder نباید Parent history را تغییر دهد.

## 16. Today Center / Next Action
Today Center باید بر اساس `nextActionAt` مستقل کار کند. Bucketها derived هستند و ذخیره نمی‌شوند: Today، Overdue، Upcoming و No Next Action.

Next Action فقط روی Root Task باشد. تقسیم روزها بر اساس local calendar day باشد. Today و Reminder به هیچ عنوان یک مفهوم تلقی نشوند.

## 17. Projects
Projectها First-Class هستند. Root Task می‌تواند Project داشته باشد. FollowUp Project مستقل ندارد و context را از Parent می‌گیرد. Projectها در همان JSON foundation ذخیره شوند و Database دوم ممنوع است.

Project باید create، rename، color، assign، reassign و safe delete را با حفظ canonical Task data پشتیبانی کند.

## 18. Search
Search باید canonical و reuse-based باقی بماند و حداقل در Root title، Description و FollowUp text جستجو کند. ساخت Index/Store مستقل فقط در صورت نیاز اثبات‌شده performance مجاز است.

## 19. Reports / PDF
مسیر گزارش موجود foundation اصلی است.

Scope موجود: All، Selected، Single Task، Selected Jalali day و Inclusive date range.

PDF باید Persian، RTL، Jalali و history-aware باشد. برای date report فقط FollowUpهای match شده وارد شوند. صرف تاریخ ایجاد Root نباید باعث match شدن گزارش FollowUp شود. PDF / Print / Share باید یک document/report foundation مشترک داشته باشند.

## 20. Backup / Restore
Backup و Restore بخشی از Release Contract هستند.

باید schema validation، backward compatibility، crash-safe write، unsupported newer schema fail-closed، restore reconciliation و reminder reconciliation حفظ شود. هیچ Release نهایی بدون Backup/Restore regression معتبر نباشد.

## 21. Android Validation
Android chain باید برای تغییرات Product/Release مرتبط اجرا شود و حداقل موارد مرتبط Debug APK، Release Candidate، Emulator startup، storage recovery، Reminder scheduling، Persian/RTL، Jalali date، Home، FollowUp، Backup/Restore و Release readiness را پوشش دهد.

Evidence باید واقعی باشد. Mock یا screenshot مصنوعی به‌جای Device evidence پذیرفته نیست.

## 22. Release Strategy
هدف فعلی: **Production Local APK پایدار**

Release محلی نباید به Play Store یا Signing Production وابسته شود مگر Owner صریحاً چنین تصمیمی بگیرد.

وضعیت Release ممکن است candidate verified، local production usable، governance verified، production signing blocked و Play-Store publish pending باشد و نباید این وضعیت‌ها با هم اشتباه شوند.

## 23. Signing / Play Store
بدون تصمیم صریح Owner/Security:
- Production Keystore ساخته نشود
- Secret ثبت نشود
- Real Release Tag ساخته نشود
- GitHub Release نهایی ساخته نشود
- Play Store Publish انجام نشود

این موارد مستقل از آماده‌بودن APK محلی هستند.

## 24. Governance Gap
Issue: `#19 — require YadNegar CI in main ruleset`

این Gap وابسته به Platform capability است. تا زمانی که Ruleset Write واقعاً در دسترس نیست، نباید توسعه Product را Block کند.

Operational Safety باید جای آن را پوشش دهد: exact head، relevant green CI، fresh scope، mergeability، expected head و post-main proof.

Platform blocker فقط همان Governance Lane را متوقف کند.

## 25. Documentation
مستندات بخشی از محصول هستند. Canonical docs موجود باید حفظ شوند، از جمله AI Continuation State، AI Handoff، Operation Plan، Comprehensive Project Document، Product Roadmap، Project Operating Package، Production Orchestrator docs و Development History.

هیچ تاریخچه معتبر حذف نشود. موارد قدیمی Historical، Superseded یا Archived علامت‌گذاری شوند ولی قابل بازیابی بمانند.

## 26. اولویت Merge
Merge Priority با Development Parallelism فرق دارد.

ترتیب پیشنهادی فعلی:
1. Reminder integration
2. Reminder Android/full-chain validation
3. Today/Next Action regression
4. FollowUp regression
5. Home regression
6. Project regression
7. Search regression
8. Reports/PDF regression
9. Backup/Restore regression
10. Release stabilization

اما همه Laneهای مستقل می‌توانند هم‌زمان توسعه پیدا کنند.

## 27. Release Stabilization Lane
این Lane باید دائماً در Parallel فعال باشد و منتظر تمام‌شدن Features نماند.

به‌طور پیوسته analyze، tests، Android build، Release Candidate، emulator smoke، persistence regression، Backup/Restore، Reminder reconciliation، Home/FollowUp smoke، RTL، Jalali، Search و PDF بررسی شوند.

هدف: پیدا کردن regression قبل از Release Lock.

## 28. Release Candidate Definition
RC وقتی مجاز است که current main در scope فعلی دارای Fast CI Green، Android Build Green، Candidate generated، Smoke/Recovery Green و Core CRUD، FollowUp، Reminder، Today/Next Action، Projects، Search، PDF/Print/Share و Backup/Restore سالم باشد.

## 29. Production Local APK Definition
Production Local APK وقتی قابل تحویل است که Release build موفق باشد، clean install و upgrade path مرتبط سالم باشد، storage reload سالم باشد، FollowUp history، Reminder scheduling/reconcile، Today/Next Action، Project persistence، Backup/Restore، RTL/Jalali و Android Smoke معتبر باشند و regression بحرانی باز وجود نداشته باشد.

## 30. برخورد با PR قدیمی
هیچ PR قدیمی کورکورانه Merge نشود.

اگر main جلو رفته: Fresh Compare → intent extraction → rebuild on current main → transfer relevant tests → new small PR.

Force Merge تاریخچه قدیمی ممنوع است.

## 31. رفتار بعد از Merge
بعد از هر Merge:
1. main جدید Fresh-read شود
2. exact SHA ثبت شود
3. PRهای باز دوباره مقایسه شوند
4. stale branches تشخیص داده شوند
5. فقط Laneهای impacted rebuild شوند
6. Historical CI invalid شود
7. Post-main CI اجرا/بررسی شود
8. سایر Laneها ادامه پیدا کنند

## 32. گزارش‌دهی
بعد از هر موج فقط گزارش کوتاه غیر فنی:

**کجا هستیم:** مرحله کلی پروژه.  
**انجام شد:** فقط چیزهایی که واقعاً complete/merge شده‌اند.  
**در حال انجام:** Laneها یا PRهای فعال.  
**مانع:** فقط blocker واقعی.  
**قدم بعد:** نزدیک‌ترین حرکت اجرایی.

گزارش نباید تبدیل به توضیح طولانی فنی شود مگر درخواست مستقیم Owner.

## 33. رفتار خودکار هنگام ادامه پروژه
وقتی در صفحه پروژه نوشته شد «ادامه یادنگار»، «ادامه با حالت Maximum Parallel؛ سریع، خودکار، مستند و با گزارش کوتاه غیر فنی» یا «Maximum Parallel Extreme»، باید:
1. GitHub Fresh-read شود
2. current main مشخص شود
3. open PRها بررسی شوند
4. open Issues مرتبط بررسی شوند
5. CI/Android evidence بررسی شود
6. eligible work جلو برود
7. stale work rebuild شود
8. Laneهای مستقل موازی ادامه پیدا کنند
9. Mergeها یکی‌یکی انجام شوند
10. Post-main proof گرفته شود
11. docs sync شوند
12. گزارش کوتاه داده شود

نباید فقط برنامه داده شود. در صورت وجود امکان واقعی باید کار انجام شود.

## 34. قانون عدم توقف
یک blocker نباید کل یادنگار را متوقف کند.

اگر Reminder Android گیر کرد: Docs / Reports / Regression / Release audit ادامه یابد.  
اگر Ruleset #19 گیر است: Product Development ادامه یابد.  
اگر یک PR stale شد: فقط همان Lane rebuild شود.

اصل:

**One blocker pauses one lane, not YadNegar.**

## 35. دستور دائمی نهایی
از آخرین وضعیت واقعی GitHub یادنگار ادامه بده.

حالت دائمی:

**Maximum Parallel؛ سریع، خودکار، مستند، کم‌توقف و با گزارش کوتاه غیر فنی.**

Production Orchestrator هشت‌دقیقه‌ای باید جریان PR/CI/Merge را محافظت کند.

توسعه: **حداکثر Parallel**  
CI: **Exact-Head + Evidence-Based**  
Merge: **One-by-One**  
Architecture: **Reuse-First**  
Release: **Android-Validated**

هدف:

**کوتاه‌ترین مسیر امن از current main به یک YadNegar Production Local APK پایدار و قابل تحویل، بدون خراب‌کردن تاریخچه، داده یا معماری canonical پروژه.**
