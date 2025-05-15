
--اضافه کردن یک فرد جدید در جدول Person:
INSERT INTO Person (FirstName, LastName, DateOfBirth, PhoneNumber, Email, Address)
VALUES ('Ali', 'Rezaei', '1990-03-15', '09123456789', 'ali.rezaei@example.com', 'Tehran, Iran');

--افزودن یک حساب جدید برای یک فرد موجود در جدول Account:
SELECT CustomerID FROM Customer WHERE PersonID = [PersonID];--بادی پر کنیم

INSERT INTO Account (OwnerID, AccountNumber, AccountType, Balance, DateOpened, Status)
VALUES ([CustomerID], '123456789012', 'Checking', 1000, CURRENT_DATE, 'Active');--باید پر کنیم جاشو


--انتخاب و نمایش تمام تراکنش‌های مرتبط با یک حساب خاص از جدول Transaction:
SELECT * FROM Transaction WHERE SourceID = [AccountID] OR DestinationID = [AccountID];--اکانت ایدی میزاریم اونجا


--نمایش تمام وام‌های فعال از جدول Loan:
SELECT * FROM Loan WHERE Status = 'Active';


--مایش تمام حساب‌هایی که موجودی آنها از یک مقدار مشخص بیشتر است:
SELECT * FROM Account WHERE Balance > 5000;


--محاسبه مجموع کل حساب‌های هر فرد و نمایش نام و نام خانوادگی صاحب حساب به تفکیک نوع حساب:
SELECT P.FirstName, P.LastName, A.AccountType, SUM(A.Balance) AS TotalBalance
FROM Person P
JOIN Customer C ON P.PersonID = C.PersonID
JOIN Account A ON C.CustomerID = A.OwnerID
GROUP BY P.FirstName, P.LastName, A.AccountType;


--انتخاب نام، نام خانوادگی و مقدار وام کارمندانی که دارای وام‌های فعال هستند:
SELECT P.FirstName, P.LastName, L.LoanAmount
FROM Person P
JOIN Employee E ON P.PersonID = E.PersonID
JOIN Loan L ON E.EmployeeID = L.ApplicantID
WHERE L.Status = 'Active';


--نمایش نام، نام خانوادگی و تعداد حساب‌هایی که مشتریانی با بیش از یک حساب دارند:
SELECT P.FirstName, P.LastName, COUNT(A.AccountID) AS NumberOfAccounts
FROM Person P
JOIN Customer C ON P.PersonID = C.PersonID
JOIN Account A ON C.CustomerID = A.OwnerID
GROUP BY P.FirstName, P.LastName
HAVING COUNT(A.AccountID) > 1;

-----------------------------------------------------BOUNES-------------------------------------------------

--نمایش مشتریانی که بیشترین تعداد وام‌های فعال را دارند:
SELECT P.FirstName, P.LastName, COUNT(L.LoanID) AS ActiveLoans
FROM Person P
JOIN Customer C ON P.PersonID = C.PersonID
JOIN Loan L ON C.CustomerID = L.ApplicantID
WHERE L.Status = 'Active'
GROUP BY P.FirstName, P.LastName
ORDER BY ActiveLoans DESC
LIMIT 1;


--انتخاب وامی که کمترین تعداد اقساط پرداخت‌شده را داشته است:
SELECT L.LoanID, COUNT(LP.LoanPaymentID) AS PaidInstallments
FROM Loan L
LEFT JOIN LoanPayment LP ON L.LoanID = LP.LoanID AND LP.PaidDate IS NOT NULL
GROUP BY L.LoanID
ORDER BY PaidInstallments ASC
LIMIT 1;



--نمایش نام، نام خانوادگی، شناسه وام و مقدار وام مشتریانی که اقساط وام خود را به موقع پرداخت نکرده‌اند:
SELECT P.FirstName, P.LastName, L.LoanID, L.LoanAmount
FROM Person P
JOIN Customer C ON P.PersonID = C.PersonID
JOIN Loan L ON C.CustomerID = L.ApplicantID
JOIN LoanPayment LP ON L.LoanID = LP.LoanID
WHERE LP.ScheduledPaymentDate < LP.PaidDate;


--نمایش نام، نام خانوادگی و موجودی ۵ مشتری که بالاترین موجودی را در حساب‌های خود دارند:
SELECT P.FirstName, P.LastName, SUM(A.Balance) AS TotalBalance
FROM Person P
JOIN Customer C ON P.PersonID = C.PersonID
JOIN Account A ON C.CustomerID = A.OwnerID
GROUP BY P.FirstName, P.LastName
ORDER BY TotalBalance DESC
LIMIT 5;


