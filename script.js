const fs = require('fs');
const centre = fs.readFileSync('src/main/webapp/WEB-INF/views/aboutCentre.jsp', 'utf8');
let entre = fs.readFileSync('src/main/webapp/WEB-INF/views/aboutEntrepreneur.jsp', 'utf8');

const headMatch = centre.match(/<head>[\s\S]*?<\/head>/);
let headHtml = headMatch ? headMatch[0] : '';
headHtml = headHtml.replace(/<title>.*?<\/title>/, '<title><c:out value="\"/> — Entrepreneur Profile Review | Fight D Fear Admin</title>');

entre = entre.replace(/<head>[\s\S]*?<\/head>/, headHtml);

const wrapperMatch = centre.match(/(<c:choose>[\s\S]*?<div class=\"review-container\".*?>)[\s\S]*?(<!-- Flash messages -->|<!-- 60\/30\/10)/);
if (wrapperMatch) {
    let wrapperHtml = wrapperMatch[1];
    
    // Customize back-nav inside wrapper
    wrapperHtml = wrapperHtml.replace(/<a href=\"\\/admin\/martialManagement\".*?>[\s\S]*?<\/a>/, '<a href=\"\/admin/pending-entrepreneurs\" class=\"back-nav\"><i class=\"bi bi-arrow-left\"></i> Back to Entrepreneur Management</a>');
    wrapperHtml = wrapperHtml.replace(/<a href=\"\\/admin\/martialManagement\">Martial Arts Centres<\/a>/, '<a href=\"\/admin/pending-entrepreneurs\">Entrepreneurs</a>');
    wrapperHtml = wrapperHtml.replace(/<a href=\"\\/centres\/dashboard\".*?>[\s\S]*?<\/a>/, '');

    entre = entre.replace(/<!-- Topbar -->[\s\S]*?<div class=\"review-container\">/, wrapperHtml);
}

if (!entre.includes('</main>')) {
    entre = entre.replace(/<\/body>/, '</div></main></div></c:when></c:choose></body>');
}

fs.writeFileSync('src/main/webapp/WEB-INF/views/aboutEntrepreneur.jsp', entre);
console.log('Done');
