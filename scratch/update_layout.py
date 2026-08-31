import re
import codecs

path = 'src/main/webapp/WEB-INF/views/lawyer/dashboard.jsp'
with codecs.open(path, 'r', 'utf-8') as f:
    html = f.read()

# 1. Swap the Welcome bar and the Profile Completion banner
# The banner is currently right after <div id="dashboard-tab" class="tab-section active">
# Let's find the banner block
banner_match = re.search(r'(<c:if test="\$\{lawyer\.profileCompletionPct.*?</c:if>)', html, re.DOTALL)
if banner_match:
    banner_code = banner_match.group(1)
    # Remove it from current position
    html = html.replace(banner_code, '')
    
    # Find the welcome bar and insert banner after it
    welcome_match = re.search(r'(<div class="welcome-bar">.*?</div>\s*</div>)', html, re.DOTALL)
    if welcome_match:
        welcome_code = welcome_match.group(1)
        html = html.replace(welcome_code, welcome_code + '\n' + banner_code + '\n')

# 2. Delete Profile Summary card and the two-col wrapper
# Find the start of two-col and the two cards inside it
# We'll just replace the entire two-col block with the first card.
two_col_match = re.search(r'<div class="two-col">(.*?<div class="card">.*?<!-- Profile Summary -->.*?</div>\s*</div>\s*)</div>', html, re.DOTALL)

# Let's do it differently, by capturing the Upcoming Appointments card specifically
upcoming_match = re.search(r'(<div class="card">\s*<div class="card-header">\s*<h3><i class="bi bi-calendar4-week"></i> Upcoming Appointments.*?</div>\s*</div>)', html, re.DOTALL)

if upcoming_match:
    upcoming_code = upcoming_match.group(1)
    # The entire block from <div class="two-col"> to the end of Profile Summary is:
    full_two_col = re.search(r'<div class="two-col">.*?<h3><i class="bi bi-person"></i> Profile Summary.*?</div>\s*</div>\s*</div>\s*</div>', html, re.DOTALL)
    if full_two_col:
        # replace the full block with just the upcoming_code
        html = html.replace(full_two_col.group(0), upcoming_code)

with codecs.open(path, 'w', 'utf-8') as f:
    f.write(html)
