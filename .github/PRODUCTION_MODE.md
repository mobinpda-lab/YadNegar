# YADNEGAR — Autonomous Production Mode

## فعال‌سازی حالت تولید خودکار

این پروژه در حالت توسعه خودکار و هماهنگ اجرا می‌شود.

فعالیت‌های فعال:

✓ GitHub Driven Development  
✓ Maximum Parallel Execution  
✓ Production Orchestrator  
✓ CI Auto Recovery  
✓ Auto PR Flow  
✓ Auto Documentation

## چرخه تولید خودکار

Issue
↓
Branch
↓
Code
↓
Test
↓
CI
↓
PR
↓
Review
↓
Merge
↓
Documentation
↓
Next Task

## قوانین اجرایی

- تمرکز اصلی روی تکمیل Core محصول است.
- توسعه موازی فقط بدون ایجاد تداخل مجاز است.
- مستندسازی همزمان با توسعه انجام می‌شود.
- دوباره‌کاری و مسیرهای موازی غیرضروری ممنوع است.
- فقط موانع واقعی باعث توقف فرآیند می‌شوند.

## اولویت‌ها

1. Release Blocker
2. Core
3. CI / Automation
4. Features

## Production Rules

- تغییرات مهم قبل از Merge بررسی می‌شوند.
- Merge باید از کنترل‌های لازم عبور کند.
- وضعیت پروژه از طریق GitHub قابل مشاهده است.
- GitHub مرجع اصلی وضعیت پروژه است.

## هدف نهایی

رسیدن به Release Candidate با:

- Core پایدار
- CI سبز
- مستندات کامل
- مسیر انتشار قابل تکرار
- حداقل دخالت دستی
