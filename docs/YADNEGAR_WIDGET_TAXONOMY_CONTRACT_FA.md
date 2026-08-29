# قرارداد ویجت و Taxonomy یادنگار

مرجع: Issue #174

## قرارداد بصری ویجت
- پس‌زمینه اصلی ویجت سفید است؛ کرم، بژ یا رنگ مشابه استفاده نشود.
- تمام عنوان‌ها، تاریخ‌ها و ساعت‌ها فارسی و RTL باشند.
- تاریخ‌ها جلالی و ساعت‌ها ۲۴ ساعته باشند.
- ساختار بصری مرجع شامل چهار بخش است: «ویجت یادنگار»، «تنظیمات ویجت»، «دسته‌بندی‌ها»، «تگ‌ها».
- لیست ویجت از Root Taskهای canonical ساخته شود و ظاهر آن با Home یادنگار هم‌خانواده بماند.

## رفتار ویجت
- کلیک روی هر ردیف، همان Task را داخل برنامه باز کند.
- فیلتر زمانی: امروز / هفته جاری / همه.
- فیلتر اختیاری: پروژه / دسته‌بندی / تگ.
- تعداد آیتم‌های قابل نمایش قابل تنظیم باشد.
- Refresh امن و Empty State فارسی داشته باشد.
- تنظیم ظاهر ساده مجاز است، اما foundation دوم UI یا storage ساخته نشود.

## قرارداد Taxonomy
- Category و Tag موجودیت‌های مستقل از Project هستند.
- هر Root Task حداکثر یک Category دارد.
- هر Root Task می‌تواند صفر، یک یا چند Tag داشته باشد.
- FollowUp مالک مستقل Project/Category/Tag نیست و context را از Parent می‌گیرد.
- افزودن، ویرایش و حذف Category/Tag باید از منوی برنامه قابل دسترسی باشد.
- حذف باید امن باشد و داده Task را حذف نکند.

## معماری
- GitHub Reality منبع حقیقت است.
- همان JSON persistence foundation موجود توسعه یابد.
- store/database دوم برای Category، Tag یا Widget ممنوع است.
- Widget فقط projection/cache مشتق‌شده است و منبع حقیقت مستقل نیست.
- Reuse Before Add.
- Migration باید backward-compatible و safe-write باشد.

## Validation
- Fast CI، UI Evidence و Android Full Chain روی exact head.
- Android device/emulator evidence برای Widget.
- Persian/RTL/Jalali/24h validation.
- Backup/Restore و schema regression.
- Fresh Compare behind=0، expected-head merge و Post-main proof.

Baseline هنگام ثبت قرارداد: `3211ebed6b554e0cd7b233b0b163cf6f80c247b0`.
هر baseline تاریخی با حرکت main باید با Fresh Audit جایگزین شود.
