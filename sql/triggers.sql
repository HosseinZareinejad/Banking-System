-- 1. ثبت تاریخ ایجاد حساب جدید
CREATE OR REPLACE FUNCTION set_date_opened()
RETURNS TRIGGER AS $$
BEGIN
    NEW.DateOpened := CURRENT_DATE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_date_opened
BEFORE INSERT ON Account
FOR EACH ROW
EXECUTE FUNCTION set_date_opened();

-- 2. جلوگیری از حذف مشتری با وام‌های فعال
CREATE OR REPLACE FUNCTION prevent_customer_deletion()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Loan WHERE ApplicantID = OLD.CustomerID AND Status = 'Active') THEN
        RAISE EXCEPTION 'Cannot delete customer with active loans.';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_prevent_customer_deletion
BEFORE DELETE ON Customer
FOR EACH ROW
EXECUTE FUNCTION prevent_customer_deletion();

-- 3. به‌روزرسانی موجودی حساب پس از انجام تراکنش
CREATE OR REPLACE FUNCTION update_account_balance()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Account
    SET Balance = Balance - NEW.Amount
    WHERE AccountID = NEW.SourceID;

    UPDATE Account
    SET Balance = Balance + NEW.Amount
    WHERE AccountID = NEW.DestinationID;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_account_balance
AFTER INSERT ON Transaction
FOR EACH ROW
EXECUTE FUNCTION update_account_balance();

-- 4. بررسی موجودی کافی قبل از انجام تراکنش
CREATE OR REPLACE FUNCTION check_sufficient_balance()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT Balance FROM Account WHERE AccountID = NEW.SourceID) < NEW.Amount THEN
        RAISE EXCEPTION 'Insufficient funds for this transaction.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_sufficient_balance
BEFORE INSERT ON Transaction
FOR EACH ROW
EXECUTE FUNCTION check_sufficient_balance();
