import java.nio.file.*;
import java.util.regex.*;

public class Rewrite {
    public static void main(String[] args) throws Exception {
        String content = Files.readString(Path.of("src/main/webapp/WEB-INF/views/adminPendingDoctors.jsp"));
        
        content = content.replace("Doctor Verification", "Proposal Verification");
        content = content.replace("doctor profiles before they appear", "business proposals before they appear");
        content = content.replace("Total Doctors", "Total Proposals");
        content = content.replace("doctorSearchInput", "proposalSearchInput");
        content = content.replace("doctorFilterForm", "proposalFilterForm");
        content = content.replace("doctorQueueTable", "proposalQueueTable");
        content = content.replace("/admin/pending-doctors", "/admin/pending-proposals");
        content = content.replace("<th>Doctor</th>", "<th>Proposal</th>");
        content = content.replace("<th>Specialization</th>", "<th>Entrepreneur</th>");
        content = content.replace("<th>Submitted On</th>", "<th>Funding Needed</th>");
        content = content.replace("var=\"d\"", "var=\"p\"");
        content = content.replace("doctor-row", "proposal-row");
        
        String tableLogic = "              <c:choose>\\n" +
"                <c:when test=\\"\\">\\n" +
"                  <c:forEach var=\\"p\\" items=\\"\\" varStatus=\\"st\\">\\n" +
"                    <c:set var=\\"stKey\\" value=\\"\\"/>\\n" +
"                    <c:set var=\\"ent\\" value=\\"\\"/>\\n" +
"                    <c:set var=\\"photo\\" value=\\"\\"/>\\n" +
"                    <c:set var=\\"pitch\\" value=\\"\\"/>\\n" +
"                    <c:set var=\\"bizPhotos\\" value=\\"\\"/>\\n" +
"                    <c:set var=\\"pct\\" value=\\"\\"/>\\n" +
"                    \\n" +
"                    <tr class=\\"proposal-row \\"\\n" +
"                        data-id=\\"\\"\\n" +
"                        data-name=\\"<c:out value=''/>\\"\\n" +
"                        data-email=\\"<c:out value=''/>\\"\\n" +
"                        data-phone=\\"<c:out value=''/>\\"\\n" +
"                        data-spec=\\"<c:out value=''/>\\"\\n" +
"                        data-loc=\\"<c:out value=''/>\\"\\n" +
"                        data-status=\\"<c:out value=''/>\\"\\n" +
"                        data-pct=\\"\\"\\n" +
"                        data-photo=\\"<c:out value=''/>\\"\\n" +
"                        data-pitch=\\"\\"\\n" +
"                        data-biz=\\"\\"\\n" +
"                        data-photo-ok=\\"\\">\\n" +
"                      <td>\\n" +
"                        <div class=\\"ap-doc\\">\\n" +
"                          <span class=\\"av\\">\\n" +
"                            <c:choose>\\n" +
"                              <c:when test=\\"\\">\\n" +
"                                <img src=\\"\\" alt=\\"\\">\\n" +
"                              </c:when>\\n" +
"                              <c:otherwise></c:otherwise>\\n" +
"                            </c:choose>\\n" +
"                          </span>\\n" +
"                          <span style=\\"min-width:0;\\">\\n" +
"                            <div class=\\"nm\\" title=\\"<c:out value=''/>\\"><c:out value=\\"\\"/></div>\\n" +
"                            <div class=\\"em\\"><c:out value=\\"\\"/></div>\\n" +
"                          </span>\\n" +
"                        </div>\\n" +
"                      </td>\\n" +
"                      <td><c:out value=\\"\\"/></td>\\n" +
"                      <td><c:out value=\\"\\"/></td>\\n" +
"                      <td>\\u20B9<c:out value=\\"\\"/></td>\\n" +
"                      <td><span class=\\"ap-badge st-\\"><i class=\\"fas fa-circle\\"></i> </span></td>\\n" +
"                      <td style=\\"text-align:right;\\">\\n" +
"                        <a href=\\"/entrepreneurs/about/\\" class=\\"ap-btn ap-btn-ghost ap-btn-sm\\"><i class=\\"fas fa-eye\\"></i> View</a>\\n" +
"                      </td>\\n" +
"                    </tr>\\n" +
"                  </c:forEach>\\n" +
"                </c:when>\\n" +
"                <c:otherwise>\\n" +
"                  <tr>\\n" +
"                    <td colspan=\\"6\\" class=\\"ap-empty-state\\">\\n" +
"                      <div class=\\"ic\\"><i class=\\"fas fa-inbox\\"></i></div>\\n" +
"                      No proposals in this queue.\\n" +
"                    </td>\\n" +
"                  </tr>\\n" +
"                </c:otherwise>\\n" +
"              </c:choose>";
              
        content = content.replaceAll("<tbody>(?s).*?</tbody>", "<tbody>\\n" + Matcher.quoteReplacement(tableLogic) + "\\n              </tbody>");

        String jsLogic = "var ctx = '';\\n" +
"  var rows = document.querySelectorAll('.proposal-row');\\n" +
"  var specSelect = document.getElementById('specClientFilter');\\n" +
"\\n" +
"  function fillPreview(row) {\\n" +
"    var p = document.getElementById('previewPane');\\n" +
"    var ph = document.getElementById('previewHolder');\\n" +
"    if (!row) {\\n" +
"      p.style.display = 'none';\\n" +
"      ph.style.display = 'flex';\\n" +
"      return;\\n" +
"    }\\n" +
"    ph.style.display = 'none';\\n" +
"    p.style.display = 'flex';\\n" +
"\\n" +
"    var rData = row.dataset;\\n" +
"    \\n" +
"    var nm = p.querySelector('.nm');\\n" +
"    var st = p.querySelector('.st');\\n" +
"    var em = p.querySelector('.em');\\n" +
"    var phn = p.querySelector('.phn');\\n" +
"    var bar = p.querySelector('.ap-prog-fill');\\n" +
"    var pctTxt = p.querySelector('.ap-prog-txt');\\n" +
"    var av = p.querySelector('.av');\\n" +
"\\n" +
"    nm.textContent = rData.name;\\n" +
"    st.textContent = rData.status;\\n" +
"    st.className = 'st ap-badge st-' + rData.status;\\n" +
"    em.textContent = rData.email || '-';\\n" +
"    phn.textContent = rData.phone || '-';\\n" +
"\\n" +
"    var pct = parseInt(rData.pct) || 0;\\n" +
"    bar.style.width = pct + '%';\\n" +
"    pctTxt.textContent = pct + '%';\\n" +
"\\n" +
"    if (rData.photoOk === '1') {\\n" +
"      av.innerHTML = '<img src=\"' + (rData.photo.startsWith('http') ? rData.photo : ctx + rData.photo) + '\" alt=\"\">';\\n" +
"    } else {\\n" +
"      av.innerHTML = rData.name.charAt(0).toUpperCase();\\n" +
"    }\\n" +
"\\n" +
"    var dt = p.querySelector('.ap-docs-tbl');\\n" +
"    if (dt) {\\n" +
"      dt.innerHTML = \\n" +
"        <tr><td>Profile Photo</td><td class=\"text-end\"> + (rData.photoOk === '1' ? '<span class=\"status ok\"><i class=\"fas fa-check\"></i> Uploaded</span>' : '<span class=\"status no\">Not uploaded</span>') + </td></tr>\\n" +
"        <tr><td>Pitch Deck</td><td class=\"text-end\"> + (rData.pitch === '1' ? '<span class=\"status ok\"><i class=\"fas fa-check\"></i> Uploaded</span>' : '<span class=\"status no\">Not uploaded</span>') + </td></tr>\\n" +
"        <tr><td>Business Photos</td><td class=\"text-end\"> + (rData.biz === '1' ? '<span class=\"status ok\"><i class=\"fas fa-check\"></i> Uploaded</span>' : '<span class=\"status no\">Not uploaded</span>') + </td></tr>\\n" +
"      ;\\n" +
"    }\\n" +
"\\n" +
"    var btnAct = document.getElementById('btnReviewAct');\\n" +
"    var btnView = document.getElementById('btnReviewFull');\\n" +
"    var link = ctx + '/entrepreneurs/about/' + rData.id;\\n" +
"    if (btnAct) btnAct.href = link;\\n" +
"    if (btnView) btnView.href = link;\\n" +
"  }";

        content = content.replaceAll("var ctx =(?s).*?if \\(btnView\\) btnView\\.href = link;\\n  \\}", Matcher.quoteReplacement(jsLogic));

        Files.writeString(Path.of("src/main/webapp/WEB-INF/views/admin/pendingProposals.jsp"), content);
    }
}
