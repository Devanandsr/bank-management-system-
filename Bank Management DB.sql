create Database Bank_management_db;
use Bank_management_db;

create table branches (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    branch_code VARCHAR(20) UNIQUE,
    ifsc_code VARCHAR(20) UNIQUE,
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10),
    phone VARCHAR(15)
);
select * from branches;

create table customers (
customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender VARCHAR(10),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15) UNIQUE,
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10),
    branch_id INT,

    FOREIGN KEY (branch_id)
    REFERENCES branches(branch_id)
);

CREATE TABLE  employees
(
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    designation VARCHAR(50),
    salary DECIMAL(12,2),
    joining_date DATE,
    branch_id INT,
    status VARCHAR(20) DEFAULT 'Active',

    FOREIGN KEY (branch_id)
    REFERENCES branches(branch_id)
);


CREATE TABLE account_types
(
    account_type_id INT AUTO_INCREMENT PRIMARY KEY,
    account_type_name VARCHAR(50) NOT NULL UNIQUE,
    minimum_balance DECIMAL(12,2) DEFAULT 0,
    interest_rate DECIMAL(5,2) DEFAULT 0,
    description VARCHAR(200)
);


CREATE TABLE  accounts
(
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    account_number VARCHAR(30) NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    account_type_id INT NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0,
    opening_date DATE,
    account_status VARCHAR(20) DEFAULT 'Active',

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id),

    FOREIGN KEY (branch_id)
    REFERENCES branches(branch_id),

    FOREIGN KEY (account_type_id)
    REFERENCES account_types(account_type_id),

    CHECK (balance >= 0)
);

CREATE TABLE  transactions
(
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_type VARCHAR(30),
    amount DECIMAL(15,2) NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(200),
    transaction_status VARCHAR(20) DEFAULT 'Success',

    FOREIGN KEY (account_id)
    REFERENCES accounts(account_id),

    CHECK (amount > 0)
);


CREATE TABLE beneficiaries
(
    beneficiary_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    beneficiary_name VARCHAR(100) NOT NULL,
    bank_name VARCHAR(100),
    account_number VARCHAR(30) NOT NULL,
    ifsc_code VARCHAR(20),
    nickname VARCHAR(50),
    added_date DATE,
    status VARCHAR(20) DEFAULT 'Active',

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);

CREATE TABLE  transfers
(
    transfer_id INT AUTO_INCREMENT PRIMARY KEY,
    from_account_id INT NOT NULL,
    to_account_id INT NOT NULL,
    beneficiary_id INT,
    amount DECIMAL(15,2) NOT NULL,
    transfer_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    transfer_mode VARCHAR(20),
    transfer_status VARCHAR(20) DEFAULT 'Pending',

    FOREIGN KEY (from_account_id)
    REFERENCES accounts(account_id),

    FOREIGN KEY (to_account_id)
    REFERENCES accounts(account_id),

    FOREIGN KEY (beneficiary_id)
    REFERENCES beneficiaries(beneficiary_id),

    CHECK (amount > 0)
);

CREATE TABLE loans
(
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT,
    loan_type VARCHAR(50),
    loan_amount DECIMAL(15,2) NOT NULL,
    interest_rate DECIMAL(5,2),
    loan_term_months INT,
    loan_date DATE,
    loan_status VARCHAR(20) DEFAULT 'Pending',

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id),

    FOREIGN KEY (branch_id)
    REFERENCES branches(branch_id),

    CHECK (loan_amount > 0)
);


CREATE TABLE loan_payments
(
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    payment_amount DECIMAL(15,2) NOT NULL,
    payment_date DATE,
    payment_method VARCHAR(30),
    payment_status VARCHAR(20) DEFAULT 'Success',

    FOREIGN KEY (loan_id)
    REFERENCES loans(loan_id),

    CHECK (payment_amount > 0)
);

CREATE TABLE cards
(
    card_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    card_type VARCHAR(20),
    card_number VARCHAR(30) NOT NULL UNIQUE,
    issue_date DATE,
    expiry_date DATE,
    card_status VARCHAR(20) DEFAULT 'Active',

    FOREIGN KEY (account_id)
    REFERENCES accounts(account_id)
);

CREATE TABLE atm_transactions
(
    atm_transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    card_id INT NOT NULL,
    account_id INT NOT NULL,
    atm_location VARCHAR(150),
    transaction_type VARCHAR(30),
    amount DECIMAL(15,2),
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    transaction_status VARCHAR(20),

    FOREIGN KEY (card_id)
    REFERENCES cards(card_id),

    FOREIGN KEY (account_id)
    REFERENCES accounts(account_id),

    CHECK (amount > 0)
);


CREATE TABLE  interest_rates
(
    interest_rate_id INT AUTO_INCREMENT PRIMARY KEY,
    product_type VARCHAR(50) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    effective_from DATE,
    effective_to DATE,
    status VARCHAR(20) DEFAULT 'Active',

    CHECK (interest_rate >= 0)
);

CREATE TABLE  fixed_deposits
(
    fd_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_id INT NOT NULL,
    interest_rate_id INT,
    principal_amount DECIMAL(15,2) NOT NULL,
    interest_rate DECIMAL(5,2),
    duration_months INT,
    opening_date DATE,
    maturity_date DATE,
    maturity_amount DECIMAL(15,2),
    fd_status VARCHAR(20) DEFAULT 'Active',

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id),

    FOREIGN KEY (account_id)
    REFERENCES accounts(account_id),

    FOREIGN KEY (interest_rate_id)
    REFERENCES interest_rates(interest_rate_id),

    CHECK (principal_amount > 0)
);

CREATE TABLE complaints
(
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    employee_id INT,
    complaint_type VARCHAR(100),
    complaint_description TEXT,
    complaint_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    complaint_status VARCHAR(30) DEFAULT 'Pending',
    resolution_date DATE,

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id),

    FOREIGN KEY (employee_id)
    REFERENCES employees(employee_id)
);

CREATE TABLE kyc_documents
(
    kyc_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    document_type VARCHAR(50),
    document_reference VARCHAR(100),
    submission_date DATE,
    verification_status VARCHAR(30) DEFAULT 'Pending',
    verification_date DATE,

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);

CREATE TABLE  audit_logs
(
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    customer_id INT,
    action_type VARCHAR(50),
    table_name VARCHAR(100),
    record_id INT,
    action_description TEXT,
    action_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (employee_id)
    REFERENCES employees(employee_id),

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);


show tables;

SHOW CREATE TABLE customers;
SHOW CREATE TABLE accounts;
SHOW CREATE TABLE transactions;

SHOW CREATE TABLE accounts;


SELECT *
FROM accounts
WHERE balance IS NULL
   OR opening_date IS NULL
   OR account_status IS NULL;
   
SHOW CREATE TABLE customers;


SELECT COUNT(*) AS total_tables
FROM information_schema.tables
WHERE table_schema = 'bank_management_db';