# ShopMan6 – Hệ thống quản lý bán hàng bách hóa trực tuyến

Bài tập học phần Phân tích và thiết kế hệ thống thông tin (INT1342M) – đề 36, pha cài đặt.
Phần cài đặt gồm 2 module:

1. **Khách hàng tìm kiếm mặt hàng**: `customerHomeFrm6` → `searchProductFrm6` → `productDetailFrm6`
2. **Nhân viên quản lí thống kê khách hàng theo doanh thu**: `managerHomeFrm6` → `selectReportFrm6` → `customerStatFrm6` → `customerDetailFrm6` → `invoiceDetailFrm6`

Kiến trúc 3 tầng J2EE: trình duyệt ↔ Tomcat (JSP + DAO + model) ↔ MySQL (JDBC, cổng 3306).
Code tổ chức theo chương 5 của bài giảng: trang JSP gọi trực tiếp lớp DAO, DAO gọi stored procedure qua `CallableStatement` và đóng gói kết quả vào các lớp model.

## Cấu trúc thư mục

```
ShopMan6/
├── database/shopman6_db.sql     Bảng (tbl...6), stored procedure, dữ liệu mẫu
├── src/
│   ├── model/                   Lớp thực thể: Member6, Staff6, Manager6, Customer6, CustomerStat6,
│   │                            Product6, ProductCategory6, Invoice6, OrderedProduct6, ...
│   ├── dao/                     DAO6 (kết nối dùng chung), MemberDAO6, ProductDAO6,
│   │                            CustomerStatDAO6, InvoiceDAO6
│   └── db.properties.example    Mẫu cấu hình kết nối CSDL
├── test/unittest/               Kiểm thử đơn vị JUnit 4 cho các lớp DAO
├── WebContent/                  Tầng giao diện (view)
│   ├── header.jsp               CSS + hàm dùng chung (include vào mọi trang)
│   ├── member6/                 Đăng nhập / đăng xuất
│   ├── customer6/               Trang của khách hàng (module 1)
│   ├── manager6/                Trang của nhân viên quản lí (module 2)
│   └── WEB-INF/web.xml
├── scripts/                     Script PowerShell: setup-libs, build, run-tests, run-tomcat
└── .vscode/                     Cấu hình VS Code + task
```

Các thư mục `tools/` (Tomcat), `lib/`, `WebContent/WEB-INF/lib/` (file .jar) và `WebContent/WEB-INF/classes/`
không có trên GitHub: chúng được tạo ra khi chạy `setup-libs` và `build`.

## Cài đặt và chạy (Windows)

Yêu cầu: **JDK 17+** và **MySQL Server 8**. Nên dùng VS Code (có sẵn task trong `.vscode/tasks.json`).

1. **Tải mã nguồn**
   ```
   git clone <link repository>
   cd ShopMan6
   ```
2. **Tạo CSDL**: mở `database/shopman6_db.sql` trong MySQL Workbench và chạy (Execute All), hoặc
   ```
   mysql -u root -p --default-character-set=utf8mb4 -e "source database/shopman6_db.sql"
   ```
3. **Cấu hình kết nối CSDL**: sao chép `src/db.properties.example` thành `src/db.properties`,
   sửa `db.user`, `db.password` (và cổng trong `db.url` nếu MySQL không chạy ở cổng 3306).
   File `src/db.properties` đã được khai báo trong `.gitignore`, không bị đẩy lên GitHub.
4. **Tải thư viện và Tomcat** (1 lần):
   ```
   powershell -ExecutionPolicy Bypass -File scripts/setup-libs.ps1
   ```
   Tải mysql-connector-j 8.4.0, junit 4.13.2, hamcrest 1.3 (Maven Central) và Tomcat 10.1.34 (archive.apache.org).
5. **Chạy kiểm thử đơn vị**:
   ```
   powershell -ExecutionPolicy Bypass -File scripts/run-tests.ps1
   ```
6. **Chạy web**:
   ```
   powershell -ExecutionPolicy Bypass -File scripts/run-tomcat.ps1
   ```
   rồi mở <http://localhost:8080/ShopMan6/>. Bấm Ctrl + C trong terminal để dừng server.

Trong VS Code có thể chạy bước 4–6 qua **Terminal → Run Task…**.

> Lưu ý: `localhost` là máy của chính người chạy. Mỗi người cần tự tạo CSDL và chạy Tomcat trên máy mình.

## Tài khoản mẫu

Mật khẩu tất cả tài khoản mẫu: `123456`.

| Tài khoản   | Vai trò            |
|-------------|--------------------|
| `customer6` | Khách hàng (KH001) |
| `manager6`  | Nhân viên quản lí  |

## Dữ liệu để thử

- Tìm kiếm: nhập `sữa` → 4 mặt hàng; nhập `mì` → 1 mặt hàng; nhập `abc` → "Không tìm thấy mặt hàng phù hợp".
- Thống kê từ 01/08/2026 đến 31/08/2026 → KH002 Trần Thị B (2 lượt, 1.148.000 VNĐ), KH009 Lê Văn C (1 lượt, 555.000 VNĐ).
  Chỉ hóa đơn **Đã giao** mới được tính doanh thu: HD00300 (đang giao), HD00290 (đã hủy), HD00310 (chờ duyệt) không được tính.

## Ghi chú so với thiết kế

- Bảng `tblProduct6` có thêm cột `brand` để hiển thị "Thương hiệu" như trên thiết kế giao diện chi tiết mặt hàng.
- Mã mặt hàng/hóa đơn hiển thị được sinh từ id: `SP` + 3 chữ số (SP012), `HD` + 5 chữ số (HD00231).
- Kiểu tiền dùng `double` (thay vì `float`) để tổng doanh thu lớn không bị sai số.
- Doanh thu, số lượt mua, tổng tiền hóa đơn là thuộc tính dẫn xuất: tính bằng SUM/COUNT trong stored procedure, không lưu trong CSDL.
- Doanh thu chỉ tính hóa đơn có trạng thái `DELIVERED` (Đã giao), vì đơn chờ duyệt / đã duyệt / đang giao chưa chắc khách nhận hàng.
- Tìm kiếm mặt hàng phân biệt dấu nhưng không phân biệt hoa thường (`utf8mb4_0900_as_ci`).
