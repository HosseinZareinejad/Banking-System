--1. محاسبه موجودی کل حساب‌های یک مشتری
CREATE OR REPLACE FUNCTION calculate_total_balance(customer_id INT)
RETURNS NUMERIC AS $$
DECLARE
    total_balance NUMERIC;
BEGIN
    SELECT SUM(Balance)
    INTO total_balance
    FROM Account A
    JOIN Customer C ON A.OwnerID = C.CustomerID
    WHERE C.CustomerID = customer_id;
    RETURN total_balance;
END;
$$ LANGUAGE plpgsql;

--2. بررسی وضعیت یک وام خاص
CREATE OR REPLACE FUNCTION check_loan_status(loan_id INT)
RETURNS TEXT AS $$
DECLARE
    loan_status TEXT;
BEGIN
    SELECT Status
    INTO loan_status
    FROM Loan
    WHERE LoanID = loan_id;
    RETURN loan_status;
END;
$$ LANGUAGE plpgsql;

--3. محاسبه تعداد وام‌های فعال یک مشتری
CREATE OR REPLACE FUNCTION count_active_loans(customer_id INT)
RETURNS INT AS $$
DECLARE
    active_loans_count INT;
BEGIN
    SELECT COUNT(*)
    INTO active_loans_count
    FROM Loan
    WHERE ApplicantID = customer_id AND Status = 'Active';
    RETURN active_loans_count;
END;
$$ LANGUAGE plpgsql;

--4. محاسبه مجموع پرداخت‌های انجام‌شده برای یک وام
CREATE OR REPLACE FUNCTION calculate_total_payments(loan_id INT)
RETURNS NUMERIC AS $$
DECLARE
    total_payments NUMERIC;
BEGIN
    SELECT SUM(PaymentAmount)
    INTO total_payments
    FROM LoanPayment
    WHERE LoanID = loan_id;
    RETURN total_payments;
END;
$$ LANGUAGE plpgsql;

--5. دریافت نام مشتری بر اساس شناسه
CREATE OR REPLACE FUNCTION get_customer_name(customer_id INT)
RETURNS TEXT AS $$
DECLARE
    customer_name TEXT;
BEGIN
    SELECT CONCAT(FirstName, ' ', LastName)
    INTO customer_name
    FROM Person P
    JOIN Customer C ON P.PersonID = C.PersonID
    WHERE C.CustomerID = customer_id;
    RETURN customer_name;
END;
$$ LANGUAGE plpgsql;
