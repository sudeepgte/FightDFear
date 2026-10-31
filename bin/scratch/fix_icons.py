import re

file_path = r'c:\Users\priya\Desktop\FightDfire\FightDFear\src\main\webapp\WEB-INF\views\userDashboard.jsp'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

replacements = {
    'bi bi-arrow-right': 'fas fa-arrow-right',
    'bi bi-calendar2-heart': 'fas fa-calendar-alt',
    'bi bi-shield-check': 'fas fa-shield-alt',
    'bi bi-building': 'fas fa-building',
    'bi bi-bell': 'fas fa-bell',
    'bi bi-calendar3': 'fas fa-calendar',
    'bi bi-people': 'fas fa-users',
    'bi bi-calendar2-x': 'fas fa-calendar-times',
    'bi bi-activity': 'fas fa-heartbeat',
    'bi bi-shield': 'fas fa-shield-alt',
    'bi bi-check2-circle': 'fas fa-check-circle',
    'bi bi-heart-pulse': 'fas fa-heartbeat',
    'bi bi-heart-pulse-fill': 'fas fa-heartbeat',
    'bi bi-calendar-check': 'fas fa-calendar-check',
    'bi bi-journal-check': 'fas fa-book',
    'bi bi-person': 'fas fa-user',
    'bi bi-headset': 'fas fa-headset',
    'bi bi-bell-fill': 'fas fa-bell'
}

for bi, fa in replacements.items():
    content = content.replace(bi, fa)

# Remove the bootstrap-icons css link just in case
content = re.sub(r'<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons[^"]+" rel="stylesheet">\n?', '', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Icons replaced successfully.")
