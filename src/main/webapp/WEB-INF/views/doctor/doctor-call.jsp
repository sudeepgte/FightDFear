<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${audioOnly ? 'Voice' : 'Video'} Call — Dr. ${doctor.fullName}</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap">
  <style>
    *{box-sizing:border-box;margin:0;padding:0}
    body,html{height:100%;overflow:hidden;background:#0f0a1e;font-family:'Poppins',sans-serif}
    .call-header{height:56px;background:linear-gradient(135deg,rgba(74,14,120,0.95),rgba(123,44,191,0.95));display:flex;align-items:center;justify-content:space-between;padding:0 20px;z-index:10;position:relative}
    .call-header .brand{font-size:15px;font-weight:800;color:#ffd700;display:flex;align-items:center;gap:8px}
    .call-header .brand i{font-size:20px}
    .call-info{display:flex;align-items:center;gap:10px;color:#fff;font-size:13px}
    .call-info .badge{padding:3px 10px;border-radius:999px;font-size:10px;font-weight:700}
    .call-info .badge.video{background:rgba(74,144,217,0.2);color:#4a90d9}
    .call-info .badge.voice{background:rgba(32,201,151,0.2);color:#20c997}
    .call-leave{padding:6px 16px;border-radius:999px;border:2px solid rgba(255,107,107,0.5);background:transparent;color:#f43f5e;font-size:12px;font-weight:600;font-family:'Poppins',sans-serif;cursor:pointer;transition:all 0.2s;display:flex;align-items:center;gap:5px}
    .call-leave:hover{background:#f43f5e;color:#fff}
    #meet{width:100%;height:calc(100vh - 56px)}
  </style>
</head>
<body>
  <div class="call-header">
    <div class="brand"><i class="bi bi-heart-pulse"></i> SafeHer</div>
    <div class="call-info">
      <span>Dr. ${doctor.fullName}</span>
      <span class="badge ${audioOnly ? 'voice' : 'video'}">
        <i class="bi ${audioOnly ? 'bi-telephone-fill' : 'bi-camera-video-fill'}"></i>
        ${audioOnly ? 'Voice Call' : 'Video Call'}
      </span>
    </div>
    <button class="call-leave" onclick="leaveCall()"><i class="bi bi-x-circle"></i> Leave</button>
  </div>
  <div id="meet"></div>

  <script src="https://meet.jit.si/external_api.js"></script>
  <script>
    const domain = 'meet.jit.si';
    const options = {
      roomName: '${roomName}',
      width: '100%',
      height: '100%',
      parentNode: document.querySelector('#meet'),
      userInfo: { displayName: '${displayName}' },
      configOverwrite: {
        startWithAudioMuted: false,
        startWithVideoMuted: ${audioOnly}
      },
      interfaceConfigOverwrite: {
        TOOLBAR_BUTTONS: [
          'microphone','camera','hangup','chat','desktop',
          'fullscreen','raisehand','tileview','settings'
        ],
        SHOW_JITSI_WATERMARK: false,
        SHOW_WATERMARK_FOR_GUESTS: false
      }
    };
    const api = new JitsiMeetExternalAPI(domain, options);
    api.addEventListener('readyToClose', function() {
      window.close();
      window.location.href = '${pageContext.request.contextPath}/doctors/view/${doctor.id}';
    });
    function leaveCall() {
      api.dispose();
      window.close();
      window.location.href = '${pageContext.request.contextPath}/doctors/view/${doctor.id}';
    }
  </script>
</body>
</html>

