<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Digital Ticket — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <style>
        :root {
            --bg-cream: #FFF4F6;
            --bg-card: #FDE8ED;
            --text-plum: #2D142C;
            --text-light: #6B5B68;
            --brand-pink: #F43F5E;
            --brand-rose: #F8C8D4;
            --white: #FFFFFF;
        }
        * { box-sizing: border-box; }
        body { margin: 0; font-family: Outfit, sans-serif; background: var(--bg-cream); color: var(--text-plum); }
        .wrap { max-width: 520px; margin: 32px auto; padding: 0 16px 48px; }
        .ticket {
            background: var(--white); border: 1px solid var(--brand-rose); border-radius: 24px;
            overflow: hidden; box-shadow: 0 10px 40px rgba(243,63,94,0.08);
        }
        .head { background: linear-gradient(135deg, #2D142C, #F43F5E); color: #fff; padding: 22px 24px; }
        .head h1 { margin: 0; font-size: 1.25rem; }
        .head p { margin: 6px 0 0; opacity: .9; font-size: .9rem; }
        .body { padding: 24px; }
        .row { display: flex; justify-content: space-between; gap: 12px; padding: 8px 0; font-size: .92rem; }
        .label { color: var(--text-light); }
        .val { font-weight: 700; text-align: right; }
        .qr { text-align: center; background: var(--bg-card); border-radius: 16px; padding: 20px; margin-top: 16px; }
        .qr img { width: 180px; height: 180px; background: #fff; border-radius: 12px; }
        .code { font-family: ui-monospace, monospace; font-weight: 800; letter-spacing: 2px; margin-top: 10px; }
        .actions { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 20px; }
        .btn {
            flex: 1; min-width: 140px; text-align: center; text-decoration: none; border-radius: 12px;
            padding: 12px; font-weight: 700; font-size: .9rem;
        }
        .primary { background: var(--brand-pink); color: #fff; }
        .ghost { background: var(--white); color: var(--text-plum); border: 1px solid var(--brand-rose); }
        .note { font-size: .8rem; color: var(--text-light); margin-top: 12px; }
        @media print { .actions, .note { display: none; } body { background: #fff; } }
    </style>
</head>
<body>
<div class="wrap">
    <div class="ticket">
        <div class="head">
            <h1><c:out value="${event.name}"/></h1>
            <p>Fight D Fear · Digital ticket</p>
        </div>
        <div class="body">
            <div class="row"><span class="label">Attendee</span><span class="val"><c:out value="${loggedUser.fullName}"/></span></div>
            <div class="row"><span class="label">Booking ID</span><span class="val">#${reg.id}</span></div>
            <div class="row"><span class="label">Ticket type</span><span class="val"><c:out value="${empty reg.ticketTypeName ? 'General' : reg.ticketTypeName}"/></span></div>
            <div class="row"><span class="label">Date</span><span class="val">${event.eventDate} <c:if test="${not empty event.eventTime}">${event.eventTime}</c:if></span></div>
            <div class="row"><span class="label">Venue</span><span class="val"><c:out value="${event.venue}"/>, <c:out value="${event.city}"/></span></div>
            <div class="row"><span class="label">Status</span><span class="val">${reg.status}</span></div>
            <div class="row"><span class="label">Amount paid</span><span class="val">₹${empty reg.amountPaid ? 0 : reg.amountPaid}</span></div>
            <c:if test="${reg.coinsUsed != null && reg.coinsUsed > 0}">
                <div class="row"><span class="label">Coins used</span><span class="val">${reg.coinsUsed}</span></div>
            </c:if>
            <c:if test="${not empty streamLink}">
                <div class="row"><span class="label">Online access</span><span class="val"><a href="${streamLink}">Join</a></span></div>
            </c:if>
            <div class="qr">
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=180x180&amp;data=${empty reg.qrToken ? reg.ticketCode : reg.qrToken}" alt="Ticket QR"/>
                <div class="code">${reg.ticketCode}</div>
                <div class="note">Show this QR at entry. Do not share your ticket.</div>
            </div>
            <div class="actions">
                <a class="btn primary" href="${pageContext.request.contextPath}/women-events/my-registrations">My bookings</a>
                <a class="btn ghost" href="javascript:window.print()">Print / Save</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
