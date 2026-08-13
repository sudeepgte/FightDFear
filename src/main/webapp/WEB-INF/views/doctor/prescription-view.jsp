<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Prescription — Fight D Fear</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
  <style>
    *{box-sizing:border-box;margin:0;padding:0}
    body{font-family:'Poppins',sans-serif;background:#f8fafc;min-height:100vh;color:#1a1a2e;padding:24px}
    .rx-wrap{max-width:720px;margin:0 auto}
    .rx-actions{display:flex;flex-wrap:wrap;gap:10px;justify-content:flex-end;margin-bottom:16px}
    .rx-btn{display:inline-flex;align-items:center;gap:6px;padding:10px 16px;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:none;cursor:pointer;font-family:inherit}
    .rx-btn.primary{background:#312e81;color:#fff}
    .rx-btn.success{background:#0d9668;color:#fff}
    .rx-btn.muted{background:#fff;color:#1e1b4b;border:1px solid #ddd}
    .rx-card{background:#fff;border-radius:12px;box-shadow:0 8px 30px rgba(30,27,75,0.1);overflow:hidden}
    #rxPrintArea{padding:40px;background:#fff;color:#333;font-family:'Times New Roman',Times,serif}
    @media print{
      body *{visibility:hidden}
      #rxPrintArea,#rxPrintArea *{visibility:visible}
      #rxPrintArea{position:absolute;left:0;top:0;width:100%;padding:0}
      .rx-actions{display:none!important}
    }
  </style>
</head>
<body>
<div class="rx-wrap">
  <div class="rx-actions">
    <a class="rx-btn muted" href="${pageContext.request.contextPath}/doctors/myAppointments?section=prescriptions">
      <i class="bi bi-arrow-left"></i> Back
    </a>
    <a class="rx-btn success" href="${pageContext.request.contextPath}/doctors/appointments/${appointment.id}/prescription/download">
      <i class="bi bi-download"></i> Download
    </a>
    <button type="button" class="rx-btn primary" onclick="downloadPDF()"><i class="bi bi-file-earmark-pdf"></i> PDF</button>
    <button type="button" class="rx-btn muted" onclick="window.print()"><i class="bi bi-printer"></i> Print</button>
  </div>

  <div class="rx-card">
    <div id="rxPrintArea">
      <div style="display:flex;justify-content:space-between;border-bottom:2px solid #222;padding-bottom:16px;margin-bottom:16px;">
        <div>
          <h2 style="margin:0;font-size:24px;text-transform:uppercase;letter-spacing:1px;color:#222;">
            <c:out value="${appointment.doctor.fullName}"/>
          </h2>
          <div style="font-size:14px;color:#555;margin-top:4px;">
            <c:out value="${appointment.doctor.specialization}"/>
          </div>
        </div>
        <div style="text-align:right;">
          <div style="font-size:24px;font-weight:bold;color:#222;"><i class="bi bi-heart-pulse"></i></div>
          <div style="font-size:12px;font-weight:bold;margin-top:4px;text-transform:uppercase;">
            <c:out value="${empty appointment.doctor.hospitalName ? 'Fight D Fear Clinic' : appointment.doctor.hospitalName}"/>
          </div>
        </div>
      </div>

      <div style="display:flex;justify-content:space-between;border-bottom:2px solid #222;padding-bottom:12px;margin-bottom:20px;font-size:12px;">
        <div style="max-width:60%;">
          <strong>Clinic/Address:</strong>
          <c:out value="${empty appointment.doctor.clinicAddress ? '—' : appointment.doctor.clinicAddress}"/>
        </div>
        <div style="text-align:right;">
          <strong>Date &amp; Time:</strong> <c:out value="${appointment.appointmentTime}"/>
        </div>
      </div>

      <div style="margin-bottom:30px;font-size:14px;">
        <strong>Patient's Name:</strong>
        <span style="border-bottom:1px solid #888;padding:0 10px;"><c:out value="${appointment.user.fullName}"/></span>
      </div>

      <div style="min-height:240px;">
        <div style="margin-bottom:16px;font-size:28px;font-weight:700;">Rx</div>
        <div style="font-size:15px;line-height:1.6;white-space:pre-wrap;padding-left:8px;"><c:out value="${appointment.prescriptionText}"/></div>
      </div>

      <div style="margin-top:40px;border-top:1px solid #ddd;padding-top:20px;display:flex;justify-content:flex-end;">
        <div style="text-align:center;width:200px;">
          <div style="font-family:'Brush Script MT','Lucida Handwriting',cursive;font-size:24px;color:#000;margin-bottom:4px;">
            <c:out value="${appointment.doctor.fullName}"/>
          </div>
          <div style="border-bottom:1px solid #333;margin-bottom:5px;"></div>
          <div style="font-size:12px;font-weight:bold;">Signature</div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
function downloadPDF() {
  var element = document.getElementById('rxPrintArea');
  html2pdf().set({
    margin: 0.5,
    filename: 'Prescription-${appointment.id}.pdf',
    image: { type: 'jpeg', quality: 0.98 },
    html2canvas: { scale: 2 },
    jsPDF: { unit: 'in', format: 'letter', orientation: 'portrait' }
  }).from(element).save();
}
</script>
</body>
</html>
