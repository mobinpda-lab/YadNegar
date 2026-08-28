# YadNegar — Live AI Handoff

## مرجع حقیقت
`GitHub Reality > قرارداد تأییدشده مالک > Governance > اسناد canonical > حافظه گفتگو`

قبل از هر Write/Merge/گزارش وضعیت، Fresh Audit الزامی است و Green تاریخی برای Head جدید معتبر نیست.

Repository: `mobinpda-lab/YadNegar`  
Default branch: `main`  
Current merged product main: `64460c5cb0cf1e70f6361a32acf9e77a6bfdfdfe`

## وضعیت محصول
یادنگار بر مدل «یک کار ثابت + تاریخچه پیگیری‌های فرزند» استوار است. هر FollowUp به همان root متصل می‌شود. Repository/JSON/Reminder/PDF foundation موجود reuse شده و Store موازی ساخته نشده است.

قابلیت‌های فعلی:
- Home فقط rootها را نشان می‌دهد و با **یک repository snapshot** بارگذاری می‌شود.
- Search روی title + description + FollowUp text کار می‌کند.
- description اختیاری روی root وجود دارد.
- Project اختیاری روی root وجود دارد؛ FollowUp Project مستقل ندارد.
- Projects در همان فایل JSON ذخیره می‌شوند.
- Home بالای صفحه «بسم الله الرحمن الرحیم» دارد.
- Swipe چپ یا راست هر task، فرم FollowUp همان root را باز می‌کند و هرگز task را حذف/Dismiss نمی‌کند.
- Date Picker ماهانه/جدولی جلالی و Time Picker ساعت‌گرد ۲۴ساعته فعال‌اند.
- PDF فارسی RTL، Share و Print برای همه/انتخاب‌شده/یک کار فعال‌اند.
- گزارش یک روز یا بازه جلالی روی FollowUpهای واقعی فعال است.
- Backup/Restore و Reminder none/daily/weekly برقرارند.

## Data Safety
Storage schema فعلی: **v6**  
Backward reads: **v1 تا v5**

- v4: `parentId`
- v5: root `description`
- v6: Projects + root `projectId`
- no destructive migration
- no read-time rewrite
- safe write + tmp/bak recovery
- validated Backup/Restore
- newer unsupported schema => fail-closed

## آخرین موج‌ها
### #149 / PR #157
Home از N+1 repository read به یک snapshot در هر reload تبدیل شد. Post-main CI و Android full chain Green و Issue بسته است.

### #153
گزارش تاریخ‌محور یک‌روزه/بازه‌ای با reuse مسیر PDF/Print/Share تکمیل و بسته شده است.

### #151 / PR #159
Final PR head:
`0e27cfd8083ca5428b1fb7a321982cc6d4b7f936`

Exact-head:
- CI #396 `33209126088`: success
- UI Evidence #39 `33209126046`: success
- Android #169 `33209126028`: full chain success

Merged main:
`64460c5cb0cf1e70f6361a32acf9e77a6bfdfdfe`

Post-main:
- CI #397 `33209875036`: success
- Android #170 `33209875095`: **در حال اجرا** در لحظه آماده‌سازی این سند

#151 تا پایان Green کامل Android #170 عمداً باز نگه داشته می‌شود. این docs branch نیز قبل از آن Merge نمی‌شود.

## Release Safety
Automation:
`Fast CI → Android Build → Candidate → Smoke/Recovery → Readiness → Release Draft → Approval/Rollback`

وضعیت:
`candidate verified / governance verified / production signing blocked / not Play-Store-ready`

Production key/secret، Tag واقعی، GitHub Release و Play Store publish بدون تصمیم صریح ساخته نمی‌شوند.

## Issue #19
#19 مستقل و Platform-limited است. Ruleset فعلی PR را الزام می‌کند و deletion/non-fast-forward را می‌بندد؛ اما Ruleset Write برای required status checks در ابزار متصل موجود نیست.

Merge operational contract:
`exact head + exact-head gates + fresh scope + live mergeability + expected_head_sha + post-main proof`

## قدم محصول بعدی — #160
Today Center بر پایه فیلد اختیاری root-only به نام `nextActionAt` ساخته می‌شود؛ این فیلد با Reminder متفاوت است.

Bucket contract:
- Today: هر زمان در روز تقویمی محلی امروز
- Overdue: قبل از شروع امروز
- Upcoming: بعد از پایان امروز
- No Next Action: null

Implementation آماده دو Slice است:
1. Data/Application — schema v7 + mutations + buckets + tests
2. Product/UI — create/edit/detail + Home Today Center با reuse pickerهای فعلی

هیچ DB/Store/Calendar/Reminder موازی ساخته نمی‌شود.

## Documentation Lane
Branch:
`docs/current-state-after-151`

Scope نهایی فقط چهار سند canonical است. قبل از Merge، وضعیت Android #170 باید به Evidence نهایی Green تبدیل شود.

## Maximum Parallel
- Product / Release / Automation / Docs مستقل و موازی
- Reuse قبل از Rebuild
- کوچک‌ترین Slice برگشت‌پذیر
- stale evidence ممنوع
- main فقط از PR و exact-head merge

## Trigger
`ادامه یادنگار`

## گزارش مالک
`کجا هستیم | انجام شد | وضعیت | مانع | قدم بعد`
