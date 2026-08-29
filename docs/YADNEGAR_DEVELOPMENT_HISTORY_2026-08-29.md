# تاریخچه تجمیعی توسعه یادنگار

آخرین به‌روزرسانی این سند: 2026-08-29

این فایل یک رکورد تاریخی/تحویلی (handoff) است. هدف آن این است که مسیر تصمیم‌ها، Issueها، PRها، SHAها، تست‌ها، خطاهای کشف‌شده، اصلاحات و نقطه ادامه پروژه یادنگار در GitHub متمرکز و قابل بازیابی باشد. این سند جایگزین کد، Issueها یا PRها نیست؛ بلکه به آن‌ها ارجاع می‌دهد.

## 1) قرارداد ثابت توسعه

- Repository: `mobinpda-lab/YadNegar`
- هیچ تغییر مستقیمی روی `main` انجام نشود؛ مسیر استاندارد Branch → PR → Gates → Merge است.
- قبل از Merge: Fresh Audit، Exact Head SHA، Scope، `behind=0`، CI، Android Build، UI Evidence برای تغییرات UI، Smoke/Recovery، Release Readiness، Release Draft و Release Approval بررسی شوند.
- Merge با `expected_head_sha` انجام شود و بعد از Merge، Post-main Proof روی SHA جدید main ثبت شود.
- اصل معماری: یک Timeline/Repository/JSON storage؛ از ایجاد store یا engine موازی خودداری شود.
- سرعت نباید Data Safety، rollback، tests یا documentation را تضعیف کند.

## 2) مدل محصول تثبیت‌شده

- Root Task = «کار» اصلی.
- FollowUp = «پیگیری» فرزند یک کار؛ هویت مستقل پروژه/Next Action ندارد.
- Project = موجودیت مستقل و رنگی برای گروه‌بندی کارها؛ با Tag یکی نیست.
- Tag در صورت توسعه آتی باید مستقل از Project باقی بماند.
- هر Root Task می‌تواند شرح اختیاری داشته باشد و صفر یا چند FollowUp داشته باشد.
- در نسخه فعلی هر Root Task حداکثر یک `projectId` دارد.
- FollowUp پروژه مستقل ندارد و context پروژه را از Root می‌گیرد.
- Reminder = زمان اعلان/Notification.
- Next Action = برنامه کاربر برای اقدام/پیگیری بعدی و عمداً از Reminder مستقل است.

اصل مفهومی: `کار ≠ پیگیری ≠ پروژه ≠ تگ ≠ یادآوری ≠ اقدام بعدی`.

## 3) مسیر مهم Featureها و PRها

### گزارش تاریخ‌محور — Issue #153 / PR #154

- Issue: `#153` — گزارش‌گیری تاریخ‌محور PDF/Print برای یک تاریخ یا بازه زمانی.
- PR: `#154` — `feat: add date-based PDF reports and Persian pickers`.
- Exact PR head: `08fb9366225c96a5e5404c1d4e1e49a4febf43e6`.
- Merge commit روی main: `9b80451ea0cc8234939230a76330f5a01017210b`.
- نتیجه: Persian Jalali month-grid picker، 24-hour time picker، گزارش تک‌روز/بازه inclusive، PDF/Print/Share با reuse مسیر موجود.
- CI، UI Evidence و Android full chain برای exact head سبز شدند.

### Projects — Issue #155 / PR #156

- Issue: `#155` — پروژه‌های مستقل و رنگی برای گروه‌بندی کارها.
- PR: `#156` — `feat: add first-class colored Projects for tracked tasks`.
- Exact PR head: `3da9e3989f0b9bb83010922d2bd7f6a19629f1da`.
- Merge commit روی main: `b4504f11a8eed99cc3c2c03c4e436d6c953aba78`.
- schema از v5 به v6 رفت.
- Projects در همان `timeline.json` ذخیره می‌شوند؛ store دوم ایجاد نشد.
- حذف Project غیرخالی در application layer ممنوع شد.
- title/color پروژه قابل ویرایش شد و create/edit task امکان انتخاب/پاک‌کردن Project گرفت.
- Backup/Restore شامل Projects و `projectId` شد.
- exact-head CI، UI Evidence و Android full chain سبز شدند.

### Performance Home snapshot — Issue #149 / PR #150 و مسیر جایگزین

- Issue: `#149` — load tracked tasks/follow-ups از یک repository snapshot.
- PR قدیمی: `#150`، branch `perf/tracked-subject-home-snapshot`، head تاریخی `c08c7627f8a2e3c37e48e451e8a1443059845674`.
- پس از Merge شدن Projects و تغییرات Home، branch قدیمی 3 commit از main عقب افتاد و نباید مستقیم Merge می‌شد.
- قرارداد تصمیم: optimization باید روی main جدید port شود و Home جدید/Projects حفظ شوند؛ PR قدیمی به‌عنوان historical/superseded در نظر گرفته شود.
- در وضعیت بعدی پروژه، Home single-snapshot projection به‌عنوان زیرساخت قابل reuse تثبیت شد و Issue #160 نیز صریحاً باید از همین projection استفاده کند.

### UX Home/FollowUp — Issue #151

- درخواست‌ها: «بسم‌الله الرحمن الرحیم» بالای Home، تقویم شمسی جدولی، ساعت dial 24h، Swipe دوطرفه روی task برای ایجاد FollowUp بدون حذف task.
- Date Picker و Time Picker در PR #154 وارد شدند.
- باقی موارد بعداً تکمیل شدند: Bismillah + swipe دوطرفه امن؛ swipe باید editor پیگیری همان Root را باز کند و هرگز task را حذف نکند.
- بعد از تکمیل این موج، main پیش از موج Today Center روی `64460c5cb0cf1e70f6361a32acf9e77a6bfdfdfe` بوده و مستندات canonical در PR #162 همگام شدند.

### Canonical docs sync — PR #162

- PR #162 مستندات continuation/operation/comprehensive را با وضعیت بعد از Issue #151 و schema v6 همگام کرد.
- Merge commit مستندات روی main: `400611415f4a355a3c16ed0ee2443578b3ee5e96`.
- CI push روی این main نیز سبز ثبت شد.

## 4) Today Center / Next Action — Issue #160

Issue: `#160` — «Today Center: اقدام بعدی، امروز، عقب‌افتاده و آینده بدون تداخل با Reminder».

### قرارداد محصول

- Root Task دارای `nextActionAt` اختیاری است.
- `nextActionAt` از `reminderAt` مستقل است.
- FollowUp نمی‌تواند `nextActionAt` داشته باشد.
- bucketها persist نمی‌شوند و از data واقعی مشتق می‌شوند:
  - Today
  - Overdue
  - Upcoming
  - No Next Action
- مرز Today بر اساس روز تقویمی محلی است؛ زمان گذشته در همان روز هنوز Today محسوب می‌شود.
- UI از Persian/Jalali picker و 24h picker موجود reuse می‌کند.
- Home filtering باید از snapshot موجود انجام شود و repository read اضافه ایجاد نکند.

### Slice A — Data/Application — PR #161

- PR: `#161` — `feat(today): add root next-action schema v7 foundation`.
- Final exact head: `4d0348d9c65332c9155b2e77190d1b66673ceacd`.
- Fresh Compare پیش از Merge: `behind=0` و دقیقاً 7 فایل.
- تغییرات اصلی:
  - `TimelineItem.nextActionAt`
  - `QuickCapture` set support
  - `EditTimelineItem` replace/clear support
  - classifier برای Today/Overdue/Upcoming/No Next Action
  - JSON schema v7
  - backward-compatible reads برای v1-v6
  - Project schema boundary مستقل در v6 حفظ شد
  - FollowUp + nextActionAt نامعتبر است
- تست‌ها: bucket boundaries، v6→v7 safe upgrade، v7 round-trip، استقلال Reminder، invalid FollowUp ownership.
- exact-head CI سبز.
- exact-head UI Evidence سبز.
- Android full chain سبز: Build، Release Candidate، Smoke/Recovery، Release Readiness، Release Draft، Release Approval.
- PR با `expected_head_sha=4d0348d...` Merge شد.
- Merge commit رسمی main: `9b1d3bf52913b99dc1869f81975e8e8981075214`.

### Slice B — UI — PR #164

- PR: `#164` — `feat(today): complete Today Center and Next Action UI`.
- Branch: `feat/today-center-main`.
- آخرین Head مشاهده‌شده هنگام نگارش این سند: `4dcb64f3da3f4e2954b548b4c782737a2b44cb11`.
- Fresh Compare بعد از Merge #161: `behind=0` و Scope فقط 7 فایل UI/Test.
- UI پیاده‌شده:
  - Create Task: تعیین اختیاری Next Action با Jalali month grid + 24h dial.
  - Edit Task: set/change/clear Next Action.
  - Detail: نمایش صریح Next Action یا «تعیین نشده».
  - Home: شمارنده/فیلتر Today، Overdue، Upcoming، No Next Action.
  - نمایش compact Next Action روی کارت task.
  - filtering فقط از snapshot موجود Home؛ repository read جدید اضافه نشده.

### Regression/Test history در Slice B

در Full Tests چند failure در تست‌های قدیمی Home آشکار شد. منطق Data/Analyze/UI Evidence سالم بود و علت، lazy rendering / viewport و نوع Finder در تست‌ها بود.

1. Failure اولیه: کارت task در viewport کوچک دیگر ساخته نشده بود چون Today Center بالای لیست ارتفاع اضافه کرده بود.
2. تلاش بعدی با `scrollUntilVisible` و key مستقیم ListView به خطای cast منجر شد، چون Finder به `ListView` اشاره می‌کرد نه `Scrollable`.
3. Finder descendant به دلیل چند Scrollable تو در تو `Too many elements` داد.
4. اصلاح نهایی تست‌ها به drag مستقیم روی ListView کلیددار تغییر یافت تا تست به implementation داخلی Scrollable وابسته نباشد.

در تمام این اصلاحات، product logic دست نخورده ماند؛ اصلاحات در test harness انجام شد.

### وضعیت دقیق PR #164 در زمان ثبت این سند

- State: Open.
- Draft: Yes.
- Mergeable: true در آخرین fetch.
- Latest head: `4dcb64f3da3f4e2954b548b4c782737a2b44cb11`.
- UI Evidence روی headهای قبلی چندبار سبز شده است؛ برای Merge فقط Evidence مربوط به exact latest head معتبر است.
- CI run نهایی برای latest head هنگام ثبت این سند هنوز در حال اجرا/تکمیل بود.
- Android run نهایی برای latest head نیز هنوز در حال اجرا بود.
- بنابراین این سند عمداً PR #164 و Issue #160 را «Completed/Merged» اعلام نمی‌کند.
- تبدیل Draft به Ready از طریق connector یک خطای GitHub GraphQL schema داد؛ اگر همچنان برقرار بود، می‌توان PR non-draft جدید با همان Head ساخت یا وضعیت را از UI GitHub اصلاح کرد. این خطا مربوط به کد محصول نیست.

## 5) نکات Data Safety / Migration

- schema فعلی main پس از #161: v7.
- schema v7 افزایشی است و v1-v6 باید خوانده شوند.
- migration با read-time destructive rewrite انجام نمی‌شود؛ upgrade روی safe write رخ می‌دهد.
- Projects از v6 موجودند و schema boundary آن‌ها با افزایش schema به v7 حفظ شده است.
- Backup/Restore و crash-safe JSON write path نباید دور زده شوند.
- `nextActionAt` تنها روی Root persist می‌شود.
- Reminder recurrence و notification semantics نباید با Next Action ادغام شوند.

## 6) وضعیت main در لحظه ثبت

- Exact main SHA: `9b1d3bf52913b99dc1869f81975e8e8981075214`.
- آخرین feature ادغام‌شده روی main: Slice A / schema v7 Next Action foundation.
- PR #164 هنوز خارج از main است.

## 7) نقطه ادامه اجباری

برای ادامه Issue #160:

1. `main` و PR #164 را Fresh Fetch کن.
2. Exact latest head #164 را مشخص کن؛ اگر از `4dcb64f...` جلو رفته، این سند historical است و head جدید مبناست.
3. exact-head CI + UI Evidence + Android full chain را بررسی کن.
4. Fresh Compare باید `behind=0` و Scope فقط UI/Test مورد انتظار باشد.
5. PR باید Ready/non-draft و mergeable باشد.
6. Merge فقط با `expected_head_sha` دقیق.
7. Post-main Proof روی SHA جدید main.
8. Issue #160 را فقط پس از Post-main Proof ببند.
9. canonical docs را از schema v6 wording به schema v7 + Today Center نهایی sync کن.

## 8) سیاست گزارش‌دهی و ادامه توسعه

حالت کاری پروژه: Maximum Parallel — سریع، خودکار، مستند، با گزارش کوتاه غیر فنی. Laneهای مستقل می‌توانند هم‌زمان جلو بروند، اما هر Merge باید exact-head و gated باشد. هر failure باید از log واقعی تحلیل شود و patch حدسی ممنوع است.

---

این سند snapshot تاریخی است. GitHub (`main`, Issueها، PRها و workflow runs) منبع حقیقت نهایی برای وضعیت زنده پروژه است.