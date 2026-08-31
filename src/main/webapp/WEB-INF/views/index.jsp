<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FightDFear - Women's Empowerment</title>
    <!-- Premium Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=Playfair+Display:ital,wght@0,600;1,600&display=swap" rel="stylesheet">
    
    <style>
        :root {
            /* Color Palette - Soft Pink Theme */
            --bg-cream: #FFF4F6;          /* Soft Blush Pink Main Page background */
            --bg-card: #FDE8ED;           /* Soft Rose Pink for cards */
            --text-plum: #2D142C;         /* Header / main text */
            --text-charcoal: #23202B;     /* Dark Text */
            --text-light: #6B5B68;        /* Secondary Text */
            --brand-plum: #F33F5E;        /* Primary Pink/Coral */
            --brand-plum-hover: #D92545;  /* Primary Dark */
            --brand-rose: #F8C8D4;        /* Soft Pink Borders/Accents */
            --sos-red: #F33F5E;           /* SOS section */
            --sos-red-hover: #D92545;     /* SOS hover */
            --white: #FFFFFF;
            --border-muted: #F8C8D4;      /* Soft Pink Border */
            
            /* Typography */
            --font-main: 'Outfit', sans-serif;
            --font-serif: 'Playfair Display', serif;
            
            /* Spacing */
            --nav-height: 80px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: var(--font-main);
            background-color: var(--bg-cream);
            color: var(--text-charcoal);
            line-height: 1.5;
            overflow-x: hidden;
            opacity: 0;
            animation: fadeIn 0.8s ease forwards;
        }

        @keyframes fadeIn {
            to { opacity: 1; }
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        ul {
            list-style: none;
        }

        /* ---------------- NAVBAR ---------------- */
        .navbar {
            height: var(--nav-height);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 4rem;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: rgba(253, 251, 247, 0.9);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            z-index: 1000;
            border-bottom: 1px solid rgba(45, 20, 44, 0.05);
            transition: all 0.3s ease;
        }

        .navbar.sticky {
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
            background: rgba(253, 251, 247, 0.98);
        }

        .nav-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-family: var(--font-serif);
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--text-plum);
            letter-spacing: -0.5px;
            text-decoration: none;
        }

        .brand-logo-img {
            height: 48px;
            width: auto;
            object-fit: contain;
            filter: drop-shadow(0 2px 6px rgba(243, 63, 94, 0.15));
            transition: transform 0.3s ease;
        }

        .nav-logo:hover .brand-logo-img {
            transform: scale(1.06);
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 2rem;
            height: 100%;
        }

        .nav-item {
            position: relative;
            height: 100%;
            display: flex;
            align-items: center;
            cursor: pointer;
            font-weight: 500;
            font-size: 0.95rem;
            color: var(--text-plum);
            transition: color 0.3s ease;
        }

        .nav-item:hover {
            color: var(--brand-rose);
        }

        /* Dropdown */
        .dropdown-menu {
            position: absolute;
            top: 100%;
            left: 50%;
            transform: translateX(-50%) translateY(10px);
            background: var(--white);
            min-width: 200px;
            padding: 1rem 0;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .nav-item:hover .dropdown-menu {
            opacity: 1;
            visibility: visible;
            transform: translateX(-50%) translateY(0);
        }

        .dropdown-item {
            padding: 0.7rem 1.5rem;
            font-size: 0.9rem;
            color: var(--text-charcoal);
            transition: background 0.2s ease, color 0.2s ease;
            white-space: nowrap;
        }

        .dropdown-item:hover {
            background: rgba(198, 122, 136, 0.05);
            color: var(--brand-plum);
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .nav-login, .nav-events {
            font-weight: 500;
            color: var(--text-plum);
            font-size: 0.95rem;
            transition: color 0.3s ease;
            cursor: pointer;
        }
        .nav-login:hover, .nav-events:hover {
            color: var(--brand-rose);
        }

        .btn-sos-nav {
            background-color: var(--sos-red);
            color: var(--white);
            padding: 0.5rem 1.2rem;
            border-radius: 30px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .btn-sos-nav:hover {
            background-color: var(--sos-red-hover);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(217, 37, 37, 0.3);
        }

        /* Hamburger Menu */
        .mobile-menu-btn {
            display: none;
            background: none;
            border: none;
            font-size: 1.5rem;
            color: var(--text-plum);
            cursor: pointer;
        }

        .mobile-only-item {
            display: none;
        }

        /* ---------------- PREMIUM SPLIT HERO ---------------- */
        .split-hero-section {
            background: linear-gradient(135deg, #FFFBFC 0%, #FFF5F7 100%);
            padding: calc(var(--nav-height) + 0.8rem) 0 1.2rem;
            min-height: auto;
            display: flex;
            align-items: center;
        }

        .split-hero-container {
            width: 100%;
            max-width: 95%;
            margin: 0 auto;
            padding: 0 1rem;
            display: grid;
            grid-template-columns: 1fr 0.9fr;
            gap: 2rem;
            align-items: center;
        }

        /* Image Column - Clean, Unboxed Visual Flow */
        .hero-img-col {
            position: relative;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: none;
            max-height: 950px;
            aspect-ratio: 4/3;
        }

        .hero-split-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
        
        .floating-badge {
            position: absolute;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 50px;
            padding: 6px 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-plum);
            border: 1px solid rgba(243, 63, 94, 0.15);
            z-index: 5;
        }

        .badge-top-right {
            top: 16px;
            right: 16px;
        }

        .badge-bottom-left {
            bottom: 16px;
            left: 16px;
        }

        .badge-icon {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: var(--brand-plum);
            color: var(--white);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
        }

        /* Content Column */
        .hero-content {
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .eyebrow-badge {
            display: inline-flex;
            align-items: center;
            background: rgba(243, 63, 94, 0.1);
            border-radius: 50px;
            padding: 5px 14px;
            margin-bottom: 0.8rem;
            border: 1px solid rgba(243, 63, 94, 0.2);
            align-self: flex-start;
        }

        .eyebrow-text {
            color: var(--brand-plum);
            font-size: 0.8rem;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
        }

        .split-hero-section .hero-title {
            font-family: var(--font-serif);
            font-size: 2.8rem;
            color: var(--text-plum);
            line-height: 1.15;
            margin-bottom: 0.8rem;
            font-weight: 700;
        }

        .split-hero-section .highlight-pink {
            color: var(--brand-pink);
        }

        .split-hero-section .hero-desc {
            font-size: 0.98rem;
            color: var(--text-charcoal);
            line-height: 1.5;
            margin-bottom: 1rem;
            max-width: 95%;
        }

        .static-hero-features {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            margin-bottom: 1.2rem;
        }

        .feature-box {
            display: flex;
            align-items: center;
            gap: 10px;
            background: var(--white);
            padding: 8px 14px;
            border-radius: 12px;
            border: 1px solid rgba(243, 63, 94, 0.1);
            font-size: 0.88rem;
            transition: all 0.3s ease;
        }

        .feature-box:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(243, 63, 94, 0.08);
            border-color: rgba(243, 63, 94, 0.3);
        }

        .feature-box-icon {
            font-size: 1.3rem;
            background: rgba(243, 63, 94, 0.05);
            width: 38px;
            height: 38px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .feature-box-text {
            font-weight: 600;
            color: var(--text-plum);
            font-size: 0.95rem;
        }

        .hero-actions {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .btn-primary {
            background-color: var(--brand-plum);
            color: var(--white);
            padding: 0.95rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            box-shadow: 0 8px 25px rgba(243, 63, 94, 0.25);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary:hover {
            background-color: #E4234C;
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(243, 63, 94, 0.35);
            color: var(--white);
        }

        .btn-secondary-outline {
            background-color: transparent;
            color: var(--brand-plum);
            border: 2px solid var(--brand-plum);
            padding: 0.85rem 1.8rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-secondary-outline:hover {
            background-color: var(--brand-plum);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(243, 63, 94, 0.2);
        }

        /* Responsive Design */
        @media (max-width: 1100px) {
            .carousel-slide .hero-title {
                font-size: 3.2rem;
            }
        }

        @media (max-width: 900px) {
            .navbar {
                padding: 0 1.5rem;
            }
            .nav-links {
                display: flex;
                flex-direction: column;
                position: fixed;
                top: var(--nav-height);
                left: 0;
                right: 0;
                background: rgba(255, 244, 246, 0.98);
                backdrop-filter: blur(16px);
                -webkit-backdrop-filter: blur(16px);
                padding: 1.5rem 2rem 2.5rem;
                height: calc(100vh - var(--nav-height));
                overflow-y: auto;
                gap: 1rem;
                align-items: flex-start;
                box-shadow: 0 20px 40px rgba(45, 20, 44, 0.12);
                border-top: 1px solid rgba(248, 200, 212, 0.6);
                transform: translateY(-100%);
                opacity: 0;
                visibility: hidden;
                transition: transform 0.35s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.3s ease, visibility 0.3s ease;
                z-index: 999;
            }
            .nav-links.active {
                transform: translateY(0);
                opacity: 1;
                visibility: visible;
            }
            .nav-links .nav-item {
                width: 100%;
                flex-direction: column;
                align-items: flex-start;
                height: auto;
                padding: 0.5rem 0;
                font-size: 1.05rem;
                font-weight: 600;
                border-bottom: 1px solid rgba(248, 200, 212, 0.3);
            }
            .nav-links .dropdown-menu {
                position: static;
                transform: none !important;
                opacity: 1;
                visibility: visible;
                box-shadow: none;
                background: rgba(248, 200, 212, 0.2);
                padding: 0.5rem 1rem;
                border-radius: 12px;
                margin-top: 0.5rem;
                width: 100%;
                display: flex;
                flex-direction: column;
                gap: 0.4rem;
            }
            .nav-links .dropdown-item {
                padding: 0.4rem 0.6rem;
                font-size: 0.9rem;
                color: var(--text-plum);
                border-radius: 6px;
            }
            .mobile-only-item {
                display: flex;
            }
            .nav-actions .nav-login, .nav-actions .nav-events {
                display: none;
            }
            .mobile-menu-btn {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: rgba(243, 63, 94, 0.08);
                border: 1px solid rgba(243, 63, 94, 0.2);
                color: var(--text-plum);
                font-size: 1.3rem;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            .mobile-menu-btn:hover {
                background: var(--brand-plum);
                color: var(--white);
            }
            
            .carousel-slide {
                flex-direction: column;
                padding: calc(var(--nav-height) + 2rem) 2rem 4rem;
                text-align: center;
                gap: 2rem;
            }
            
            .carousel-slide .hero-content {
                flex: none;
                padding-right: 0;
            }
            
            .carousel-slide .hero-desc {
                margin: 0 auto 2.5rem;
            }
            
            .carousel-slide .hero-actions, .carousel-slide .trust-indicators {
                justify-content: center;
            }
            
            .carousel-slide .hero-image-wrapper {
                flex: none;
                width: 100%;
                max-width: 500px;
                margin: 0 auto;
            }
            
            .carousel-nav-wrapper {
                left: 2rem;
                right: 2rem;
                bottom: 1rem;
            }
        }

        @media (max-width: 600px) {
            .carousel-slide .hero-title {
                font-size: 2.4rem;
            }
            .carousel-slide .hero-actions {
                flex-direction: column;
                gap: 1rem;
            }
            .btn-primary, .btn-secondary-sos, .btn-secondary-outline {
                width: 100%;
                justify-content: center;
            }
            .carousel-dots {
                display: none;
            }
            .arrow-btn {
                width: 35px;
                height: 35px;
            }
        }

        /* ---------------- SECTION 1: SAFETY ALWAYS WITHIN REACH ---------------- */
        .safety-reach-section {
            background-color: var(--bg-cream);
            padding: 2.5rem 0;
        }

        .safety-container {
            max-width: 95%;
            margin: 0 auto;
            padding: 0 1rem;
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .safety-block-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.8rem;
            align-items: center;
        }

        .safety-img-wrapper {
            position: relative;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: none;
            background-color: transparent;
        }

        .safety-img-wrapper .safety-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            aspect-ratio: 4/3;
            display: block;
            transition: transform 0.6s ease;
        }

        .safety-img-wrapper:hover .safety-img {
            transform: scale(1.03);
        }

        /* Glassmorphic Overlay Badges */
        .safety-badge-overlay {
            position: absolute;
            z-index: 5;
            background: rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-radius: 50px;
            padding: 0.6rem 1.2rem;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.8);
            font-size: 0.88rem;
            font-weight: 600;
            color: #1D1B43;
        }

        .badge-icon-pink {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: #FCE8EB;
            color: #C64B62;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }

        .badge-top-left { top: 28px; left: 28px; }
        .badge-middle-right { top: 45%; right: 24px; transform: translateY(-50%); }
        .badge-bottom-left { bottom: 28px; left: 28px; }

        /* SOS Status Stack */
        .sos-status-stack {
            position: absolute;
            left: 28px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 5;
            display: flex;
            flex-direction: column;
            gap: 14px;
            max-width: 260px;
        }

        .sos-status-item {
            background: rgba(255, 255, 255, 0.94);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-radius: 50px;
            padding: 0.6rem 1.2rem 0.6rem 0.7rem;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.9);
        }

        .status-badge-icon {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 800;
            color: var(--white);
            flex-shrink: 0;
        }

        .status-badge-icon.sos-bg { background: #E63956; }
        .status-badge-icon.loc-bg { background: #F33F5E; }
        .status-badge-icon.contact-bg { background: #1D1B43; }

        .status-info {
            display: flex;
            flex-direction: column;
            line-height: 1.2;
            flex-grow: 1;
        }

        .status-info strong {
            font-size: 0.85rem;
            color: #1D1B43;
            font-weight: 700;
        }

        .status-info span {
            font-size: 0.72rem;
            color: #725E5B;
        }

        .status-check {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            border: 1.5px solid #C64B62;
            color: #C64B62;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7rem;
            font-weight: 800;
        }

        /* Right Content Column */
        .safety-text-col {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .safety-main-title {
            font-family: var(--font-serif);
            font-size: 2.8rem;
            line-height: 1.15;
            color: #1D1B43;
            font-weight: 700;
            letter-spacing: -0.5px;
        }

        .highlight-pink-line {
            color: #C64B62;
            display: block;
        }

        .safety-main-desc {
            font-size: 1.05rem;
            color: #725E5B;
            line-height: 1.6;
            max-width: 480px;
        }

        /* 4 Feature Cards Grid */
        .safety-4cards-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.2rem;
            margin-top: 0.5rem;
        }

        .safety-card-item {
            background: #FFFFFF;
            border: 1.5px solid #F6EAEF;
            border-radius: 20px;
            padding: 1.4rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02);
        }

        .safety-card-item:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(198, 75, 98, 0.1);
            border-color: #C64B62;
        }

        .card-item-icon {
            font-size: 1.6rem;
            margin-bottom: 0.6rem;
            color: #C64B62;
        }

        .safety-card-item h4 {
            font-size: 1.05rem;
            font-weight: 700;
            color: #1D1B43;
            margin-bottom: 0.3rem;
        }

        .safety-card-item p {
            font-size: 0.85rem;
            color: #725E5B;
            line-height: 1.45;
        }

        .btn-explore-safety-tools {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            border: 1.5px solid #C64B62;
            color: #C64B62;
            background: transparent;
            padding: 0.85rem 1.8rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            text-decoration: none;
            width: fit-content;
        }

        .btn-explore-safety-tools:hover {
            background: #C64B62;
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(198, 75, 98, 0.25);
        }

        /* Emergency SOS Panel (Row 2) */
        .emergency-support-row {
            display: grid;
            grid-template-columns: 0.85fr 1.15fr;
            gap: 3rem;
            align-items: center;
        }

        .sos-img-wrapper {
            max-width: 420px;
            width: 100%;
            margin: 0 auto;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 15px 35px rgba(243, 63, 94, 0.12);
            border: 1px solid rgba(243, 63, 94, 0.15);
            background-color: var(--white);
        }

        .emergency-side-img {
            width: 100%;
            height: auto;
            max-height: 480px;
            object-fit: cover;
            display: block;
            border-radius: 24px;
            transition: transform 0.4s ease;
        }

        .sos-img-wrapper:hover .emergency-side-img {
            transform: scale(1.02);
        }

        .emergency-sos-card {
            background: linear-gradient(145deg, #FFF0F4 0%, #FDE8ED 50%, #FEDBDF 100%);
            border: 1.5px solid #F8C8D4;
            border-radius: 28px;
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            gap: 2rem;
            box-shadow: 0 20px 50px rgba(243, 63, 94, 0.12);
            position: relative;
        }

        .emergency-tag-pill {
            display: inline-block;
            background: rgba(243, 63, 94, 0.12);
            color: #D92545;
            font-size: 0.78rem;
            font-weight: 700;
            letter-spacing: 1.8px;
            text-transform: uppercase;
            padding: 0.45rem 1.1rem;
            border-radius: 50px;
            margin-bottom: 0.8rem;
            border: 1px solid rgba(243, 63, 94, 0.2);
        }

        /* Pulsing Circular SOS Button */
        .pulse-sos-circle {
            width: 145px;
            height: 145px;
            border-radius: 50%;
            background: linear-gradient(135deg, #F33F5E 0%, #D92545 100%);
            color: var(--white);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            margin: 1.2rem auto;
            text-align: center;
            box-shadow: 0 0 0 14px rgba(243, 63, 94, 0.16), 0 15px 35px rgba(243, 63, 94, 0.35);
            transition: all 0.3s ease;
            position: relative;
            cursor: pointer;
        }

        .pulse-sos-circle:hover {
            transform: scale(1.06);
            box-shadow: 0 0 0 20px rgba(243, 63, 94, 0.22), 0 20px 45px rgba(243, 63, 94, 0.45);
        }

        .sos-circle-text {
            font-size: 2.2rem;
            font-weight: 800;
            letter-spacing: 1px;
            line-height: 1;
        }

        .sos-circle-sub {
            font-size: 0.72rem;
            opacity: 0.95;
            margin-top: 6px;
            max-width: 100px;
            line-height: 1.2;
            color: var(--white);
            font-weight: 500;
        }

        .emergency-actions-row {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 0.5rem;
        }

        .btn-action-pink {
            background: #FFFFFF;
            color: #D92545;
            padding: 0.9rem 1.5rem;
            border-radius: 50px;
            font-size: 0.92rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: 1px solid #F8C8D4;
            box-shadow: 0 4px 15px rgba(243, 63, 94, 0.06);
        }

        .btn-action-pink:hover {
            background: #D92545;
            color: var(--white);
            border-color: #D92545;
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(217, 37, 69, 0.25);
        }

        @media (max-width: 900px) {
            .safety-block-row {
                grid-template-columns: 1fr;
                gap: 2.5rem;
            }
            .safety-4cards-grid {
                grid-template-columns: 1fr;
            }
            .sos-status-stack {
                left: 15px;
            }
        }

        /* --- NEW SECTIONS STYLES --- */
        .section-padding { padding: 2rem 1rem; }
        .section-header { text-align: center; margin-bottom: 1.2rem; }
        .section-title { font-family: var(--font-serif); font-size: 2.2rem; color: var(--text-plum); margin-bottom: 0.5rem; }
        .section-desc { font-size: 0.95rem; color: var(--text-light); max-width: 550px; margin: 0 auto; line-height: 1.5; }

        /* SAFETY SECTION */
        .safety-section { background-color: var(--white); }
        .safety-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; max-width: 95%; margin: 0 auto; padding: 0 1rem; }
        .safety-card { background: var(--bg-cream); border-radius: 20px; padding: 2.5rem; transition: all 0.3s ease; position: relative; overflow: hidden; border: 1px solid rgba(0,0,0,0.03); }
        .safety-card:hover { transform: translateY(-5px); box-shadow: 0 15px 40px rgba(45,20,44,0.06); }
        
        .safety-card.sos-card { grid-column: span 1; grid-row: span 2; background: linear-gradient(145deg, var(--sos-red), var(--sos-red-hover)); color: var(--white); display: flex; flex-direction: column; justify-content: space-between; }
        .sos-card h3 { font-size: 1.8rem; margin-bottom: 1rem; }
        .sos-card p { opacity: 0.9; margin-bottom: 2rem; font-size: 1.1rem; }
        .btn-sos-large { background: var(--white); color: var(--sos-red); padding: 1rem; border-radius: 50px; text-align: center; font-weight: 700; transition: all 0.3s; margin-top: auto; }
        .btn-sos-large:hover { transform: scale(1.02); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        
        .safety-icon { font-size: 2.5rem; margin-bottom: 1.5rem; color: var(--brand-plum); }
        .safety-card:not(.sos-card) h3 { font-size: 1.3rem; color: var(--text-plum); margin-bottom: 0.8rem; }
        .safety-card:not(.sos-card) p { color: var(--text-light); font-size: 0.95rem; }

        /* BENTO FEATURES SECTION */
        .features-section { background-color: var(--bg-cream); }
        .bento-grid { display: grid; grid-template-columns: repeat(4, 1fr); grid-auto-rows: minmax(180px, auto); gap: 1.5rem; max-width: 95%; margin: 0 auto; padding: 0 1rem; }
        
        .bento-item { border-radius: 24px; overflow: hidden; position: relative; background: var(--white); transition: all 0.4s ease; box-shadow: 0 10px 30px rgba(0,0,0,0.02); border: 1px solid rgba(45,20,44,0.03); display: flex; flex-direction: column; padding: 2rem; }
        .bento-item:hover { transform: translateY(-5px) scale(1.01); box-shadow: 0 20px 40px rgba(45,20,44,0.08); z-index: 2; }
        
        .bento-bg-img { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; opacity: 0.8; z-index: 0; transition: transform 0.6s ease; }
        .bento-item:hover .bento-bg-img { transform: scale(1.05); }
        .bento-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: linear-gradient(to top, rgba(45,20,44,0.9) 0%, rgba(45,20,44,0.2) 100%); z-index: 1; }
        
        .bento-content { position: relative; z-index: 2; margin-top: auto; color: var(--text-charcoal); }
        .bento-content-light { color: var(--white); }
        
        .bento-item h3 { font-family: var(--font-serif); font-size: 1.5rem; margin-bottom: 0.5rem; }
        .bento-item p { font-size: 0.9rem; opacity: 0.8; margin-bottom: 1rem; }
        .bento-action { font-weight: 600; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px; display: inline-flex; align-items: center; gap: 5px; }
        .bento-action:hover { gap: 8px; }

        /* Bento specific sizes */
        .bento-safety { grid-column: span 2; grid-row: span 2; padding: 0; }
        .bento-safety .bento-content { padding: 2.5rem; }
        
        .bento-doctors { grid-column: span 2; grid-row: span 1; display: flex; flex-direction: row; align-items: center; justify-content: space-between; gap: 2rem; }
        .bento-doctors .img-circle { width: 100px; height: 100px; border-radius: 50%; object-fit: cover; }
        
        .bento-wellness { grid-column: span 2; grid-row: span 1; padding: 0; }
        .bento-wellness .bento-content { padding: 2rem; }
        
        .bento-beauty { grid-column: span 2; grid-row: span 1; }
        .bento-market { grid-column: span 2; grid-row: span 1; padding: 0; }
        .bento-market .bento-content { padding: 2rem; }
        .bento-business { grid-column: span 2; grid-row: span 1; }
        .bento-community { grid-column: span 4; grid-row: span 1; display: flex; flex-direction: row; justify-content: space-between; align-items: center; background: var(--brand-plum); color: var(--white); }
        
        /* WHY CHOOSE US */
        .why-us-section { background-color: var(--white); }
        .why-us-container { display: flex; align-items: center; gap: 2rem; max-width: 95%; margin: 0 auto; padding: 0 1rem; }
        .why-us-image { flex: 0 0 45%; position: relative; border-radius: 24px; overflow: hidden; box-shadow: 0 20px 50px rgba(0,0,0,0.1); }
        .why-us-image img { width: 100%; height: auto; display: block; aspect-ratio: 4/5; object-fit: cover; }
        .why-us-content { flex: 1; }
        
        .why-us-label { font-size: 0.8rem; font-weight: 600; letter-spacing: 1.5px; color: var(--brand-rose); text-transform: uppercase; margin-bottom: 0.6rem; display: inline-block; }
        .why-us-title { font-family: var(--font-serif); font-size: 2.2rem; color: var(--text-plum); margin-bottom: 0.8rem; line-height: 1.2; }
        .why-us-desc { color: var(--text-light); font-size: 0.95rem; margin-bottom: 1.2rem; }
        
        .why-us-points { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        .point-icon { color: var(--brand-rose); font-size: 1.5rem; margin-bottom: 0.8rem; }
        .point-item h4 { color: var(--text-plum); font-size: 1.1rem; margin-bottom: 0.5rem; font-weight: 600; }
        .point-item p { color: var(--text-light); font-size: 0.95rem; }

        /* Animation Classes */
        .reveal { opacity: 0; transform: translateY(30px); transition: all 0.8s ease; }
        .reveal.active { opacity: 1; transform: translateY(0); }

        /* Media Queries */
        @media (max-width: 1024px) {
            .safety-grid { grid-template-columns: 1fr 1fr; }
            .safety-card.sos-card { grid-column: span 2; grid-row: span 1; }
            .bento-grid { grid-template-columns: 1fr 1fr; }
            .bento-community { grid-column: span 2; flex-direction: column; text-align: center; }
            .why-us-container { flex-direction: column; }
            .why-us-image, .why-us-content { flex: none; width: 100%; }
        }
        @media (max-width: 768px) {
            .section-padding { padding: 5rem 2rem; }
            .safety-grid { grid-template-columns: 1fr; }
            .safety-card.sos-card { grid-column: span 1; }
            .bento-grid { grid-template-columns: 1fr; }
            .bento-safety, .bento-doctors, .bento-wellness, .bento-beauty, .bento-market, .bento-business, .bento-community { grid-column: span 1; }
            .why-us-points { grid-template-columns: 1fr; }
        }
        /* WELLNESS SECTION */
        .wellness-section { background-color: var(--bg-cream); }
        .wellness-grid { display: grid; grid-template-columns: 1fr 1fr; grid-auto-rows: minmax(300px, auto); gap: 2rem; max-width: 1200px; margin: 0 auto; }
        .well-card-large { grid-column: span 1; grid-row: span 2; position: relative; border-radius: 24px; overflow: hidden; }
        .well-card-large img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.6s ease; }
        .well-card-large:hover img { transform: scale(1.05); }
        .well-overlay { position: absolute; inset: 0; background: linear-gradient(to top, rgba(45,20,44,0.85) 0%, rgba(45,20,44,0) 100%); display: flex; flex-direction: column; justify-content: flex-end; padding: 3rem; color: var(--white); }
        .well-overlay h3 { font-family: var(--font-serif); font-size: 2.5rem; margin-bottom: 1rem; }
        .well-overlay p { font-size: 1.1rem; opacity: 0.9; margin-bottom: 2rem; max-width: 90%; }
        
        .well-card-medium { background: var(--white); border-radius: 24px; padding: 3rem; display: flex; flex-direction: column; justify-content: center; box-shadow: 0 10px 30px rgba(0,0,0,0.02); transition: all 0.3s ease; }
        .well-card-medium:hover { transform: translateY(-5px); box-shadow: 0 20px 40px rgba(45,20,44,0.06); }
        .well-icon { font-size: 2.5rem; margin-bottom: 1.5rem; }
        .well-card-medium h3 { font-size: 1.8rem; color: var(--text-plum); margin-bottom: 1rem; }
        .well-card-medium p { color: var(--text-light); font-size: 1.05rem; margin-bottom: 2rem; line-height: 1.6; }
        .well-link { font-weight: 600; color: var(--brand-plum); text-transform: uppercase; letter-spacing: 1px; font-size: 0.9rem; display: inline-flex; align-items: center; gap: 5px; }
        .well-link:hover { gap: 8px; color: var(--brand-rose); }

        /* STATS STRIP */
        .stats-section { background-color: var(--brand-plum); color: var(--white); padding: 4rem 2rem; }
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); max-width: 1200px; margin: 0 auto; text-align: center; gap: 2rem; }
        .stat-number { font-family: var(--font-serif); font-size: 3.5rem; margin-bottom: 0.5rem; }
        .stat-label { font-size: 1rem; text-transform: uppercase; letter-spacing: 2px; opacity: 0.8; }

        /* AWARENESS SECTION - MAGAZINE EDITORIAL LAYOUT */
        .awareness-section { background-color: var(--white); }
        .awareness-editorial-list {
            display: flex;
            flex-direction: column;
            gap: 2.5rem;
            max-width: 95%;
            margin: 0 auto;
            padding: 0 1rem;
        }
        .aw-editorial-item {
            display: grid;
            grid-template-columns: 1fr 1.1fr;
            gap: 2.5rem;
            align-items: center;
            padding-bottom: 2rem;
            border-bottom: 1px solid rgba(248, 200, 212, 0.4);
        }
        .aw-editorial-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }
        .aw-editorial-item.aw-reverse {
            grid-template-columns: 1.1fr 1fr;
        }
        .aw-editorial-item.aw-reverse .aw-item-img {
            order: 2;
        }
        .aw-editorial-item.aw-reverse .aw-item-content {
            order: 1;
        }
        .aw-item-img {
            position: relative;
            border-radius: 16px;
            overflow: hidden;
            aspect-ratio: 16/9;
            box-shadow: none;
        }
        .aw-item-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: transform 0.6s ease;
        }
        .aw-editorial-item:hover .aw-item-img img {
            transform: scale(1.03);
        }
        .aw-item-content {
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .aw-item-cat {
            font-size: 0.8rem;
            font-weight: 700;
            color: var(--brand-rose);
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 0.6rem;
        }
        .aw-item-content h3 {
            font-family: var(--font-serif);
            font-size: 2.2rem;
            color: var(--text-plum);
            margin-bottom: 0.8rem;
            line-height: 1.2;
        }
        .aw-item-content p {
            color: var(--text-light);
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 1.2rem;
            max-width: 95%;
        }
        .aw-item-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-weight: 700;
            font-size: 0.9rem;
            color: var(--brand-plum);
            text-decoration: none;
            transition: all 0.3s ease;
            align-self: flex-start;
        }
        .aw-item-link:hover {
            color: #F33F5E;
            transform: translateX(4px);
        }
        
        @media (max-width: 900px) {
            .wellness-grid { grid-template-columns: 1fr; }
            .well-card-large { grid-row: span 1; }
            .stats-grid { grid-template-columns: 1fr 1fr; }
            .aw-editorial-item, .aw-editorial-item.aw-reverse {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
            .aw-editorial-item.aw-reverse .aw-item-img {
                order: 1;
            }
            .aw-editorial-item.aw-reverse .aw-item-content {
                order: 2;
            }
        }
        /* BUSINESS & INVESTMENT SECTION - ELEVATED DESIGN */
        .business-section {
            background: linear-gradient(135deg, #FFF7F9 0%, #FDF0F3 50%, #F8E5EB 100%);
            position: relative;
            overflow: hidden;
            border-top: 1px solid rgba(248, 200, 212, 0.4);
            border-bottom: 1px solid rgba(248, 200, 212, 0.4);
        }
        .business-grid {
            display: grid;
            grid-template-columns: 0.9fr 1.1fr;
            gap: 2rem;
            max-width: 95%;
            margin: 0 auto;
            padding: 0 1rem;
            align-items: center;
        }
        .business-img-wrapper {
            position: relative;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: none;
            border: none;
            background: transparent;
        }
        .business-img-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            aspect-ratio: 4/5;
            display: block;
            transition: transform 0.6s ease;
        }
        .business-img-wrapper:hover img {
            transform: scale(1.03);
        }

        .business-content {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }
        .biz-card {
            background: transparent;
            padding: 1.2rem 0;
            border-radius: 0;
            box-shadow: none;
            transition: all 0.3s ease;
            border: none;
            border-bottom: 1px solid rgba(248, 200, 212, 0.5);
            position: relative;
        }
        .biz-card:hover {
            transform: translateY(-2px);
            box-shadow: none;
        }
        .biz-card h3 {
            font-family: var(--font-serif);
            font-size: 1.85rem;
            color: #2D142C;
            margin-bottom: 0.7rem;
        }
        .biz-card p {
            color: #6B5B68;
            font-size: 1.02rem;
            margin-bottom: 1.4rem;
            line-height: 1.6;
        }
        .biz-card .well-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 700;
            font-size: 0.88rem;
            color: #D92545;
            text-transform: uppercase;
            letter-spacing: 1px;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .biz-card .well-link:hover {
            gap: 12px;
            color: #2D142C;
        }

        .biz-opportunities {
            padding-top: 1.4rem;
            border-top: 1px solid rgba(248, 200, 212, 0.6);
        }
        .biz-opportunities h4 {
            font-size: 1.05rem;
            color: #2D142C;
            margin-bottom: 1rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .biz-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
        }
        .biz-tag {
            background: #FFF0F4;
            color: #C64B62;
            font-weight: 600;
            font-size: 0.82rem;
            padding: 0.45rem 1.2rem;
            border-radius: 50px;
            border: 1px solid #F8C8D4;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }
        .biz-tag:hover {
            background: #D92545;
            color: #FFFFFF;
            border-color: #D92545;
            transform: translateY(-2px);
        }

        /* MARKETPLACE SECTION */
        .marketplace-section { background-color: var(--white); }
        .market-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; max-width: 1200px; margin: 0 auto; }
        
        .market-featured { grid-column: span 2; grid-row: span 2; position: relative; border-radius: 24px; overflow: hidden; display: flex; flex-direction: column; justify-content: flex-end; padding: 3rem; color: var(--white); background: #333; }
        .market-featured img { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; z-index: 0; transition: transform 0.6s ease; opacity: 0.8; }
        .market-featured:hover img { transform: scale(1.05); }
        .market-featured .bento-overlay { z-index: 1; background: linear-gradient(to top, rgba(45,20,44,0.9) 0%, rgba(45,20,44,0.1) 100%); }
        .market-featured-content { position: relative; z-index: 2; }
        .market-featured-content .cat-label { font-size: 0.85rem; font-weight: 600; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 0.5rem; display: block; }
        .market-featured-content h3 { font-family: var(--font-serif); font-size: 2.5rem; margin-bottom: 1rem; }
        
        .market-card { position: relative; border-radius: 20px; overflow: hidden; aspect-ratio: 1; display: flex; align-items: flex-end; padding: 1.5rem; color: var(--white); }
        .market-card img { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; z-index: 0; transition: transform 0.6s ease; }
        .market-card:hover img { transform: scale(1.05); }
        .market-card .bento-overlay { z-index: 1; background: linear-gradient(to top, rgba(45,20,44,0.9) 0%, rgba(45,20,44,0.1) 100%); }
        .market-card h4 { position: relative; z-index: 2; font-size: 1.2rem; font-weight: 600; width: 100%; display: flex; justify-content: space-between; align-items: center; }

        .market-action-wrapper { text-align: center; margin-top: 4rem; }

        /* EVENTS SECTION */
        .events-section { background-color: var(--bg-cream); }
        .events-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; max-width: 1200px; margin: 0 auto; }
        .event-card { background: var(--white); border-radius: 20px; overflow: hidden; transition: all 0.3s ease; box-shadow: 0 10px 30px rgba(0,0,0,0.02); display: flex; flex-direction: column; }
        .event-card:hover { transform: translateY(-5px); box-shadow: 0 20px 40px rgba(45,20,44,0.08); }
        .event-img { width: 100%; height: 220px; overflow: hidden; position: relative; }
        .event-img img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.6s ease; }
        .event-card:hover .event-img img { transform: scale(1.05); }
        
        .event-date-badge { position: absolute; top: 15px; right: 15px; background: var(--white); color: var(--brand-plum); padding: 0.5rem; border-radius: 12px; text-align: center; font-weight: 700; line-height: 1.1; min-width: 60px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .event-date-badge span { display: block; font-size: 0.75rem; text-transform: uppercase; font-weight: 500; color: var(--text-light); }
        
        .event-content { padding: 2rem; display: flex; flex-direction: column; flex-grow: 1; }
        .event-meta { font-size: 0.85rem; color: var(--brand-rose); font-weight: 600; margin-bottom: 0.5rem; display: flex; align-items: center; gap: 8px; }
        .event-card h3 { font-size: 1.3rem; color: var(--text-plum); margin-bottom: 1rem; line-height: 1.4; }
        .event-card p { color: var(--text-light); font-size: 0.95rem; line-height: 1.6; margin-bottom: 1.5rem; flex-grow: 1; }

        /* MARKETPLACE BENTO GRID */
        .marketplace-section { background-color: #FFF0F5; padding: 4.5rem 2rem; text-align: center; }
        .marketplace-header { margin-bottom: 2.5rem; }
        .market-bento-layout {
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            grid-template-rows: 250px 250px 250px;
            gap: 1.5rem;
            max-width: 1100px;
            margin: 0 auto 3rem;
        }

        .market-bento-card {
            border-radius: 20px;
            overflow: hidden;
            position: relative;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            transition: transform 0.4s ease;
        }

        .market-bento-card:hover {  transform: translateY(-5px);  box-shadow: 0 15px 40px rgba(45,20,44,0.1); }

        .market-bento-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: transform 0.6s ease;
        }

        .market-bento-card:hover img {  transform: scale(1.05); }

        .market-bento-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(29, 27, 67, 0.9) 0%, rgba(29, 27, 67, 0.1) 100%);
            z-index: 1;
        }

        .market-bento-content {
            position: absolute;
            bottom: 30px;
            left: 30px;
            z-index: 2;
            text-align: left;
            color: var(--white);
        }

        .market-card-main { grid-column: 1 / 2; grid-row: 1 / 3; }
        .market-card-sm-top { grid-column: 2 / 3; grid-row: 1 / 2; }
        .market-card-sm-mid { grid-column: 2 / 3; grid-row: 2 / 3; }
        .market-card-hz-bot-l { grid-column: 1 / 2; grid-row: 3 / 4; }
        .market-card-hz-bot-r { grid-column: 2 / 3; grid-row: 3 / 4; }

        .market-cat { font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 0.5rem; display: block; opacity: 0.9; }
        .market-bento-card h3 { font-family: var(--font-serif); font-size: 1.5rem; margin: 0; display: inline-flex; align-items: center; gap: 10px; }
        .market-card-main h3 { font-size: 2.5rem; margin-bottom: 1.5rem; }
        .market-btn { background: var(--white); color: var(--brand-plum); padding: 10px 24px; border-radius: 50px; text-decoration: none; font-weight: 600; font-size: 0.9rem; transition: all 0.3s; }
        .market-btn:hover { background: var(--brand-rose); color: var(--white); }
        .btn-magenta { background-color: #F33F5E; color: white; padding: 15px 40px; border-radius: 50px; font-weight: bold; text-decoration: none; border: none; font-size: 1.1rem; cursor: pointer; transition: 0.3s; display: inline-block;}
        .btn-magenta:hover { background-color: #E4234C; }

        @media (max-width: 900px) {
            .market-bento-layout { grid-template-columns: 1fr; grid-template-rows: auto; }
            .market-card-main, .market-card-sm-top, .market-card-sm-mid, .market-card-hz-bot-l, .market-card-hz-bot-r { grid-column: span 1; grid-row: span 1; height: 300px; }
        }

        /* COMMUNITY CTA */
        .community-cta { padding: 5rem 2rem; position: relative; overflow: hidden; color: var(--white); text-align: center; display: flex; justify-content: center; align-items: center; min-height: 50vh; }
        .community-cta img { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; z-index: 0; }
        .community-cta .bento-overlay { z-index: 1; background: rgba(74,28,64,0.85); }
        .cta-content { position: relative; z-index: 2; max-width: 700px; margin: 0 auto; }
        .cta-content h2 { font-family: var(--font-serif); font-size: 3.5rem; margin-bottom: 1.5rem; }
        .cta-content p { font-size: 1.2rem; opacity: 0.9; margin-bottom: 3rem; line-height: 1.6; }
        .cta-buttons { display: flex; justify-content: center; gap: 1rem; flex-wrap: wrap; }
        .btn-outline-light { border: 2px solid var(--white); color: var(--white); background: transparent; padding: 1rem 2rem; border-radius: 50px; font-weight: 500; transition: all 0.3s; }
        .btn-outline-light:hover { background: var(--white); color: var(--brand-plum); transform: translateY(-3px); }

        @media (max-width: 900px) {
            .business-grid { grid-template-columns: 1fr; }
            .market-grid { grid-template-columns: 1fr 1fr; }
            .events-grid { grid-template-columns: 1fr; }
            .market-featured { grid-column: span 2; grid-row: span 1; }
            .cta-content h2 { font-size: 2.5rem; }
        }
        /* FINAL CTA SECTION */
        .final-cta-section { background-color: var(--brand-plum); color: var(--white); text-align: center; }
        .final-cta-container { max-width: 800px; margin: 0 auto; }
        .final-cta-container h2 { font-family: var(--font-serif); font-size: 3.5rem; margin-bottom: 1.5rem; }
        .final-cta-container p { font-size: 1.2rem; opacity: 0.9; margin-bottom: 3rem; line-height: 1.6; }
        
        /* FOOTER */
        .footer { background-color: var(--bg-cream); color: var(--text-plum); padding-top: 2.2rem; border-top: 1px solid rgba(45,20,44,0.1); }
        .footer-container { max-width: 95%; margin: 0 auto; padding: 0 1rem; }
        .footer-top { text-align: center; margin-bottom: 1.8rem; }
        .footer-logo { font-family: var(--font-serif); font-size: 1.6rem; font-weight: 700; color: var(--brand-plum); text-decoration: none; display: inline-block; margin-bottom: 0.5rem; }
        .footer-brand-statement { font-size: 0.95rem; color: var(--text-light); max-width: 400px; margin: 0 auto 1rem auto; }
        .footer-social { display: flex; justify-content: center; gap: 1.2rem; }
        .footer-social a { color: var(--text-light); text-decoration: none; font-weight: 600; font-size: 0.8rem; transition: color 0.3s; text-transform: uppercase; letter-spacing: 1px; }
        .footer-social a:hover { color: var(--brand-rose); }
        
        .footer-links-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.5rem; margin-bottom: 2rem; }
        .footer-col h4 { font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1.5px; color: var(--brand-plum); margin-bottom: 0.8rem; border-bottom: 1px solid rgba(45,20,44,0.1); padding-bottom: 0.4rem; }
        .footer-col ul { list-style: none; padding: 0; margin: 0; }
        .footer-col ul li { margin-bottom: 0.4rem; }
        .footer-col ul li a { color: var(--text-light); text-decoration: none; font-size: 0.85rem; transition: color 0.3s; }
        .footer-col ul li a:hover { color: var(--brand-rose); }
        
        /* EMERGENCY FOOTER STRIP */
        .footer-emergency { background-color: var(--white); border-radius: 12px; padding: 1.2rem 1.8rem; display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.8rem; box-shadow: 0 4px 15px rgba(0,0,0,0.02); }
        .footer-emergency-text h4 { color: var(--text-plum); font-size: 1.05rem; margin-bottom: 0.2rem; }
        .footer-emergency-text p { color: var(--text-light); font-size: 0.85rem; }
        
        .footer-bottom { border-top: 1px solid rgba(45,20,44,0.1); padding: 1rem 0; display: flex; justify-content: space-between; align-items: center; color: var(--text-light); font-size: 0.8rem; }
        .footer-bottom-links a { color: var(--text-light); text-decoration: none; margin-left: 1.2rem; transition: color 0.3s; }
        .footer-bottom-links a:hover { color: var(--brand-plum); }

        /* FLOATING SOS */
        .floating-sos { position: fixed; bottom: 30px; right: 30px; background-color: var(--emergency-red); color: var(--white); padding: 1rem 1.5rem; border-radius: 50px; text-decoration: none; font-weight: 700; font-size: 1rem; box-shadow: 0 10px 30px rgba(220,53,69,0.3); z-index: 1000; display: flex; align-items: center; gap: 8px; transition: all 0.3s ease; animation: pulseSOS 2s infinite; }
        .floating-sos:hover { transform: scale(1.05) translateY(-3px); box-shadow: 0 15px 40px rgba(220,53,69,0.4); }
        @keyframes pulseSOS { 0% { box-shadow: 0 0 0 0 rgba(220,53,69,0.5); } 70% { box-shadow: 0 0 0 15px rgba(220,53,69,0); } 100% { box-shadow: 0 0 0 0 rgba(220,53,69,0); } }

        /* EMERGENCY SERVICES & MAP SECTION */
        .emergency-map-section {
            background-color: var(--bg-cream);
            padding: 5rem 0;
        }

        .em-header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .em-eyebrow {
            color: var(--brand-rose);
            font-size: 0.85rem;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            margin-bottom: 1rem;
        }
        
        .em-eyebrow::before, .em-eyebrow::after {
            content: "";
            width: 30px;
            height: 1px;
            background-color: var(--brand-rose);
        }

        .em-title {
            font-family: var(--font-serif);
            font-size: 2.8rem;
            color: var(--text-plum);
            margin-bottom: 1rem;
        }

        .em-desc {
            color: var(--text-light);
            font-size: 1.1rem;
            max-width: 600px;
            margin: 0 auto;
        }

        .em-contacts-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.5rem;
            max-width: 1200px;
            margin: 0 auto 3rem auto;
            padding: 0 2rem;
        }

        .em-contact-card {
            background: var(--white);
            border-radius: 20px;
            padding: 2rem 1.5rem;
            text-align: left;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03);
            border: 1px solid rgba(45,20,44,0.05);
            display: flex;
            flex-direction: column;
        }

        .em-card-header {
            display: flex;
            gap: 15px;
            align-items: center;
            margin-bottom: 1rem;
        }

        .em-card-icon {
            width: 50px;
            height: 50px;
            background: rgba(243, 63, 94, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--brand-rose);
            flex-shrink: 0;
        }
        
        .em-card-info h4 {
            color: var(--text-light);
            font-size: 0.9rem;
            font-weight: 500;
            margin: 0;
        }
        
        .em-card-info h2 {
            color: var(--text-plum);
            font-size: 2rem;
            font-family: var(--font-serif);
            line-height: 1;
            margin: 0;
        }

        .em-contact-card p {
            color: var(--text-light);
            font-size: 0.85rem;
            line-height: 1.5;
            margin-bottom: 1.5rem;
            flex-grow: 1;
        }

        .btn-call-now {
            background: rgba(243, 63, 94, 0.08);
            color: var(--brand-rose);
            padding: 0.8rem;
            border-radius: 50px;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-call-now:hover {
            background: var(--brand-rose);
            color: var(--white);
        }

        .map-section-wrapper {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .map-notice-bar {
            background: rgba(255, 251, 252, 0.8);
            border-radius: 12px;
            padding: 1.5rem 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2rem;
            box-shadow: 0 5px 20px rgba(0,0,0,0.02);
            border: 1px solid rgba(243, 63, 94, 0.1);
        }
        
        .map-notice-icon {
            width: 40px;
            height: 40px;
            background: rgba(243, 63, 94, 0.08);
            color: var(--brand-rose);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            flex-shrink: 0;
        }
        
        .map-notice-text h4 {
            color: var(--text-plum);
            font-size: 1.05rem;
            margin: 0 0 0.2rem 0;
        }
        
        .map-notice-text p {
            color: var(--text-light);
            font-size: 0.9rem;
            margin: 0;
        }

        .map-grid-layout {
            display: grid;
            grid-template-columns: 1.3fr 1fr;
            gap: 0;
            background: var(--white);
            border-radius: 20px;
            padding: 0.5rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03);
            border: 1px solid rgba(45,20,44,0.05);
            overflow: hidden;
        }

        .map-iframe-container {
            width: 100%;
            height: 500px;
            border-radius: 16px;
            overflow: hidden;
            background: #e9e9e9;
        }

        .map-iframe-container iframe {
            width: 100%;
            height: 100%;
            border: none;
        }

        .map-legend-col {
            padding: 2rem 2.5rem;
            display: flex;
            flex-direction: column;
        }
        
        .legend-eyebrow {
            color: var(--brand-rose);
            font-weight: 700;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.5rem;
        }

        .map-legend-col h3 {
            font-family: var(--font-serif);
            font-size: 2.2rem;
            color: var(--text-plum);
            margin: 0 0 1rem 0;
        }

        .map-legend-col > p {
            color: var(--text-light);
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 2rem;
        }

        .legend-items {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            position: relative;
        }
        
        .legend-item::after {
            content: "";
            position: absolute;
            bottom: -0.75rem;
            left: 0;
            right: 0;
            height: 1px;
            background: rgba(0,0,0,0.05);
        }
        
        .legend-item:last-child::after { display: none; }

        .legend-icon {
            width: 45px;
            height: 45px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 1.2rem;
        }
        
        .legend-icon.high { background: rgba(243, 63, 94, 0.1); color: #F33F5E; }
        .legend-icon.medium { background: rgba(255, 183, 77, 0.15); color: #F57C00; }
        .legend-icon.safe { background: rgba(102, 187, 106, 0.15); color: #388E3C; }

        .legend-text { flex-grow: 1; }
        
        .legend-text h5 {
            font-size: 0.95rem;
            margin: 0 0 0.2rem 0;
        }
        
        .legend-text h5.high { color: #F33F5E; }
        .legend-text h5.medium { color: #F57C00; }
        .legend-text h5.safe { color: #388E3C; }
        
        .legend-text p {
            font-size: 0.8rem;
            line-height: 1.4;
            color: var(--text-light);
            margin: 0;
        }
        
        .legend-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            flex-shrink: 0;
        }
        
        .legend-dot.high { background: #F33F5E; }
        .legend-dot.medium { background: #FFB74D; }
        .legend-dot.safe { background: #66BB6A; }
        
        .btn-view-map {
            background-color: var(--brand-rose);
            color: var(--white);
            padding: 1rem;
            border-radius: 50px;
            text-align: center;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s;
            margin-top: auto;
            border: none;
            cursor: pointer;
        }
        
        .btn-view-map:hover {
            background-color: #E4234C;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(243, 63, 94, 0.3);
        }
        
        @media (max-width: 1100px) {
            .em-contacts-grid { grid-template-columns: repeat(2, 1fr); padding: 0 1rem;}
            .map-grid-layout { grid-template-columns: 1fr; }
            .map-iframe-container { height: 400px; }
        }
        @media (max-width: 600px) {
            .em-contacts-grid { grid-template-columns: 1fr; }
            .map-legend-col { padding: 1.5rem; }
        }

        @media (max-width: 900px) {
            .footer-links-grid { grid-template-columns: repeat(2, 1fr); }
            .footer-emergency { flex-direction: column; text-align: center; gap: 1.5rem; }
            .final-cta-container h2 { font-size: 2.5rem; }
        }
        @media (max-width: 600px) {
            .market-grid { grid-template-columns: 1fr; }
            .market-featured { grid-column: span 1; }
            .footer-links-grid { grid-template-columns: 1fr; text-align: center; }
            .footer-bottom { flex-direction: column; gap: 1rem; text-align: center; }
            .footer-bottom-links a { margin: 0 0.8rem; }
            .floating-sos { bottom: 20px; right: 20px; padding: 0.8rem 1.2rem; }
            .floating-sos span { display: none; }
        }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <nav class="navbar" id="navbar">
        <a href="/users/register" class="nav-logo">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="FightDFear Logo" class="brand-logo-img">
           
        </a>
        
        <ul class="nav-links">
            <li class="nav-item">Home</li>
            <li class="nav-item">
                Safety ⌄
                <div class="dropdown-menu">
                    <a href="/users/register" class="dropdown-item">Emergency SOS</a>
                    <a href="/users/register" class="dropdown-item">Emergency Contacts</a>
                    <a href="/users/register" class="dropdown-item">Safe Route</a>
                    <a href="/centres/registerCentre" class="dropdown-item">Self Defense</a>
                    <a href="/users/register" class="dropdown-item">Safety Awareness</a>
                </div>
            </li>
            <li class="nav-item">
                Wellness ⌄
                <div class="dropdown-menu">
                    <a href="/doctors/register" class="dropdown-item">Women Doctors</a>
                    <a href="/fitness/trainer/register" class="dropdown-item">Fitness</a>
                    <a href="/salons/register" class="dropdown-item">Beauty & Wellness</a>
                </div>
            </li>
            <li class="nav-item"><a href="/salons/register" style="text-decoration:none;">Services</a></li>
            <li class="nav-item"><a href="/marketplace/provider/register" style="text-decoration:none;">Marketplace</a></li>
            <li class="nav-item">
                Business ⌄
                <div class="dropdown-menu">
                    <a href="/entrepreneur/register" class="dropdown-item">Entrepreneurs</a>
                    <a href="/investor/register" class="dropdown-item">Women Investors</a>
                </div>
            </li>
            <li class="nav-item">
                Community ⌄
                <div class="dropdown-menu">
                    <a href="/women-events/host/register" class="dropdown-item">Events</a>
                    <a href="/users/register" class="dropdown-item">Women's Community</a>
                </div>
            </li>
            <li class="nav-item mobile-only-item">
                Login Portals ⌄
                <div class="dropdown-menu">
                    <a href="/login" class="dropdown-item">Join as Member</a>
                    <a href="/doctors/login" class="dropdown-item">Women Doctor</a>
                    <a href="/centres/login" class="dropdown-item">Self-Defense Trainer</a>
                    <a href="/salons/login" class="dropdown-item">Beauty & Wellness</a>
                    <a href="/seller/login" class="dropdown-item">Service Partner</a>
                    <a href="/provider/login" class="dropdown-item">Marketplace Seller</a>
                    <a href="/entrepreneur/login" class="dropdown-item">Entrepreneur</a>
                    <a href="/investor/login" class="dropdown-item">Investor</a>
                    <a href="${pageContext.request.contextPath}/women-events/host/login" class="dropdown-item">Event Host</a>
                    <a href="/trainer/login" class="dropdown-item">Fitness Trainer</a>
                </div>
            </li>
        </ul>

        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/women-events" class="nav-events" style="text-decoration:none;">Events</a>
            <div class="nav-item">
                <span class="nav-login" style="display:inline-flex; align-items:center; gap:6px; background-color: var(--brand-rose); color: var(--white); padding: 0.6rem 1.4rem; border-radius: 50px; font-weight: 600; cursor: pointer; transition: all 0.3s ease;">
                    <svg fill="currentColor" width="18" height="18" viewBox="0 0 24 24"><path d="M15 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm-9-2V7H4v3H1v2h3v3h2v-3h3v-2H6zm9 4c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg> 
                    login ▾
                </span>
                <div class="dropdown-menu" style="right: 0; left: auto; top: 100%; margin-top: 15px; width: 230px;">
                    <a href="${pageContext.request.contextPath}/login" class="dropdown-item">Join as Member</a>
                    <a href="${pageContext.request.contextPath}/doctors/login" class="dropdown-item">Women Doctor</a>
                    <a href="${pageContext.request.contextPath}/centres/login" class="dropdown-item">Self-Defense Trainer</a>
                    <a href="${pageContext.request.contextPath}/salons/login" class="dropdown-item">Beauty & Wellness</a>
					<a href="${pageContext.request.contextPath}/lawyer/login" class="dropdown-item">Women Lawyer</a>
                    <a href="${pageContext.request.contextPath}/women-jobs/login" class="dropdown-item">Women Jobs</a>
                    <a href="${pageContext.request.contextPath}/women-products/seller/login" class="dropdown-item">Product Seller</a>
                    <a href="${pageContext.request.contextPath}/marketplace/provider/login" class="dropdown-item">Marketplace Provider</a>
                    <a href="${pageContext.request.contextPath}/entrepreneur/login" class="dropdown-item">Entrepreneur</a>
                    <a href="${pageContext.request.contextPath}/investor/login" class="dropdown-item">Investor</a>
                    <a href="${pageContext.request.contextPath}/women-events/host/login" class="dropdown-item">Event Host</a>
                    <a href="${pageContext.request.contextPath}/fitness/trainer/login" class="dropdown-item">Fitness Trainer</a>
                </div>

            </div>
            <a href="/users/register" class="btn-sos-nav">🆘 Emergency SOS</a>
            <button class="mobile-menu-btn">☰</button>
        </div>
    </nav>

    <!-- PREMIUM SPLIT HERO SECTION -->
    <section class="split-hero-section" id="heroStatic">
        <div class="split-hero-container">
            <!-- Left Side: Content Column -->
            <div class="hero-content">
                <div class="eyebrow-badge">
                    <span class="eyebrow-text">Fight D Fear • Empowering Women</span>
                </div>
                <h1 class="hero-title">Empowering Women.<br><span class="highlight-pink">Protecting Futures.</span></h1>
                <p class="hero-desc">Safety, healthcare, wellness, financial growth, career opportunities, and meaningful connections — everything women need to live stronger, safer, and more empowered.</p>
                
                <div class="static-hero-features">
                    <div class="feature-box">
                        <div class="feature-box-icon">🛡️</div>
                        <span class="feature-box-text">Safety & Protection</span>
                    </div>
                    <div class="feature-box">
                        <div class="feature-box-icon">🏥</div>
                        <span class="feature-box-text">Women’s Health</span>
                    </div>
                    <div class="feature-box">
                        <div class="feature-box-icon">🧘‍♀️</div>
                        <span class="feature-box-text">Fitness & Wellness</span>
                    </div>
                    <div class="feature-box">
                        <div class="feature-box-icon">📈</div>
                        <span class="feature-box-text">Financial Growth</span>
                    </div>
                    <div class="feature-box">
                        <div class="feature-box-icon">🤝</div>
                        <span class="feature-box-text">Events & Community</span>
                    </div>
                    <div class="feature-box">
                        <div class="feature-box-icon">💼</div>
                        <span class="feature-box-text">Business & Investment</span>
                    </div>
                </div>

                <div class="hero-actions">
                    <a href="/users/register" class="btn-primary">Explore Our Platform &rarr;</a>
                    <a href="/users/register" class="btn-secondary-outline">Get Started</a>
                </div>
            </div>

            <!-- Right Side: Image Column -->
            <div class="hero-img-col">
              
                <!-- Using the Indian women empowerment hero image -->
                <img src="${pageContext.request.contextPath}/images/hero_split_img.png" alt="Empowering Women" class="hero-split-image">
            </div>
        </div>
    </section>
  <!-- OPTIONAL STATISTICS STRIP -->
    <section class="stats-section reveal">
        <div class="stats-grid">
            <div>
                <div class="stat-number">10K+</div>
                <div class="stat-label">Women Connected</div>
            </div>
            <div>
                <div class="stat-number">500+</div>
                <div class="stat-label">Services</div>
            </div>
            <div>
                <div class="stat-number">100+</div>
                <div class="stat-label">Events</div>
            </div>
            <div>
                <div class="stat-number">50+</div>
                <div class="stat-label">Resources</div>
            </div>
        </div>
    </section>

    <!-- SECTION 1: YOUR SAFETY, ALWAYS WITHIN REACH -->
    <section class="safety-reach-section reveal">
        <div class="safety-container">
            
            <!-- ROW 1: SAFETY WITHIN REACH -->
            <div class="safety-block-row">
                <!-- Left Image (Clean image without floating badges overlay) -->
                <div class="safety-img-wrapper">
                    <img src="${pageContext.request.contextPath}/images/safety_emergency_illustration.png" alt="Your Safety Always Within Reach" class="safety-img">
                </div>

                <!-- Right Content Column -->
                <div class="safety-text-col">
                    <h2 class="safety-main-title">
                        Your Safety,
                        <span class="highlight-pink-line">Always Within Reach</span>
                    </h2>
                    <p class="safety-main-desc">
                        Everyday protection, trusted resources and practical safety tools designed to help women feel confident wherever they go.
                    </p>

                    <!-- 4 Feature Cards Grid -->
                    <div class="safety-4cards-grid">
                        <!-- Card 1 -->
                        <div class="safety-card-item">
                            <div class="card-item-icon">🗺️</div>
                            <h4>Safe Map</h4>
                            <p>Find safer routes and nearby trusted places.</p>
                        </div>
                        
                        <!-- Card 2 -->
                        <div class="safety-card-item">
                            <div class="card-item-icon">🎯</div>
                            <h4>Share Live Location</h4>
                            <p>Stay connected with trusted contacts wherever you go.</p>
                        </div>
                        
                        <!-- Card 3 -->
                        <div class="safety-card-item">
                            <div class="card-item-icon">🛡️</div>
                            <h4>Self Defence</h4>
                            <p>Learn practical skills and techniques to protect yourself.</p>
                        </div>
                        
                        <!-- Card 4 -->
                        <div class="safety-card-item">
                            <div class="card-item-icon">🎧</div>
                            <h4>Trusted Support</h4>
                            <p>Connect with verified professionals and support resources.</p>
                        </div>
                    </div>

                    <!-- Button -->
                    <div style="margin-top: 0.5rem;">
                        <a href="/users/register" class="btn-explore-safety-tools">
                            <span>🛡️</span> Explore Safety Tools &rarr;
                        </a>
                    </div>
                </div>
            </div>

            <!-- ROW 2: GET HELP WHEN YOU NEED IT -->
            <div class="safety-block-row emergency-support-row">
                <!-- Left Image Wrapper: Normal display, compact width, clean image without upper side overlay badges -->
                <div class="safety-img-wrapper sos-img-wrapper">
                    <img src="${pageContext.request.contextPath}/images/emergency_sos_img.png" alt="Get Help When You Need It" class="safety-img emergency-side-img">
                </div>

                <!-- Right Card Box: Pink Background Styling -->
                <div class="emergency-sos-card">
                    <div>
                        <span class="emergency-tag-pill">EMERGENCY SUPPORT</span>
                        <h2 class="safety-main-title" style="margin-top: 0.5rem; font-size: 2.5rem;">
                            Get Help When You Need It
                        </h2>
                        <p class="safety-main-desc">
                            Activate an emergency alert to notify your trusted contacts and share your current location.
                        </p>
                    </div>

                    <!-- Large Pulsing Circular SOS Button -->
                    <a href="/users/register" class="pulse-sos-circle" style="text-decoration:none;">
                        <span class="sos-circle-text">SOS</span>
                        <span class="sos-circle-sub">Press to send emergency alert</span>
                    </a>

                    <!-- Action Pill Buttons -->
                    <div class="emergency-actions-row">
                        <a href="/users/register" class="btn-action-pink">
                            📞 Emergency Contacts &rarr;
                        </a>
                        <a href="/users/register" class="btn-action-pink">
                            📍 Share Live Location &rarr;
                        </a>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <!-- SECTION 2: EVERYTHING SHE NEEDS -->
    <section class="features-section section-padding reveal">
        <div class="section-header">
            <h2 class="section-title">Everything She Needs, In One Place</h2>
            <p class="section-desc">From everyday wellness to ambitious dreams, discover services, resources and opportunities designed around women.</p>
        </div>
        
        <div class="bento-grid">
            <!-- Safety -->
            <div class="bento-item bento-safety">
                <img src="https://images.openai.com/static-rsc-4/VwgI5kAPqWSxIuFIQk4KJt8co5YSbVSxcSusxYhgplfBQQs9cErFyhlf1e1Abd7LkznYNFOfYMMq5U8dKQjxkzFHLMBS8KXQlH845N18IxqPTOKxXrl32wWXlOlFNiQmyxezEjoquO9-Q73MYIW9mttJWfza3NPyAFqxVB6t_s_bCk3imj2DiN0YmEej6kMo?purpose=fullsize" alt="Safety" class="bento-bg-img">
                <div class="bento-overlay"></div>
                <div class="bento-content bento-content-light">
                    <div style="font-size: 2rem; margin-bottom:1rem;">🛡️</div>
                    <h3>Safety & Emergency</h3>
                    <p>Protection, emergency support, self-defense and safety resources.</p>
                    <a href="/users/register" class="bento-action" style="color:var(--brand-rose);">Explore Safety &rarr;</a>
                </div>
            </div>
            
            <!-- Doctors -->
            <div class="bento-item bento-doctors">
                <div class="bento-content">
                    <div style="font-size: 2rem; margin-bottom:1rem; color: var(--brand-rose);">👩‍⚕️</div>
                    <h3>Women Doctors</h3>
                    <p>Find healthcare professionals and trusted health resources.</p>
                    <a href="/users/register" class="bento-action" style="color:var(--brand-plum);">Find Care &rarr;</a>
                </div>
                <img src="https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=300&q=80" alt="Doctor" class="img-circle">
            </div>
            
            <!-- Beauty -->
            <div class="bento-item bento-beauty">
                <div class="bento-content">
                    <div style="font-size: 2rem; margin-bottom:1rem;">✨</div>
                    <h3>Beauty & Self Care</h3>
                    <p>Find trusted beauty and wellness professionals.</p>
                    <a href="/users/register" class="bento-action" style="color:var(--brand-plum);">Discover &rarr;</a>
                </div>
            </div>
            
            <!-- Wellness -->
            <div class="bento-item bento-wellness">
                <img src="https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=600&q=80" alt="Wellness" class="bento-bg-img">
                <div class="bento-overlay"></div>
                <div class="bento-content bento-content-light">
                    <div style="font-size: 2rem; margin-bottom:1rem;">🧘‍♀️</div>
                    <h3>Fitness & Wellness</h3>
                    <p>Discover fitness classes, trainers and wellness programs.</p>
                    <a href="/users/register" class="bento-action" style="color:var(--brand-rose);">View Programs &rarr;</a>
                </div>
            </div>
            
            <!-- Marketplace -->
            <div class="bento-item bento-market">
                <img src="https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=600&q=80" alt="Marketplace" class="bento-bg-img">
                <div class="bento-overlay"></div>
                <div class="bento-content bento-content-light">
                    <div style="font-size: 2rem; margin-bottom:1rem;">🛍️</div>
                    <h3>Women's Marketplace</h3>
                    <p>Buy, sell and discover products and services.</p>
                    <a href="/users/register" class="bento-action" style="color:var(--brand-rose);">Shop Now &rarr;</a>
                </div>
            </div>
            
            <!-- Business -->
            <div class="bento-item bento-business">
                <div class="bento-content">
                    <div style="font-size: 2rem; margin-bottom:1rem;">💼</div>
                    <h3>Entrepreneurs & Investors</h3>
                    <p>Connect women entrepreneurs with investors and business opportunities.</p>
                    <a href="/users/register" class="bento-action" style="color:var(--brand-plum);">Connect &rarr;</a>
                </div>
            </div>
            
            <!-- Community -->
            <div class="bento-item bento-community">
                <div class="bento-content bento-content-light">
                    <h3>🤝 Community & Events</h3>
                    <p style="margin-bottom:0;">Discover workshops, networking, awareness programs and women-focused events.</p>
                </div>
                <a href="/users/register" class="btn-primary" style="background:var(--white); color:var(--brand-plum);">Join Community</a>
            </div>
        </div>
    </section>

    <!-- SECTION 3: WHY CHOOSE US -->
    <section class="why-us-section section-padding reveal">
        <div class="why-us-container">
            <div class="why-us-image">
                <img src="https://images.openai.com/static-rsc-4/LQ_GjMZak7cAnhAStavqa07Nd4Fmd_VYNpEqvCJE4GvZEMIqqtj6wy7CDFmzGvHGmQzyqLaty04E8BoeLZLBHU97N1CjFADqm8T4cLJXhLtDlyezYWbAGGsGuutBPrFfuSQP2U6Q275sWg7Bl7D6YKkJIlmZMOW8DACxJ3v8v3Rmau1Nz7xO65hsdhEnKj9Y?purpose=fullsize" alt="Empowered Women">
            </div>
            
            <div class="why-us-content">
                <span class="why-us-label">Why Choose Us</span>
                <h2 class="why-us-title">More Than a Platform.<br>A Support System.</h2>
                <p class="why-us-desc">Everything we build is designed to help women feel safer, healthier, more connected and more empowered.</p>
                
                <div class="why-us-points">
                    <div class="point-item">
                        <div class="point-icon">✓</div>
                        <h4>Safety First</h4>
                        <p>Protection is at the heart of the platform.</p>
                    </div>
                    
                    <div class="point-item">
                        <div class="point-icon">✓</div>
                        <h4>Women-Centered</h4>
                        <p>Services and experiences are designed around women's needs.</p>
                    </div>
                    
                    <div class="point-item">
                        <div class="point-icon">✓</div>
                        <h4>Trusted Connections</h4>
                        <p>Connect with professionals, providers and communities.</p>
                    </div>
                    
                    <div class="point-item">
                        <div class="point-icon">✓</div>
                        <h4>Opportunities to Grow</h4>
                        <p>Learn, build, connect and grow.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- SECTION 4: WOMEN'S WELLNESS -->
    <section class="wellness-section section-padding reveal">
        <div class="section-header">
            <h2 class="section-title">Take Care of You</h2>
            <p class="section-desc">Your wellbeing matters. Discover trusted healthcare, fitness and self-care services designed for every stage of your journey.</p>
        </div>
        
        <div class="wellness-grid">
            <!-- Large Editorial Card -->
            <div class="well-card-large">
                <img src="${pageContext.request.contextPath}/images/women_doctor_img.png" alt="Women Doctors Consultation">
                <div class="well-overlay">
                    <div style="font-size:2rem; margin-bottom:1rem;">👩‍⚕️</div>
                    <h3>Women Doctors</h3>
                    <p>Find healthcare professionals and trusted resources for women's health.</p>
                    <a href="${pageContext.request.contextPath}/doctors/list" class="btn-primary" style="align-self: flex-start; background: var(--white); color: var(--brand-plum);">Find a Doctor &rarr;</a>
                </div>
            </div>
            
            <!-- Medium Card 1 -->
            <div class="well-card-medium">
                <div class="well-icon">🧘‍♀️</div>
                <h3>Fitness & Wellness</h3>
                <p>Discover fitness classes, trainers and wellness programs that fit your lifestyle.</p>
                <div><a href="/fitness/trainer/register" class="well-link">Explore Fitness &rarr;</a></div>
            </div>
            
            <!-- Medium Card 2 -->
            <div class="well-card-medium">
                <div class="well-icon">✨</div>
                <h3>Beauty & Self Care</h3>
                <p>Connect with trusted beauty and wellness professionals for your self-care journey.</p>
                <div><a href="/salons/register" class="well-link">Explore Wellness &rarr;</a></div>
            </div>
        </div>
    </section>

    <!-- EMERGENCY SERVICES & MAP SECTION -->
    <section class="emergency-map-section reveal">
        <div class="em-header">
            <div class="em-eyebrow">EMERGENCY SERVICES</div>
            <h2 class="em-title">Quick Help When You Need It Most</h2>
            <p class="em-desc">Get immediate access to important emergency contacts and stay informed about safety risks around you.</p>
        </div>

        <div class="em-contacts-grid">
            <!-- Police -->
            <div class="em-contact-card">
                <div class="em-card-header">
                    <div class="em-card-icon">👮‍♂️</div>
                    <div class="em-card-info">
                        <h4>Police</h4>
                        <h2>100</h2>
                    </div>
                </div>
                <p>For immediate police assistance and emergency protection.</p>
                <a href="tel:100" class="btn-call-now">📞 Call Now</a>
            </div>

            <!-- Ambulance -->
            <div class="em-contact-card">
                <div class="em-card-header">
                    <div class="em-card-icon">🚑</div>
                    <div class="em-card-info">
                        <h4>Ambulance</h4>
                        <h2>108</h2>
                    </div>
                </div>
                <p>Get urgent medical assistance during emergencies.</p>
                <a href="tel:108" class="btn-call-now">📞 Call Now</a>
            </div>

            <!-- Women Helpline -->
            <div class="em-contact-card">
                <div class="em-card-header">
                    <div class="em-card-icon">👩‍💼</div>
                    <div class="em-card-info">
                        <h4>Women Helpline</h4>
                        <h2>1091</h2>
                    </div>
                </div>
                <p>Get support and assistance for women facing unsafe or emergency situations.</p>
                <a href="tel:1091" class="btn-call-now">📞 Call Now</a>
            </div>

            <!-- Fire Service -->
            <div class="em-contact-card">
                <div class="em-card-header">
                    <div class="em-card-icon">🧯</div>
                    <div class="em-card-info">
                        <h4>Fire Service</h4>
                        <h2>101</h2>
                    </div>
                </div>
                <p>Contact fire and rescue services during fire or rescue emergencies.</p>
                <a href="tel:101" class="btn-call-now">📞 Call Now</a>
            </div>
        </div>

        <div class="map-section-wrapper">
            <div class="map-notice-bar">
                <div class="map-notice-icon">🛡️</div>
                <div class="map-notice-text">
                    <h4>Your Safety, Always Within Reach</h4>
                    <p>Use the map to understand your surroundings, plan safer routes, and make informed decisions while travelling.</p>
                </div>
            </div>

            <div class="map-grid-layout">
                <!-- Map Left Side -->
                <div class="map-iframe-container">
                    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d112002.50280453303!2d77.10091394576378!3d28.68538354972179!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x390cfd5b347eb62d%3A0x37205b715389640!2sDelhi!5e0!3m2!1sen!2sin!4v1703649666014!5m2!1sen!2sin" title="Safety Map" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                </div>

                <!-- Legend Right Side -->
                <div class="map-legend-col">
                    <div class="legend-eyebrow">STAY AWARE</div>
                    <h3>Unsafe Area Map</h3>
                    <p>Check unsafe areas in and around your location in real-time. Stay alert, stay safe!</p>

                    <div class="legend-items">
                        <div class="legend-item">
                            <div class="legend-icon high">🛡️</div>
                            <div class="legend-text">
                                <h5 class="high">High Risk Area</h5>
                                <p>Areas with reported safety concerns. Stay alert and avoid unnecessary travel.</p>
                            </div>
                            <div class="legend-dot high"></div>
                        </div>

                        <div class="legend-item">
                            <div class="legend-icon medium">🛡️</div>
                            <div class="legend-text">
                                <h5 class="medium">Medium Risk Area</h5>
                                <p>Areas where additional awareness and caution are recommended.</p>
                            </div>
                            <div class="legend-dot medium"></div>
                        </div>

                        <div class="legend-item">
                            <div class="legend-icon safe">🛡️</div>
                            <div class="legend-text">
                                <h5 class="safe">Safe Area</h5>
                                <p>Areas currently showing lower reported safety concerns.</p>
                            </div>
                            <div class="legend-dot safe"></div>
                        </div>
                    </div>

                    <a href="/safety/map" class="btn-view-map">View Full Safety Map &rarr;</a>
                </div>
            </div>
        </div>
    </section>

   

    <!-- SECTION 5: WOMEN'S AWARENESS HUB -->
    <section class="awareness-section section-padding reveal">
        <div class="section-header">
            <h2 class="section-title">Know More. Stay Aware. Stay Safe.</h2>
            <p class="section-desc">Knowledge gives confidence. Explore practical resources that help women make informed decisions, protect themselves and build a stronger future.</p>
        </div>
        
        <div class="awareness-editorial-list">
            <!-- Article 1: Legal Rights (Left Image, Right Content) -->
            <div class="aw-editorial-item">
                <div class="aw-item-img">
                    <img src="${pageContext.request.contextPath}/images/legal_rights_img.png" alt="Legal Rights">
                </div>
                <div class="aw-item-content">
                    <span class="aw-item-cat">Legal Rights</span>
                    <h3>Know Your Rights</h3>
                    <p>Understanding your rights is the first step toward protecting yourself, standing firm, and making confident decisions in everyday life.</p>
                    <a href="/users/register" class="aw-item-link">Read Full Guide &rarr;</a>
                </div>
            </div>

            <!-- Article 2: Safety Awareness (Right Image, Left Content) -->
            <div class="aw-editorial-item aw-reverse">
                <div class="aw-item-img">
                    <img src="${pageContext.request.contextPath}/images/safety_awareness_img.png" alt="Safety Awareness">
                </div>
                <div class="aw-item-content">
                    <span class="aw-item-cat">Safety & Preparedness</span>
                    <h3>Safety Awareness</h3>
                    <p>Practical everyday safety strategies, emergency alert tools, and essential self-defense guidelines tailored for modern women.</p>
                    <a href="/users/register" class="aw-item-link">Read Full Guide &rarr;</a>
                </div>
            </div>

            <!-- Article 3: Money Confidence (Left Image, Right Content) -->
            <div class="aw-editorial-item">
                <div class="aw-item-img">
                    <img src="${pageContext.request.contextPath}/images/financial_awareness_img.png" alt="Financial Awareness">
                </div>
                <div class="aw-item-content">
                    <span class="aw-item-cat">Financial Awareness</span>
                    <h3>Money Confidence</h3>
                    <p>Build confidence around money management, smart investments, savings, and financial independence for long-term freedom.</p>
                    <a href="/users/register" class="aw-item-link">Read Full Guide &rarr;</a>
                </div>
            </div>

            <!-- Article 4: Women's Health (Right Image, Left Content) -->
            <div class="aw-editorial-item aw-reverse">
                <div class="aw-item-img">
                    <img src="${pageContext.request.contextPath}/images/womens_health_guide_img.png" alt="Women's Health Guide">
                </div>
                <div class="aw-item-content">
                    <span class="aw-item-cat">Health & Wellbeing</span>
                    <h3>Women's Health Guide</h3>
                    <p>Expert healthcare advice, mental health check-ins, and holistic wellness resources curated for every stage of your life journey.</p>
                    <a href="/users/register" class="aw-item-link">Read Full Guide &rarr;</a>
                </div>
            </div>
        </div>
    </section>

    <!-- SECTION 6: WOMEN BUSINESS & INVESTMENT -->
    <section class="business-section section-padding reveal">
        <div class="section-header">
            <h2 class="section-title">Her Ambition Has No Limits</h2>
            <p class="section-desc">Discover opportunities, build businesses, connect with investors and grow alongside a community of ambitious women.</p>
        </div>
        
        <div class="business-grid">
            <div class="business-img-wrapper">
                <img src="${pageContext.request.contextPath}/images/investor_entrepreneur_img.png" alt="Woman Entrepreneur & Investor">
            </div>
            
            <div class="business-content">
                <div class="biz-card">
                    <h3>Build Something That Matters</h3>
                    <p>Turn your idea into an opportunity. Connect with resources, mentors and a community that supports women entrepreneurs.</p>
                    <a href="/entrepreneur/register" class="well-link">Explore Entrepreneurs &rarr;</a>
                </div>
                
                <div class="biz-card">
                    <h3>Invest in Her Potential</h3>
                    <p>Discover women-led businesses and opportunities with the potential to create meaningful impact.</p>
                    <a href="/investor/register" class="well-link">Explore Investment Opportunities &rarr;</a>
                </div>
                
                <div class="biz-opportunities">
                    <h4>Discover Opportunities</h4>
                    <div class="biz-tags">
                        <span class="biz-tag">Business</span>
                        <span class="biz-tag">Mentorship</span>
                        <span class="biz-tag">Networking</span>
                        <span class="biz-tag">Funding</span>
                        <span class="biz-tag">Workshops</span>
                        <span class="biz-tag">Partnerships</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- SECTION 7: WOMEN'S MARKETPLACE -->
    <section class="marketplace-section reveal">
        <div class="marketplace-header">
            <h2 style="background-color: #3A60D0; color: white; display: inline-block; padding: 5px 15px; font-size: 2.8rem; font-family: var(--font-serif); margin-bottom: 10px;">Support Her. Shop Her. Grow Together.</h2>
      
            <br>
            <p style="background-color: #3A60D0; color: white; display: inline-block; padding: 4px 12px; font-size: 0.95rem; margin-bottom: 5px;">Discover products, services and businesses created by women and</p><br>
            <p style="background-color: #3A60D0; color: white; display: inline-block; padding: 4px 12px; font-size: 0.95rem; margin: 0;">support the people behind them</p>
        </div>
        
        <div class="market-bento-layout">
            <!-- Main Grid Card (Left Tall) -->
            <div class="market-bento-card market-card-main">
                <img src="https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&q=80" alt="Curated Collection">
                <div class="market-bento-overlay"></div>
                <div class="market-bento-content">
                    <span class="market-cat">FEATURED WOMEN BRAND</span>
                    <h3>Curated Collection</h3>
                    <a href="/marketplace/provider/register" class="market-btn">Explore Premium &rarr;</a>
                </div>
            </div>
            
            <!-- Right Top (Beauty) -->
            <div class="market-bento-card market-card-sm-top">
                <img src="https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=500&q=80" alt="Beauty">
                <div class="market-bento-overlay"></div>
                <div class="market-bento-content">
                    <h3>Beauty <span style="font-size: 1rem;">&rarr;</span></h3>
                </div>
            </div>
            
            <!-- Right Middle (Fashion) -->
            <div class="market-bento-card market-card-sm-mid">
                <img src="https://images.unsplash.com/photo-1483985988355-763728e1935b?w=500&q=80" alt="Fashion">
                <div class="market-bento-overlay"></div>
                <div class="market-bento-content">
                    <h3>Fashion <span style="font-size: 1rem;">&rarr;</span></h3>
                </div>
            </div>
            
            <!-- Bottom Left (Wellness) -->
            <div class="market-bento-card market-card-hz-bot-l">
                <img src="https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=600&q=80" alt="Wellness">
                <div class="market-bento-overlay"></div>
                <div class="market-bento-content">
                    <h3>Wellness <span style="font-size: 1rem;">&rarr;</span></h3>
                </div>
            </div>
            
            <!-- Bottom Right (Home & Lifestyle) -->
            <div class="market-bento-card market-card-hz-bot-r">
                <img src="https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=600&q=80" alt="Home & Lifestyle">
                <div class="market-bento-overlay"></div>
                <div class="market-bento-content">
                    <h3>Home & Lifestyle <span style="font-size: 1rem;">&rarr;</span></h3>
                </div>
            </div>
        </div>
        
        <div style="text-align: center;">
            <a href="/marketplace/provider/register" class="btn-magenta">Explore Marketplace &rarr;</a>
        </div>
    </section>

    <!-- SECTION 8: EVENTS -->
    <section class="events-section section-padding reveal">
        <div class="section-header">
            <h2 class="section-title">What's Happening for Her</h2>
            <p class="section-desc">Connect, learn, celebrate and grow through events created for women.</p>
        </div>
        
        <div class="events-grid">
            <div class="event-card">
                <div class="event-img">
                    <img src="https://images.unsplash.com/photo-1548142813-c348350df52b?w=600&q=80" alt="Self Defense">
                    <div class="event-date-badge">22<span>Aug</span></div>
                </div>
                <div class="event-content">
                    <div class="event-meta">📍 Bangalore</div>
                    <h3>Self Defense Workshop</h3>
                    <p>Learn practical safety techniques.</p>
                    <div><a href="/centres/registerCentre" class="well-link">View Event &rarr;</a></div>
                </div>
            </div>
            
            <div class="event-card">
                <div class="event-img">
                    <img src="https://images.unsplash.com/photo-1573164713714-d95e436ab8d6?w=600&q=80" alt="Networking">
                    <div class="event-date-badge">28<span>Aug</span></div>
                </div>
                <div class="event-content">
                    <div class="event-meta">📍 Bangalore</div>
                    <h3>Women's Networking Meetup</h3>
                    <p>Meet ambitious women and build meaningful connections.</p>
                    <div><a href="/women-events/host/register" class="well-link">View Event &rarr;</a></div>
                </div>
            </div>
            
            <div class="event-card">
                <div class="event-img">
                    <img src="https://images.unsplash.com/photo-1518611012118-696072aa579a?w=600&q=80" alt="Wellness Day">
                    <div class="event-date-badge">05<span>Sep</span></div>
                </div>
                <div class="event-content">
                    <div class="event-meta">📍 Bangalore</div>
                    <h3>Wellness & Fitness Day</h3>
                    <p>A day focused on movement, wellness and self-care.</p>
                    <div><a href="/fitness/trainer/register" class="well-link">View Event &rarr;</a></div>
                </div>
            </div>
        </div>
    </section>

    <!-- SECTION 9: COMMUNITY CTA -->
    <section class="community-cta reveal">
        <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=1200&q=80" alt="Community">
        <div class="bento-overlay"></div>
        <div class="cta-content">
            <h2>You Don't Have to Do It Alone.</h2>
            <p>Connect with women who share your interests, goals and experiences.</p>
            <div class="cta-buttons">
                <a href="/users/register" class="btn-primary" style="background:var(--white); color:var(--brand-plum);">Join the Community</a>
                <a href="/users/register" class="btn-outline-light">Explore Discussions</a>
            </div>
        </div>
    </section>

    <!-- SECTION 10: FINAL CTA -->
    <section class="final-cta-section section-padding reveal">
        <div class="final-cta-container">
            <h2>Everything She Needs. One Place.</h2>
            <p>From safety and healthcare to wellness, business and community &mdash; build a life where you feel supported, informed and empowered.</p>
            <div class="cta-buttons">
                <a href="/users/register" class="btn-primary" style="background:var(--white); color:var(--brand-plum);">Get Started</a>
                <a href="/users/register" class="btn-primary" style="background:transparent; border:2px solid var(--white);">Explore the Platform</a>
            </div>
            <div style="margin-top:2rem;">
                <a href="/users/register" class="btn-primary" style="background:var(--emergency-red); border:none; color:var(--white); font-size:0.9rem; padding:0.8rem 1.5rem;">&#127382; Emergency Help</a>
            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <footer class="footer reveal">
        <div class="footer-container">
            <div class="footer-top">
                <a href="/users/register" class="footer-logo" style="display:inline-flex; align-items:center; gap:12px; text-decoration:none;">
                    <img src="${pageContext.request.contextPath}/images/logo.png" alt="FightDFear Logo" style="height:60px; width:auto; filter:drop-shadow(0 4px 12px rgba(243, 63, 94, 0.2));">
                    <span style="font-family:var(--font-serif); font-size:2rem; font-weight:700; color:var(--brand-plum);">FightDFear</span>
                </a>
                <p class="footer-brand-statement">A safer, healthier and more empowered future for women.</p>
                <div class="footer-social">
                    <a href="/users/register">Instagram</a>
                    <a href="/users/register">LinkedIn</a>
                    <a href="/users/register">Facebook</a>
                    <a href="/users/register">YouTube</a>
                </div>
            </div>
            
            <div class="footer-links-grid">
                <div class="footer-col">
                    <h4>Platform</h4>
                    <ul>
                        <li><a href="/users/register">Safety</a></li>
                        <li><a href="/users/register">Emergency SOS</a></li>
                        <li><a href="/marketplace/provider/register">Marketplace</a></li>
                        <li><a href="/women-events/host/register">Events</a></li>
                        <li><a href="/users/register">Community</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Wellness</h4>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/doctors/list">Women Doctors</a></li>
                        <li><a href="/fitness/trainer/register">Fitness</a></li>
                        <li><a href="/centres/registerCentre">Wellness Centres</a></li>
                        <li><a href="/salons/register">Beauty & Self Care</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Business</h4>
                    <ul>
                        <li><a href="/entrepreneur/register">Entrepreneurs</a></li>
                        <li><a href="/investor/register">Women Investors</a></li>
                        <li><a href="/entrepreneur/register">Opportunities</a></li>
                        <li><a href="/women-events/host/register">Networking</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Resources</h4>
                    <ul>
                        <li><a href="/users/register">Awareness</a></li>
                        <li><a href="/users/register">Safety Tips</a></li>
                        <li><a href="/doctors/register">Health Resources</a></li>
                        <li><a href="/centres/registerCentre">Self Defense</a></li>
                    </ul>
                </div>
            </div>
            
            <div class="footer-bottom">
                <div>&copy; 2026 FightDFear. All rights reserved.</div>
                <div class="footer-bottom-links">
                    <a href="/users/register">Privacy Policy</a>
                    <a href="/users/register">Terms of Service</a>
                    <a href="/users/register">Contact Us</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Vanilla Javascript for interactions -->
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const navbar = document.getElementById('navbar');
            
            // Sticky Navbar
            window.addEventListener('scroll', () => {
                if (window.scrollY > 50) {
                    navbar.classList.add('sticky');
                } else {
                    navbar.classList.remove('sticky');
                }
            });

            // Mobile menu toggle
            const mobileBtn = document.querySelector('.mobile-menu-btn');
            const navLinks = document.querySelector('.nav-links');
            if (mobileBtn && navLinks) {
                mobileBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    navLinks.classList.toggle('active');
                    const isOpen = navLinks.classList.contains('active');
                    mobileBtn.innerHTML = isOpen ? '✕' : '☰';
                    mobileBtn.setAttribute('aria-expanded', isOpen);
                });

                // Close mobile menu when clicking outside
                document.addEventListener('click', (e) => {
                    if (navLinks.classList.contains('active') && !navLinks.contains(e.target) && !mobileBtn.contains(e.target)) {
                        navLinks.classList.remove('active');
                        mobileBtn.innerHTML = '☰';
                        mobileBtn.setAttribute('aria-expanded', 'false');
                    }
                });

                // Close mobile menu when clicking any link inside
                navLinks.querySelectorAll('a').forEach(link => {
                    link.addEventListener('click', () => {
                        navLinks.classList.remove('active');
                        mobileBtn.innerHTML = '☰';
                        mobileBtn.setAttribute('aria-expanded', 'false');
                    });
                });
            }

            // Scroll Reveal Animation
            const revealElements = document.querySelectorAll('.reveal');
            
            const revealOnScroll = () => {
                const windowHeight = window.innerHeight;
                const elementVisible = 100;
                
                revealElements.forEach(el => {
                    const elementTop = el.getBoundingClientRect().top;
                    if (elementTop < windowHeight - elementVisible) {
                        el.classList.add('active');
                    }
                });
            };
            
            window.addEventListener('scroll', revealOnScroll);
            revealOnScroll(); // Trigger on load
        });
    </script>

</body>
</html>