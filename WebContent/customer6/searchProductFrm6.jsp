<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@include file="../header.jsp" %>
<title>Tìm kiếm mặt hàng</title>
</head>
<%
    request.setCharacterEncoding("UTF-8");
    Customer6 customer = (Customer6) session.getAttribute("customer6");
    if (customer == null) {
        response.sendRedirect("../member6/loginFrm6.jsp?err=timeout");
        return;
    }

    // inProductName: chi co khi khach hang bam Tim kiem
    String keyword = request.getParameter("inProductName");
    String errorMsg = null;
    ArrayList<Product6> listProduct = null;

    if (keyword != null) {
        if (keyword.trim().isEmpty()) {
            // ngoai le 5.a: tu khoa de trong
            errorMsg = "Vui lòng nhập tên mặt hàng cần tìm";
        } else {
            listProduct = (new ProductDAO6()).getProductByName(keyword.trim());
            if (listProduct.isEmpty()) {
                // ngoai le 10.a: khong tim thay mat hang
                errorMsg = "Không tìm thấy mặt hàng phù hợp";
            }
        }
    }
    session.setAttribute("listProduct", listProduct);
%>
<body>
<div class="app-header">
    <h1>Tìm kiếm mặt hàng</h1>
    <div class="user">Xin chào, <b><%=esc(customer.getFullName())%></b>
        <a href="../member6/logout6.jsp">Đăng xuất</a></div>
</div>

<form class="toolbar" name="searchProduct" action="searchProductFrm6.jsp" method="get">
    <div class="row">
        <label class="field" for="inProductName">Tên mặt hàng cần tìm:</label>
        <input type="text" name="inProductName" id="inProductName" size="40" value="<%=esc(keyword)%>" autofocus />
    </div>
    <div class="row">
        <input type="submit" class="btn btn-primary" name="subSearch" value="Tìm kiếm" />
        <button type="button" class="btn btn-secondary" name="subClear" onclick="openPage('searchProductFrm6.jsp')">Xóa</button>
        <button type="button" class="btn" name="subBack" onclick="openPage('customerHomeFrm6.jsp')">Quay lại</button>
    </div>
</form>

<% if (errorMsg != null) { %>
    <div class="error"><%=errorMsg%></div>
<% } %>

<% if (listProduct != null && !listProduct.isEmpty()) { %>
<div class="table-wrap">
<table class="grid">
    <tr>
        <th>TT</th>
        <th>Mã SP</th>
        <th>Tên mặt hàng</th>
        <th>Danh mục</th>
        <th>Đơn giá</th>
        <th>Đơn vị tính</th>
    </tr>
    <% for (int i = 0; i < listProduct.size(); i++) {
           Product6 p = listProduct.get(i);
           String detailUrl = "productDetailFrm6.jsp?idProduct=" + p.getId();
           String title = "Chi tiết mặt hàng - " + p.getName(); %>
    <tr class="clickable" tabindex="0"
        onclick="selectRow(this, '<%=js(title)%>', '<%=detailUrl%>')"
        onkeydown="if(event.key==='Enter') this.click()">
        <td class="center"><%=(i + 1)%></td>
        <td><%=p.getProductCode()%></td>
        <td><%=esc(p.getName())%></td>
        <td><%=esc(p.getCategory().getCategoryName())%></td>
        <td class="num"><%=fmtMoney(p.getSalePrice())%></td>
        <td><%=esc(p.getUnit())%></td>
    </tr>
    <% } %>
</table>
</div>
<% } %>
</body>
</html>
