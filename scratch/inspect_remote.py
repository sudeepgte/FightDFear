with open('remote_adminPendingProviders.jsp', 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    for k in ['globalAdminMenu', 'class="layout"', 'openApproveModal', 'openRejectModal', 'openChangesModal', '<table']:
        if k in l:
            print(f"{i+1}: {l.strip()[:100]}")
