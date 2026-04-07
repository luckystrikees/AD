# Codebase Documentation

## Table of Contents

- [Frontend Files](#frontend-files)
  - [/Users/macbookpro16/Desktop/AutisticScholars.org/github/AD/about.html](#-users-macbookpro16-desktop-autisticscholars-org-github-ad-about-html)
  - [/Users/macbookpro16/Desktop/AutisticScholars.org/github/AD/index.html](#-users-macbookpro16-desktop-autisticscholars-org-github-ad-index-html)
  - [/Users/macbookpro16/Desktop/AutisticScholars.org/github/AD/login.html](#-users-macbookpro16-desktop-autisticscholars-org-github-ad-login-html)
  - [/Users/macbookpro16/Desktop/AutisticScholars.org/github/AD/framework/index.html](#-users-macbookpro16-desktop-autisticscholars-org-github-ad-framework-index-html)
  - [/Users/macbookpro16/Desktop/AutisticScholars.org/github/AD/assets/css/styles.css](#-users-macbookpro16-desktop-autisticscholars-org-github-ad-assets-css-styles-css)

---

## Frontend Files

<a name="-users-macbookpro16-desktop-autisticscholars-org-github-ad-about-html"></a>

### `/Users/macbookpro16/Desktop/AutisticScholars.org/github/AD/about.html`

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About | Autistic Scholars</title>

    <!-- Fonts: Updated to include both EB Garamond and Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- CSS -->
    <link rel="stylesheet" href="/assets/css/styles.css">
</head>
<body>

    <header class="site-header">
        <div class="nav-inner">
            <div class="site-title">Autistic Scholars</div>

            <nav class="site-nav" aria-label="Primary Navigation">
                <a href="/framework/">Research Program</a> <!-- Now the primary link -->
                <span class="nav-divider">·</span>
                <a href="/login.html">Research Portfolio</a> <!-- Changed from 'Research' -->
                <span class="nav-divider">·</span>
                <a href="/login.html">Working Papers</a>
                <span class="nav-divider">·</span>
                <a href="/about.html">About</a>
            </nav>
            
        </div>
        <hr class="nav-rule">
    </header>

    <main>

        <!-- Hero Section Updated to Match the New Backplate Style -->
        <section class="hero framework-hero">
            <div class="hero-inner">
                <p class="hero-kicker-large">About</p>
                <div class="hero-divider-long"></div>
                <h1>Autistic Scholars</h1>
            </div>
        </section>

        <article class="content-inner article-content">

            <h3>The Initiative</h3>

            <p>
                Autistic Scholars is an independent research initiative examining how different regulatory architectures of cognition interact within shared environments.
            </p>

            <p>
                The work begins from a specific observation: that contemporary psychology has implicitly adopted the cognitive architecture of majority social interaction as its normative baseline, treating one regulatory strategy as the unmarked standard for human social functioning. This renders alternative architectures visible only as deviation or deficit.
            </p>

            <p>
                The initiative makes this baseline visible and examines its consequences across multiple levels of analysis—from the phenomenological identification of distinct regulatory systems, through their computational formalization under energetic constraint, to the physiological and molecular consequences of sustained architectural mismatch within environments calibrated to a single norm.
            </p>

            <p>
                The work treats autistic lived experience not as anecdotal supplement but as situated knowledge capable of generating formal theory. Autistic perspectives function as analytical vantage points—positions from which normally implicit regulatory processes become explicit objects of analysis. This orientation draws on feminist epistemology, critical psychology, disability studies, and the double empathy framework.
            </p>

            <div class="article-divider">
                ‡
            </div>

            <h3>Founding Scholar</h3>

            <div class="scholar-block">

                <img src="/assets/images/ericwilliam.jpg" alt="Ericwilliam Brown" class="scholar-portrait">

                <div class="scholar-text">

                    <p>
                        <strong>Ericwilliam Brown</strong> is the founder and principal investigator of Autistic Scholars. He is a twice-exceptional, Black, gay, late-diagnosed autistic independent scholar. His research examines the epistemology of psychological classification, the regulatory architecture of social cognition, and the consequences of sustained cross-architecture interaction at neural, metabolic, and ecological levels of analysis.
                    </p>

                    <p>
                        Contact: <a href="mailto:ericwilliam@autisticscholars.org">ericwilliam@autisticscholars.org</a>
                    </p>

                </div>

            </div>

        </article>

    </main>

    <footer class="site-footer">
        <div class="footer-inner">
            <div class="footer-seal-wrap">
                <img src="/assets/images/emblem.png" alt="Autistic Scholars Institutional Seal" class="footer-seal" loading="lazy">
            </div>
            <div class="footer-name">Autistic Scholars</div>
            <div class="footer-descriptor">An Independent Research Initiative</div>
            <div class="footer-copyright">© 2026 Autistic Scholars</div>
        </div>
    </footer>

</body>
</html>
```

---

<a name="-users-macbookpro16-desktop-autisticscholars-org-github-ad-index-html"></a>

### `/Users/macbookpro16/Desktop/AutisticScholars.org/github/AD/index.html`

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AUTISTIC SCHOLARS | Independent Research Institute</title>
  <meta name="description" content="Autistic Scholars is an independent research initiative developing a multi-level account of how different regulatory architectures of cognition interact within shared environments.">

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  
  <!-- Updated: Loading both EB Garamond and Inter -->
  <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400;0,500;0,600;1,400&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
  
  <link rel="stylesheet" href="assets/css/styles.css">
</head>

<body>

  <header class="site-header">
    <div class="nav-inner">
      <div class="site-title">
        Autistic Scholars
      </div>
      
      <nav class="site-nav" aria-label="Primary Navigation">
          <a href="/framework/">Research Program</a> <!-- Now the primary link -->
          <span class="nav-divider">·</span>
          <a href="/login.html">Research Portfolio</a> <!-- Changed from 'Research' -->
          <span class="nav-divider">·</span>
          <a href="/login.html">Working Papers</a>
          <span class="nav-divider">·</span>
          <a href="/about.html">About</a>
      </nav>
    </div>
    
    <hr class="nav-rule">
  </header>

  <main>
    <section class="hero">
      <div class="hero-overlay"></div>
      
      <!-- Updated: Removed the conflicting 'content-inner' class -->
      <div class="hero-inner">
        <p class="hero-kicker">
          <span class="hero-plate">Independent Research Institute</span>
        </p>
        
        <h1>
          How Different Cognitive Architectures Interact Within Shared Environments
        </h1>
        
        <p class="tagline">
          A multi-level research program examining regulatory architecture, energetic constraint, and the structural limits of social adaptation.
        </p>
        
        <div class="hero-actions">
            <!-- Make the Program the focus -->
            <a href="framework/" class="hero-button primary">
                Research Program
            </a>
            <!-- Make the Papers secondary -->
            <a href="login.html" class="hero-button secondary">
                Research Portfolio
            </a>
        </div>
      </div>
    </section>

    <section class="pillar-container">
      <!-- Updated: Changed 'content-inner' (740px) to 'wide-container' (1100px) -->
      <div class="wide-container">
        <div class="pillar-grid">

          
<!-- Pillar 1 -->       
          <a href="framework/" class="pillar">
            <h3>Research Program</h3>
            <p>
              The five-level integrative framework: Architectural, Computational, Experiential, Mechanistic, and Ecological.
            </p>
            <span class="pillar-link">
              View Program
            </span>
          </a>

          
<!-- Pillar 2 -->       
          <a href="login.html" class="pillar">
              <h3>Research Portfolio</h3>
              <p>
                  Full library of empirical data, analysis, and cross-scale theoretical frameworks.
              </p>
              <span class="pillar-link">Access Portfolio</span>
          </a>

 <!-- Pillar 3 -->     
          <a href="login.html" class="pillar">
            <h3>Research Portfolio</h3>
            <p>
              Cross-scale theoretical frameworks integrating regulatory architecture, predictive processing, neuroenergetics, and social structure.
            </p>
            <span class="pillar-link">
              Access Research
            </span>
          </a>         

        </div>
      </div>
    </section>
  </main>

  <footer class="site-footer">
      <div class="footer-inner">
          <div class="footer-seal-wrap">
              <img src="/assets/images/emblem.png" alt="Autistic Scholars Institutional Seal" class="footer-seal" loading="lazy">
          </div>
          <div class="footer-name">Autistic Scholars</div>
          <div class="footer-descriptor">An Independent Research Initiative</div>
          <div class="footer-copyright">© 2026 Autistic Scholars</div>
      </div>
  </footer>

</body>
</html>
```

---

<a name="-users-macbookpro16-desktop-autisticscholars-org-github-ad-login-html"></a>

### `/Users/macbookpro16/Desktop/AutisticScholars.org/github/AD/login.html`

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log In | Autistic Scholars</title>
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Inter:wght@400;600&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="/assets/css/styles.css">

    <style>
        /* 1. Ensure the container centers between header/footer */
        main {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 70vh; /* Keeps the card centered on the screen */
        }

        .hero {
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background-image: url("/assets/images/books.png");
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            padding: 60px 20px;
        }
    
        /* 2. THE CARD: Fixed styling for emblem and alignment */
        .login-container {
            width: 100%;
            max-width: 400px;
            padding: 40px 40px; 
            background: #ffffff !important;
            border: 1px solid var(--border);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15) !important;
            border-radius: 20px !important;
            text-align: center;
        }
    
        /* 3. THE EMBLEM: Centered via CSS, size controlled by class */
        .login-emblem {
            width: 90px !important; 
            display: block !important;
            margin: 0 auto 20px auto !important; 
            opacity: 0.7;
        }
    
        .login-title {
            font-family: 'EB Garamond', serif;
            font-size: 1.6rem;
            color: var(--accent);
            margin: 0 0 25px 0 !important; 
        }
    
        .login-form input {
            width: 100%;
            padding: 14px 16px;
            margin-bottom: 15px;
            border: 1px solid var(--border) !important;
            background: #fcfcfc !important;
            font-family: 'Inter', sans-serif;
            font-size: 0.9rem;
        }
    
        .login-submit {
            display: block;
            width: 100%;
            padding: 16px 0;
            margin-top: 5px;
            background-color: var(--accent) !important;
            color: #ffffff;
            text-transform: uppercase;
            letter-spacing: 0.15em;
            font-size: 0.8rem;
            font-weight: 600;
            border: none !important;
            cursor: pointer;
        }
    
        .login-utility {
            margin-top: 20px;
            font-family: 'Inter', sans-serif;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.15em;
            color: #888;
        }
    </style>
    
</head>
<body>

    <header class="site-header">
        <div class="site-title">Autistic Scholars</div>
        <nav class="site-nav">
            <a href="/index.html">Home</a>
            <span class="nav-divider">·</span>
            <a href="/framework/index.html">Research Program</a>
            <span class="nav-divider">·</span>
            <a href="/login.html">Research</a>
        </nav>
        <hr class="nav-rule">
    </header>

    <main>
        <section class="hero">
            <div class="login-container">
                <!-- Emblem now uses the login-emblem class defined in CSS -->
                <img src="/assets/images/emblem.png" alt="Emblem" class="login-emblem">
                
                <h2 class="login-title">Secure Portal</h2>
                
                <form class="login-form" action="/login" method="POST">
                    <input type="text" name="username" placeholder="SCHOLAR ID" required>
                    <input type="password" name="password" placeholder="PASSWORD" required>
                    <button type="submit" class="login-submit">Authenticate</button>
                </form>
                
                <div class="login-utility">
                    <a href="#">Forgot ID?</a> <span>•</span> <a href="#">Request Access</a>
                </div>
            </div>
        </section>
    </main>

    <footer class="site-footer">
        <div class="footer-inner">
            <div class="footer-name">Autistic Scholars</div>
            <div class="footer-descriptor">An Independent Research Initiative</div>
            <div class="footer-copyright">© 2026</div>
        </div>
    </footer>

</body>
</html>
```

---

<a name="-users-macbookpro16-desktop-autisticscholars-org-github-ad-framework-index-html"></a>

### `/Users/macbookpro16/Desktop/AutisticScholars.org/github/AD/framework/index.html`

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Research Program | Autistic Scholars</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="/assets/css/styles.css">
</head>

<body>

  <header class="site-header">
    <div class="nav-inner">
      <div class="site-title">Autistic Scholars</div>
      <nav class="site-nav" aria-label="Primary Navigation">
        <a href="/index.html">Home</a>
        <span class="nav-divider">·</span>
        <a href="/login.html">Research</a>
        <span class="nav-divider">·</span>
        <a href="/login.html">Working Papers</a>
        <span class="nav-divider">·</span>
        <a href="/about.html">About</a>
      </nav>
    </div>
    <hr class="nav-rule">
  </header>

  <main>
    <section class="hero framework-hero">
      <div class="hero-inner">
        <p class="hero-kicker"><span class="hero-plate">Research Program</span></p>
        <h1>Regulatory Architecture and the Energetic Limits of Social Adaptation</h1>
        <p class="tagline">A multi-level account of how different regulatory architectures of cognition interact within shared environments.</p>
      </div>
    </section>

    <article class="content-inner article-content">
      <p class="abstract-text">
        This research program develops an integrated account of cognitive regulatory architecture, spanning phenomenological identification, computational formalization, metabolic mechanism, and ecological dynamics. These five levels constitute a single argument, tracing the consequences of architectural mismatch within environments calibrated to a single norm.
      </p>

      <div class="article-divider">⁂</div>

      <div class="vertical-timeline">
        <!-- Paper I -->
        <div class="paper-section">
          <h3>I. Architectural: The Majority Baseline</h3>
          <p class="paper-title"><em>Making Majority Social Cognition Visible</em></p>
          <p>Interrogates the normative baseline of social cognition. By contrasting "socially coupled" and "internally mediated" architectures, this level identifies the double empathy problem as a consequence of systemic architectural mismatch.</p>
          <div class="paper-meta-box"><p><strong>Research Inquiry:</strong> How are the two regulatory architectures defined?</p></div>
        </div>

        <!-- Paper II -->
        <div class="paper-section">
          <h3>II. Computational: Energetic Precision</h3>
          <p class="paper-title"><em>Formalizing Dyadic Energetic Asymmetry</em></p>
          <p>Translates architectural differences into the language of active inference. It formalizes precision weighting as a metabolically constrained variable, establishing the machinery for how coupled systems interact under energetic limit.</p>
          <div class="paper-meta-box"><p><strong>Research Inquiry:</strong> What are the computational mechanics of interaction?</p></div>
        </div>

        <!-- Paper III -->
        <div class="paper-section">
          <h3>III. Experiential: Structural Insolvency</h3>
          <p class="paper-title"><em>The Metabolic Cost of Social Adaptation</em></p>
          <p>Uses "Systemic Witnessing" to map the lived experience of sustained regulatory load. It analyzes how compensatory social regulation compounds across intersectional axes, manifesting as measurable metabolic debt.</p>
          <div class="paper-meta-box"><p><strong>Research Inquiry:</strong> What is the somatic cost of regulatory load?</p></div>
        </div>

        <!-- Paper IV -->
        <div class="paper-section">
          <h3>IV. Mechanistic: Immunometabolic Pathways</h3>
          <p class="paper-title"><em>Neuro-Immunometabolic Sequelae of Compensatory Regulation</em></p>
          <p>Identifies the molecular cascade linking chronic masking to mitochondrial dysfunction, specifically through the hepcidin-ferroportin axis. Provides a falsifiable model of iron sequestration in PV+ interneurons.</p>
          <div class="paper-meta-box"><p><strong>Research Inquiry:</strong> What is the specific molecular pathway of decay?</p></div>
        </div>

        <!-- Paper V -->
        <div class="paper-section">
          <h3>V. Ecological: Regulatory Ecology</h3>
          <p class="paper-title"><em>Systems-Level Integration and Environmental Load</em></p>
          <p>Synthesizes the program into a dynamic systems model. Connects environmental input load, stress physiology, and regulatory flexibility to provide a comprehensive account of architecture-environment fit.</p>
          <div class="paper-meta-box"><p><strong>Research Inquiry:</strong> How do all these levels synthesize as a dynamic system?</p></div>
        </div>
      </div>

      <div class="article-divider">❦</div>

      <h3>Program Structure</h3>
      <p>These lines of enquiry  are structurally interdependent. The architectural distinction (Level I) is formalized (Level II), manifesting as long-term metabolic consequences (Level III) specified at the molecular level (Level IV). Level V provides the systems-level container within which all preceding mechanisms operate.</p>
    </article>
  </main>

  <footer class="site-footer">
    <div class="footer-inner">
      <div class="footer-seal-wrap">
        <img src="/assets/images/emblem.png" alt="Autistic Scholars Institutional Seal" class="footer-seal" loading="lazy">
      </div>
      <div class="footer-name">Autistic Scholars</div>
      <div class="footer-descriptor">An Independent Research Initiative</div>
      <div class="footer-copyright">© 2026 Autistic Scholars</div>
    </div>
  </footer>

</body>
</html>
```

---

<a name="-users-macbookpro16-desktop-autisticscholars-org-github-ad-assets-css-styles-css"></a>

### `/Users/macbookpro16/Desktop/AutisticScholars.org/github/AD/assets/css/styles.css`

```css
/* =================================================
   AUTISTIC SCHOLARS — MASTER STYLESHEET
================================================= */
:root {
  --paper: #f7f5f2; --text: #1c1c1c; --accent: #243833;
  --parchment: #F2EFE8; --border: #e6e2dc;
  --hero-text: #e8e0d4; --hero-text-soft: #ddd5c8;
}

/* -------------------------------------------------
   TYPOGRAPHIC SYMBOLS FOR DIVIDERS
   -------------------------------------------------
   Double Dagger: ‡ (Standard Academic)
   Asterism:      ⁂ (Research Program Structure)
   Fleuron:       ❦ (Humanities/Epistemological)
   Interpunct:    · (Minimalist)
   ------------------------------------------------- */

* { box-sizing: border-box; border-radius: 0 !important; box-shadow: none !important; }
html { font-size: 18px; background-color: var(--paper); }
body { margin: 0; padding: 0; font-family: 'EB Garamond', serif; line-height: 1.75; color: var(--text); background-color: var(--paper); }

/* UI Elements */
.site-nav, .hero-kicker, .hero-button, .pillar-link, .button-primary,
.footer-descriptor, .footer-copyright, .paper-meta-box p, .hero-kicker-large {
  font-family: 'Inter', sans-serif;
}

a { color: var(--text); text-decoration: none; transition: opacity 0.2s ease; }
a:hover { opacity: .75; }

/* Containers */
.content-inner { max-width: 740px; margin: 0 auto; padding: 0 25px; }
.wide-container { max-width: 1100px; margin: 0 auto; padding: 0 25px; }

/* Header */
.site-header { text-align: center; padding: 20px 0 0; }
.site-title { font-weight: 500; font-variant-caps: small-caps; font-size: 2.2rem; color: var(--accent); margin-bottom: 15px; }
.site-nav { font-size: .85rem; text-transform: uppercase; letter-spacing: .15em; margin-bottom: 20px; }
.site-nav a { padding: 0 15px; color: #444; }
.nav-rule { border: 0; border-top: 1px solid var(--border); max-width: 900px; margin: 0 auto; }

/* Hero Section */
.hero { position: relative; text-align: center; padding: 120px 20px 130px; background-image: url("../images/books.png"); background-size: cover; background-position: center; }
.hero-inner {
  position: relative; max-width: 740px; margin: 0 auto; padding: 80px 60px;
  display: flex; flex-direction: column; align-items: center;
  background-color: rgba(24, 30, 28, 0.82) !important;
  border-radius: 20px !important; backdrop-filter: blur(15px) !important; color: #fff;
}
.hero-kicker { letter-spacing: 0.4em; font-size: 0.9rem; font-weight: 600; margin: 0 0 25px 0 !important; }
.hero-kicker-large { letter-spacing: 0.3em; font-size: 1.8rem; font-weight: 600; color: #ffffff; margin: 0 0 10px 0 !important; line-height: 1; }
.hero h1 { font-family: 'EB Garamond', serif; font-size: 4.2rem; line-height: 1; color: #fff; margin: 0 !important; font-weight: 400; }
.hero-divider-long { display: block; width: 240px !important; height: 1.5px !important; background: rgba(255, 255, 255, 0.5) !important; margin: 35px auto !important; border: none !important; }
.hero-actions { display: flex; justify-content: center; gap: 20px; margin-top: 40px; }
.hero-button {
  padding: 14px 28px; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.15em; font-weight: 600;
  border: 1px solid rgba(255, 255, 255, 0.4) !important; color: #ffffff !important; background: transparent !important; transition: all 0.3s ease;
}
.hero-button:hover { background: #ffffff !important; color: var(--accent) !important; }

/* Institutional Pillars (Section 6) */
.pillar-container { margin: 0 auto 90px; padding: 0 20px; }
.pillar-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 30px; }
.pillar {
  display: flex; flex-direction: column; justify-content: center; padding: 42px 28px; border: 1px solid var(--border);
  background: #ffffff; text-align: center; min-height: 260px; text-decoration: none; transition: all 0.3s ease;
}
.pillar:hover { background: var(--paper); border-color: var(--accent); transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.04) !important; }
.pillar h3 { font-size: 1.28rem; margin-bottom: 16px; color: var(--accent); font-family: 'EB Garamond', serif; }
.pillar p { font-size: .97rem; line-height: 1.55; margin-bottom: 20px; color: var(--text); }
.pillar-link { font-size: .82rem; font-weight: 500; text-transform: uppercase; letter-spacing: .06em; color: var(--accent); }

/* Research/Article Page (Section 9) */
.framework-hero { padding: 85px 0 55px; }
.article-content { max-width: 800px; margin: 0px auto 110px auto; padding: 30px 70px 80px 70px; background: #ffffff; border: 1px solid var(--border); box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
.article-content h3 { font-family: 'EB Garamond', serif; font-size: 1.8rem; color: var(--accent); margin-top: 0.75em; border-bottom: 1px solid var(--border); padding-bottom: 10px; }
.vertical-timeline { border-left: 2px solid var(--border); margin-left: 10px; padding-left: 40px; margin-top: 40px; }
.paper-section { position: relative; margin-bottom: 60px; }
.paper-section::before { content: ''; position: absolute; left: -48px; top: 5px; width: 14px; height: 14px; background: var(--accent); border-radius: 50%; }
.article-divider { display: block; text-align: center; font-size: 1.8rem; color: var(--accent); opacity: 0.7; margin: 40px auto !important; letter-spacing: 0.5em; border: none !important; }
.scholar-portrait { width: 120px; height: 140px; object-fit: cover; object-position: 50% 10%; float: left; margin: 0 30px 5px 0; border: 1px solid var(--border); border-radius: 8px !important; }

/* -------------------------------------------------
   10. FOOTER (COMPRESSED)
------------------------------------------------- */
.site-footer {
  text-align: center;
  padding: 20px 0; /* Reduced from 40px */
  border-top: 1px solid var(--border);
  background: var(--paper);
}

.footer-seal-wrap {
  margin-bottom: 5px; /* Reduced from 15px */
}

.footer-seal {
  max-width: 45px; /* Slightly smaller emblem for a compact look */
  filter: grayscale(100%);
  opacity: 0.6;
}

.footer-name {
  font-family: 'EB Garamond', serif;
  font-variant-caps: small-caps;
  font-size: 1rem;
  margin: 0;
  line-height: 1; /* Removed extra line height */
}

.footer-descriptor {
  font-family: 'Inter', sans-serif;
  font-size: 0.75rem; /* Slightly smaller */
  margin: 2px 0 5px 0; /* Tightened margins */
  color: #777;
}

.footer-copyright {
  font-family: 'Inter', sans-serif;
  font-size: 0.7rem;
  color: #999;
  margin: 0;
}
```

---

