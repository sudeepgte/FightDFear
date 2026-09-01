import sys

with open('c:/Users/priya/Desktop/FightDfire/FightDFear/src/main/webapp/WEB-INF/views/creatorMyProfile.jsp', 'r', encoding='utf-8') as f:
    content = f.read()

target = """                viewers.forEach(v => {
                    list.innerHTML += `
                    <div style="display:flex; align-items:center; gap:10px; padding:10px 0; border-bottom:1px solid var(--border);">
                        <img src="${v.avatar || '${pageContext.request.contextPath}/assets/img/default-avatar.png'}" style="width:36px;height:36px;border-radius:50%;object-fit:cover;">
                        <div style="font-size:14px;font-weight:600;">${v.name}</div>
                    </div>`;
                });"""

replacement = """                viewers.forEach(v => {
                    list.innerHTML += '<div style="display:flex; align-items:center; gap:10px; padding:10px 0; border-bottom:1px solid var(--border);">'
                        + '<img src="' + (v.avatar ? v.avatar : '${pageContext.request.contextPath}/assets/img/default-avatar.png') + '" style="width:36px;height:36px;border-radius:50%;object-fit:cover;">'
                        + '<div style="font-size:14px;font-weight:600;">' + v.name + '</div>'
                        + '</div>';
                });"""

if target in content:
    content = content.replace(target, replacement)
    with open('c:/Users/priya/Desktop/FightDfire/FightDFear/src/main/webapp/WEB-INF/views/creatorMyProfile.jsp', 'w', encoding='utf-8') as f:
        f.write(content)
    print('Replaced successfully.')
else:
    print('Target not found!')
