<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@include file="../header.jsp" %>
<title>Trang chủ khách hàng</title>
</head>
<%
    Customer6 customer = (Customer6) session.getAttribute("customer6");
    if (customer == null) {
        response.sendRedirect("../member6/loginFrm6.jsp?err=timeout");
        return;
    }
%>
<body>
<div class="app-header">
    <h1>Trang chủ khách hàng</h1>
    <div class="user">Xin chào, <b><%=esc(customer.getFullName())%></b>
        <a href="../member6/logout6.jsp">Đăng xuất</a></div>
</div>
<div class="toolbar">
    <div class="row">
        <button class="btn btn-primary" name="subSearchProduct" onclick="openPage('searchProductFrm6.jsp')">Tìm kiếm mặt hàng</button>
    </div>
</div>
</body>
</html>
