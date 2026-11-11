<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@include file="../header.jsp" %>
<title>Đăng nhập - ShopMan</title>
<script>
    // neu het phien khi dang o trong cua so noi thi mo trang dang nhap o cua so chinh
    if (window.top !== window) window.top.location.href = window.location.href;
</script>
</head>
<body>
<div class="app-header"><h1>ShopMan – Đăng nhập</h1></div>
<div class="toolbar">
    <%
        String err = request.getParameter("err");
        if ("timeout".equalsIgnoreCase(err)) {
    %>      <div class="row notice">Hết phiên làm việc. Làm ơn đăng nhập lại!</div>
    <%  } else if ("fail".equalsIgnoreCase(err)) { %>
            <div class="row error" style="padding:0">Sai tên đăng nhập/mật khẩu!</div>
    <%  } else if ("role".equalsIgnoreCase(err)) { %>
            <div class="row notice">Chức năng dành cho vai trò này chưa được cài đặt.</div>
    <%  } %>
    <form name="login" action="doLogin6.jsp" method="post">
        <div class="row">
            <label class="field" for="username" style="min-width:110px">Tên đăng nhập:</label>
            <input type="text" name="username" id="username" required autofocus />
        </div>
        <div class="row">
            <label class="field" for="password" style="min-width:110px">Mật khẩu:</label>
            <input type="password" name="password" id="password" required />
        </div>
        <div class="row">
            <input type="submit" class="btn btn-primary" name="subLogin" value="Đăng nhập" />
        </div>
    </form>
</div>
</body>
</html>
