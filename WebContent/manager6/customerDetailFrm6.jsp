<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@include file="../header.jsp" %>
<title>Lịch sử mua hàng của khách hàng</title>
</head>
<%
    Manager6 manager = (Manager6) session.getAttribute("manager6");
    if (manager == null) {
        response.sendRedirect("../member6/loginFrm6.jsp?err=timeout");
        return;
    }

    String inStartDate = request.getParameter("inStartDate");
    String inEndDate = request.getParameter("inEndDate");
    Date startDate = parseDate(inStartDate);
    Date endDate = parseDate(inEndDate);
    int idCustomer = -1;
    try {
        idCustomer = Integer.parseInt(request.getParameter("idCustomer"));
    } catch (Exception e) {
        idCustomer = -1;
    }

    // lay thong tin khach hang tu danh sach thong ke da luu trong session
    CustomerStat6 customer = null;
    ArrayList<CustomerStat6> listCustomerStat = (ArrayList<CustomerStat6>) session.getAttribute("listCustomerStat");
    if (listCustomerStat != null)
        for (CustomerStat6 cs : listCustomerStat)
            if (cs.getId() == idCustomer) {
                customer = cs;
                break;
            }

    ArrayList<Invoice6> listInvoice = (new InvoiceDAO6()).getInvoiceOfCustomer(idCustomer, startDate, endDate);
    session.setAttribute("listInvoice", listInvoice);
    String period = "inStartDate=" + url(inStartDate) + "&inEndDate=" + url(inEndDate);
%>
<body class="<%=popup ? "popup" : ""%>">
<% if (!popup) { %>
<div class="app-header"><h1>Lịch sử mua hàng của khách hàng</h1></div>
<% } %>

<div class="info-grid">
    <span class="k">Khách hàng:</span>
    <span><b><%=customer != null ? esc(customer.getFullName()) : ""%></b>
          (<%=customer != null ? esc(customer.getCustomerCode()) : ""%>)</span>
    <span class="k">Thời gian:</span>
    <span><%=fmtDate(startDate)%> → <%=fmtDate(endDate)%></span>
</div>

<% if (listInvoice.isEmpty()) { %>
    <div class="error">Khách hàng không có lần mua nào trong khoảng thời gian đã chọn.</div>
<% } else {
       double sumRevenue = 0; %>
<div class="table-wrap">
<table class="grid">
    <tr>
        <th>Mã HĐ</th>
        <th>Ngày đặt</th>
        <th>Địa chỉ nhận</th>
        <th>Tổng tiền</th>
        <th>Trạng thái</th>
    </tr>
    <% for (int i = 0; i < listInvoice.size(); i++) {
           Invoice6 inv = listInvoice.get(i);
           sumRevenue += inv.getTotalAmount();
           String detailUrl = "invoiceDetailFrm6.jsp?idInvoice=" + inv.getId();
           String title = "Chi tiết hóa đơn - " + inv.getInvoiceCode(); %>
    <tr class="clickable" tabindex="0"
        onclick="selectRow(this, '<%=js(title)%>', '<%=detailUrl%>')"
        onkeydown="if(event.key==='Enter') this.click()">
        <td><%=inv.getInvoiceCode()%></td>
        <td><%=fmtDate(inv.getOrderDate())%></td>
        <td><%=esc(inv.getShippingAddress())%></td>
        <td class="num"><%=fmtMoney(inv.getTotalAmount())%></td>
        <td><%=inv.getStatusText()%></td>
    </tr>
    <% } %>
</table>
</div>
<div class="total">Tổng doanh thu của khách hàng: <%=fmtMoney(sumRevenue)%> VNĐ</div>
<% } %>

<div class="actions">
    <% if (popup) { %>
        <button class="btn" name="subBack" onclick="closeModal()">Quay lại</button>
    <% } else { %>
        <button class="btn" name="subBack" onclick="openPage('customerStatFrm6.jsp?<%=period%>')">Quay lại</button>
    <% } %>
</div>
</body>
</html>
