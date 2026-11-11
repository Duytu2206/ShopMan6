<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@include file="../header.jsp" %>
<title>Thống kê khách hàng theo doanh thu</title>
</head>
<%
    Manager6 manager = (Manager6) session.getAttribute("manager6");
    if (manager == null) {
        response.sendRedirect("../member6/loginFrm6.jsp?err=timeout");
        return;
    }

    String inStartDate = request.getParameter("inStartDate");
    String inEndDate = request.getParameter("inEndDate");
    String errorMsg = null;
    ArrayList<CustomerStat6> listCustomerStat = null;

    if (inStartDate == null && inEndDate == null) {
        // lan dau mo trang: mac dinh la ngay dau va ngay cuoi cua thang hien tai
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.DAY_OF_MONTH, 1);
        inStartDate = isoDate(cal.getTime());
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        inEndDate = isoDate(cal.getTime());
    } else {
        // nguoi dung bam Xem thong ke
        Date startDate = parseDate(inStartDate);
        Date endDate = parseDate(inEndDate);
        if (startDate == null || endDate == null) {
            errorMsg = "Vui lòng chọn ngày bắt đầu và ngày kết thúc hợp lệ";
        } else if (startDate.after(endDate)) {
            // ngoai le 8.a
            errorMsg = "Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc";
        } else {
            listCustomerStat = (new CustomerStatDAO6()).getCustomerStatByRevenue(startDate, endDate);
            if (listCustomerStat.isEmpty()) {
                // ngoai le 14.a
                errorMsg = "Không có dữ liệu thống kê trong khoảng thời gian đã chọn";
            }
        }
    }
    session.setAttribute("listCustomerStat", listCustomerStat);
    String period = "inStartDate=" + url(inStartDate) + "&inEndDate=" + url(inEndDate);
%>
<body>
<div class="app-header">
    <h1>Thống kê khách hàng theo doanh thu</h1>
    <div class="user">Xin chào, <b><%=esc(manager.getFullName())%></b>
        <a href="../member6/logout6.jsp">Đăng xuất</a></div>
</div>

<form class="toolbar" name="customerStat" action="customerStatFrm6.jsp" method="get">
    <div class="row">
        <label class="field" for="inStartDate">Từ ngày:</label>
        <input type="date" name="inStartDate" id="inStartDate" value="<%=esc(inStartDate)%>" required />
        <button type="button" class="btn" onclick="pickDate('inStartDate')">Chọn ngày</button>
        <span class="spacer"></span>
        <label class="field" for="inEndDate">Đến ngày:</label>
        <input type="date" name="inEndDate" id="inEndDate" value="<%=esc(inEndDate)%>" required />
        <button type="button" class="btn" onclick="pickDate('inEndDate')">Chọn ngày</button>
    </div>
    <div class="row">
        <input type="submit" class="btn btn-primary" name="subStat" value="Thống kê" />
        <button type="button" class="btn btn-secondary" name="subClear" onclick="openPage('customerStatFrm6.jsp')">Xóa</button>
        <button type="button" class="btn" name="subBack" onclick="openPage('selectReportFrm6.jsp')">Quay lại</button>
    </div>
</form>
<script>
    function pickDate(id) {
        var el = document.getElementById(id);
        if (el.showPicker) el.showPicker(); else el.focus();
    }
</script>

<% if (errorMsg != null) { %>
    <div class="error"><%=errorMsg%></div>
<% } %>

<% if (listCustomerStat != null && !listCustomerStat.isEmpty()) { %>
<div class="table-wrap">
<table class="grid">
    <tr>
        <th>TT</th>
        <th>Mã KH</th>
        <th>Tên khách hàng</th>
        <th>Số lượt mua</th>
        <th>Tổng doanh thu</th>
    </tr>
    <% for (int i = 0; i < listCustomerStat.size(); i++) {
           CustomerStat6 cs = listCustomerStat.get(i);
           String detailUrl = "customerDetailFrm6.jsp?idCustomer=" + cs.getId() + "&" + period;
           String title = "Lịch sử mua hàng - " + cs.getFullName() + " (" + cs.getCustomerCode() + ")"; %>
    <tr class="clickable" tabindex="0"
        onclick="selectRow(this, '<%=js(title)%>', '<%=esc(detailUrl)%>')"
        onkeydown="if(event.key==='Enter') this.click()">
        <td class="center"><%=(i + 1)%></td>
        <td><%=esc(cs.getCustomerCode())%></td>
        <td><%=esc(cs.getFullName())%></td>
        <td class="num"><%=cs.getPurchaseCount()%></td>
        <td class="num"><%=fmtMoney(cs.getTotalRevenue())%></td>
    </tr>
    <% } %>
</table>
</div>
<% } %>
</body>
</html>
