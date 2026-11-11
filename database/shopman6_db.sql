-- =====================================================================
-- ShopMan6 - He thong quan ly ban hang bach hoa truc tuyen
-- Script khoi tao CSDL: bang (theo so do CSDL pha thiet ke),
-- stored procedure va du lieu mau.
-- Chay: mysql -u root -p < shopman6_db.sql   (hoac mo bang MySQL Workbench)
-- =====================================================================
DROP DATABASE IF EXISTS ShopManDB;
CREATE DATABASE ShopManDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE ShopManDB;

-- ---------------------------------------------------------------------
-- 1. BANG
-- ---------------------------------------------------------------------
CREATE TABLE tblMember6 (
    idMember      INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL UNIQUE,
    passwordHash  VARCHAR(255) NOT NULL,
    fullName      VARCHAR(150) NOT NULL,
    birthDate     DATE,
    address       VARCHAR(255),
    email         VARCHAR(150),
    phoneNumber   VARCHAR(20),
    role          VARCHAR(20)  NOT NULL,   -- customer | manager | salesstaff | deliverystaff
    notes         TEXT
);

CREATE TABLE tblCustomer6 (
    idMember         INT PRIMARY KEY,
    customerCode     VARCHAR(30) NOT NULL UNIQUE,
    registrationDate DATE,
    FOREIGN KEY (idMember) REFERENCES tblMember6(idMember)
);

CREATE TABLE tblStaff6 (
    idMember  INT PRIMARY KEY,
    position  VARCHAR(100),
    isActive  BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (idMember) REFERENCES tblMember6(idMember)
);

CREATE TABLE tblProductCategory6 (
    idCategory   INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(100) NOT NULL,
    description  TEXT
);

CREATE TABLE tblProduct6 (
    idProduct     INT AUTO_INCREMENT PRIMARY KEY,
    idCategory    INT NOT NULL,
    name          VARCHAR(180) NOT NULL,
    brand         VARCHAR(100),            -- bo sung de hien thi "Thuong hieu" tren giao dien chi tiet
    unit          VARCHAR(50),
    salePrice     DECIMAL(12,2) NOT NULL,
    stockQuantity INT DEFAULT 0,
    description   TEXT,
    imageUrl      VARCHAR(500),
    FOREIGN KEY (idCategory) REFERENCES tblProductCategory6(idCategory)
);

CREATE TABLE tblSupplier6 (
    idSupplier  INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(150) NOT NULL,
    address     VARCHAR(255),
    phoneNumber VARCHAR(20),
    email       VARCHAR(150),
    description TEXT
);

CREATE TABLE tblInvoice6 (
    idInvoice          INT AUTO_INCREMENT PRIMARY KEY,
    idCustomer         INT NOT NULL,
    approvedByStaffId  INT NULL,
    deliveryStaffId    INT NULL,
    orderDate          DATETIME NOT NULL,
    shippingAddress    VARCHAR(255),
    status             VARCHAR(30) NOT NULL,  -- NEW, APPROVED, PACKED, SHIPPING, DELIVERED, CANCELLED
    notes              TEXT,
    FOREIGN KEY (idCustomer)        REFERENCES tblCustomer6(idMember),
    FOREIGN KEY (approvedByStaffId) REFERENCES tblStaff6(idMember),
    FOREIGN KEY (deliveryStaffId)   REFERENCES tblStaff6(idMember)
);

CREATE TABLE tblOrderedProduct6 (
    idOrderedProduct INT AUTO_INCREMENT PRIMARY KEY,
    idInvoice        INT NOT NULL,
    idProduct        INT NOT NULL,
    quantity         INT NOT NULL,
    unitPrice        DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (idInvoice) REFERENCES tblInvoice6(idInvoice),
    FOREIGN KEY (idProduct) REFERENCES tblProduct6(idProduct)
);

CREATE TABLE tblGoodsReceipt6 (
    idReceipt   INT AUTO_INCREMENT PRIMARY KEY,
    idSupplier  INT NOT NULL,
    idManager   INT NOT NULL,
    receiptDate DATETIME NOT NULL,
    notes       TEXT,
    FOREIGN KEY (idSupplier) REFERENCES tblSupplier6(idSupplier),
    FOREIGN KEY (idManager)  REFERENCES tblStaff6(idMember)
);

CREATE TABLE tblReceiptItem6 (
    idReceiptItem INT AUTO_INCREMENT PRIMARY KEY,
    idReceipt     INT NOT NULL,
    idProduct     INT NOT NULL,
    quantity      INT NOT NULL,
    unitCost      DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (idReceipt) REFERENCES tblGoodsReceipt6(idReceipt),
    FOREIGN KEY (idProduct) REFERENCES tblProduct6(idProduct)
);

-- ---------------------------------------------------------------------
-- 2. STORED PROCEDURE
-- ---------------------------------------------------------------------
DELIMITER $$

-- Kiem tra dang nhap: tra ve thong tin thanh vien (+ thong tin khach hang / nhan vien neu co)
CREATE PROCEDURE checkLogin6(IN usr VARCHAR(50), IN pwdHash VARCHAR(255))
BEGIN
    SELECT m.*, c.customerCode, c.registrationDate, s.position, s.isActive
    FROM tblMember6 m
         LEFT JOIN tblCustomer6 c ON c.idMember = m.idMember
         LEFT JOIN tblStaff6 s    ON s.idMember = m.idMember
    WHERE m.username = usr AND m.passwordHash = pwdHash;
END$$

-- Module 1: tim mat hang co ten chua tu khoa
-- So sanh co phan biet dau, khong phan biet hoa thuong (utf8mb4_0900_as_ci):
-- "mì" chi khop "Mì Hảo Hảo", khong khop "Vinamilk"; "sữa" van khop "Sữa tươi".
CREATE PROCEDURE searchProductByName6(IN keyword VARCHAR(180))
BEGIN
    SELECT p.*, c.categoryName
    FROM tblProduct6 p, tblProductCategory6 c
    WHERE c.idCategory = p.idCategory
      AND p.name COLLATE utf8mb4_0900_as_ci LIKE CONCAT('%', keyword, '%') COLLATE utf8mb4_0900_as_ci
    ORDER BY p.name;
END$$

-- Module 1: lay chi tiet mot mat hang
CREATE PROCEDURE getProductDetail6(IN idPro INT)
BEGIN
    SELECT p.*, c.categoryName, c.description AS categoryDescription
    FROM tblProduct6 p, tblProductCategory6 c
    WHERE c.idCategory = p.idCategory AND p.idProduct = idPro;
END$$

-- Module 2: thong ke khach hang theo doanh thu trong khoang [startDate, endDate]
-- doanh thu = SUM(quantity * unitPrice) cua cac hoa don DA GIAO (khach da nhan hang);
-- don cho duyet / da duyet / dang giao / da huy chua chac chan thu duoc tien nen khong tinh
CREATE PROCEDURE getCustomerStatByRevenue(IN startDate DATE, IN endDate DATE)
BEGIN
    SELECT m.idMember, m.username, m.fullName, m.birthDate, m.address, m.email,
           m.phoneNumber, m.role, c.customerCode, c.registrationDate,
           COUNT(DISTINCT i.idInvoice)      AS purchaseCount,
           SUM(o.quantity * o.unitPrice)    AS totalRevenue
    FROM tblMember6 m, tblCustomer6 c, tblInvoice6 i, tblOrderedProduct6 o
    WHERE c.idMember = m.idMember
      AND i.idCustomer = c.idMember
      AND o.idInvoice = i.idInvoice
      AND i.status = 'DELIVERED'
      AND i.orderDate >= startDate
      AND i.orderDate <  DATE_ADD(endDate, INTERVAL 1 DAY)
    GROUP BY m.idMember, m.username, m.fullName, m.birthDate, m.address, m.email,
             m.phoneNumber, m.role, c.customerCode, c.registrationDate
    ORDER BY totalRevenue DESC, m.idMember;
END$$

-- Module 2: cac lan mua (hoa don da giao) cua mot khach hang trong khoang thoi gian
CREATE PROCEDURE getInvoiceOfCustomer6(IN idCus INT, IN startDate DATE, IN endDate DATE)
BEGIN
    SELECT i.*, SUM(o.quantity * o.unitPrice) AS totalAmount
    FROM tblInvoice6 i, tblOrderedProduct6 o
    WHERE o.idInvoice = i.idInvoice
      AND i.idCustomer = idCus
      AND i.status = 'DELIVERED'
      AND i.orderDate >= startDate
      AND i.orderDate <  DATE_ADD(endDate, INTERVAL 1 DAY)
    GROUP BY i.idInvoice
    ORDER BY i.orderDate;
END$$

-- Module 2: hoa don chi tiet (thong tin hoa don + khach hang + tung mat hang)
CREATE PROCEDURE getInvoiceDetail6(IN idInv INT)
BEGIN
    SELECT i.idInvoice, i.orderDate, i.shippingAddress, i.status, i.notes,
           m.idMember AS idCustomer, m.fullName, c.customerCode,
           o.idOrderedProduct, o.quantity, o.unitPrice,
           p.idProduct, p.name AS productName, p.unit
    FROM tblInvoice6 i
         JOIN tblMember6 m   ON m.idMember = i.idCustomer
         JOIN tblCustomer6 c ON c.idMember = i.idCustomer
         LEFT JOIN tblOrderedProduct6 o ON o.idInvoice = i.idInvoice
         LEFT JOIN tblProduct6 p        ON p.idProduct = o.idProduct
    WHERE i.idInvoice = idInv
    ORDER BY o.idOrderedProduct;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- 3. DU LIEU MAU (mat khau tat ca tai khoan: 123456, luu duoi dang SHA-256)
-- ---------------------------------------------------------------------
INSERT INTO tblMember6 (idMember, username, passwordHash, fullName, birthDate, address, email, phoneNumber, role) VALUES
 (1, 'manager6',  SHA2('123456',256), 'Hoàng Văn Quản',  '1990-05-12', '12 Trần Phú, Hà Đông, Hà Nội',  'manager6@shopman.vn',  '0901000001', 'manager'),
 (2, 'sales6',    SHA2('123456',256), 'Vũ Thị Bán',      '1995-03-20', '45 Quang Trung, Hà Đông',       'sales6@shopman.vn',    '0901000002', 'salesstaff'),
 (3, 'delivery6', SHA2('123456',256), 'Ngô Văn Giao',    '1993-11-02', '8 Lê Lợi, Hà Đông',             'delivery6@shopman.vn', '0901000003', 'deliverystaff'),
 (4, 'customer6', SHA2('123456',256), 'Nguyễn Văn A',    '2000-01-15', '10 Chùa Bộc, Đống Đa, Hà Nội',  'nva@gmail.com',        '0912000004', 'customer'),
 (5, 'tranthib',  SHA2('123456',256), 'Trần Thị B',      '1998-07-08', '123 Nguyễn Trãi, Hà Nội',       'ttb@gmail.com',        '0912000005', 'customer'),
 (6, 'levanc',    SHA2('123456',256), 'Lê Văn C',        '1997-09-21', '56 Kim Mã, Ba Đình, Hà Nội',    'lvc@gmail.com',        '0912000006', 'customer'),
 (7, 'phamthud',  SHA2('123456',256), 'Phạm Thu D',      '1999-12-30', '7 Hàng Bài, Hoàn Kiếm, Hà Nội', 'ptd@gmail.com',        '0912000007', 'customer'),
 (8, 'dominhf',   SHA2('123456',256), 'Đỗ Minh F',       '2001-04-04', '99 Xuân Thủy, Cầu Giấy, Hà Nội','dmf@gmail.com',        '0912000008', 'customer');

INSERT INTO tblStaff6 (idMember, position, isActive) VALUES
 (1, 'Quản lí cửa hàng', TRUE),
 (2, 'Nhân viên bán hàng', TRUE),
 (3, 'Nhân viên giao hàng', TRUE);

INSERT INTO tblCustomer6 (idMember, customerCode, registrationDate) VALUES
 (4, 'KH001', '2026-01-10'),
 (5, 'KH002', '2026-02-14'),
 (6, 'KH009', '2026-03-01'),
 (7, 'KH003', '2026-03-15'),
 (8, 'KH004', '2026-04-20');

INSERT INTO tblProductCategory6 (idCategory, categoryName, description) VALUES
 (1, 'Sữa',     'Sữa và các chế phẩm từ sữa'),
 (2, 'Gạo',     'Gạo các loại'),
 (3, 'Dầu ăn',  'Dầu ăn thực vật'),
 (4, 'Mì gói',  'Mì, phở, bún ăn liền'),
 (5, 'Gia vị',  'Nước mắm, nước tương, gia vị');

-- ma san pham hien thi = 'SP' + idProduct (3 chu so), vi du idProduct 12 -> SP012
INSERT INTO tblProduct6 (idProduct, idCategory, name, brand, unit, salePrice, stockQuantity, description, imageUrl) VALUES
 (7,  3, 'Dầu ăn Simply 1L',            'Simply',    'Chai',  62000,  300, 'Dầu đậu nành nguyên chất',            NULL),
 (12, 1, 'Sữa tươi Vinamilk 1L',        'Vinamilk',  'Hộp',   34000,  480, 'Sữa tươi tiệt trùng nguyên chất 100%', NULL),
 (13, 1, 'Sữa chua Vinamilk',           'Vinamilk',  'Hộp',    7000,  900, 'Sữa chua ăn có đường',                NULL),
 (14, 1, 'Sữa đặc Ông Thọ',             'Vinamilk',  'Lon',   26000,  350, 'Sữa đặc có đường',                    NULL),
 (18, 1, 'Sữa tươi TH true MILK 1L',    'TH true MILK','Hộp', 36000,  260, 'Sữa tươi sạch tiệt trùng',            NULL),
 (21, 4, 'Mì Hảo Hảo (thùng 30 gói)',   'Acecook',   'Thùng', 115000, 120, 'Mì tôm chua cay',                     NULL),
 (35, 2, 'Gạo ST25 túi 5kg',            'ST25',      'Túi',   185000, 150, 'Gạo thơm ST25 Sóc Trăng',             NULL),
 (44, 5, 'Nước mắm Nam Ngư 500ml',      'Chin-su',   'Chai',  28000,  410, 'Nước mắm cá cơm',                     NULL);

INSERT INTO tblSupplier6 (idSupplier, name, address, phoneNumber, email, description) VALUES
 (1, 'Công ty CP Sữa Việt Nam', '10 Tân Trào, Q.7, TP.HCM', '02854155555', 'contact@vinamilk.com.vn', 'Nhà cung cấp sữa'),
 (2, 'Công ty Lương thực Sóc Trăng', 'Sóc Trăng', '02993822222', 'st25@gao.vn', 'Nhà cung cấp gạo');

INSERT INTO tblGoodsReceipt6 (idReceipt, idSupplier, idManager, receiptDate, notes) VALUES
 (1, 1, 1, '2026-07-31 09:00:00', 'Nhập sữa tháng 8'),
 (2, 2, 1, '2026-07-31 10:00:00', 'Nhập gạo tháng 8');

INSERT INTO tblReceiptItem6 (idReceipt, idProduct, quantity, unitCost) VALUES
 (1, 12, 500, 28000),
 (1, 18, 300, 30000),
 (2, 35, 200, 160000);

-- Hoa don: ma hien thi = 'HD' + idInvoice (5 chu so), vi du 231 -> HD00231
INSERT INTO tblInvoice6 (idInvoice, idCustomer, approvedByStaffId, deliveryStaffId, orderDate, shippingAddress, status, notes) VALUES
 (150, 8, 2, 3,    '2026-07-20 10:00:00', '99 Xuân Thủy, Cầu Giấy, Hà Nội', 'DELIVERED', NULL),
 (231, 5, 2, 3,    '2026-08-03 08:30:00', '123 Nguyễn Trãi, Hà Nội',        'DELIVERED', NULL),
 (247, 6, 2, 3,    '2026-08-07 14:00:00', '56 Kim Mã, Ba Đình, Hà Nội',     'DELIVERED', NULL),
 (268, 5, 2, 3,    '2026-08-15 19:45:00', '123 Nguyễn Trãi, Hà Nội',        'DELIVERED', NULL),
 (290, 7, NULL, NULL,'2026-08-20 11:00:00', '7 Hàng Bài, Hoàn Kiếm, Hà Nội', 'CANCELLED', 'Khách hủy đơn'),
 (300, 6, 2, 3,    '2026-08-31 18:30:00', '56 Kim Mã, Ba Đình, Hà Nội',     'SHIPPING',  NULL),
 (310, 4, NULL, NULL,'2026-09-02 09:15:00', '10 Chùa Bộc, Đống Đa, Hà Nội', 'NEW',       NULL);

INSERT INTO tblOrderedProduct6 (idInvoice, idProduct, quantity, unitPrice) VALUES
 (150, 7,  2, 62000),    -- 124.000 (thang 7)
 (231, 12, 12, 34000),   -- 408.000
 (231, 35, 2, 185000),   -- 370.000  => HD00231 = 778.000
 (247, 35, 3, 185000),   -- HD00247 = 555.000
 (268, 35, 2, 185000),   -- HD00268 = 370.000
 (290, 21, 5, 115000),   -- hoa don bi huy, khong tinh doanh thu
 (300, 44, 5, 28000),    -- HD00300 = 140.000 (ngay cuoi thang 8)
 (310, 12, 1, 34000);    -- thang 9

-- Ket qua mong doi khi thong ke 01/08/2026 - 31/08/2026 (chi tinh hoa don DA GIAO):
--   1. KH002 Tran Thi B : 2 luot mua, 1.148.000
--   2. KH009 Le Van C   : 1 luot mua,   555.000  (HD00300 dang giao -> chua tinh)
--   KH003 khong co (HD00290 da huy); KH001 khong co (HD00310 cho duyet, thang 9)
