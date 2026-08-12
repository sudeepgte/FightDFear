<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="categoryDisplayName" value="${not empty provider.category ? (not empty provider.category.displayName ? provider.category.displayName : provider.category) : 'Service Partner'}"/>
<c:set var="categoryBadge" value="Partner"/>
<c:set var="classPlaceholder" value="e.g. Masterclass & Professional Workshop"/>
<c:set var="descPlaceholder" value="Provide a summary of topics, syllabus, and skills covered in this session..."/>
<c:set var="formTitle" value="Create New Class"/>
<c:set var="emptyStateDesc" value="Create your first class to start taking enrollments."/>

<c:choose>
    <c:when test="${provider.category == 'BABYSITTER'}">
        <c:set var="categoryDisplayName" value="Babysitter"/>
        <c:set var="categoryBadge" value="Babysitter"/>
        <c:set var="classPlaceholder" value="e.g. Full-Day Infant &amp; Toddler Care Session"/>
        <c:set var="descPlaceholder" value="Provide details on age groups catered, emergency care skills, activity routines, and hours..."/>
        <c:set var="formTitle" value="Create New Babysitting / Childcare Session"/>
        <c:set var="emptyStateDesc" value="Create your first childcare session to start accepting bookings."/>
    </c:when>
    <c:when test="${provider.category == 'TUTOR'}">
        <c:set var="categoryDisplayName" value="Tutor"/>
        <c:set var="categoryBadge" value="Tutor"/>
        <c:set var="classPlaceholder" value="e.g. High School Mathematics &amp; Physics Coaching"/>
        <c:set var="descPlaceholder" value="Provide a summary of subject curriculum, problem-solving, and study materials..."/>
        <c:set var="formTitle" value="Create New Tutoring Session"/>
        <c:set var="emptyStateDesc" value="Create your first tutoring session to start taking enrollments."/>
    </c:when>
    <c:when test="${provider.category == 'TAILOR'}">
        <c:set var="categoryDisplayName" value="Tailor"/>
        <c:set var="categoryBadge" value="Tailor"/>
        <c:set var="classPlaceholder" value="e.g. Custom Blouse Designing &amp; Stitching Session"/>
        <c:set var="descPlaceholder" value="Provide details on clothing types, fabric requirements, stitching timeline, and custom options..."/>
        <c:set var="formTitle" value="Create New Tailoring / Alteration Service"/>
        <c:set var="emptyStateDesc" value="Create your first tailoring service to start accepting orders."/>
    </c:when>
    <c:when test="${provider.category == 'HOME_COOK'}">
        <c:set var="categoryDisplayName" value="Home Cook"/>
        <c:set var="categoryBadge" value="Chef"/>
        <c:set var="classPlaceholder" value="e.g. Daily North Indian Tiffin &amp; Meal Preparation"/>
        <c:set var="descPlaceholder" value="Provide details on menu items, dietary options, ingredients, and delivery schedules..."/>
        <c:set var="formTitle" value="Create New Meal Service / Cooking Session"/>
        <c:set var="emptyStateDesc" value="Create your first meal service to start taking orders."/>
    </c:when>
    <c:when test="${provider.category == 'CATERING_SERVICE'}">
        <c:set var="categoryDisplayName" value="Catering Service"/>
        <c:set var="categoryBadge" value="Caterer"/>
        <c:set var="classPlaceholder" value="e.g. Wedding &amp; Party Buffet Catering Package"/>
        <c:set var="descPlaceholder" value="Provide details on guest count, course menu, dietary preferences, and service terms..."/>
        <c:set var="formTitle" value="Create New Event Catering Package"/>
        <c:set var="emptyStateDesc" value="Create your first catering package to start receiving inquiries."/>
    </c:when>
    <c:when test="${provider.category == 'EVENT_PLANNER'}">
        <c:set var="categoryDisplayName" value="Event Planner"/>
        <c:set var="categoryBadge" value="Planner"/>
        <c:set var="classPlaceholder" value="e.g. Birthday &amp; Party Management Package"/>
        <c:set var="descPlaceholder" value="Provide details on theme options, venue setup, vendor coordination, and inclusions..."/>
        <c:set var="formTitle" value="Create New Event Planning Package"/>
        <c:set var="emptyStateDesc" value="Create your first event package to start taking event bookings."/>
    </c:when>
    <c:when test="${provider.category == 'PET_CARE'}">
        <c:set var="categoryDisplayName" value="Pet Care"/>
        <c:set var="categoryBadge" value="Pet Sitter"/>
        <c:set var="classPlaceholder" value="e.g. Dog Walking &amp; Daily Pet Sitting Package"/>
        <c:set var="descPlaceholder" value="Provide details on pet types accepted, feeding routines, exercise walks, and care instructions..."/>
        <c:set var="formTitle" value="Create New Pet Care / Sitting Session"/>
        <c:set var="emptyStateDesc" value="Create your first pet care service to start taking bookings."/>
    </c:when>
    <c:when test="${provider.category == 'DIETITIAN'}">
        <c:set var="categoryDisplayName" value="Dietitian"/>
        <c:set var="categoryBadge" value="Dietitian"/>
        <c:set var="classPlaceholder" value="e.g. Personalized Weight Loss &amp; Diet Consultation"/>
        <c:set var="descPlaceholder" value="Provide details on health assessment, meal plans, follow-up consultations, and goal tracking..."/>
        <c:set var="formTitle" value="Create New Nutrition Consultation"/>
        <c:set var="emptyStateDesc" value="Create your first diet consultation to start accepting clients."/>
    </c:when>
    <c:when test="${provider.category == 'HOME_CLEANER'}">
        <c:set var="categoryDisplayName" value="Home Cleaner"/>
        <c:set var="categoryBadge" value="Cleaner"/>
        <c:set var="classPlaceholder" value="e.g. Full House Deep Cleaning &amp; Sanitization Service"/>
        <c:set var="descPlaceholder" value="Provide details on room coverage, cleaning equipment provided, duration, and safety standards..."/>
        <c:set var="formTitle" value="Create New Deep Cleaning Package"/>
        <c:set var="emptyStateDesc" value="Create your first cleaning package to start taking orders."/>
    </c:when>
    <c:when test="${provider.category == 'INTERIOR_DESIGNER'}">
        <c:set var="categoryDisplayName" value="Interior Designer"/>
        <c:set var="categoryBadge" value="Designer"/>
        <c:set var="classPlaceholder" value="e.g. 3D Living Room &amp; Kitchen Design Consultation"/>
        <c:set var="descPlaceholder" value="Provide details on design style, site visit, 3D renderings, material selection, and budget..."/>
        <c:set var="formTitle" value="Create New Interior Design Consultation"/>
        <c:set var="emptyStateDesc" value="Create your first design consultation to start accepting projects."/>
    </c:when>
    <c:when test="${provider.category == 'HANDICRAFT_SELLER'}">
        <c:set var="categoryDisplayName" value="Handicraft Seller"/>
        <c:set var="categoryBadge" value="Artisan"/>
        <c:set var="classPlaceholder" value="e.g. Handmade Terracotta &amp; Clay Crafts Workshop"/>
        <c:set var="descPlaceholder" value="Provide details on craft materials, techniques taught, finished items, and order terms..."/>
        <c:set var="formTitle" value="Create New Handicraft Workshop"/>
        <c:set var="emptyStateDesc" value="Create your first craft workshop to start taking enrollments."/>
    </c:when>
    <c:when test="${provider.category == 'DIGITAL_MARKETING_CONSULTANT'}">
        <c:set var="categoryDisplayName" value="Digital Marketing Consultant"/>
        <c:set var="categoryBadge" value="Consultant"/>
        <c:set var="classPlaceholder" value="e.g. Social Media Growth &amp; SEO Audit Package"/>
        <c:set var="descPlaceholder" value="Provide details on campaign scope, target audience analysis, ad budget, and performance reports..."/>
        <c:set var="formTitle" value="Create New Marketing Consultation Package"/>
        <c:set var="emptyStateDesc" value="Create your first marketing package to start taking clients."/>
    </c:when>
    <c:when test="${provider.category == 'HOME_BAKER'}">
        <c:set var="categoryDisplayName" value="Home Baker"/>
        <c:set var="categoryBadge" value="Baker"/>
        <c:set var="classPlaceholder" value="e.g. Masterclass: Eggless Chocolate Cakes"/>
        <c:set var="descPlaceholder" value="Provide a summary of recipes, baking techniques, and skills covered..."/>
        <c:set var="formTitle" value="Create New Baking Class"/>
        <c:set var="emptyStateDesc" value="Create your first baking class to start taking enrollments."/>
    </c:when>
    <c:when test="${provider.category == 'LANGUAGE_TRAINER'}">
        <c:set var="categoryDisplayName" value="Language Trainer"/>
        <c:set var="categoryBadge" value="Trainer"/>
        <c:set var="classPlaceholder" value="e.g. Spoken English &amp; Accent Training Masterclass"/>
        <c:set var="descPlaceholder" value="Provide a summary of language modules, practice sessions, and learning outcomes..."/>
        <c:set var="formTitle" value="Create New Language Training Class"/>
        <c:set var="emptyStateDesc" value="Create your first language training class to start taking enrollments."/>
    </c:when>
    <c:when test="${provider.category == 'WOMEN_PRODUCTS'}">
        <c:set var="categoryDisplayName" value="Women Products"/>
        <c:set var="categoryBadge" value="Creator"/>
        <c:set var="classPlaceholder" value="e.g. Artisan Handcrafted Skincare Workshop"/>
        <c:set var="descPlaceholder" value="Provide a summary of product making techniques, materials, and key highlights..."/>
        <c:set var="formTitle" value="Create New Product Workshop"/>
        <c:set var="emptyStateDesc" value="Create your first product workshop to start taking enrollments."/>
    </c:when>
    <c:when test="${provider.category == 'WOMEN_LAWYER'}">
        <c:set var="categoryDisplayName" value="Women Lawyer"/>
        <c:set var="categoryBadge" value="Advocate"/>
        <c:set var="classPlaceholder" value="e.g. Property &amp; Family Law Advisory Session"/>
        <c:set var="descPlaceholder" value="Provide details on legal consultation scope, document review, and legal guidance..."/>
        <c:set var="formTitle" value="Create New Legal Consultation Session"/>
        <c:set var="emptyStateDesc" value="Create your first legal consultation session to start accepting appointments."/>
    </c:when>
    <c:when test="${provider.category == 'FITNESS_ZUMBA'}">
        <c:set var="categoryDisplayName" value="Fitness / Zumba"/>
        <c:set var="categoryBadge" value="Instructor"/>
        <c:set var="classPlaceholder" value="e.g. High-Energy Daily Dance Zumba Workout"/>
        <c:set var="descPlaceholder" value="Provide details on fitness level, calorie burn goals, music styles, and workout gear needed..."/>
        <c:set var="formTitle" value="Create New Zumba / Cardio Fitness Class"/>
        <c:set var="emptyStateDesc" value="Create your first Zumba class to start taking enrollments."/>
    </c:when>
    <c:when test="${provider.category == 'BEAUTICIAN'}">
        <c:set var="categoryDisplayName" value="Beautician"/>
        <c:set var="categoryBadge" value="Beautician"/>
        <c:set var="classPlaceholder" value="e.g. Bridal Glow Facial &amp; Beauty Package"/>
        <c:set var="descPlaceholder" value="Provide details on beauty treatments, products used, duration, and skin type suitability..."/>
        <c:set var="formTitle" value="Create New Beauty &amp; Skincare Package"/>
        <c:set var="emptyStateDesc" value="Create your first beauty package to start taking appointments."/>
    </c:when>
    <c:when test="${provider.category == 'MAKEUP_ARTIST'}">
        <c:set var="categoryDisplayName" value="Makeup Artist"/>
        <c:set var="categoryBadge" value="Artist"/>
        <c:set var="classPlaceholder" value="e.g. Professional HD Bridal &amp; Party Makeup Session"/>
        <c:set var="descPlaceholder" value="Provide details on makeup style, cosmetic brands used, hair styling, and trial options..."/>
        <c:set var="formTitle" value="Create New Makeup Masterclass / Service"/>
        <c:set var="emptyStateDesc" value="Create your first makeup session to start receiving bookings."/>
    </c:when>
    <c:when test="${provider.category == 'MEHENDI_ARTIST'}">
        <c:set var="categoryDisplayName" value="Mehendi Artist"/>
        <c:set var="categoryBadge" value="Artist"/>
        <c:set var="classPlaceholder" value="e.g. Traditional Bridal &amp; Arabic Mehendi Service"/>
        <c:set var="descPlaceholder" value="Provide details on design patterns, natural henna quality, duration, and booking slots..."/>
        <c:set var="formTitle" value="Create New Mehendi Service Package"/>
        <c:set var="emptyStateDesc" value="Create your first mehendi service package to start taking bookings."/>
    </c:when>
    <c:when test="${provider.category == 'PHOTOGRAPHER'}">
        <c:set var="categoryDisplayName" value="Photographer"/>
        <c:set var="categoryBadge" value="Photographer"/>
        <c:set var="classPlaceholder" value="e.g. Outdoor Portrait &amp; Event Photography Shoot"/>
        <c:set var="descPlaceholder" value="Provide details on shoot duration, number of edited photos, deliverables, and gear used..."/>
        <c:set var="formTitle" value="Create New Photography Shoot Package"/>
        <c:set var="emptyStateDesc" value="Create your first photography package to start accepting bookings."/>
    </c:when>
    <c:when test="${provider.category == 'YOGA_TRAINER'}">
        <c:set var="categoryDisplayName" value="Yoga Trainer"/>
        <c:set var="categoryBadge" value="Yogi"/>
        <c:set var="classPlaceholder" value="e.g. Morning Hatha Yoga &amp; Pranayama Session"/>
        <c:set var="descPlaceholder" value="Provide details on yoga posture focus, breathing techniques, stress relief, and mat requirements..."/>
        <c:set var="formTitle" value="Create New Yoga &amp; Meditation Class"/>
        <c:set var="emptyStateDesc" value="Create your first yoga class to start taking enrollments."/>
    </c:when>
    <c:when test="${provider.category == 'FITNESS_TRAINER'}">
        <c:set var="categoryDisplayName" value="Fitness Trainer"/>
        <c:set var="categoryBadge" value="Trainer"/>
        <c:set var="classPlaceholder" value="e.g. 1-on-1 Weight Loss &amp; Strength Training Program"/>
        <c:set var="descPlaceholder" value="Provide details on training routine, workout intensity, equipment needed, and fitness targets..."/>
        <c:set var="formTitle" value="Create New Personal Fitness Training Session"/>
        <c:set var="emptyStateDesc" value="Create your first fitness program to start accepting clients."/>
    </c:when>
    <c:when test="${provider.category == 'DANCE_INSTRUCTOR'}">
        <c:set var="categoryDisplayName" value="Dance Instructor"/>
        <c:set var="categoryBadge" value="Choreographer"/>
        <c:set var="classPlaceholder" value="e.g. Bollywood &amp; Classical Fusion Dance Workshop"/>
        <c:set var="descPlaceholder" value="Provide details on choreography style, song track, beginner friendliness, and video recs..."/>
        <c:set var="formTitle" value="Create New Dance Workshop"/>
        <c:set var="emptyStateDesc" value="Create your first dance workshop to start taking enrollments."/>
    </c:when>
    <c:when test="${provider.category == 'MUSIC_TEACHER'}">
        <c:set var="categoryDisplayName" value="Music Teacher"/>
        <c:set var="categoryBadge" value="Musician"/>
        <c:set var="classPlaceholder" value="e.g. Indian Classical Vocals &amp; Keyboard Coaching"/>
        <c:set var="descPlaceholder" value="Provide details on instrument/vocal lessons, practice exercises, and skill levels..."/>
        <c:set var="formTitle" value="Create New Music &amp; Vocal Lesson"/>
        <c:set var="emptyStateDesc" value="Create your first music lesson to start taking students."/>
    </c:when>
    <c:when test="${provider.category == 'CRAFT_SELLER'}">
        <c:set var="categoryDisplayName" value="Craft Seller"/>
        <c:set var="categoryBadge" value="Craftsperson"/>
        <c:set var="classPlaceholder" value="e.g. Paper Quilling &amp; DIY Gift Crafting Workshop"/>
        <c:set var="descPlaceholder" value="Provide details on craft materials included, step-by-step guidance, and project outcomes..."/>
        <c:set var="formTitle" value="Create New Craft Workshop"/>
        <c:set var="emptyStateDesc" value="Create your first craft workshop to start taking enrollments."/>
    </c:when>
    <c:when test="${provider.category == 'HANDMADE_PRODUCTS'}">
        <c:set var="categoryDisplayName" value="Handmade Products"/>
        <c:set var="categoryBadge" value="Artisan"/>
        <c:set var="classPlaceholder" value="e.g. Organic Scented Candle Making Workshop"/>
        <c:set var="descPlaceholder" value="Provide details on natural wax ingredients, fragrance oils, molds, and safety tips..."/>
        <c:set var="formTitle" value="Create New Handmade Product Workshop"/>
        <c:set var="emptyStateDesc" value="Create your first product workshop to start taking enrollments."/>
    </c:when>
    <c:when test="${provider.category == 'BOUTIQUE'}">
        <c:set var="categoryDisplayName" value="Boutique"/>
        <c:set var="categoryBadge" value="Boutique"/>
        <c:set var="classPlaceholder" value="e.g. Designer Ethnic Wear &amp; Saree Showcase"/>
        <c:set var="descPlaceholder" value="Provide details on fabric quality, sizing range, customization, and fitting options..."/>
        <c:set var="formTitle" value="Create New Fashion Collection Showcase"/>
        <c:set var="emptyStateDesc" value="Create your first collection showcase to start taking client inquiries."/>
    </c:when>
    <c:when test="${provider.category == 'FASHION_DESIGNER'}">
        <c:set var="categoryDisplayName" value="Fashion Designer"/>
        <c:set var="categoryBadge" value="Designer"/>
        <c:set var="classPlaceholder" value="e.g. Custom Wedding Outfit &amp; Gown Designing"/>
        <c:set var="descPlaceholder" value="Provide details on design sketching, fabric sourcing, fittings, and delivery schedules..."/>
        <c:set var="formTitle" value="Create New Fashion Design Consultation"/>
        <c:set var="emptyStateDesc" value="Create your first design consultation to start accepting orders."/>
    </c:when>
    <c:when test="${provider.category == 'FREELANCER'}">
        <c:set var="categoryDisplayName" value="Freelancer"/>
        <c:set var="categoryBadge" value="Freelancer"/>
        <c:set var="classPlaceholder" value="e.g. Professional Virtual Assistant &amp; Admin Support"/>
        <c:set var="descPlaceholder" value="Provide details on service scope, deliverables, turnaround time, and revision terms..."/>
        <c:set var="formTitle" value="Create New Freelance Service Package"/>
        <c:set var="emptyStateDesc" value="Create your first freelance package to start receiving projects."/>
    </c:when>
    <c:when test="${provider.category == 'GRAPHIC_DESIGNER'}">
        <c:set var="categoryDisplayName" value="Graphic Designer"/>
        <c:set var="categoryBadge" value="Designer"/>
        <c:set var="classPlaceholder" value="e.g. Brand Identity &amp; Social Media Template Design"/>
        <c:set var="descPlaceholder" value="Provide details on design software, source file formats, revisions, and branding assets..."/>
        <c:set var="formTitle" value="Create New Graphic Design Package"/>
        <c:set var="emptyStateDesc" value="Create your first design package to start accepting projects."/>
    </c:when>
    <c:when test="${provider.category == 'CONTENT_WRITER'}">
        <c:set var="categoryDisplayName" value="Content Writer"/>
        <c:set var="categoryBadge" value="Writer"/>
        <c:set var="classPlaceholder" value="e.g. SEO Website Content &amp; Blog Writing Package"/>
        <c:set var="descPlaceholder" value="Provide details on word count, keyword optimization, niche topics, and turnaround time..."/>
        <c:set var="formTitle" value="Create New Content / Blogging Package"/>
        <c:set var="emptyStateDesc" value="Create your first content package to start accepting writing assignments."/>
    </c:when>
    <c:when test="${provider.category == 'MARTIAL_ARTS'}">
        <c:set var="categoryDisplayName" value="Martial Arts"/>
        <c:set var="categoryBadge" value="Instructor"/>
        <c:set var="classPlaceholder" value="e.g. Self-Defense &amp; Fitness Masterclass"/>
        <c:set var="descPlaceholder" value="Provide a summary of physical techniques, drills, and safety guidelines..."/>
        <c:set var="formTitle" value="Create New Martial Arts Class"/>
        <c:set var="emptyStateDesc" value="Create your first martial arts class to start taking enrollments."/>
    </c:when>
    <c:when test="${provider.category == 'FEMALE_DOCTORS'}">
        <c:set var="categoryDisplayName" value="Female Doctor"/>
        <c:set var="categoryBadge" value="Doctor"/>
        <c:set var="classPlaceholder" value="e.g. Women's Health &amp; Wellness Consultation Seminar"/>
        <c:set var="descPlaceholder" value="Provide a summary of health topics, medical guidance, and Q&amp;A sessions..."/>
        <c:set var="formTitle" value="Create New Health Consultation"/>
        <c:set var="emptyStateDesc" value="Create your first health session to start taking appointments."/>
    </c:when>
</c:choose>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>${categoryDisplayName} Dashboard | Fight D Fear</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- SockJS & Stomp -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <!-- CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-body: #f8fafc;
            --bg-surface: #ffffff;
            --border-color: #e2e8f0;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --text-muted: #64748b;
            --brand-primary: #e11d48;
            --brand-primary-hover: #be123c;
            --brand-light: #fff1f2;
            --accent-indigo: #4f46e5;
            --accent-indigo-light: #eef2ff;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --radius-sm: 8px;
            --radius-md: 12px;
            --radius-lg: 16px;
            --radius-xl: 20px;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--bg-body);
            color: var(--text-primary);
            min-height: 100vh;
            margin: 0;
            padding: 0;
        }

        /* Sidebar Styling */
        .sidebar {
            width: 260px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background-color: var(--bg-surface);
            border-right: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            z-index: 1040;
            transition: transform 0.3s ease;
        }

        .sidebar-header {
            padding: 24px 20px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .sidebar-brand {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--text-primary);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sidebar-brand span {
            color: var(--brand-primary);
        }

        .sidebar-badge {
            background-color: var(--brand-light);
            color: var(--brand-primary);
            font-size: 0.65rem;
            font-weight: 700;
            padding: 3px 8px;
            border-radius: 50px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .sidebar-profile {
            padding: 20px;
            border-bottom: 1px solid var(--border-color);
            background: #fafafa;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .sidebar-profile:hover {
            background-color: var(--brand-light);
        }

        .avatar-box {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            background: linear-gradient(135deg, var(--brand-primary), var(--accent-indigo));
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 12px;
            box-shadow: var(--shadow-sm);
        }

        .sidebar-nav {
            list-style: none;
            padding: 16px 12px;
            margin: 0;
            flex-grow: 1;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
        }

        .sidebar-nav li {
            margin-bottom: 4px;
        }

        .sidebar-nav a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            color: var(--text-secondary);
            text-decoration: none;
            border-radius: var(--radius-md);
            font-weight: 500;
            font-size: 0.925rem;
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .sidebar-nav a:hover {
            background-color: #f1f5f9;
            color: var(--text-primary);
        }

        .sidebar-nav a.active {
            background-color: var(--brand-light);
            color: var(--brand-primary);
            font-weight: 600;
        }

        .sidebar-nav a.active i {
            color: var(--brand-primary);
        }

        /* Main Content Wrapper */
        .main-wrapper {
            margin-left: 260px;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            transition: margin-left 0.3s ease;
        }

        /* Top Header */
        .top-header {
            height: 72px;
            background-color: var(--bg-surface);
            border-bottom: 1px solid var(--border-color);
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 1030;
        }

        .header-title h1 {
            font-size: 1.25rem;
            font-weight: 700;
            margin: 0;
            color: var(--text-primary);
        }

        .header-title p {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin: 2px 0 0 0;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .btn-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 1px solid var(--border-color);
            background: var(--bg-surface);
            color: var(--text-secondary);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
            position: relative;
        }

        .btn-icon:hover {
            background-color: #f1f5f9;
            color: var(--text-primary);
        }

        .notification-dot {
            position: absolute;
            top: 8px;
            right: 8px;
            width: 8px;
            height: 8px;
            background-color: var(--brand-primary);
            border-radius: 50%;
            border: 2px solid var(--bg-surface);
        }

        .content-body {
            padding: 32px;
            flex-grow: 1;
        }

        /* Summary Cards */
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 32px;
        }

        .summary-card {
            background-color: var(--bg-surface);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            cursor: pointer;
        }

        .summary-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .summary-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
        }

        .summary-icon {
            width: 44px;
            height: 44px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
        }

        .icon-earnings { background-color: #ecfdf5; color: #10b981; }
        .icon-clients { background-color: #e0f2fe; color: #0284c7; }
        .icon-classes { background-color: var(--brand-light); color: var(--brand-primary); }
        .icon-rating { background-color: #fef3c7; color: #d97706; }

        .summary-title {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .summary-value {
            font-size: 1.75rem;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 4px;
            line-height: 1.2;
        }

        .summary-subtext {
            font-size: 0.8rem;
            color: var(--text-muted);
        }

        /* Quick Actions Bar */
        .quick-actions-bar {
            background-color: var(--bg-surface);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 16px 24px;
            margin-bottom: 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
            box-shadow: var(--shadow-sm);
        }

        .quick-actions-label {
            font-size: 0.9rem;
            font-weight: 700;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .quick-actions-group {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-action {
            padding: 8px 16px;
            border-radius: var(--radius-md);
            font-size: 0.875rem;
            font-weight: 600;
            border: 1px solid var(--border-color);
            background-color: var(--bg-surface);
            color: var(--text-secondary);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-action:hover {
            background-color: #f1f5f9;
            color: var(--text-primary);
            border-color: #cbd5e1;
        }

        .btn-action-primary {
            background-color: var(--brand-primary);
            color: #ffffff;
            border-color: var(--brand-primary);
        }

        .btn-action-primary:hover {
            background-color: var(--brand-primary-hover);
            color: #ffffff;
            border-color: var(--brand-primary-hover);
        }

        /* Dashboard Cards & Layout */
        .card-custom {
            background-color: var(--bg-surface);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            padding: 24px;
            margin-bottom: 24px;
            height: 100%;
        }

        .card-title-custom {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        /* Class Rows / Items */
        .class-row {
            padding: 16px;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            margin-bottom: 12px;
            background-color: var(--bg-surface);
            transition: border-color 0.2s ease, background-color 0.2s ease;
        }

        .class-row:hover {
            border-color: var(--brand-primary);
            background-color: #fffafb;
        }

        .badge-mode {
            padding: 4px 10px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-mode-live { background-color: #fee2e2; color: #dc2626; }
        .badge-mode-rec { background-color: #e0e7ff; color: #4338ca; }

        .status-pill {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
        }

        .status-PENDING { background-color: #fef3c7; color: #b45309; }
        .status-CONFIRMED, .status-PAID { background-color: #d1fae5; color: #047857; }
        .status-COMPLETED { background-color: #e0f2fe; color: #0369a1; }
        .status-CANCELLED { background-color: #fee2e2; color: #b91c1c; }

        /* Tables */
        .table-custom {
            width: 100%;
            margin-bottom: 0;
            color: var(--text-primary);
        }

        .table-custom th {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-muted);
            background-color: #f8fafc;
            border-bottom: 1px solid var(--border-color);
            padding: 12px 16px;
        }

        .table-custom td {
            padding: 16px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
            font-size: 0.9rem;
        }

        /* Form Inputs */
        .form-label-custom {
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-secondary);
            margin-bottom: 6px;
        }

        .form-control-custom, .form-select-custom {
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 10px 14px;
            font-size: 0.9rem;
            color: var(--text-primary);
            background-color: #ffffff;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .form-control-custom:focus, .form-select-custom:focus {
            border-color: var(--brand-primary);
            box-shadow: 0 0 0 3px rgba(225, 29, 72, 0.15);
            outline: none;
        }

        /* Empty States */
        .empty-state-box {
            text-align: center;
            padding: 40px 20px;
            background-color: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: var(--radius-md);
        }

        .empty-state-icon {
            font-size: 2.5rem;
            color: #cbd5e1;
            margin-bottom: 12px;
        }

        .empty-state-title {
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 4px;
        }

        .empty-state-desc {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin-bottom: 16px;
        }

        /* Responsive Breakpoints */
        @media (max-width: 1024px) {
            .summary-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 991px) {
            .sidebar {
                transform: translateX(-100%);
            }
            .sidebar.show {
                transform: translateX(0);
            }
            .main-wrapper {
                margin-left: 0;
            }
            .top-header {
                padding: 0 20px;
            }
            .content-body {
                padding: 20px;
            }
        }

        @media (max-width: 640px) {
            .summary-grid {
                grid-template-columns: 1fr;
            }
            .quick-actions-bar {
                flex-direction: column;
                align-items: stretch;
            }
            .quick-actions-group {
                flex-direction: column;
                align-items: stretch;
            }
            .btn-action {
                justify-content: center;
            }
        }
    </style>
</head>
<body>

    <!-- Left Sidebar -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <a href="${pageContext.request.contextPath}/marketplace/provider/dashboard" class="sidebar-brand">
                <i class="bi bi-person-badge-fill text-danger"></i> Fight D Fear
            </a>
            <span class="sidebar-badge">${categoryBadge}</span>
        </div>

        <div class="sidebar-profile" onclick="showTab('profile')">
            <div class="d-flex align-items-center gap-3">
                <c:choose>
                    <c:when test="${not empty provider.profilePhoto}">
                        <img src="${pageContext.request.contextPath}${provider.profilePhoto}" alt="${provider.fullName}" class="rounded-circle border shadow-sm" style="width: 48px; height: 48px; object-fit: cover;">
                    </c:when>
                    <c:otherwise>
                        <div class="avatar-box mb-0">
                            ${provider.fullName.charAt(0)}
                        </div>
                    </c:otherwise>
                </c:choose>
                <div style="overflow: hidden;">
                    <div class="fw-bold text-dark text-truncate" style="font-size: 0.95rem;">${provider.fullName}</div>
                    <div class="text-muted small text-truncate">${categoryDisplayName}</div>
                    <div class="small fw-semibold text-warning mt-1"><i class="fas fa-star me-1"></i> ${provider.rating}</div>
                </div>
            </div>
        </div>

        <ul class="sidebar-nav">
            <li>
                <a href="javascript:void(0)" onclick="showTab('overview')" id="nav-overview" class="active">
                    <i class="bi bi-grid-fill"></i> Overview
                </a>
            </li>
            <li>
                <a href="javascript:void(0)" onclick="showTab('schedule')" id="nav-schedule">
                    <i class="bi bi-calendar-event-fill"></i> Schedule
                </a>
            </li>
            <li>
                <a href="javascript:void(0)" onclick="showTab('clients')" id="nav-clients">
                    <i class="bi bi-people-fill"></i> My Clients
                </a>
            </li>
            <li>
                <a href="javascript:void(0)" onclick="showTab('earnings')" id="nav-earnings">
                    <i class="bi bi-wallet2"></i> Earnings
                </a>
            </li>
            <li>
                <a href="javascript:void(0)" onclick="showTab('profile')" id="nav-profile">
                    <i class="bi bi-person-circle"></i> Profile
                </a>
            </li>
            <li class="mt-auto pt-3 border-top">
                <a href="${pageContext.request.contextPath}/logout" class="text-danger">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </a>
            </li>
        </ul>
    </aside>

    <!-- Main Wrapper -->
    <div class="main-wrapper">
        
        <!-- Top Header -->
        <header class="top-header">
            <div class="d-flex align-items-center gap-3">
                <button class="btn btn-light border d-lg-none" onclick="toggleSidebar()" title="Toggle Menu">
                    <i class="bi bi-list fs-5"></i>
                </button>
                <div class="header-title">
                    <h1>${categoryDisplayName} Dashboard</h1>
                    <p>Welcome back! Here's your business overview.</p>
                </div>
            </div>

            <div class="header-actions">
                <button class="btn-icon" title="Notifications" onclick="openNotificationModal()">
                    <i class="bi bi-bell"></i>
                    <span class="notification-dot"></span>
                </button>
                <div class="d-none d-sm-flex align-items-center gap-2 ps-3 border-start" onclick="showTab('profile')" style="cursor: pointer;">
                    <c:choose>
                        <c:when test="${not empty provider.profilePhoto}">
                            <img src="${pageContext.request.contextPath}${provider.profilePhoto}" alt="${provider.fullName}" class="rounded-circle border shadow-sm" style="width: 38px; height: 38px; object-fit: cover;">
                        </c:when>
                        <c:otherwise>
                            <div class="avatar-box" style="width: 38px; height: 38px; font-size: 1rem; border-radius: 10px; margin: 0;">
                                ${provider.fullName.charAt(0)}
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="d-none d-md-block text-start">
                        <div class="fw-bold" style="font-size: 0.85rem; line-height: 1.1;">${provider.fullName}</div>
                        <div class="text-muted" style="font-size: 0.75rem;">${categoryDisplayName}</div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Content Body -->
        <div class="content-body">

            <!-- Alert Notice -->
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-3 mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <%-- Calculate Profile Completion Percentage Dynamically (100% Weighted Formula) --%>
            <c:set var="profilePercent" value="0"/>

            <c:if test="${not empty provider.fullName && provider.fullName.trim().length() > 0}">
                <c:set var="profilePercent" value="${profilePercent + 15}"/>
            </c:if>
            <c:if test="${not empty provider.phone && provider.phone.trim().length() > 0}">
                <c:set var="profilePercent" value="${profilePercent + 10}"/>
            </c:if>
            <c:if test="${not empty provider.profilePhoto && provider.profilePhoto.trim().length() > 0}">
                <c:set var="profilePercent" value="${profilePercent + 15}"/>
            </c:if>
            <c:if test="${not empty provider.locationText && provider.locationText.trim().length() > 0}">
                <c:set var="profilePercent" value="${profilePercent + 15}"/>
            </c:if>
            <c:if test="${not empty provider.qualification && provider.qualification.trim().length() > 0}">
                <c:set var="profilePercent" value="${profilePercent + 15}"/>
            </c:if>
            <c:if test="${not empty provider.experience && provider.experience.trim().length() > 0}">
                <c:set var="profilePercent" value="${profilePercent + 10}"/>
            </c:if>
            <c:if test="${not empty provider.availableDays && provider.availableDays.trim().length() > 0}">
                <c:set var="profilePercent" value="${profilePercent + 10}"/>
            </c:if>
            <c:if test="${not empty provider.description && provider.description.trim().length() > 0}">
                <c:set var="profilePercent" value="${profilePercent + 10}"/>
            </c:if>

            <c:choose>
                <c:when test="${profilePercent < 40}">
                    <c:set var="completionMsg" value="Complete your profile to help customers learn more about you."/>
                </c:when>
                <c:when test="${profilePercent < 70}">
                    <c:set var="completionMsg" value="Your profile is taking shape. Add more details to improve it."/>
                </c:when>
                <c:when test="${profilePercent < 90}">
                    <c:set var="completionMsg" value="Your profile is almost complete. Add the remaining details."/>
                </c:when>
                <c:when test="${profilePercent < 100}">
                    <c:set var="completionMsg" value="Almost there! Complete the remaining information."/>
                </c:when>
                <c:otherwise>
                    <c:set var="completionMsg" value="Your profile is complete."/>
                </c:otherwise>
            </c:choose>

            <!-- Quick Actions Bar -->
            <div class="quick-actions-bar">
                <div class="quick-actions-label">
                    <i class="bi bi-lightning-charge-fill text-warning"></i> Quick Actions
                </div>
                <div class="quick-actions-group">
                    <button class="btn-action btn-action-primary" onclick="showTab('schedule'); focusCreateClass();">
                        <i class="bi bi-plus-lg"></i> Create New Class
                    </button>
                    <button class="btn-action" onclick="showTab('schedule')">
                        <i class="bi bi-calendar3"></i> View Schedule
                    </button>
                    <button class="btn-action" onclick="showTab('clients')">
                        <i class="bi bi-people"></i> Manage Clients
                    </button>
                    <button class="btn-action" onclick="showTab('earnings')">
                        <i class="bi bi-currency-rupee"></i> View Earnings
                    </button>
                    <button class="btn-action" onclick="openEditProfileModal()">
                        <i class="bi bi-person"></i> Edit Profile
                    </button>
                </div>
            </div>

            <!-- Profile Completion Progress Bar -->
            <div class="card-custom mb-4" style="background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%); border-left: 4px solid var(--brand-primary, #dc3545);">
                <div class="d-flex justify-content-between align-items-center mb-2 flex-wrap gap-2">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-shield-check text-primary fs-5"></i>
                        <span class="fw-bold text-dark" style="font-size: 1rem;">Profile Completion</span>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge bg-primary px-3 py-2 fs-6 rounded-pill fw-bold">${profilePercent}%</span>
                        <c:choose>
                            <c:when test="${profilePercent < 100}">
                                <button class="btn btn-sm btn-outline-primary fw-bold rounded-pill px-3" onclick="openEditProfileModal()">
                                    <i class="bi bi-pencil-square me-1"></i> Complete Profile
                                </button>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 rounded-pill fw-bold" style="font-size: 0.85rem;">
                                    <i class="bi bi-check-circle-fill me-1"></i> &#10003; Profile Complete
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="progress mb-2" style="height: 10px; border-radius: 6px; background-color: #e2e8f0;">
                    <div class="progress-bar ${profilePercent == 100 ? 'bg-success' : 'bg-primary'} progress-bar-striped progress-bar-animated" role="progressbar" style="width: ${profilePercent}%;" aria-valuenow="${profilePercent}" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
                <div class="text-secondary small fw-medium">
                    <i class="bi bi-info-circle me-1 text-primary"></i> ${completionMsg}
                </div>
            </div>

            <!-- Summary Cards -->
            <div class="summary-grid">
                <!-- Card 1: Total Earnings -->
                <div class="summary-card" onclick="showTab('earnings')">
                    <div class="summary-header">
                        <span class="summary-title">Total Earnings</span>
                        <div class="summary-icon icon-earnings">
                            <i class="bi bi-wallet2"></i>
                        </div>
                    </div>
                    <div class="summary-value">₹${totalEarnings}</div>
                    <div class="summary-subtext">Total Revenue Settled</div>
                </div>

                <!-- Card 2: Total Clients -->
                <div class="summary-card" onclick="showTab('clients')">
                    <div class="summary-header">
                        <span class="summary-title">Total Clients</span>
                        <div class="summary-icon icon-clients">
                            <i class="bi bi-people"></i>
                        </div>
                    </div>
                    <div class="summary-value">${enrollments.size()}</div>
                    <div class="summary-subtext">Enrolled Students & Customers</div>
                </div>

                <!-- Card 3: Upcoming Classes -->
                <div class="summary-card" onclick="showTab('schedule')">
                    <div class="summary-header">
                        <span class="summary-title">Upcoming Classes</span>
                        <div class="summary-icon icon-classes">
                            <i class="bi bi-journal-bookmark-fill"></i>
                        </div>
                    </div>
                    <div class="summary-value">${classes.size()}</div>
                    <div class="summary-subtext">Active Sessions</div>
                </div>

                <!-- Card 4: Average Rating -->
                <div class="summary-card" onclick="showTab('profile')">
                    <div class="summary-header">
                        <span class="summary-title">Average Rating</span>
                        <div class="summary-icon icon-rating">
                            <i class="bi bi-star-fill"></i>
                        </div>
                    </div>
                    <div class="summary-value">${provider.rating}</div>
                    <div class="summary-subtext">Out of 5.0 Star Reviews</div>
                </div>
            </div>

            <!-- 1. OVERVIEW SECTION TAB -->
            <div id="overview-section" class="dashboard-section">
                <div class="row g-4">
                    <!-- Upcoming Classes Card -->
                    <div class="col-lg-6">
                        <div class="card-custom">
                            <div class="card-title-custom">
                                <span><i class="bi bi-calendar-event me-2 text-danger"></i> Upcoming Classes</span>
                                <a href="javascript:void(0)" onclick="showTab('schedule')" class="text-decoration-none small text-danger fw-bold">View All <i class="bi bi-arrow-right"></i></a>
                            </div>

                            <c:if test="${empty classes}">
                                <div class="empty-state-box">
                                    <div class="empty-state-icon"><i class="bi bi-calendar-x"></i></div>
                                    <div class="empty-state-title">No upcoming classes scheduled.</div>
                                    <div class="empty-state-desc">${emptyStateDesc}</div>
                                    <button class="btn btn-sm btn-action btn-action-primary" onclick="showTab('schedule'); focusCreateClass();">
                                        <i class="bi bi-plus-lg"></i> Create New Class
                                    </button>
                                </div>
                            </c:if>

                            <c:if test="${not empty classes}">
                                <div style="max-height: 380px; overflow-y: auto;">
                                    <c:forEach var="c" items="${classes}" varStatus="status">
                                        <c:if test="${status.index < 4}">
                                            <div class="class-row">
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <div>
                                                        <div class="fw-bold text-dark" style="font-size: 0.95rem;">${c.className}</div>
                                                        <div class="text-muted small"><i class="bi bi-clock me-1"></i> ${c.dateTime}</div>
                                                    </div>
                                                    <span class="badge-mode ${c.mode == 'Live' ? 'badge-mode-live' : 'badge-mode-rec'}">${c.mode}</span>
                                                </div>
                                                <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                                    <span class="fw-bold text-danger">₹${c.price}</span>
                                                    <button class="btn btn-sm btn-outline-secondary py-0 px-2" style="font-size: 0.75rem;" onclick="openClassDetailsModal('${c.className}', '${c.dateTime}', '${c.mode}', '₹${c.price}', '${c.meetingLink}', '${c.description}')">Details</button>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Recent Bookings Card -->
                    <div class="col-lg-6">
                        <div class="card-custom">
                            <div class="card-title-custom">
                                <span><i class="bi bi-person-badge me-2 text-primary"></i> Recent Bookings</span>
                                <a href="javascript:void(0)" onclick="showTab('clients')" class="text-decoration-none small text-primary fw-bold">Manage Clients <i class="bi bi-arrow-right"></i></a>
                            </div>

                            <c:if test="${empty bookings}">
                                <div class="empty-state-box">
                                    <div class="empty-state-icon"><i class="bi bi-person-x"></i></div>
                                    <div class="empty-state-title">No recent bookings.</div>
                                    <div class="empty-state-desc">Customer booking requests for 1-on-1 sessions will appear here.</div>
                                </div>
                            </c:if>

                            <c:if test="${not empty bookings}">
                                <div style="max-height: 380px; overflow-y: auto;">
                                    <c:forEach var="b" items="${bookings}" varStatus="status">
                                        <c:if test="${status.index < 4}">
                                            <div class="p-3 border rounded-3 mb-2 bg-white">
                                                <div class="d-flex justify-content-between align-items-center mb-1">
                                                    <div class="fw-bold text-dark">${b.user.fullName}</div>
                                                    <span class="status-pill status-${b.status}">${b.status}</span>
                                                </div>
                                                <div class="small text-muted mb-2"><i class="bi bi-calendar me-1"></i> ${b.requestedTime}</div>
                                                <c:if test="${not empty b.note}">
                                                    <div class="small text-secondary bg-light p-2 rounded">${b.note}</div>
                                                </c:if>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 2. SCHEDULE & CLASS MANAGEMENT TAB -->
            <div id="schedule-section" class="dashboard-section" style="display: none;">
                <div class="row g-4">
                    <!-- Create Class Form -->
                    <div class="col-lg-7">
                        <div class="card-custom" id="create-class-card">
                            <div class="card-title-custom">
                                <span><i class="bi bi-plus-circle-fill me-2 text-danger"></i> ${formTitle}</span>
                            </div>

                            <form action="${pageContext.request.contextPath}/marketplace/provider/classes/add" method="post">
                                <div class="row g-3">
                                    <div class="col-12">
                                        <label class="form-label-custom">Class Title</label>
                                        <input type="text" name="className" class="form-control form-control-custom" placeholder="${classPlaceholder}" required>
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label-custom">Duration</label>
                                        <input type="text" name="duration" class="form-control form-control-custom" placeholder="e.g. 2 Hours" required>
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label-custom">Session Mode <span class="text-danger">*</span></label>
                                        <select name="mode" id="sessionModeSelect" class="form-select form-select-custom" required>
                                            <option value="" disabled selected>Choose session mode</option>
                                        </select>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label-custom">Category</label>
                                        <input type="hidden" name="category" id="formCategoryInput" value="${not empty provider.category ? provider.category : 'HOME_BAKER'}">
                                        <input type="text" class="form-control form-control-custom bg-light fw-bold text-dark" value="${categoryDisplayName}" readonly style="cursor: not-allowed;">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label-custom">Service Provided <span class="text-danger">*</span></label>
                                        <select name="serviceProvided" id="serviceProvidedSelect" class="form-select form-select-custom" required>
                                            <option value="" disabled selected>Choose a service</option>
                                        </select>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label-custom">Description</label>
                                        <textarea name="description" class="form-control form-control-custom" placeholder="${descPlaceholder}" rows="3" required></textarea>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label-custom">Date &amp; Time</label>
                                        <input type="datetime-local" name="dateTime" class="form-control form-control-custom" required>
                                    </div>
                                    <div class="col-12" id="meetingLinkGroup" style="display: none;">
                                        <label class="form-label-custom">Meeting / Online Link <span class="text-danger">*</span></label>
                                        <input type="url" name="meetingLink" id="meetingLinkInput" class="form-control form-control-custom" placeholder="https://zoom.us/j/123456789">
                                    </div>
                                    <div class="col-12" id="serviceLocationGroup" style="display: none;">
                                        <label class="form-label-custom">Service Location / Address <span class="text-danger">*</span></label>
                                        <input type="text" name="serviceLocation" id="serviceLocationInput" class="form-control form-control-custom" placeholder="e.g. Studio 4B, MG Road / Client Address">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label-custom">Price (₹)</label>
                                        <input type="number" name="price" class="form-control form-control-custom" placeholder="e.g. 499.00" step="0.01" required>
                                    </div>
                                    <div class="col-12 mt-4">
                                        <button type="submit" class="btn btn-danger w-100 py-2 fw-bold" style="border-radius: var(--radius-md);">
                                            <i class="bi bi-check-circle-fill me-2"></i> Launch Class Now
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Active Classes List -->
                    <div class="col-lg-5">
                        <div class="card-custom">
                            <div class="card-title-custom">
                                <span><i class="bi bi-journal-bookmark-fill me-2 text-primary"></i> Active Class Schedule</span>
                                <span class="badge bg-light text-dark border">${classes.size()} Total</span>
                            </div>

                            <c:if test="${empty classes}">
                                <div class="empty-state-box">
                                    <div class="empty-state-icon"><i class="bi bi-calendar-x"></i></div>
                                    <div class="empty-state-title">No scheduled classes.</div>
                                    <div class="empty-state-desc">Use the form on the left to add a class.</div>
                                </div>
                            </c:if>

                            <c:if test="${not empty classes}">
                                <div style="max-height: 540px; overflow-y: auto;">
                                    <c:forEach var="c" items="${classes}">
                                        <div class="class-row">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <div>
                                                    <div class="fw-bold text-dark">${c.className}</div>
                                                    <div class="text-muted small"><i class="bi bi-calendar me-1"></i> ${c.dateTime}</div>
                                                </div>
                                                <span class="badge-mode ${c.mode == 'Live' ? 'badge-mode-live' : 'badge-mode-rec'}">${c.mode}</span>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center pt-2 border-top mt-2">
                                                <span class="fw-bold text-danger">₹${c.price}</span>
                                                <button class="btn btn-sm btn-outline-secondary py-0 px-2" style="font-size: 0.75rem;" onclick="openClassDetailsModal('${c.className}', '${c.dateTime}', '${c.mode}', '₹${c.price}', '${c.meetingLink}', '${c.description}')">Details</button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 3. MY CLIENTS & BOOKINGS TAB -->
            <div id="clients-section" class="dashboard-section" style="display: none;">
                <div class="row g-4">
                    <!-- 1-on-1 Sessions -->
                    <div class="col-12">
                        <div class="card-custom">
                            <div class="card-title-custom">
                                <span><i class="bi bi-calendar-check me-2 text-primary"></i> 1-on-1 Customer Booking Requests</span>
                                <span class="badge bg-light text-dark border">${bookings.size()} Requests</span>
                            </div>

                            <c:if test="${empty bookings}">
                                <div class="empty-state-box">
                                    <div class="empty-state-icon"><i class="bi bi-people"></i></div>
                                    <div class="empty-state-title">No clients yet.</div>
                                    <div class="empty-state-desc">Customer booking requests will appear here.</div>
                                </div>
                            </c:if>

                            <c:if test="${not empty bookings}">
                                <div class="table-responsive">
                                    <table class="table table-custom align-middle">
                                        <thead>
                                            <tr>
                                                <th>Customer</th>
                                                <th>Session Request Note</th>
                                                <th>Schedule Date/Time</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="b" items="${bookings}">
                                                <tr>
                                                    <td>
                                                        <div class="fw-bold text-dark">${b.user.fullName}</div>
                                                        <div class="small text-muted">ID: #USR-${b.user.id}</div>
                                                    </td>
                                                    <td>
                                                        <div class="small text-secondary" style="max-width: 260px;" title="${b.note}">
                                                            ${not empty b.note ? b.note : 'No custom note provided'}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="small fw-semibold">${b.requestedTime}</div>
                                                    </td>
                                                    <td>
                                                        <span class="status-pill status-${b.status}">${b.status}</span>
                                                    </td>
                                                    <td id="booking-actions-${b.id}">
                                                        <div class="d-flex flex-column gap-2">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <select class="form-select form-select-sm form-select-custom" id="status-select-${b.id}" style="width: 130px;">
                                                                    <option value="PENDING" ${b.status.name() == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                                                    <option value="CONFIRMED" ${b.status.name() == 'CONFIRMED' ? 'selected' : ''}>CONFIRM</option>
                                                                    <option value="COMPLETED" ${b.status.name() == 'COMPLETED' ? 'selected' : ''}>COMPLETE</option>
                                                                    <option value="CANCELLED" ${b.status.name() == 'CANCELLED' ? 'selected' : ''}>CANCEL</option>
                                                                </select>
                                                                <button class="btn btn-sm btn-primary" onclick="updateStatus(${b.id})" title="Save Status">
                                                                    <i class="bi bi-check-lg"></i>
                                                                </button>
                                                            </div>

                                                            <div id="comm-buttons-${b.id}" class="${b.status.name() == 'CONFIRMED' ? 'd-flex' : 'd-none'} gap-2">
                                                                <button class="btn btn-sm btn-outline-primary w-100" onclick="openChat(${b.id}, '${b.user.fullName}')">
                                                                    <i class="bi bi-chat-dots me-1"></i> Chat
                                                                </button>
                                                                <button class="btn btn-sm btn-outline-danger w-100" onclick="startVideoCall(${b.id}, '${b.user.fullName}')">
                                                                    <i class="bi bi-camera-video me-1"></i> Video
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Enrolled Class Students -->
                    <div class="col-12">
                        <div class="card-custom">
                            <div class="card-title-custom">
                                <span><i class="bi bi-journal-check me-2 text-success"></i> Class Enrolled Students</span>
                                <span class="badge bg-light text-dark border">${enrollments.size()} Enrolled</span>
                            </div>

                            <c:if test="${empty enrollments}">
                                <div class="empty-state-box">
                                    <div class="empty-state-icon"><i class="bi bi-journal-x"></i></div>
                                    <div class="empty-state-title">No class enrollments yet.</div>
                                    <div class="empty-state-desc">Students enrolling in your classes will appear in this list.</div>
                                </div>
                            </c:if>

                            <c:if test="${not empty enrollments}">
                                <div class="table-responsive">
                                    <table class="table table-custom align-middle">
                                        <thead>
                                            <tr>
                                                <th>Student Name</th>
                                                <th>Email</th>
                                                <th>Enrolled Class</th>
                                                <th>Enrollment Date</th>
                                                <th>Payment Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="e" items="${enrollments}">
                                                <tr>
                                                    <td class="fw-bold text-dark">${e.user.fullName}</td>
                                                    <td class="small text-muted">${e.user.email}</td>
                                                    <td class="fw-semibold text-danger">${e.providerClass.className}</td>
                                                    <td class="small">${e.enrollmentTime}</td>
                                                    <td>
                                                        <span class="status-pill status-${e.paymentStatus}">${e.paymentStatus}</span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 4. EARNINGS LEDGER TAB -->
            <div id="earnings-section" class="dashboard-section" style="display: none;">
                <div class="card-custom mb-4">
                    <div class="card-title-custom">
                        <span><i class="bi bi-currency-rupee me-2 text-success"></i> Earnings Overview</span>
                    </div>

                    <div class="row g-4">
                        <div class="col-md-4">
                            <div class="p-3 border rounded-3 bg-light text-center">
                                <div class="text-muted small uppercase fw-bold">Settled Revenue</div>
                                <div class="fs-3 fw-bold text-success mt-1">₹${totalEarnings}</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3 border rounded-3 bg-light text-center">
                                <div class="text-muted small uppercase fw-bold">Paid Class Bookings</div>
                                <c:set var="paidCount" value="0"/>
                                <c:forEach var="e" items="${enrollments}">
                                    <c:if test="${e.paymentStatus == 'PAID'}">
                                        <c:set var="paidCount" value="${paidCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                <div class="fs-3 fw-bold text-primary mt-1">${paidCount}</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3 border rounded-3 bg-light text-center">
                                <div class="text-muted small uppercase fw-bold">Pending / Unpaid</div>
                                <c:set var="pendingCount" value="0"/>
                                <c:forEach var="e" items="${enrollments}">
                                    <c:if test="${e.paymentStatus != 'PAID'}">
                                        <c:set var="pendingCount" value="${pendingCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                <div class="fs-3 fw-bold text-warning mt-1">${pendingCount}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-custom">
                    <div class="card-title-custom">
                        <span><i class="bi bi-receipt me-2 text-primary"></i> Verified Transaction Ledger</span>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-custom align-middle">
                            <thead>
                                <tr>
                                    <th>Transaction ID</th>
                                    <th>Student</th>
                                    <th>Purchased Item</th>
                                    <th>Billing Date</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="hasPaid" value="false"/>
                                <c:forEach var="e" items="${enrollments}">
                                    <c:if test="${e.paymentStatus == 'PAID'}">
                                        <c:set var="hasPaid" value="true"/>
                                        <tr>
                                            <td class="font-monospace fw-bold text-primary">TXN-ENR-${e.id}</td>
                                            <td>
                                                <div class="fw-bold text-dark">${e.user.fullName}</div>
                                                <div class="small text-muted">${e.user.email}</div>
                                            </td>
                                            <td class="fw-semibold">${e.providerClass.className}</td>
                                            <td class="small">${e.enrollmentTime}</td>
                                            <td class="fw-bold text-dark">₹${e.providerClass.price}</td>
                                            <td>
                                                <span class="status-pill status-PAID">SETTLED</span>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${!hasPaid}">
                                    <tr>
                                        <td colspan="6" class="text-center py-5">
                                            <div class="empty-state-icon"><i class="bi bi-wallet2"></i></div>
                                            <div class="empty-state-title">No earnings available yet.</div>
                                            <div class="empty-state-desc">Settled student payments will appear in this ledger.</div>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- 5. PROFILE SUMMARY TAB -->
            <div id="profile-section" class="dashboard-section" style="display: none;">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card-custom">
                            <div class="card-title-custom">
                                <span><i class="bi bi-person-badge-fill me-2 text-danger"></i> Provider Profile</span>
                                <span class="status-pill status-${provider.verificationStatus}">${provider.verificationStatus}</span>
                            </div>

                            <div class="d-flex align-items-center gap-4 p-3 bg-light rounded-3 mb-4">
                                <c:choose>
                                    <c:when test="${not empty provider.profilePhoto}">
                                        <img src="${pageContext.request.contextPath}${provider.profilePhoto}" alt="${provider.fullName}" class="rounded-circle border shadow-sm" style="width: 72px; height: 72px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="avatar-box" style="width: 72px; height: 72px; font-size: 2rem; margin: 0;">
                                            ${provider.fullName.charAt(0)}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="flex-grow-1">
                                    <h4 class="fw-bold mb-1 text-dark">${provider.fullName}</h4>
                                    <div class="text-muted mb-1"><i class="bi bi-briefcase me-1"></i> ${categoryDisplayName}</div>
                                    <div class="fw-bold text-warning mb-2"><i class="fas fa-star me-1"></i> ${provider.rating} / 5.0 Rating</div>
                                    
                                    <!-- Progress Bar in Profile Header -->
                                    <div class="p-2 bg-white rounded border">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <span class="small fw-bold text-dark">Profile Completion</span>
                                            <span class="small fw-bold text-primary">${profilePercent}%</span>
                                        </div>
                                        <div class="progress" style="height: 6px; border-radius: 4px; background-color: #e2e8f0;">
                                            <div class="progress-bar ${profilePercent == 100 ? 'bg-success' : 'bg-primary'}" role="progressbar" style="width: ${profilePercent}%;" aria-valuenow="${profilePercent}" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label class="form-label-custom">Email Address</label>
                                    <input type="text" class="form-control form-control-custom bg-light" value="${provider.email}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label-custom">Phone Number</label>
                                    <input type="text" class="form-control form-control-custom bg-light" value="${provider.phone}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label-custom">Qualification</label>
                                    <input type="text" class="form-control form-control-custom bg-light" value="${not empty provider.qualification ? provider.qualification : 'Not specified'}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label-custom">Experience</label>
                                    <input type="text" class="form-control form-control-custom bg-light" value="${not empty provider.experience ? provider.experience : 'Not specified'}" readonly>
                                </div>
                                <div class="col-12">
                                    <label class="form-label-custom">Available Days</label>
                                    <input type="text" class="form-control form-control-custom bg-light" value="${not empty provider.availableDays ? provider.availableDays : 'Not specified'}" readonly>
                                </div>
                                <div class="col-12">
                                    <label class="form-label-custom">Location / Area</label>
                                    <textarea class="form-control form-control-custom bg-light" rows="2" readonly>${provider.locationText}</textarea>
                                </div>
                                <div class="col-12">
                                    <label class="form-label-custom">Service Bio / Description</label>
                                    <textarea class="form-control form-control-custom bg-light" rows="3" readonly>${provider.description}</textarea>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                                <button class="btn btn-primary" onclick="openEditProfileModal()">
                                    <i class="bi bi-pencil-square me-1"></i> Edit Profile Details
                                </button>
                                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger">
                                    <i class="bi bi-box-arrow-right me-1"></i> Logout
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- Edit Profile Modal -->
    <div class="modal fade" id="editProfileModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg" style="border-radius: var(--radius-lg);">
                <div class="modal-header border-bottom p-3">
                    <h5 class="modal-title fw-bold"><i class="bi bi-person-lines-fill me-2 text-danger"></i> Edit Provider Profile</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/marketplace/provider/profile/update" method="post" enctype="multipart/form-data" id="editProfileForm">
                    <div class="modal-body p-4" style="max-height: 75vh; overflow-y: auto;">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label-custom">Full Name <span class="text-danger">*</span></label>
                                <input type="text" name="fullName" class="form-control form-control-custom" value="${provider.fullName}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label-custom">Phone Number <span class="text-danger">*</span></label>
                                <input type="text" name="phone" class="form-control form-control-custom" value="${provider.phone}" required>
                            </div>
                            <div class="col-12">
                                <label class="form-label-custom">Profile Photo (JPG, PNG, WEBP)</label>
                                <input type="file" name="profilePhoto" class="form-control form-control-custom" accept="image/jpeg,image/jpg,image/png,image/webp">
                                <c:if test="${not empty provider.profilePhoto}">
                                    <div class="form-text text-muted">Current Photo: <a href="${pageContext.request.contextPath}${provider.profilePhoto}" target="_blank">View Photo</a></div>
                                </c:if>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label-custom">Qualification</label>
                                <input type="text" name="qualification" class="form-control form-control-custom" value="${provider.qualification}" placeholder="e.g. Baking Certification, MBBS, LL.B, B.Ed, Certified Trainer">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label-custom">Experience</label>
                                <select name="experience" class="form-select form-select-custom">
                                    <option value="" ${empty provider.experience ? 'selected' : ''}>Select Experience</option>
                                    <option value="Fresher" ${provider.experience == 'Fresher' ? 'selected' : ''}>Fresher</option>
                                    <option value="Less than 1 year" ${provider.experience == 'Less than 1 year' ? 'selected' : ''}>Less than 1 year</option>
                                    <option value="1–2 years" ${provider.experience == '1–2 years' ? 'selected' : ''}>1–2 years</option>
                                    <option value="3–5 years" ${provider.experience == '3–5 years' ? 'selected' : ''}>3–5 years</option>
                                    <option value="6–10 years" ${provider.experience == '6–10 years' ? 'selected' : ''}>6–10 years</option>
                                    <option value="10+ years" ${provider.experience == '10+ years' ? 'selected' : ''}>10+ years</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label-custom">Available Days</label>
                                <input type="hidden" name="availableDays" id="availableDaysHiddenInput" value="${provider.availableDays}">
                                <div class="p-3 border rounded-3 bg-light">
                                    <div class="form-check mb-2 pb-2 border-bottom">
                                        <input class="form-check-input" type="checkbox" id="allDaysCheckbox">
                                        <label class="form-check-input-label fw-bold text-dark" for="allDaysCheckbox">Available all days</label>
                                    </div>
                                    <div class="d-flex flex-wrap gap-3 mt-2">
                                        <c:set var="daysList" value="Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday"/>
                                        <c:forEach var="day" items="${daysList.split(',')}">
                                            <div class="form-check">
                                                <input class="form-check-input day-checkbox" type="checkbox" value="${day}" id="day_${day}">
                                                <label class="form-check-label" for="day_${day}">${day}</label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12">
                                <label class="form-label-custom">Location / Operating Area</label>
                                <input type="text" name="locationText" class="form-control form-control-custom" value="${provider.locationText}">
                            </div>
                            <div class="col-12">
                                <label class="form-label-custom">Service Description / Bio</label>
                                <textarea name="description" class="form-control form-control-custom" rows="3">${provider.description}</textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top p-3">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger px-4 fw-bold">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Class Details Modal -->
    <div class="modal fade" id="classDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: var(--radius-lg);">
                <div class="modal-header border-bottom p-3">
                    <h5 class="modal-title fw-bold" id="cdTitle">Class Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <span class="text-muted small uppercase fw-bold">Schedule</span>
                        <div class="fw-bold text-dark" id="cdDateTime"></div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-6">
                            <span class="text-muted small uppercase fw-bold">Mode</span>
                            <div class="fw-bold text-primary" id="cdMode"></div>
                        </div>
                        <div class="col-6">
                            <span class="text-muted small uppercase fw-bold">Price</span>
                            <div class="fw-bold text-danger" id="cdPrice"></div>
                        </div>
                    </div>
                    <div class="mb-3">
                    <div class="mb-3" id="cdMeetingBox">
                        <span class="text-muted small uppercase fw-bold">Meeting Link</span>
                        <div><a href="#" id="cdMeetingLink" target="_blank" class="text-truncate d-block text-primary"></a></div>
                    </div>
                    <div>
                        <span class="text-muted small uppercase fw-bold">Description</span>
                        <p class="text-secondary small" id="cdDesc"></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Notification Modal -->
    <div class="modal fade" id="notificationModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: var(--radius-lg);">
                <div class="modal-header border-bottom p-3">
                    <h5 class="modal-title fw-bold"><i class="bi bi-bell-fill me-2 text-warning"></i> Notifications</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="p-3 bg-light rounded-3 mb-2 border-start border-4 border-primary">
                        <div class="fw-bold text-dark" style="font-size: 0.9rem;">Welcome to Fight D Fear Provider Dashboard</div>
                        <div class="text-muted small">Manage your classes, track customer bookings, and monitor earnings seamlessly.</div>
                    </div>
                    <c:forEach var="b" items="${bookings}" varStatus="status">
                        <c:if test="${status.index < 3}">
                            <div class="p-3 bg-light rounded-3 mb-2 border-start border-4 border-info">
                                <div class="fw-bold text-dark" style="font-size: 0.9rem;">Booking Request: ${b.user.fullName}</div>
                                <div class="text-muted small">Status: <strong>${b.status}</strong> | Date: ${b.requestedTime}</div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- Chat Modal -->
    <div class="modal fade" id="chatModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: var(--radius-lg);">
                <div class="modal-header border-bottom p-3">
                    <h5 class="modal-title fw-bold" id="chatPartnerName">Chat</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-0">
                    <div id="chatArea" style="height: 380px; overflow-y: auto; padding: 20px; display: flex; flex-direction: column; gap: 10px; background-color: #f8fafc;"></div>
                    <div class="p-3 bg-white border-top">
                        <div class="input-group">
                            <input type="text" id="chatInput" class="form-control form-control-custom" placeholder="Type your message...">
                            <button class="btn btn-primary" onclick="sendMessage()"><i class="bi bi-send-fill"></i></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Video Call Modal -->
    <div class="modal fade" id="videoModal" data-bs-backdrop="static" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: var(--radius-lg); background-color: #0f172a; color: white;">
                <div class="modal-header border-bottom border-secondary p-3">
                    <h5 class="modal-title fw-bold text-white">Video Call: <span id="videoPartnerName"></span></h5>
                    <div class="ms-auto me-3 fw-bold text-warning" id="callTimer">00:00</div>
                    <button type="button" class="btn-close btn-close-white" onclick="endCall()"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="position-relative w-100 mb-4 bg-black rounded-3 overflow-hidden" style="aspect-ratio: 16/9;">
                        <video id="remoteVideo" autoplay playsinline style="width: 100%; height: 100%; object-fit: cover;"></video>
                        <video id="localVideo" autoplay playsinline muted style="position: absolute; bottom: 16px; right: 16px; width: 28%; aspect-ratio: 16/9; background: #222; border: 2px solid var(--brand-primary); border-radius: 8px; object-fit: cover;"></video>
                    </div>
                    <div class="d-flex justify-content-center gap-3">
                        <button id="muteBtn" class="btn btn-outline-light rounded-circle p-3" onclick="toggleMute()" title="Mute/Unmute">
                            <i class="bi bi-mic-fill"></i>
                        </button>
                        <button id="videoBtn" class="btn btn-outline-light rounded-circle p-3" onclick="toggleVideo()" title="Video On/Off">
                            <i class="bi bi-camera-video-fill"></i>
                        </button>
                        <button class="btn btn-danger rounded-pill px-4 py-2 fw-bold" onclick="endCall()">
                            <i class="bi bi-telephone-x-fill me-2"></i> End Call
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <script>
        const ctx = '${pageContext.request.contextPath}';
        let stompClient = null;
        let currentBookingId = null;
        let localStream = null;
        let peerConnection = null;
        let callTimerInterval = null;
        let secondsElapsed = 0;
        let isMuted = false;
        let isVideoOff = false;
        let iceCandidatesQueue = [];
        const config = { 
            iceServers: [
                { urls: 'stun:stun.l.google.com:19302' },
                { urls: 'stun:stun1.l.google.com:19302' }
            ] 
        };

        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('show');
        }

        function focusCreateClass() {
            const card = document.getElementById('create-class-card');
            if (card) {
                card.scrollIntoView({ behavior: 'smooth' });
            }
        }

        function openEditProfileModal() {
            new bootstrap.Modal(document.getElementById('editProfileModal')).show();
        }

        function openNotificationModal() {
            new bootstrap.Modal(document.getElementById('notificationModal')).show();
        }

        function openClassDetailsModal(title, dateTime, mode, price, meetingLink, desc) {
            document.getElementById('cdTitle').innerText = title;
            document.getElementById('cdDateTime').innerText = dateTime;
            document.getElementById('cdMode').innerText = mode;
            document.getElementById('cdPrice').innerText = price;
            document.getElementById('cdDesc').innerText = desc || 'No detailed description provided.';
            
            const meetingBox = document.getElementById('cdMeetingBox');
            const meetingLinkEl = document.getElementById('cdMeetingLink');
            if (meetingLink && meetingLink !== 'null' && meetingLink !== '') {
                meetingBox.style.display = 'block';
                meetingLinkEl.href = meetingLink;
                meetingLinkEl.innerText = meetingLink;
            } else {
                meetingBox.style.display = 'none';
            }
            new bootstrap.Modal(document.getElementById('classDetailsModal')).show();
        }

        // JS Tabbed Navigation System with Auto-Close Mobile Sidebar
        function showTab(tabId) {
            const sidebar = document.getElementById('sidebar');
            if (sidebar) sidebar.classList.remove('show');

            document.querySelectorAll('.dashboard-section').forEach(section => {
                section.style.display = 'none';
            });
            
            const targetSection = document.getElementById(tabId + '-section');
            if (targetSection) {
                targetSection.style.display = 'block';
            }
            
            document.querySelectorAll('.sidebar-nav a').forEach(link => {
                link.classList.remove('active');
            });
            
            const activeLink = document.getElementById('nav-' + tabId);
            if (activeLink) {
                activeLink.classList.add('active');
            }
            
            sessionStorage.setItem('provider_active_tab', tabId);
        }

        // WebSockets & WebRTC Video Call Logic
        function initWebSocket(bookingId) {
            if (stompClient && currentBookingId === bookingId) return;
            if (stompClient) stompClient.disconnect();
            currentBookingId = bookingId;

            const socket = new SockJS(ctx + '/ws-chat');
            stompClient = Stomp.over(socket);
            stompClient.debug = null;

            stompClient.connect({}, () => {
                stompClient.subscribe('/topic/marketplace-chat/' + bookingId, (payload) => {
                    const msg = JSON.parse(payload.body);
                    handleIncomingMessage(msg, bookingId);
                });
            });
        }

        function handleIncomingMessage(msg, bookingId) {
            if (msg.type === 'CHAT') {
                if (currentBookingId === bookingId) {
                    appendChatMessage(msg.content, msg.senderRole === 'PROVIDER' ? 'sent' : 'received');
                }
            } else if (msg.type === 'SIGNAL_OFFER') {
                currentBookingId = bookingId;
                handleOffer(msg.content);
            } else if (msg.type === 'SIGNAL_ANSWER') {
                handleAnswer(msg.content);
            } else if (msg.type === 'SIGNAL_ICE') {
                handleIceCandidate(msg.content);
            } else if (msg.type === 'END_CALL') {
                closeVideoModal();
            }
        }

        function updateStatus(id) {
            const status = document.getElementById('status-select-' + id).value;
            fetch(ctx + '/marketplace/provider/bookings/' + id + '/status', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'status=' + status
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message || 'Update failed');
                }
            });
        }

        function openChat(bookingId, partnerName) {
            document.getElementById('chatPartnerName').innerText = partnerName;
            document.getElementById('chatArea').innerHTML = '';
            initWebSocket(bookingId);
            
            fetch(ctx + '/marketplace/chat-history/' + bookingId)
                .then(res => res.json())
                .then(history => {
                    history.forEach(msg => {
                        appendChatMessage(msg.content, msg.senderRole === 'PROVIDER' ? 'sent' : 'received');
                    });
                    new bootstrap.Modal(document.getElementById('chatModal')).show();
                });
        }

        function sendMessage() {
            const input = document.getElementById('chatInput');
            const content = input.value.trim();
            if (!content || !stompClient) return;

            stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({
                type: 'CHAT',
                content: content,
                senderRole: 'PROVIDER'
            }));
            input.value = '';
        }

        function appendChatMessage(content, type) {
            const div = document.createElement('div');
            div.style.padding = '8px 14px';
            div.style.borderRadius = '12px';
            div.style.fontSize = '0.9rem';
            div.style.maxWidth = '80%';
            if (type === 'sent') {
                div.style.alignSelf = 'flex-end';
                div.style.backgroundColor = 'var(--brand-primary)';
                div.style.color = '#ffffff';
            } else {
                div.style.alignSelf = 'flex-start';
                div.style.backgroundColor = '#ffffff';
                div.style.border = '1px solid var(--border-color)';
                div.style.color = 'var(--text-primary)';
            }
            div.innerText = content;
            const area = document.getElementById('chatArea');
            area.appendChild(div);
            area.scrollTop = area.scrollHeight;
        }

        async function startVideoCall(bookingId, partnerName) {
            document.getElementById('videoPartnerName').innerText = partnerName;
            initWebSocket(bookingId);
            const modal = new bootstrap.Modal(document.getElementById('videoModal'));
            modal.show();

            try {
                localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
                document.getElementById('localVideo').srcObject = localStream;
                
                if (peerConnection) peerConnection.close();
                createPeerConnection();
                localStream.getTracks().forEach(track => peerConnection.addTrack(track, localStream));

                const offer = await peerConnection.createOffer();
                await peerConnection.setLocalDescription(offer);

                stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({
                    type: 'SIGNAL_OFFER',
                    content: JSON.stringify(offer)
                }));
            } catch (err) {
                console.error('Call failed', err);
                alert('Could not access camera/microphone.');
                modal.hide();
            }
        }

        function createPeerConnection() {
            peerConnection = new RTCPeerConnection(config);
            iceCandidatesQueue = [];

            peerConnection.onicecandidate = (event) => {
                if (event.candidate) {
                    stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({
                        type: 'SIGNAL_ICE',
                        content: JSON.stringify(event.candidate)
                    }));
                }
            };

            peerConnection.ontrack = (event) => {
                const remoteVideo = document.getElementById('remoteVideo');
                if (event.streams && event.streams[0]) {
                    remoteVideo.srcObject = event.streams[0];
                } else {
                    let remoteStream = remoteVideo.srcObject;
                    if (!remoteStream) {
                        remoteStream = new MediaStream();
                        remoteVideo.srcObject = remoteStream;
                    }
                    remoteStream.addTrack(event.track);
                }
                remoteVideo.play().catch(e => console.warn("Auto-play blocked", e));
            };

            peerConnection.onconnectionstatechange = () => {
                if (peerConnection.connectionState === 'connected') {
                    startTimer();
                }
            };
        }

        async function handleOffer(content) {
            if (peerConnection) peerConnection.close();
            createPeerConnection();
            
            const offer = JSON.parse(content);
            await peerConnection.setRemoteDescription(new RTCSessionDescription(offer));
            
            while (iceCandidatesQueue.length > 0) {
                const candidate = iceCandidatesQueue.shift();
                await peerConnection.addIceCandidate(new RTCIceCandidate(candidate));
            }

            if (!localStream) {
                try {
                    localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
                    document.getElementById('localVideo').srcObject = localStream;
                    localStream.getTracks().forEach(track => peerConnection.addTrack(track, localStream));
                    new bootstrap.Modal(document.getElementById('videoModal')).show();
                } catch (err) {
                    console.error('Failed to get media', err);
                }
            }

            const answer = await peerConnection.createAnswer();
            await peerConnection.setLocalDescription(answer);

            stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({
                type: 'SIGNAL_ANSWER',
                content: JSON.stringify(answer)
            }));
        }

        async function handleAnswer(content) {
            const answer = JSON.parse(content);
            await peerConnection.setRemoteDescription(new RTCSessionDescription(answer));
            
            while (iceCandidatesQueue.length > 0) {
                const candidate = iceCandidatesQueue.shift();
                await peerConnection.addIceCandidate(new RTCIceCandidate(candidate));
            }
        }

        async function handleIceCandidate(content) {
            const candidate = JSON.parse(content);
            if (peerConnection && peerConnection.remoteDescription) {
                await peerConnection.addIceCandidate(new RTCIceCandidate(candidate));
            } else {
                iceCandidatesQueue.push(candidate);
            }
        }

        function toggleMute() {
            if (localStream) {
                isMuted = !isMuted;
                localStream.getAudioTracks().forEach(track => track.enabled = !isMuted);
                const btn = document.getElementById('muteBtn');
                btn.innerHTML = isMuted ? '<i class="bi bi-mic-mute-fill text-danger"></i>' : '<i class="bi bi-mic-fill"></i>';
            }
        }

        function toggleVideo() {
            if (localStream) {
                isVideoOff = !isVideoOff;
                localStream.getVideoTracks().forEach(track => track.enabled = !isVideoOff);
                const btn = document.getElementById('videoBtn');
                btn.innerHTML = isVideoOff ? '<i class="bi bi-camera-video-off-fill text-danger"></i>' : '<i class="bi bi-camera-video-fill"></i>';
            }
        }

        function startTimer() {
            if (callTimerInterval) return;
            secondsElapsed = 0;
            const timerEl = document.getElementById('callTimer');
            callTimerInterval = setInterval(() => {
                secondsElapsed++;
                const mins = Math.floor(secondsElapsed / 60).toString().padStart(2, '0');
                const secs = (secondsElapsed % 60).toString().padStart(2, '0');
                timerEl.innerText = mins + ':' + secs;
            }, 1000);
        }

        function endCall() {
            if (stompClient) {
                stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({ type: 'END_CALL' }));
            }
            closeVideoModal();
        }

        function closeVideoModal() {
            if (localStream) {
                localStream.getTracks().forEach(track => track.stop());
                localStream = null;
            }
            if (peerConnection) {
                peerConnection.close();
                peerConnection = null;
            }
            if (callTimerInterval) {
                clearInterval(callTimerInterval);
                callTimerInterval = null;
            }
            document.getElementById('callTimer').innerText = '00:00';
            bootstrap.Modal.getInstance(document.getElementById('videoModal')).hide();
        }

        document.addEventListener('DOMContentLoaded', function() {
            const activeTab = sessionStorage.getItem('provider_active_tab') || 'overview';
            showTab(activeTab);

            <c:forEach var="b" items="${bookings}">
                <c:if test="${b.status.name() == 'CONFIRMED'}">
                    initWebSocket(${b.id});
                </c:if>
            </c:forEach>
        });

        const categoryServicesMap = {
            "TUTOR": ["Academic Tutoring", "School Subject Coaching", "College Subject Tutoring", "Exam Preparation", "Homework Assistance", "Online Tutoring", "One-to-One Tutoring"],
            "TAILOR": ["Custom Stitching", "Dress Alteration", "Blouse Stitching", "Saree Blouse Stitching", "Salwar Suit Stitching", "Embroidery", "Custom Clothing Design"],
            "HOME_COOK": ["Home-Cooked Meals", "Daily Meal Preparation", "Lunch / Dinner Service", "Traditional Cuisine", "Special Occasion Meals", "Meal Subscription", "Custom Food Orders"],
            "CATERING_SERVICE": ["Small Event Catering", "Birthday Catering", "Wedding Catering", "Corporate Catering", "Party Catering", "Buffet Service", "Custom Menu Catering"],
            "EVENT_PLANNER": ["Birthday Event Planning", "Wedding Planning", "Corporate Events", "Party Planning", "Decoration Planning", "Venue Coordination", "Full Event Management"],
            "BABYSITTER": ["Infant Care", "Toddler Care", "Child Care", "After-School Care", "Weekend Babysitting", "Overnight Babysitting", "Part-Time Babysitting"],
            "PET_CARE": ["Dog Walking", "Pet Sitting", "Pet Feeding", "Grooming Assistance", "Pet Day Care", "Home Pet Care", "Basic Pet Support"],
            "DIETITIAN": ["Diet Consultation", "Weight Management", "Nutrition Planning", "Personalized Meal Plan", "Fitness Nutrition", "Lifestyle Nutrition", "Online Consultation"],
            "HOME_CLEANER": ["Home Cleaning", "Deep Cleaning", "Kitchen Cleaning", "Bathroom Cleaning", "Bedroom Cleaning", "Move-In / Move-Out Cleaning", "Regular Cleaning"],
            "INTERIOR_DESIGNER": ["Home Interior Design", "Room Design", "Kitchen Design", "Bedroom Design", "Living Room Design", "Office Interior Design", "3D Interior Planning"],
            "HANDICRAFT_SELLER": ["Handmade Crafts", "Decorative Items", "Custom Crafts", "Gift Items", "Home Decor Crafts", "Traditional Crafts", "Personalized Crafts"],
            "DIGITAL_MARKETING_CONSULTANT": ["Social Media Marketing", "SEO Services", "Content Marketing", "Digital Advertising", "Brand Promotion", "Marketing Strategy", "Social Media Management"],
            "HOME_BAKER": ["Custom Cakes", "Birthday Cakes", "Cupcakes", "Cookies", "Brownies", "Pastries", "Custom Dessert Orders"],
            "LANGUAGE_TRAINER": ["English Training", "Hindi Training", "Spoken English", "Grammar Training", "Conversation Practice", "IELTS / Exam Preparation", "Business Communication"],
            "WOMEN_PRODUCTS": ["Beauty Products", "Personal Care Products", "Fashion Products", "Women's Accessories", "Wellness Products", "Handmade Products", "Custom Product Orders"],
            "WOMEN_LAWYER": ["Legal Consultation", "Family Law Consultation", "Property Law Consultation", "Employment Law Consultation", "Documentation Assistance", "Legal Notice Assistance", "Online Legal Consultation"],
            "FITNESS_ZUMBA": ["Zumba Classes", "Dance Fitness", "Cardio Fitness", "Group Fitness", "Weight Loss Training", "Online Fitness Classes", "Personal Fitness Sessions"],
            "BEAUTICIAN": ["Facial", "Hair Care", "Skin Care", "Manicure", "Pedicure", "Beauty Consultation", "Home Beauty Service"],
            "MAKEUP_ARTIST": ["Bridal Makeup", "Party Makeup", "Engagement Makeup", "Event Makeup", "Photoshoot Makeup", "Traditional Makeup", "Home Makeup Service"],
            "MEHENDI_ARTIST": ["Bridal Mehendi", "Arabic Mehendi", "Traditional Mehendi", "Party Mehendi", "Engagement Mehendi", "Custom Mehendi Design", "Festival Mehendi"],
            "PHOTOGRAPHER": ["Wedding Photography", "Event Photography", "Portrait Photography", "Product Photography", "Fashion Photography", "Birthday Photography", "Photoshoot"],
            "YOGA_TRAINER": ["Beginner Yoga", "Hatha Yoga", "Meditation", "Weight Loss Yoga", "Stress Relief Yoga", "Flexibility Training", "Online Yoga Classes"],
            "FITNESS_TRAINER": ["Personal Training", "Weight Loss Training", "Strength Training", "Muscle Building", "Fitness Assessment", "Home Training", "Online Fitness Training"],
            "DANCE_INSTRUCTOR": ["Classical Dance", "Western Dance", "Bollywood Dance", "Hip-Hop", "Contemporary Dance", "Kids Dance", "Wedding Dance Training"],
            "MUSIC_TEACHER": ["Vocal Training", "Guitar Lessons", "Piano Lessons", "Keyboard Lessons", "Music Theory", "Beginner Music Training", "Online Music Lessons"],
            "CRAFT_SELLER": ["Handmade Crafts", "DIY Crafts", "Custom Crafts", "Home Decor", "Gift Crafts", "Paper Crafts", "Personalized Crafts"],
            "HANDMADE_PRODUCTS": ["Handmade Jewelry", "Handmade Decor", "Handmade Gifts", "Handmade Accessories", "Custom Handmade Products", "Eco-Friendly Products", "Personalized Products"],
            "BOUTIQUE": ["Women's Clothing", "Custom Dresses", "Ethnic Wear", "Western Wear", "Sarees", "Custom Fashion", "Fashion Accessories"],
            "FASHION_DESIGNER": ["Custom Dress Design", "Bridal Wear", "Ethnic Wear Design", "Western Wear Design", "Fashion Consultation", "Custom Outfit Design", "Personal Styling"],
            "FREELANCER": ["Web Development", "Software Development", "Data Entry", "Virtual Assistance", "Consulting", "Translation", "Professional Services"],
            "GRAPHIC_DESIGNER": ["Logo Design", "Social Media Design", "Poster Design", "Business Card Design", "Branding Design", "UI Design", "Marketing Design"],
            "CONTENT_WRITER": ["Blog Writing", "Website Content", "Article Writing", "Social Media Content", "Product Description", "Copywriting", "SEO Content Writing"],
            "MARTIAL_ARTS": ["Karate Training", "Kickboxing", "Self-Defense Training", "Taekwondo", "Boxing", "Martial Arts Fitness", "Personal Training"],
            "FEMALE_DOCTORS": ["General Consultation", "Women's Health Consultation", "Online Doctor Consultation", "Health Checkup Guidance", "Preventive Care", "Medical Advice", "Follow-Up Consultation"]
        };

        function populateServicesForCategory(catKey, selectedService) {
            const selectEl = document.getElementById('serviceProvidedSelect');
            if (!selectEl) return;
            selectEl.innerHTML = '<option value="" disabled ' + (!selectedService ? 'selected' : '') + '>Choose a service</option>';

            const services = categoryServicesMap[catKey] || [];
            services.forEach(srv => {
                const opt = document.createElement('option');
                opt.value = srv;
                opt.textContent = srv;
                if (selectedService && srv.toLowerCase() === selectedService.toLowerCase()) {
                    opt.selected = true;
                }
                selectEl.appendChild(opt);
            });
        }

        const categoryModesMap = {
            "TUTOR": ["Online", "Offline", "Hybrid (Online + Offline)", "Recorded Workshop"],
            "TAILOR": ["Offline"],
            "HOME_COOK": ["Offline"],
            "CATERING_SERVICE": ["Offline"],
            "EVENT_PLANNER": ["Online", "Offline", "Hybrid (Online + Offline)"],
            "BABYSITTER": ["Offline"],
            "PET_CARE": ["Offline"],
            "DIETITIAN": ["Online", "Offline", "Hybrid (Online + Offline)"],
            "HOME_CLEANER": ["Offline"],
            "INTERIOR_DESIGNER": ["Online", "Offline", "Hybrid (Online + Offline)"],
            "HANDICRAFT_SELLER": ["Offline"],
            "DIGITAL_MARKETING_CONSULTANT": ["Online"],
            "HOME_BAKER": ["Offline"],
            "LANGUAGE_TRAINER": ["Online", "Offline", "Hybrid (Online + Offline)", "Recorded Workshop"],
            "WOMEN_PRODUCTS": ["Offline"],
            "WOMEN_LAWYER": ["Online", "Offline", "Hybrid (Online + Offline)"],
            "FITNESS_ZUMBA": ["Online", "Offline", "Hybrid (Online + Offline)", "Recorded Workshop"],
            "BEAUTICIAN": ["Offline"],
            "MAKEUP_ARTIST": ["Offline"],
            "MEHENDI_ARTIST": ["Offline"],
            "PHOTOGRAPHER": ["Offline"],
            "YOGA_TRAINER": ["Online", "Offline", "Hybrid (Online + Offline)", "Recorded Workshop"],
            "FITNESS_TRAINER": ["Online", "Offline", "Hybrid (Online + Offline)", "Recorded Workshop"],
            "DANCE_INSTRUCTOR": ["Online", "Offline", "Hybrid (Online + Offline)", "Recorded Workshop"],
            "MUSIC_TEACHER": ["Online", "Offline", "Hybrid (Online + Offline)", "Recorded Workshop"],
            "CRAFT_SELLER": ["Offline"],
            "HANDMADE_PRODUCTS": ["Offline"],
            "BOUTIQUE": ["Offline"],
            "FASHION_DESIGNER": ["Online", "Offline", "Hybrid (Online + Offline)"],
            "FREELANCER": ["Online"],
            "GRAPHIC_DESIGNER": ["Online"],
            "CONTENT_WRITER": ["Online"],
            "MARTIAL_ARTS": ["Online", "Offline", "Hybrid (Online + Offline)", "Recorded Workshop"],
            "FEMALE_DOCTORS": ["Online", "Offline", "Hybrid (Online + Offline)"]
        };

        function updateModeSpecificFields() {
            const modeSelect = document.getElementById('sessionModeSelect');
            const meetingGroup = document.getElementById('meetingLinkGroup');
            const meetingInput = document.getElementById('meetingLinkInput');
            const locationGroup = document.getElementById('serviceLocationGroup');
            const locationInput = document.getElementById('serviceLocationInput');

            if (!modeSelect || !meetingGroup || !locationGroup) return;
            const val = modeSelect.value ? modeSelect.value.trim() : '';

            const isOnline = val.toLowerCase() === 'online' || val.toLowerCase() === 'live' || val.toLowerCase().includes('online');
            const isOffline = val.toLowerCase() === 'offline' || val.toLowerCase().includes('offline');
            const isHybrid = val.toLowerCase().includes('hybrid');

            if (isHybrid) {
                meetingGroup.style.display = 'block';
                if (meetingInput) meetingInput.required = true;
                locationGroup.style.display = 'block';
                if (locationInput) locationInput.required = true;
            } else if (isOnline) {
                meetingGroup.style.display = 'block';
                if (meetingInput) meetingInput.required = true;
                locationGroup.style.display = 'none';
                if (locationInput) { locationInput.required = false; locationInput.value = ''; }
            } else if (isOffline) {
                meetingGroup.style.display = 'none';
                if (meetingInput) { meetingInput.required = false; meetingInput.value = ''; }
                locationGroup.style.display = 'block';
                if (locationInput) locationInput.required = true;
            } else {
                meetingGroup.style.display = 'none';
                if (meetingInput) meetingInput.required = false;
                locationGroup.style.display = 'none';
                if (locationInput) locationInput.required = false;
            }
        }

        function populateModesForCategory(catKey, selectedMode) {
            const selectEl = document.getElementById('sessionModeSelect');
            if (!selectEl) return;
            selectEl.innerHTML = '<option value="" disabled ' + (!selectedMode ? 'selected' : '') + '>Choose session mode</option>';

            const modes = categoryModesMap[catKey] || ["Online", "Offline", "Hybrid (Online + Offline)"];
            modes.forEach(m => {
                const opt = document.createElement('option');
                opt.value = m;
                opt.textContent = m;
                if (selectedMode && (m.toLowerCase() === selectedMode.toLowerCase() || (m === 'Online' && selectedMode === 'Live'))) {
                    opt.selected = true;
                }
                selectEl.appendChild(opt);
            });
            updateModeSpecificFields();
        }

        (function() {
            document.addEventListener('DOMContentLoaded', function() {
                var modeSelect = document.getElementById('sessionModeSelect');
                if (modeSelect) modeSelect.addEventListener('change', updateModeSpecificFields);

                const currentCat = '${provider.category}';
                populateServicesForCategory(currentCat, '');
                populateModesForCategory(currentCat, '');

                // Available Days Checkbox Management
                const allDaysCb = document.getElementById('allDaysCheckbox');
                const dayCbs = document.querySelectorAll('.day-checkbox');
                const hiddenInput = document.getElementById('availableDaysHiddenInput');
                const form = document.getElementById('editProfileForm');

                if (allDaysCb && hiddenInput && form) {
                    const initialVal = hiddenInput.value ? hiddenInput.value.trim() : '';
                    if (initialVal.toLowerCase() === 'available all days' || initialVal.toLowerCase().includes('all days')) {
                        allDaysCb.checked = true;
                        dayCbs.forEach(cb => cb.checked = true);
                    } else if (initialVal) {
                        const daysArr = initialVal.split(',').map(d => d.trim().toLowerCase());
                        let allChecked = true;
                        dayCbs.forEach(cb => {
                            if (daysArr.includes(cb.value.toLowerCase())) {
                                cb.checked = true;
                            } else {
                                allChecked = false;
                            }
                        });
                        if (allChecked && dayCbs.length > 0) allDaysCb.checked = true;
                    }

                    allDaysCb.addEventListener('change', function() {
                        dayCbs.forEach(cb => cb.checked = allDaysCb.checked);
                    });

                    dayCbs.forEach(cb => {
                        cb.addEventListener('change', function() {
                            const allChecked = Array.from(dayCbs).every(c => c.checked);
                            allDaysCb.checked = allChecked;
                        });
                    });

                    form.addEventListener('submit', function() {
                        if (allDaysCb.checked) {
                            hiddenInput.value = 'Available All Days';
                        } else {
                            const selected = Array.from(dayCbs)
                                .filter(cb => cb.checked)
                                .map(cb => cb.value);
                            hiddenInput.value = selected.join(', ');
                        }
                    });
                }
            });
        })();
    </script>
</body>
</html>
