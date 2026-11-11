<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@include file="../header.jsp" %>
<title>Hóa đơn chi tiết</title>
</head>
<%
    Manager6 manager = (Manager6) session.getAttribute("manager6");
    if (manager == null) {
        response.sendRedirect("../member6/loginFrm6.jsp?err=timeout");
        return;
    }

    Invoice6 invoice = null;
    try {
        int idInvoice = Integer.parseInt(request.getParameter("idInvoice"));
        invoice = (new InvoiceDAO6()).getInvoiceDetail(idInvoice);
    } catch (Exception e) {
        invoice = null;
    }
%>
<body class="<%=popup ? "popup" : ""%>">
<% if (!popup) { %>
<div class="app-header"><h1>Hóa đơn chi tiết</h1></div>
<% } %>

<% if (invoice == null) { %>
    <div class="error">Không tìm thấy hóa đơn.</div>
<% } else { %>
<div class="info-grid">
    <span class="k">Mã hóa đơn:</span>  <span><b><%=invoice.getInvoiceCode()%></b></span>
    <span class="k">Ngày đặt:</span>    <span><%=fmtDate(invoice.getOrderDate())%></span>
    <span class="k">Khách hàng:</span>  <span><%=esc(invoice.getCustomer().getFullName())%>
                                              (<%=esc(invoice.getCustomer().getCustomerCode())%>)</span>
    <span class="k">Trạng thái:</span>  <span><%=invoice.getStatusText()%></span>
    <span class="k">Địa chỉ nhận:</span><span><%=esc(invoice.getShippingAddress())%></span>
</div>

<div class="table-wrap">
<table class="grid">
    <tr>
        <th>Mã SP</th>
        <th>Tên mặt hàng</th>
        <th>Số lượng</th>
        <th>Đơn giá</th>
        <th>Thành tiền</th>
    </tr>
    <% for (OrderedProduct6 op : invoice.getOrderedProducts()) { %>
    <tr>
        <td><%=op.getProduct().getProductCode()%></td>
        <td><%=esc(op.getProduct().getName())%></td>
        <td class="num"><%=op.getQuantity()%></td>
        <td class="num"><%=fmtMoney(op.getUnitPrice())%></td>
        <td class="num"><%=fmtMoney(op.getAmount())%></td>
    </tr>
    <% } %>
</table>
</div>
<div class="total">Tổng tiền hóa đơn: <%=fmtMoney(invoice.getTotalAmount())%> VNĐ</div>
<% } %>

<div class="actions">
    <% if (popup) { %>
        <button class="btn" name="subBack" onclick="closeModal()">Quay lại</button>
    <% } else { %>
        <button class="btn" name="subBack" onclick="history.back()">Quay lại</button>
    <% } %>
</div>
</body>
</html>
