const fs = require('fs');
let c = fs.readFileSync('src/main/webapp/WEB-INF/views/salon/salon-dashboard.jsp', 'utf8');

// 1. Replace sidebar background from dark gradient to white
c = c.replace(
    /\/\* Unified Premium Sidebar \*\/\s*\.sidebar\s*\{[^}]*\}/,
    `/* Unified Premium Sidebar */
        .sidebar {
            background: #FFFFFF;
            color: #1E1B4B;
            display: flex;
            flex-direction: column;
            border-right: 1px solid #E2E8F0;
        }`
);

// 2. Replace sidebar-brand-wrapper border
c = c.replace(
    /\.sidebar-brand-wrapper\s*\{[^}]*\}/,
    `.sidebar-brand-wrapper {
            padding: 24px;
            border-bottom: 1px solid #E2E8F0;
            margin-bottom: 20px;
        }`
);

// 3. Replace sidebar-brand color from white to navy
c = c.replace(
    /\.sidebar-brand\s*\{[^}]*color:\s*white;/,
    `.sidebar-brand {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.15rem;
            color: #1E1B4B;`
);

// 4. Replace subtitle color
c = c.replace(
    /\.sidebar-brand-wrapper\s+\.subtitle\s*\{[^}]*\}/,
    `.sidebar-brand-wrapper .subtitle {
            font-size: 0.72rem;
            color: #64748B;
            margin-top: 4px;
            font-weight: 500;
            letter-spacing: 0.5px;
        }`
);

// 5. Replace nav-link-custom color from white to gray
c = c.replace(
    /\.nav-link-custom\s*\{[^}]*color:\s*rgba\(255,255,255,0\.65\);/,
    `.nav-link-custom {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 11px 16px;
            color: #64748B;`
);

// 6. Replace nav-link-custom:hover
c = c.replace(
    /\.nav-link-custom:hover\s*\{[^}]*\}/,
    `.nav-link-custom:hover {
            background: #F8FAFC;
            color: #1E1B4B;
            transform: translateX(4px);
        }`
);

// 7. Replace nav-link-custom.active
c = c.replace(
    /\.nav-link-custom\.active\s*\{[^}]*\}/,
    `.nav-link-custom.active {
            background: #FFE4E6;
            color: #F43F5E;
            font-weight: 700;
            border-left: 4px solid #F43F5E;
            padding-left: 12px;
        }`
);

// 8. Replace upgrade-card styles
c = c.replace(
    /\.upgrade-card\s*\{[^}]*background:\s*rgba\(255,\s*255,\s*255,\s*0\.04\);[^}]*\}/,
    `.upgrade-card {
            background: #F8FAFC;
            border: 1px solid #E2E8F0;
            border-radius: 16px;
            padding: 16px;
            margin: 20px 16px;
            font-size: 0.8rem;
        }`
);

c = c.replace(
    /\.upgrade-card h6\s*\{[^}]*color:\s*white;/,
    `.upgrade-card h6 {
            color: #1E1B4B;`
);

c = c.replace(
    /\.upgrade-card ul\s*\{[^}]*color:\s*rgba\(255,255,255,0\.5\);/,
    `.upgrade-card ul {
            list-style: none;
            padding: 0;
            margin: 0 0 12px 0;
            color: #64748B;`
);

// 9. Replace sidebar box-shadow
c = c.replace(
    /box-shadow:\s*10px 0 35px rgba\(0,0,0,0\.05\);/,
    `box-shadow: 2px 0 15px rgba(0,0,0,0.03);`
);

fs.writeFileSync('src/main/webapp/WEB-INF/views/salon/salon-dashboard.jsp', c);
console.log('Done updating dashboard');
