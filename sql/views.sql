--customer_accounts view
CREATE VIEW customer_accounts AS
SELECT
    P.FirstName AS CustomerFirstName,
    P.LastName AS CustomerLastName,
    P.PhoneNumber AS CustomerPhone,
    A.AccountNumber AS AccountNumber,
    A.AccountType AS AccountType,
    A.Balance AS AccountBalance
FROM
    Person P
JOIN Customer C ON P.PersonID = C.PersonID
JOIN Account A ON C.CustomerID = A.OwnerID;


--bank_transactions view
CREATE VIEW bank_transactions AS
SELECT
    T.TransactionID AS TransactionID,
    A1.AccountNumber AS SourceAccount,
    A2.AccountNumber AS DestinationAccount,
    T.Amount AS TransactionAmount,
    T.TransactionDate AS TransactionDate
FROM
    Transaction T
JOIN Account A1 ON T.SourceID = A1.AccountID
JOIN Account A2 ON T.DestinationID = A2.AccountID;


--bank_member view
CREATE VIEW bank_member AS
SELECT
    P.FirstName AS MemberFirstName,
    P.LastName AS MemberLastName,
    CASE
        WHEN E.EmployeeID IS NOT NULL THEN 'Employee'
        WHEN C.CustomerID IS NOT NULL THEN 'Customer'
        ELSE 'Unknown'
    END AS Role,
    P.Email AS MemberEmail,
    P.PhoneNumber AS MemberPhone
FROM
    Person P
LEFT JOIN Employee E ON P.PersonID = E.PersonID
LEFT JOIN Customer C ON P.PersonID = C.PersonID;
