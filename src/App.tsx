import { motion } from "framer-motion";

const pillars = [
  {
    title: "Research Portfolio",
    description:
      "Cross-scale theoretical frameworks integrating neuroenergetics, predictive processing, and social structure.",
    href: "login.html",
    linkLabel: "Access Research",
  },
  {
    title: "Working Papers",
    description: "Citable materials, preprints, and formal references for academic engagement.",
    href: "login.html",
    linkLabel: "Access Archive",
  },
  {
    title: "The Framework",
    description:
      "A multi-level analytic account of autistic burnout as sustained energetic imbalance.",
    href: "framework/",
    linkLabel: "Examine Theory",
  },
];

const navLinks = [
  { label: "Research", href: "login.html" },
  { label: "Working Papers", href: "login.html" },
  { label: "Framework", href: "framework/" },
  { label: "About", href: "/about.html" },
];

export function App() {
  return (
    <div className="bg-stone-100 text-stone-900 selection:bg-amber-200/70 selection:text-stone-950">
      <header className="fixed inset-x-0 top-0 z-20 border-b border-white/20 bg-stone-950/45 backdrop-blur-sm">
        <motion.div
          className="mx-auto flex w-full max-w-6xl items-center justify-between px-6 py-4 text-stone-100"
          initial={{ y: -20, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ duration: 0.6, ease: "easeOut" }}
        >
          <div className="flex items-center gap-3">
            <img
              src="assets/images/emblem.png"
              alt="Autistic Scholars emblem"
              className="h-8 w-8 object-contain"
            />
            <p className="text-xl tracking-[0.18em] uppercase">Autistic Scholars</p>
          </div>
          <nav className="flex items-center gap-3 text-sm text-stone-200/90 sm:gap-4">
            {navLinks.map((link, index) => (
              <div key={link.label} className="flex items-center gap-3 sm:gap-4">
                <a className="transition-colors duration-300 hover:text-white" href={link.href}>
                  {link.label}
                </a>
                {index !== navLinks.length - 1 ? <span className="text-stone-400">·</span> : null}
              </div>
            ))}
          </nav>
        </motion.div>
      </header>

      <main>
        <section className="relative min-h-screen overflow-hidden">
          <motion.img
            src="https://images.unsplash.com/photo-1507842217343-583bb7270b66?auto=format&fit=crop&w=1920&q=80"
            alt="A calm research library interior"
            className="absolute inset-0 h-full w-full object-cover"
            initial={{ scale: 1.08, opacity: 0.8 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ duration: 1.4, ease: "easeOut" }}
          />
          <div className="relative mx-auto flex min-h-screen w-full max-w-6xl items-center px-6 pt-24">
            <motion.div
              initial={{ y: 24, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              transition={{ duration: 0.8, delay: 0.2, ease: "easeOut" }}
              className="max-w-3xl bg-stone-950/66 p-6 text-stone-100 backdrop-blur-[1px] sm:p-8 [text-shadow:0_2px_14px_rgba(0,0,0,0.55)]"
            >
              <p className="mb-4 text-sm tracking-[0.3em] uppercase text-stone-200/80">
                Independent Research Institute
              </p>
              <h1 className="text-4xl leading-tight font-medium text-balance sm:text-5xl md:text-6xl">
                Mapping the Energetic Limits of Social Adaptation
              </h1>
              <p className="mt-5 max-w-2xl text-lg text-stone-100 sm:text-xl">
                Adaptation has energetic limits and those limits are not evenly distributed.
              </p>
              <div className="mt-10 flex gap-4">
                <a
                  href="login.html"
                  className="border border-stone-100 px-6 py-3 text-sm tracking-[0.12em] uppercase transition-colors duration-300 hover:bg-stone-100 hover:text-stone-950"
                >
                  Access Research
                </a>
                <a
                  href="framework/"
                  className="border border-stone-300/70 px-6 py-3 text-sm tracking-[0.12em] uppercase text-stone-100 transition-colors duration-300 hover:border-stone-100"
                >
                  Examine Theory
                </a>
              </div>
            </motion.div>
          </div>
        </section>

        <section className="mx-auto w-full max-w-6xl px-6 py-20 sm:py-24">
          <h2 className="mb-8 text-2xl tracking-wide text-stone-800 sm:text-3xl">Core Work</h2>
          <div className="grid gap-8 md:grid-cols-3">
            {pillars.map((pillar, index) => (
              <motion.a
                key={pillar.title}
                href={pillar.href}
                className="group border-t border-stone-400/60 pt-5"
                initial={{ opacity: 0, y: 24 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true, amount: 0.3 }}
                transition={{ duration: 0.55, delay: index * 0.14, ease: "easeOut" }}
              >
                <h3 className="text-xl tracking-wide text-stone-900">{pillar.title}</h3>
                <p className="mt-3 text-base leading-relaxed text-stone-700">{pillar.description}</p>
                <span className="mt-5 inline-block text-sm tracking-[0.1em] uppercase text-stone-800 transition-transform duration-300 group-hover:translate-x-1">
                  {pillar.linkLabel}
                </span>
              </motion.a>
            ))}
          </div>
        </section>
      </main>

      <footer className="border-t border-stone-300 bg-stone-200/50 px-6 py-12 text-center text-stone-800">
        <div className="mx-auto flex w-fit items-center gap-3">
          <img
            src="assets/images/emblem.png"
            alt="Institutional Seal"
            className="h-10 w-10 object-contain"
          />
          <p className="text-lg tracking-[0.08em] uppercase">Autistic Scholars</p>
        </div>
        <p className="mt-2 text-sm text-stone-700">An Independent Research Initiative</p>
        <p className="mt-1 text-xs text-stone-600">© 2026</p>
      </footer>
    </div>
  );
}
