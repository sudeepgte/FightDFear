import re

with open('src/main/webapp/WEB-INF/views/doctor/doctor-view.jsp', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix reason duplication
content = re.sub(
    r"const reason = \(document\.getElementById\('appointmentReason'\)\.value \|\| ''\)\.trim\(\);\s*const reason = document\.getElementById\('reason'\)\.value;",
    r"const reason = (document.getElementById('appointmentReason').value || '').trim();",
    content
)

# Fix object keys duplication
content = re.sub(
    r"type: 'DOCTOR', targetId: doctorId, amount,\s*appointmentTime: time, consultationType: type,\s*reason: reason\s*type: 'DOCTOR', targetId: doctorId, amount, reason: reason,\s*appointmentTime: time, consultationType: type",
    r"type: 'DOCTOR', targetId: doctorId, amount, reason: reason,\n                appointmentTime: time, consultationType: type",
    content
)

# Fix textarea HTML duplication
content = re.sub(
    r"<label class="small fw-800 text-muted mb-2 d-block" for="appointmentReason">REASON FOR VISIT</label>\s*<textarea id="appointmentReason" class="form-control rounded-3 py-2" rows="3" maxlength="500"\s*placeholder="Briefly describe your symptoms or reason for consultation \(optional\)"></textarea>\s*<div class="d-flex justify-content-between mt-1">\s*<span class="small text-muted">Shown to your doctor after booking</span>\s*<span class="small text-muted"><span id="reasonCount">0</span>/500</span>\s*</div>\s*<label class="small fw-800 text-muted mb-2 d-block">REASON FOR VISIT</label>\s*<textarea id="reason" class="form-control rounded-3 py-2" rows="2" placeholder="Briefly describe your symptoms or reason for visit \(optional\)"></textarea>",
    r"<label class="small fw-800 text-muted mb-2 d-block" for="appointmentReason">REASON FOR VISIT</label>\n              <textarea id="appointmentReason" class="form-control rounded-3 py-2" rows="3" maxlength="500" onkeyup="document.getElementById('reasonCount').innerText = this.value.length;"\n                        placeholder="Briefly describe your symptoms or reason for consultation (optional)"></textarea>\n              <div class="d-flex justify-content-between mt-1">\n                <span class="small text-muted">Shown to your doctor after booking</span>\n                <span class="small text-muted"><span id="reasonCount">0</span>/500</span>\n              </div>",
    content
)


with open('src/main/webapp/WEB-INF/views/doctor/doctor-view.jsp', 'w', encoding='utf-8') as f:
    f.write(content)
