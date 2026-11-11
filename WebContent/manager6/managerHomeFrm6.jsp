<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@include file="../header.jsp" %>
<title>Trang chủ quản lí</title>
</head>
<%
    Manager6 manager = (Manager6) session.getAttribute("manager6");
    if (manager == null) {
        response.sendRedirect("../member6/loginFrm6.jsp?err=timeout");
        return;
    }
%>
<body>
<div class="app-header">
    <h1>Trang chủ quản lí</h1>
    <div class="user">Xin chào, <b><%=esc(manager.getFullName())%></b>
        <a href="../member6/logout6.jsp">Đăng xuất</a></div>
</div>
<div class="toolbar">
    <div class="row">
        <button class="btn btn-primary" name="subViewReport" onclick="openPage('selectReportFrm6.jsp')">Xem báo cáo thống kê</button>
    </div>
</div>
</body>
</html>
