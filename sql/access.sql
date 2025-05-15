-- ایجاد کاربر
CREATE USER "William1939" WITH PASSWORD 'Blazkowicz';


-- لغو تمام دسترسی‌های پیش‌فرض
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM William1939;

-- اعطای دسترسی فقط خواندن
GRANT SELECT ON ALL TABLES IN SCHEMA public TO William1939;

-- اطمینان از دسترسی SELECT برای جداول جدید
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO William1939;
