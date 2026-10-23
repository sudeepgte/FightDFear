import re

with open(r'c:\local files onedrive\Desktop\WomenSafetry\FightDFear\src\main\webapp\WEB-INF\views\adminPendingDoctors.jsp', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('Doctor Verification', 'Proposal Verification')
content = content.replace('doctor profiles before they appear', 'business proposals before they appear')
content = content.replace('Total Doctors', 'Total Proposals')
content = content.replace('doctorSearchInput', 'proposalSearchInput')
content = content.replace('doctorFilterForm', 'proposalFilterForm')
content = content.replace('doctorQueueTable', 'proposalQueueTable')
content = content.replace('/admin/pending-doctors', '/admin/pending-proposals')
content = content.replace('<th>Doctor</th>', '<th>Proposal</th>')
content = content.replace('<th>Specialization</th>', '<th>Entrepreneur</th>')
content = content.replace('<th>Submitted On</th>', '<th>Funding Needed</th>')
content = content.replace('var="d"', 'var="p"')
content = content.replace('doctor-row', 'proposal-row')

# Replace table body logic
table_logic = '''              <c:choose>
                <c:when test="">
                  <c:forEach var="p" items="" varStatus="st">
                    <c:set var="stKey" value=""/>
                    <c:set var="ent" value=""/>
                    <c:set var="photo" value=""/>
                    <c:set var="pitch" value=""/>
                    <c:set var="bizPhotos" value=""/>
                    <c:set var="pct" value=""/>
                    
                    <tr class="proposal-row "
                        data-id=""
                        data-name="<c:out value=''/>"
                        data-email="<c:out value=''/>"
                        data-phone="<c:out value=''/>"
                        data-spec="<c:out value=''/>"
                        data-loc="<c:out value=''/>"
                        data-status="<c:out value=''/>"
                        data-pct=""
                        data-photo="<c:out value=''/>"
                        data-pitch=""
                        data-biz=""
                        data-photo-ok="">
                      <td>
                        <div class="ap-doc">
                          <span class="av">
                            <c:choose>
                              <c:when test="">
                                <img src="" alt="">
                              </c:when>
                              <c:otherwise></c:otherwise>
                            </c:choose>
                          </span>
                          <span style="min-width:0;">
                            <div class="nm" title="<c:out value=''/>"><c:out value=""/></div>
                            <div class="em"><c:out value=""/></div>
                          </span>
                        </div>
                      </td>
                      <td><c:out value=""/></td>
                      <td><c:out value=""/></td>
                      <td>?<c:out value=""/></td>
                      <td><span class="ap-badge st-"><i class="fas fa-circle"></i> </span></td>
                      <td style="text-align:right;">
                        <a href="/entrepreneurs/about/" class="ap-btn ap-btn-ghost ap-btn-sm"><i class="fas fa-eye"></i> View</a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="6" class="ap-empty-state">
                      <div class="ic"><i class="fas fa-inbox"></i></div>
                      No proposals in this queue.
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
'''

# Use regex to replace the old TBODY content
import re
content = re.sub(r'<tbody>.*?</tbody>', '<tbody>\\n' + table_logic + '\\n              </tbody>', content, flags=re.DOTALL)

# Replace Javascript logic for filling the preview
js_logic = '''
  var ctx = '';
  var rows = document.querySelectorAll('.proposal-row');
  var specSelect = document.getElementById('specClientFilter');

  function fillPreview(row) {
    var p = document.getElementById('previewPane');
    var ph = document.getElementById('previewHolder');
    if (!row) {
      p.style.display = 'none';
      ph.style.display = 'flex';
      return;
    }
    ph.style.display = 'none';
    p.style.display = 'flex';

    var rData = row.dataset;
    
    var nm = p.querySelector('.nm');
    var st = p.querySelector('.st');
    var em = p.querySelector('.em');
    var phn = p.querySelector('.phn');
    var bar = p.querySelector('.ap-prog-fill');
    var pctTxt = p.querySelector('.ap-prog-txt');
    var av = p.querySelector('.av');

    nm.textContent = rData.name;
    st.textContent = rData.status;
    st.className = 'st ap-badge st-' + rData.status;
    em.textContent = rData.email || '-';
    phn.textContent = rData.phone || '-';

    var pct = parseInt(rData.pct) || 0;
    bar.style.width = pct + '%';
    pctTxt.textContent = pct + '%';

    if (rData.photoOk === '1') {
      av.innerHTML = '<img src="' + (rData.photo.startsWith('http') ? rData.photo : ctx + rData.photo) + '" alt="">';
    } else {
      av.innerHTML = rData.name.charAt(0).toUpperCase();
    }

    // Docs
    var dt = p.querySelector('.ap-docs-tbl');
    if (dt) {
      dt.innerHTML = 
        <tr><td>Profile Photo</td><td class="text-end"> + (rData.photoOk === '1' ? '<span class="status ok"><i class="fas fa-check"></i> Uploaded</span>' : '<span class="status no">Not uploaded</span>') + </td></tr>
        <tr><td>Pitch Deck</td><td class="text-end"> + (rData.pitch === '1' ? '<span class="status ok"><i class="fas fa-check"></i> Uploaded</span>' : '<span class="status no">Not uploaded</span>') + </td></tr>
        <tr><td>Business Photos</td><td class="text-end"> + (rData.biz === '1' ? '<span class="status ok"><i class="fas fa-check"></i> Uploaded</span>' : '<span class="status no">Not uploaded</span>') + </td></tr>
      ;
    }

    var btnAct = document.getElementById('btnReviewAct');
    var btnView = document.getElementById('btnReviewFull');
    // For proposals, both buttons can just go to the entrepreneur's about page
    var link = ctx + '/entrepreneurs/about/' + rData.id;
    if (btnAct) btnAct.href = link;
    if (btnView) btnView.href = link;
  }
'''

content = re.sub(r'var ctx =.*?if \(btnView\) btnView\.href = link;\n  \}', js_logic.strip(), content, flags=re.DOTALL)

with open(r'c:\local files onedrive\Desktop\WomenSafetry\FightDFear\src\main\webapp\WEB-INF\views\admin\pendingProposals.jsp', 'w', encoding='utf-8') as f:
    f.write(content)
