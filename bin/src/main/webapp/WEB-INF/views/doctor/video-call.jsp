<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Video Consultation | Fight D Fear</title>
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <style>
        body, html { height: 100%; margin: 0; background: #0f0f1a; color: white; overflow: hidden; }
        #meet { width: 100%; height: calc(100% - 60px); }
        .header-bar { height: 60px; background: rgba(74, 14, 120, 0.9); display: flex; align-items: center; justify-content: space-between; padding: 0 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.5); }
        .logo-text { font-family: 'Montserrat', sans-serif; font-weight: 800; font-size: 1.2rem; color: #ffd700; text-decoration: none; }
    </style>
</head>
<body>

    <div class="header-bar">
        <a href="#" class="logo-text">Fight D Fear Consultation</a>
        <div class="d-flex align-items-center gap-3">
            <span class="small text-white-50">Appt ID: #${appointment.id}</span>
            <button onclick="window.close();" class="btn btn-sm btn-outline-danger">Leave Call</button>
        </div>
    </div>

    <div id="meet"></div>

    <script src='https://meet.jit.si/external_api.js'></script>
    <script>
        const domain = 'meet.jit.si';
        const options = {
            roomName: '${roomName}',
            width: '100%',
            height: '100%',
            parentNode: document.querySelector('#meet'),
            userInfo: {
                displayName: '${displayName}'
            },
            configOverwrite: {
                startWithAudioMuted: false,
                startWithVideoMuted: false
            },
            interfaceConfigOverwrite: {
                TOOLBAR_BUTTONS: [
                    'microphone', 'camera', 'closedcaptions', 'desktop', 'fullscreen',
                    'fodeviceselection', 'hangup', 'profile', 'chat', 'recording',
                    'livestreaming', 'etherpad', 'sharedvideo', 'settings', 'raisehand',
                    'videoquality', 'filmstrip', 'invite', 'feedback', 'stats', 'shortcuts',
                    'tileview', 'videobackgroundblur', 'download', 'help', 'mute-everyone',
                    'security'
                ]
            }
        };
        const api = new JitsiMeetExternalAPI(domain, options);
    </script>
</body>
</html>


