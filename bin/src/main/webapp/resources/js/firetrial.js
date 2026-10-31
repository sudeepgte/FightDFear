/**
 * 
 */
const canvas = document.getElementById('fireParticles');
const ctx = canvas.getContext('2d');
let particles = [];

function resizeCanvas() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
}
resizeCanvas();
window.addEventListener('resize', resizeCanvas);

function createParticle(x, y) {
    particles.push({
        x,
        y,
        radius: Math.random() * 4 + 1,
        color: 'rgba(255, 69, 0, 0.8)',
        vx: (Math.random() - 0.5) * 2,
        vy: -Math.random() * 1.5,
        life: 50
    });
}

function drawParticles() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    particles.forEach((p, i) => {
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
        ctx.fillStyle = p.color;
        ctx.fill();
        p.x += p.vx;
        p.y += p.vy;
        p.life--;
        if (p.life <= 0) particles.splice(i, 1);
    });
    requestAnimationFrame(drawParticles);
}

document.addEventListener('mousemove', (e) => {
    for (let i = 0; i < 5; i++) createParticle(e.clientX, e.clientY);
});
drawParticles();
