import os, re
files = [
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\user_search.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\profilechat\user_search.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\doctor\doctor-list.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\marketplace\marketplace-home.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\marketplace\provider-list.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\women-products\shop.jsp'
]
for file_path in files:
    if not os.path.exists(file_path): continue
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    if 'id="wrapper"' in content and 'sidebar.jsp' in content:
        print(f'Already processed: {file_path}')
        continue
    
    header_pattern = r'(<jsp:include page="/WEB-INF/views/fragments/header\.jsp" />)'
    if not re.search(header_pattern, content):
        print(f'No header found: {file_path}')
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
    print(f'Processed: {file_path}')
