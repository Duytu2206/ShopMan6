<%@ page pageEncoding="UTF-8"%>
<%-- Phan dung chung: CSS, ham openPage(), cua so noi (modal) va cac ham dinh dang.
     Duoc include vao <head> cua moi trang.
     Bien popup = true khi trang duoc mo ben trong cua so noi (tham so popup=1). --%>
<%
    boolean popup = "1".equals(request.getParameter("popup"));
%>
<style>
    html { color-scheme: light; background: #e6eaef; }
    * { box-sizing: border-box; }
    /* Trang chinh: khung gon o giua man hinh, giong mot cua so ung dung */
    body { margin: 32px auto; max-width: 760px; font-family: "Segoe UI", Arial, Helvetica, sans-serif;
           font-size: 14px; color: #222; background: #ffffff; border: 1px solid #c3cad3;
           box-shadow: 0 6px 24px rgba(0,0,0,.12); min-height: 440px; padding-bottom: 18px; }
    /* Trang mo trong cua so con: chiem het khung cua so con */
    body.popup { margin: 0; max-width: none; border: 0; box-shadow: none; background: #ececec;
                 min-height: 0; padding-bottom: 0; }

    /* Thanh tieu de xanh dam */
    .app-header { background: #13294b; color: #fff; padding: 12px 14px; display: flex;
                  align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 6px; }
    .app-header h1 { margin: 0; font-size: 20px; font-weight: 800; text-transform: uppercase; letter-spacing: .3px; }
    .app-header .user { font-size: 12px; color: #cfd8e6; }
    .app-header .user a { color: #fff; margin-left: 8px; }

    /* Vung cong cu (form loc) */
    .toolbar { background: #f3f5f8; padding: 10px 14px; border-bottom: 1px solid #d5dbe3; }
    .toolbar .row { display: flex; flex-wrap: wrap; align-items: center; gap: 6px 8px; margin-bottom: 8px; }
    .toolbar .row:last-child { margin-bottom: 0; }
    .toolbar .spacer { width: 14px; }
    .toolbar .btn[name=subBack] { margin-left: auto; }
    label.field { color: #333; }
    input[type=text], input[type=password], input[type=date] {
        padding: 4px 8px; font-size: 13px; border: 1px solid #b9c0c9; background: #eef0f3;
        font-family: inherit; min-height: 26px; }
    input[type=text]:focus, input[type=password]:focus, input[type=date]:focus { outline: 2px solid #7fb2e5; background: #fff; }

    /* Nut bam */
    .btn { display: inline-block; border: 1px solid #9aa4b0; background: #f6f7f9; color: #222; padding: 4px 14px;
           font-size: 13px; font-family: inherit; cursor: pointer; text-decoration: none; min-height: 26px; }
    .btn:hover { background: #e4e9ef; }
    .btn-primary { background: #1e88e5; border-color: #1e88e5; color: #fff; font-weight: 600; padding: 6px 22px; }
    .btn-primary:hover { background: #1976d2; }
    .btn-secondary { background: #607d8b; border-color: #607d8b; color: #fff; font-weight: 600; padding: 6px 22px; }
    .btn-secondary:hover { background: #546e7a; }

    .error { color: #c62828; font-weight: 600; padding: 8px 14px; }
    .notice { color: #a65f00; font-weight: 600; }
    .total { font-weight: 700; padding: 8px 14px; text-align: right; }
    .info-grid { display: grid; grid-template-columns: max-content 1fr; gap: 4px 14px; padding: 10px 14px; }
    .info-grid .k { color: #555; }

    /* Bang du lieu kieu JTable */
    .table-wrap { overflow-x: auto; margin: 14px 14px 0; border: 1px solid #c3ccd6; }
    body.popup .table-wrap { margin: 4px 12px 0; }
    .table-wrap table.grid th { border-top: 0; }
    .table-wrap table.grid tr th:first-child { border-left: 0; }
    .table-wrap table.grid tr th:last-child { border-right: 0; }
    table.grid { border-collapse: collapse; width: 100%; font-size: 13px; background: #fff; }
    table.grid th { background: #e3e9f0; border: 1px solid #b7c2cf; padding: 5px 8px; font-weight: 600; text-align: center; }
    table.grid td { border-bottom: 1px solid #e3e6ea; border-right: 1px solid #eef0f2; padding: 5px 8px; }
    table.grid tr.clickable { cursor: pointer; }
    table.grid tr.clickable:hover td { background: #e6eef8; }
    table.grid tr.selected td { background: #b8cfe8 !important; }
    table.grid td.num { text-align: right; }
    table.grid td.center { text-align: center; }
    table.grid a { color: #0b5ea8; }

    /* Panel chon bao cao */
    .panel { margin: 14px; border: 1px solid #d5dbe3; background: #f8f9fb; padding: 8px 14px; }
    .panel label { display: block; padding: 5px 0; cursor: pointer; }
    .actions { padding: 10px 14px; display: flex; gap: 8px; justify-content: flex-end; flex-wrap: wrap; }

    /* Cua so con (modal) - keo duoc bang thanh tieu de */
    .modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,.06); z-index: 1000; }
    .modal { position: absolute; background: #ececec; border: 1px solid #b9b9b9; box-shadow: 0 10px 34px rgba(0,0,0,.35);
             width: 620px; max-width: calc(100vw - 16px); display: flex; flex-direction: column; max-height: calc(100vh - 16px); }
    .modal-title { background: #f6eef0; display: flex; align-items: center; justify-content: space-between;
                   padding: 6px 8px 6px 12px; font-size: 13px; border-bottom: 1px solid #ddd;
                   cursor: move; user-select: none; touch-action: none; }
    .modal-title button { border: none; background: transparent; font-size: 18px; cursor: pointer; padding: 0 6px; line-height: 1; }
    .modal-title button:hover { background: #e81123; color: #fff; }
    .modal iframe { border: 0; width: 100%; height: 220px; background: #ececec; }

    @media (max-width: 800px) {
        body { margin: 0; border: 0; box-shadow: none; }
        .app-header h1 { font-size: 17px; }
    }
</style>
<script>
    function openPage(pageURL) {
        window.location.href = pageURL;
    }

    /** Mo mot trang JSP trong cua so noi. Luon mo o cua so ngoai cung de cac cua so xep chong len nhau. */
    function openModal(title, url) {
        if (window.top !== window && window.top.openModal) {
            window.top.openModal(title, url);
            return;
        }
        var overlay = document.createElement('div');
        overlay.className = 'modal-overlay';
        var level = document.querySelectorAll('.modal-overlay').length;
        if (level > 0) overlay.style.background = 'transparent';
        overlay.innerHTML = '<div class="modal" role="dialog" aria-modal="true">'
            + '<div class="modal-title"><span></span><button type="button" title="Đóng" aria-label="Đóng">&times;</button></div>'
            + '<iframe></iframe></div>';
        var modal = overlay.querySelector('.modal');
        var bar = overlay.querySelector('.modal-title');
        overlay.querySelector('.modal-title span').textContent = title;
        overlay.querySelector('button').onclick = closeModal;
        document.body.appendChild(overlay);

        // vi tri ban dau: giua man hinh, cua so mo sau lech xuong ben phai de thay thu tu chong
        var w = modal.offsetWidth;
        modal.style.left = Math.max(8, (window.innerWidth - w) / 2 + level * 40) + 'px';
        modal.style.top = (60 + level * 40) + 'px';

        var frame = overlay.querySelector('iframe');
        frame.onload = function () {
            try {
                var h = frame.contentDocument.documentElement.scrollHeight;
                frame.style.height = Math.min(h + 4, window.innerHeight - 80) + 'px';
            } catch (err) { /* bo qua */ }
            keepInView(modal);
        };
        frame.src = url + (url.indexOf('?') >= 0 ? '&' : '?') + 'popup=1';

        // keo cua so bang thanh tieu de
        bar.addEventListener('pointerdown', function (e) {
            if (e.target.tagName === 'BUTTON') return;
            var dx = e.clientX - modal.offsetLeft, dy = e.clientY - modal.offsetTop;
            bar.setPointerCapture(e.pointerId);
            frame.style.pointerEvents = 'none';
            function move(ev) {
                modal.style.left = (ev.clientX - dx) + 'px';
                modal.style.top = (ev.clientY - dy) + 'px';
                keepInView(modal);
            }
            function up() {
                bar.removeEventListener('pointermove', move);
                bar.removeEventListener('pointerup', up);
                frame.style.pointerEvents = '';
            }
            bar.addEventListener('pointermove', move);
            bar.addEventListener('pointerup', up);
        });
    }

    /** Giu thanh tieu de cua so con luon nam trong man hinh. */
    function keepInView(modal) {
        var maxLeft = window.innerWidth - 80, maxTop = window.innerHeight - 40;
        var left = Math.min(Math.max(modal.offsetLeft, 80 - modal.offsetWidth), maxLeft);
        var top = Math.min(Math.max(modal.offsetTop, 0), maxTop);
        modal.style.left = left + 'px';
        modal.style.top = top + 'px';
    }

    /** Dong cua so noi tren cung. */
    function closeModal() {
        if (window.top !== window && window.top.closeModal) {
            window.top.closeModal();
            return;
        }
        var list = document.querySelectorAll('.modal-overlay');
        if (list.length > 0) list[list.length - 1].remove();
        var rows = document.querySelectorAll('tr.selected');
        if (document.querySelectorAll('.modal-overlay').length === 0)
            rows.forEach(function (r) { r.classList.remove('selected'); });
    }

    /** Chon mot dong trong bang (to mau) roi mo chi tiet trong cua so noi. */
    function selectRow(row, title, url) {
        row.parentNode.querySelectorAll('tr.selected').forEach(function (r) { r.classList.remove('selected'); });
        row.classList.add('selected');
        openModal(title, url);
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeModal();
    });
</script>
<%!
    /** Dinh dang tien: 34000 -> "34,000" (giong bang mau) */
    private String fmtMoney(double value) {
        java.text.DecimalFormatSymbols sym = new java.text.DecimalFormatSymbols();
        sym.setGroupingSeparator(',');
        return new java.text.DecimalFormat("#,##0", sym).format(value);
    }

    /** Dinh dang ngay: yyyy-MM-dd (giong bang mau) */
    private String fmtDate(java.util.Date d) {
        return d == null ? "" : new java.text.SimpleDateFormat("yyyy-MM-dd").format(d);
    }

    /** Chuyen chuoi yyyy-MM-dd (gia tri cua input type=date) thanh Date; null neu sai dinh dang. */
    private java.util.Date parseDate(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        try {
            java.text.SimpleDateFormat f = new java.text.SimpleDateFormat("yyyy-MM-dd");
            f.setLenient(false);
            return f.parse(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    /** Dinh dang Date thanh yyyy-MM-dd de dua vao input type=date / tham so URL. */
    private String isoDate(java.util.Date d) {
        return d == null ? "" : new java.text.SimpleDateFormat("yyyy-MM-dd").format(d);
    }

    /** Ma hoa ky tu dac biet HTML de tranh loi hien thi / XSS. */
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }

    /** Ma hoa chuoi de dat trong chuoi JavaScript '...' nam trong thuoc tinh HTML. */
    private String js(String s) {
        if (s == null) return "";
        return esc(s.replace("\\", "\\\\").replace("'", "\\'"));
    }

    /** Ma hoa tham so tren URL. */
    private String url(String s) {
        try {
            return java.net.URLEncoder.encode(s == null ? "" : s, "UTF-8");
        } catch (Exception e) {
            return "";
        }
    }
%>
