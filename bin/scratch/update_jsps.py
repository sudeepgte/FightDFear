import os, re

files_to_process = [
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\user-profile.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\wallet.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\reportIncident.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\journey.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\reminders.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\buddy.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\chat_users.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\sosDashboard.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\listOfCentres.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\videosPage.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\reels.jsp'
]

for file_path in files_to_process:
    if not os.path.exists(file_path):
        print(f'Skipping {file_path} (not found)')
        continue
        
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    if 'id="wrapper"' in content and 'fragments/sidebar.jsp' in content:
        print(f'Skipping {file_path} (already processed)')
        continue
        
    header_pattern = r'(<jsp:include page="/WEB-INF/views/fragments/header\.jsp" />)'
    if not re.search(header_pattern, content):
        print(f'Skipping {file_path} (no header found)')
        continue
        
    new_content = re.sub(
        header_pattern, 
        r'\1\n<div id="wrapper">\n    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />\n    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">\n', 
        content,
        count=1
    )
    
    if '</body>' in new_content:
        new_content = new_content.replace('</body>', '    </div>\n</div>\n</body>')
    else:
        new_content += '\n    </div>\n</div>\n'
        
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
        
    print(f'Processed {file_path}')
