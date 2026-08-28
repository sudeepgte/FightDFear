import os

def process_file(src, dest, replacements):
    with open(src, 'r', encoding='utf-8') as f:
        content = f.read()
    
    for old, new in replacements:
        content = content.replace(old, new)
        
    with open(dest, 'w', encoding='utf-8') as f:
        f.write(content)

# Login Replacements
login_reps = [
    ('Centre Sign In', 'Lawyer Sign In'),
    ('Manage your batches, trainees and profile', 'Manage your consultations, appointments and profile'),
    ('/centres/loginCentre', '/lawyer/login'),
    ('/centres/login', '/lawyer/login'),
    ('centre@example.com', 'lawyer@example.com'),
    ('New Centre?', 'New Lawyer?'),
    ('/centres/registerCentre', '/lawyer/register')
]

process_file('src/main/webapp/WEB-INF/views/centreLogin.jsp', 'src/main/webapp/WEB-INF/views/lawyer/login.jsp', login_reps)

# Register Replacements
register_reps = [
    ('Join as Self-Defense Trainer', 'Join as Women Lawyer'),
    ('/centres/login', '/lawyer/login'),
    ('Quick registration', 'Lawyer registration'),
    ('For Karate, Taekwondo & self-defence centres. After login, add your martial arts programs and batches.', 'For qualified women lawyers providing legal guidance. After login, manage your profile and schedule.'),
    ('For Gym, Zumba or wellness coaching, register as Fitness Trainer instead.', 'For legal counseling and support for women.'),
    ('/centres/register', '/lawyer/register'),
    ('Centre / Trainer name *', 'Lawyer name *'),
    ('e.g. Tiger Martial Arts Academy', 'e.g. Advocate Priya Sharma'),
    ('Contact person (optional)', 'Bar Council ID *'),
    ('id="contactPerson" name="contactPerson"', 'id="barCouncilId" name="barCouncilId" required'),
    ('e.g. Master Rajesh Sharma', 'e.g. MAH/1234/2020'),
    ('centre@example.com', 'lawyer@example.com'),
    ('/api/martial-arts/centre/otp/send-email', '/api/lawyer/otp/send-email'),
    ('/api/martial-arts/centre/otp/verify-email', '/api/lawyer/otp/verify-email'),
    ('Centre Name:', 'Lawyer Name:'),
    ('id="revContact"', 'id="revBarCouncilId"'),
    ('const name = document.getElementById(\\'name\\').value.trim();', 'const name = document.getElementById(\\'name\\').value.trim();\n            const barCouncilId = document.getElementById(\\'barCouncilId\\').value.trim();'),
    ('document.getElementById(\\'revContact\\').textContent = contactPerson || \\'—\\';', 'document.getElementById(\\'revBarCouncilId\\').textContent = barCouncilId || \\'—\\';'),
    ('const contactPerson = document.getElementById(\\'contactPerson\\').value.trim();', ''),
    ('if (!name) { showAlert(\\'Centre / Trainer name is required.\\'); return; }', 'if (!name) { showAlert(\\'Lawyer name is required.\\'); return; }\n            if (!barCouncilId) { showAlert(\\'Bar Council ID is required.\\'); return; }')
]

process_file('src/main/webapp/WEB-INF/views/registerCentre.jsp', 'src/main/webapp/WEB-INF/views/lawyer/register.jsp', register_reps)
