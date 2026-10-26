import os, re
files = [
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\user_search.jsp',
    r'c:\Users\Hp\git\FightDFire\src\main\webapp\WEB-INF\views\index\index.jsp'
]
for file_path in files:
    if not os.path.exists(file_path): continue
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    if 'id="wrapper"' in content and 'sidebar.jsp' in content:
        print(f'Already processed: {file_path}')
        continue
    
    # Try replacing </header> with the wrapper start
    header_end_pattern = r'(</header>)'
    if not re.search(header_end_pattern, content):
        print(f'No </header> found: {file_path}')
        continue
        
    new_content = re.sub(
        header_end_pattern, 
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
