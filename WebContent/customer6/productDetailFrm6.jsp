<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@include file="../header.jsp" %>
<title>Thông tin chi tiết mặt hàng</title>
</head>
<%
    Customer6 customer = (Customer6) session.getAttribute("customer6");
    if (customer == null) {
        response.sendRedirect("../member6/loginFrm6.jsp?err=timeout");
        return;
    }

    Product6 product = null;
    try {
        int idProduct = Integer.parseInt(request.getParameter("idProduct"));
        product = (new ProductDAO6()).getProductDetail(idProduct);
    } catch (Exception e) {
        product = null;
    }
%>
<body class="<%=popup ? "popup" : ""%>">
<% if (!popup) { %>
<div class="app-header"><h1>Thông tin chi tiết mặt hàng</h1></div>
<% } %>

<% if (product == null) { %>
    <div class="error">Không tìm thấy thông tin mặt hàng.</div>
<% } else { %>
<div class="info-grid">
    <span class="k">Mã mặt hàng:</span>  <span><b><%=product.getProductCode()%></b></span>
    <span class="k">Tên mặt hàng:</span> <span><%=esc(product.getName())%></span>
    <span class="k">Danh mục:</span>     <span><%=esc(product.getCategory().getCategoryName())%></span>
    <span class="k">Thương hiệu:</span>  <span><%=esc(product.getBrand())%></span>
    <span class="k">Đơn vị tính:</span>  <span><%=esc(product.getUnit())%></span>
    <span class="k">Đơn giá:</span>      <span><%=fmtMoney(product.getSalePrice())%> VNĐ</span>
    <span class="k">Số lượng tồn:</span> <span><%=product.getStockQuantity()%></span>
    <span class="k">Mô tả:</span>        <span><%=esc(product.getDescription())%></span>
</div>
<% } %>

<div class="actions">
    <% if (popup) { %>
        <button class="btn" name="subBack" onclick="closeModal()">Quay lại kết quả</button>
    <% } else { %>
        <button class="btn" name="subBack" onclick="history.back()">Quay lại kết quả</button>
    <% } %>
</div>
</body>
</html>
