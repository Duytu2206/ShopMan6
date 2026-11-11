<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@include file="../header.jsp" %>
<title>Chọn loại báo cáo</title>
</head>
<%
    Manager6 manager = (Manager6) session.getAttribute("manager6");
    if (manager == null) {
        response.sendRedirect("../member6/loginFrm6.jsp?err=timeout");
        return;
    }

    String reportType = request.getParameter("reportType");
    String errorMsg = null;
    if (request.getParameter("subNext") != null) {
        if ("customerRevenue".equals(reportType)) {
            response.sendRedirect("customerStatFrm6.jsp");
            return;
        } else if (reportType == null) {
            errorMsg = "Vui lòng chọn một loại báo cáo.";
        } else {
            errorMsg = "Loại báo cáo này chưa được cài đặt.";
        }
    }
%>
<body>
<div class="app-header">
    <h1>Chọn loại báo cáo</h1>
    <div class="user">Xin chào, <b><%=esc(manager.getFullName())%></b>
        <a href="../member6/logout6.jsp">Đăng xuất</a></div>
</div>
<% if (errorMsg != null) { %><div class="error"><%=errorMsg%></div><% } %>
<form name="selectReport" action="selectReportFrm6.jsp" method="post">
    <div class="panel">
        <label><input type="radio" name="reportType" value="import" /> Thống kê hàng nhập</label>
        <label><input type="radio" name="reportType" value="export" /> Thống kê hàng xuất</label>
        <label><input type="radio" name="reportType" value="customerRevenue" checked /> <b>Thống kê khách hàng theo doanh thu</b></label>
        <label><input type="radio" name="reportType" value="supplier" /> Thống kê nhà cung cấp</label>
    </div>
    <div class="actions" style="justify-content:flex-start">
        <input type="submit" class="btn btn-primary" name="subNext" value="Tiếp tục" />
        <button type="button" class="btn btn-secondary" name="subBack" onclick="openPage('managerHomeFrm6.jsp')">Quay lại</button>
    </div>
</form>
</body>
</html>
